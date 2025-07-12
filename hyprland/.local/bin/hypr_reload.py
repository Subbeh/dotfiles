#!/usr/bin/env python

import json
from dataclasses import dataclass
import argparse
from typing import List, Tuple, Dict, Optional
import subprocess

MONITORS = {
    "internal": {
        "name": "eDP-1", 
        "description": "", 
        "width": 1920, 
        "height": 1200, 
        "scale": 1.0
    },
    "dell_4k": {
        "name": "",
        "description": "Dell Inc. DELL U2723QE 7M70DP3",
        "width": 3840,
        "height": 2160,
        "scale": 1.5,
    },
    "lg_4k": {
        "name": "",
        "description": "LG Electronics LG HDR 4K 308NTTQFK265",
        "width": 3840,
        "height": 2160,
        "scale": 1.5,
    },
}

PROFILES = {
    "undocked": [
        ("internal", 0, 0),
    ],
    "docked": [
        ("internal", 0, 0),
        ("dell_4k", 0, -1440),
        ("lg_4k", 2560, -1440),
    ],
    "docked-ext-only": [
        ("dell_4k", 0, 0),
        ("lg_4k", 2560, 0),
    ],
    "docked-dell-only": [
        ("dell_4k", 0, 0),
    ],
    "docked-dell": [
        ("internal", 0, 0),
        ("dell_4k", 0, -1440),
    ],
    "docked-lg-only": [
        ("lg_4k", 0, 0),
    ],
    "docked-lg": [
        ("internal", 0, 0),
        ("lg_4k", 1920, 0),
    ],
}


@dataclass
class Monitor:
    name: str
    description: str
    x: int = 0
    y: int = 0
    width: int = 0
    height: int = 0
    scale: float = 1.0
    disabled: bool = False

    @classmethod
    def from_hyprctl_data(cls, data: dict) -> "Monitor":
        return cls(
            name=data["name"],
            description=data["description"],
            x=data["x"],
            y=data["y"],
            width=data["width"],
            height=data["height"],
            scale=data["scale"],
            disabled=data["disabled"],
        )


class Profile:
    def __init__(self, name: str, monitor_configs: List[Tuple[str, int, int]]):
        self.name = name
        self.monitor_configs = monitor_configs
    
    def _find_monitor_name(self, config_name: str, monitors: Dict[str, 'Monitor']) -> Optional[str]:
        """Find the actual monitor name for a config name."""
        if config_name not in MONITORS:
            return None
            
        monitor_info = MONITORS[config_name]
        
        # First try by name (for internal monitor)
        if monitor_info.get("name"):
            name = monitor_info["name"]
            if name in monitors:
                return name
                
        # Then try by description (for external monitors)
        if monitor_info.get("description"):
            description = monitor_info["description"]
            for mon_name, mon in monitors.items():
                if mon.description == description:
                    return mon_name
                    
        return None

    def get_monitor_configs(self) -> List[Tuple[str, int, int, int, int, float]]:
        """Convert simple configs to full monitor configurations with width, height, scale."""
        full_configs = []
        for monitor_name, x, y in self.monitor_configs:
            if monitor_name in MONITORS:
                monitor_info = MONITORS[monitor_name]
                width = monitor_info["width"]
                height = monitor_info["height"]
                scale = monitor_info["scale"]
                full_configs.append((monitor_name, x, y, width, height, scale))
        return full_configs

    def is_active(self, monitors: Dict[str, 'Monitor']) -> bool:
        """Check if the current monitor configuration matches this profile."""
        expected_configs = self.get_monitor_configs()
        
        # Get the set of monitor names that should be active in this profile
        expected_active_monitors = set()
        for config_name, _, _, _, _, _ in expected_configs:
            actual_name = self._find_monitor_name(config_name, monitors)
            if actual_name:
                expected_active_monitors.add(actual_name)

        # Check that monitors not in the profile are disabled
        for monitor_name, monitor in monitors.items():
            if monitor_name not in expected_active_monitors:
                if not monitor.disabled:
                    return False  # Monitor should be disabled but isn't
            else:
                if monitor.disabled:
                    return False  # Monitor should be active but is disabled

        # Check that each expected monitor has the correct configuration
        for (
            config_name,
            expected_x,
            expected_y,
            expected_width,
            expected_height,
            expected_scale,
        ) in expected_configs:
            actual_name = self._find_monitor_name(config_name, monitors)
            if not actual_name or actual_name not in monitors:
                return False
                
            current_monitor = monitors[actual_name]

            # Check if position, dimensions, and scale match
            if (
                current_monitor.x != expected_x
                or current_monitor.y != expected_y
                or current_monitor.width != expected_width
                or current_monitor.height != expected_height
                or abs(current_monitor.scale - expected_scale) > 0.01
            ):  # Allow small floating point differences
                return False

        return True

    def is_available(self, monitors: Dict[str, 'Monitor']) -> bool:
        """Check if all monitors required by this profile are currently available/connected."""
        expected_configs = self.get_monitor_configs()

        # Check if each monitor required by the profile is available
        for config_name, _, _, _, _, _ in expected_configs:
            actual_name = self._find_monitor_name(config_name, monitors)
            if not actual_name:
                return False

        return True


class HyprlandManager:
    def __init__(self, dry_run: bool = False, verbose: bool = False):
        self.dry_run = dry_run
        self.verbose = verbose
        self._validate_config()
        self.profiles: Dict[str, Profile] = {
            name: Profile(name, configs) for name, configs in PROFILES.items()
        }
        self.monitors: Dict[str, Monitor] = {}
        self.refresh_monitors()
    
    def _validate_config(self) -> None:
        """Validate the MONITORS and PROFILES configuration."""
        # Check MONITORS config
        for name, config in MONITORS.items():
            required_fields = ["width", "height", "scale"]
            for field in required_fields:
                if field not in config:
                    raise ValueError(f"Monitor '{name}' missing required field '{field}'")
            
            # Must have either name or description
            if not config.get("name") and not config.get("description"):
                raise ValueError(f"Monitor '{name}' must have either 'name' or 'description' field")
        
        # Check PROFILES config  
        for profile_name, monitor_configs in PROFILES.items():
            for config in monitor_configs:
                if len(config) != 3:
                    raise ValueError(f"Profile '{profile_name}' has invalid monitor config: {config}")
                monitor_name, x, y = config
                if monitor_name not in MONITORS:
                    raise ValueError(f"Profile '{profile_name}' references unknown monitor '{monitor_name}'")

    def refresh_monitors(self) -> bool:
        """Refresh the current monitor state from hyprctl. Returns True on success."""
        try:
            result = subprocess.run(
                ["hyprctl", "monitors", "all", "-j"],
                capture_output=True,
                text=True,
                check=True,
            )
            monitor_data = json.loads(result.stdout)
            monitors = {}

            for mon_data in monitor_data:
                try:
                    monitor = Monitor.from_hyprctl_data(mon_data)
                    monitors[monitor.name] = monitor
                except (KeyError, TypeError) as e:
                    print(f"Warning: Failed to parse monitor data: {e}")
                    continue

            self.monitors = monitors
            return True

        except subprocess.CalledProcessError as e:
            print(f"Error running hyprctl: {e}")
            self.monitors = {}
            return False
        except json.JSONDecodeError as e:
            print(f"Error parsing monitor data: {e}")
            self.monitors = {}
            return False

    def find_monitor_by_config_name(self, config_name: str) -> Optional[str]:
        """Find the actual monitor name for a given config name."""
        if config_name not in MONITORS:
            return None
            
        monitor_info = MONITORS[config_name]
        
        # First try by name (for internal monitor)
        if monitor_info.get("name"):
            name = monitor_info["name"]
            if name in self.monitors:
                return name
                
        # Then try by description (for external monitors)
        if monitor_info.get("description"):
            description = monitor_info["description"]
            for mon_name, mon in self.monitors.items():
                if mon.description == description:
                    return mon_name
                    
        return None

    def run_hyprctl_command(self, command: List[str]) -> bool:
        """Execute a hyprctl command, respecting dry-run mode."""
        if self.verbose:
            print(f"[DEBUG] Command: {' '.join(command)}")
            
        if self.dry_run:
            print(f"[DRY RUN] Would execute: {' '.join(command)}")
            return True

        try:
            result = subprocess.run(command, capture_output=True, text=True, check=True)
            if self.verbose and result.stdout:
                print(f"[DEBUG] stdout: {result.stdout}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error executing {' '.join(command)}: {e}")
            if e.stderr:
                print(f"stderr: {e.stderr}")
            return False

    def set_profile(self, profile_name: str) -> bool:
        """Set the monitor profile. Returns True on success."""
        # Validate profile exists
        if profile_name not in self.profiles:
            print(f"Error: Unknown profile '{profile_name}'")
            available_profiles = ", ".join(self.profiles.keys())
            print(f"Available profiles: {available_profiles}")
            return False

        profile = self.profiles[profile_name]

        # Check if profile is already active
        if profile.is_active(self.monitors):
            print(f"Profile '{profile_name}' is already active")
            return True  # Success - no action needed

        # Check if profile is available (all required monitors connected)
        if not profile.is_available(self.monitors):
            print(f"Error: Profile '{profile_name}' is not available")
            print("Required monitors are not connected")
            return False

        print(f"Setting monitor profile to {profile_name}")

        # Get the monitor configurations for this profile
        profile_configs = profile.get_monitor_configs()
        if not profile_configs:
            print(f"Error: Profile '{profile_name}' has no valid monitor configurations")
            return False

        # Collect all monitor names that should be active in this profile
        profile_monitor_names = set()
        for config_name, _, _, _, _, _ in profile_configs:
            actual_name = self.find_monitor_by_config_name(config_name)
            if actual_name:
                profile_monitor_names.add(actual_name)

        success = True

        # Step 1: Disable monitors not in the profile
        for monitor_name, monitor in self.monitors.items():
            if monitor_name not in profile_monitor_names:
                if not monitor.disabled:
                    print(f"Disabling monitor: {monitor_name}")
                    if not self.run_hyprctl_command(
                        ["hyprctl", "keyword", "monitor", f"{monitor_name},disable"]
                    ):
                        success = False
                else:
                    print(f"Monitor {monitor_name} is already disabled")

        # Step 2: Configure monitors in the profile
        for config_name, x, y, width, height, scale in profile_configs:
            actual_name = self.find_monitor_by_config_name(config_name)
            if not actual_name:
                print(f"Error: Could not find monitor for config '{config_name}'")
                success = False
                continue
                
            if actual_name not in self.monitors:
                print(f"Error: Monitor '{actual_name}' not found in current monitors")
                success = False
                continue
                
            current_monitor = self.monitors[actual_name]
            
            # Check if monitor needs to be configured
            needs_config = (
                current_monitor.disabled or
                current_monitor.x != x or
                current_monitor.y != y or
                current_monitor.width != width or
                current_monitor.height != height or
                abs(current_monitor.scale - scale) > 0.01
            )
            
            if needs_config:
                # Format: monitor=name,widthxheight@refresh,positionx,scale
                monitor_config = f"{actual_name},{width}x{height},{x}x{y},{scale}"
                print(f"Configuring monitor: {monitor_config}")
                if not self.run_hyprctl_command(
                    ["hyprctl", "keyword", "monitor", monitor_config]
                ):
                    success = False
            else:
                print(f"Monitor {actual_name} is already correctly configured")

        # Report results
        if success:
            print(f"Successfully applied profile '{profile_name}'")
        else:
            print(f"Errors occurred while applying profile '{profile_name}'")

        # Refresh monitor state after changes
        if not self.dry_run:
            if not self.refresh_monitors():
                print("Warning: Failed to refresh monitor state after changes")

        return success

    def list_profiles(self) -> None:
        """List all available profiles and their status."""
        print("Available profiles:")
        for name, profile in self.profiles.items():
            status = ""
            if profile.is_active(self.monitors):
                status = " (ACTIVE)"
            elif profile.is_available(self.monitors):
                status = " (available)"
            else:
                status = " (unavailable)"
            
            print(f"  {name}{status}")
    
    def show_current_config(self) -> None:
        """Show current monitor configuration."""
        print("Current monitor configuration:")
        for name, monitor in self.monitors.items():
            status = "disabled" if monitor.disabled else "enabled"
            if not monitor.disabled:
                print(f"  {name}: {monitor.width}x{monitor.height} at ({monitor.x},{monitor.y}) scale={monitor.scale} ({status})")
            else:
                print(f"  {name}: {status}")
    
    def reload_hyprland(self) -> bool:
        """Reload Hyprland configuration."""
        print("Reloading Hyprland...")
        return self.run_hyprctl_command(["hyprctl", "reload"])


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Hyprland monitor and workspace manager"
    )
    parser.add_argument("-p", "--profile", help="Set monitor profile")
    parser.add_argument(
        "-l", "--list", action="store_true", help="List available profiles"
    )
    parser.add_argument(
        "-s", "--status", action="store_true", help="Show current monitor configuration"
    )
    parser.add_argument(
        "-r", "--reload", action="store_true", help="Reload Hyprland configuration"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Don't change anything, just show what would be done",
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose debug output",
    )

    args = parser.parse_args()
    
    # Initialize manager
    try:
        manager = HyprlandManager(dry_run=args.dry_run, verbose=args.verbose)
    except Exception as e:
        print(f"Error initializing Hyprland manager: {e}")
        return

    # Handle commands
    if args.list:
        manager.list_profiles()
    elif args.status:
        manager.show_current_config()
    elif args.reload:
        if manager.reload_hyprland():
            print("Successfully reloaded Hyprland")
        else:
            print("Failed to reload Hyprland")
    elif args.profile:
        if not manager.set_profile(args.profile):
            exit(1)
    else:
        # No action specified, show help
        parser.print_help()


if __name__ == "__main__":
    main()
