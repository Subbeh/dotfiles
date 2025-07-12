#!/usr/bin/env python

import json
from dataclasses import dataclass
import argparse
from typing import List, Tuple, Dict
import subprocess

MONITORS = {
    "internal": {"name": "eDP-1", "width": 1920, "height": 1200, "scale": 1.0},
    "dell_4k": {
        "description": "Dell Inc. DELL U2723QE 7M70DP3",
        "width": 3840,
        "height": 2160,
        "scale": 1.5,
    },
    "lg_4k": {
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

    def is_active(self, monitors: Dict) -> bool:
        """Check if the current monitor configuration matches this profile."""
        expected_configs = self.get_monitor_configs()
        
        # Get the set of monitor names that should be active in this profile
        expected_active_monitors = set()
        for monitor_name, _, _, _, _, _ in expected_configs:
            # Find the actual monitor name
            if monitor_name == "internal":
                internal_name = MONITORS["internal"]["name"]
                if internal_name in monitors:
                    expected_active_monitors.add(internal_name)
            elif monitor_name in monitors:
                expected_active_monitors.add(monitor_name)
            else:
                # Try to match by description
                monitor_info = MONITORS.get(monitor_name, {})
                expected_description = monitor_info.get("description", "")
                if expected_description:
                    for mon_name, mon in monitors.items():
                        if mon.description == expected_description:
                            expected_active_monitors.add(mon_name)
                            break

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
            monitor_name,
            expected_x,
            expected_y,
            expected_width,
            expected_height,
            expected_scale,
        ) in expected_configs:
            current_monitor = None

            # Find the actual monitor
            if monitor_name == "internal":
                internal_name = MONITORS["internal"]["name"]
                if internal_name in monitors:
                    current_monitor = monitors[internal_name]
            elif monitor_name in monitors:
                current_monitor = monitors[monitor_name]
            else:
                # Try to match by description
                monitor_info = MONITORS.get(monitor_name, {})
                expected_description = monitor_info.get("description", "")
                if expected_description:
                    for mon in monitors.values():
                        if mon.description == expected_description:
                            current_monitor = mon
                            break

            # If we couldn't find the expected monitor, profile is not active
            if current_monitor is None:
                return False

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

    def is_available(self, monitors: Dict) -> bool:
        """Check if all monitors required by this profile are currently available/connected."""
        expected_configs = self.get_monitor_configs()

        # Check if each monitor required by the profile is available
        for monitor_name, _, _, _, _, _ in expected_configs:
            monitor_found = False

            # Try to find the monitor by name first - for internal monitor, check if it has a "name" field
            if monitor_name == "internal":
                # For internal monitor, use the name from MONITORS config
                internal_name = MONITORS["internal"]["name"]
                if internal_name in monitors:
                    monitor_found = True
            elif monitor_name in monitors:
                monitor_found = True
            else:
                # If not found by name, try to match by description
                monitor_info = MONITORS.get(monitor_name, {})
                expected_description = monitor_info.get("description", "")

                if expected_description:
                    for mon in monitors.values():
                        if mon.description == expected_description:
                            monitor_found = True
                            break

            # If any required monitor is not available, the profile is not available
            if not monitor_found:
                return False

        return True


class HyprlandManager:
    def __init__(self, dry_run: bool = False):
        self.dry_run = dry_run
        self.profiles = {
            name: Profile(name, configs) for name, configs in PROFILES.items()
        }
        self.refresh_monitors()

    def refresh_monitors(self):
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
                monitor = Monitor.from_hyprctl_data(mon_data)
                monitors[monitor.name] = monitor

            self.monitors = monitors

        except subprocess.CalledProcessError as e:
            print(f"Error running hyprctl: {e}")
            self.monitors = {}
        except json.JSONDecodeError as e:
            print(f"Error parsing monitor data: {e}")
            self.monitors = {}

    def find_monitor_by_config_name(self, config_name: str) -> str:
        """Find the actual monitor name for a given config name."""
        if config_name == "internal":
            internal_name = MONITORS["internal"]["name"]
            if internal_name in self.monitors:
                return internal_name
        elif config_name in self.monitors:
            return config_name
        else:
            monitor_info = MONITORS.get(config_name, {})
            expected_description = monitor_info.get("description", "")

            if expected_description:
                for mon_name, mon in self.monitors.items():
                    if mon.description == expected_description:
                        return mon_name

        return None

    def run_hyprctl_command(self, command: List[str]) -> bool:
        """Execute a hyprctl command, respecting dry-run mode."""
        if self.dry_run:
            print(f"[DRY RUN] Would execute: {' '.join(command)}")
            return True

        try:
            subprocess.run(command, capture_output=True, text=True, check=True)
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error executing {' '.join(command)}: {e}")
            if e.stderr:
                print(f"stderr: {e.stderr}")
            return False

    def set_profile(self, profile_name: str) -> bool:
        try:
            profile = self.profiles[profile_name]
        except Exception:
            print(f"Unknown profile: {profile_name}")
            return False

        if profile.is_active(self.monitors):
            print(f"Profile '{profile_name}' is already active")
            return False

        if not profile.is_available(self.monitors):
            print(f"Profile '{profile_name}' is not available")
            return False

        print(f"Setting monitor profile to {profile_name}")

        # Get the monitor configurations for this profile
        profile_configs = profile.get_monitor_configs()
        profile_monitor_names = set()

        # Collect all monitor names that should be active in this profile
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
            if actual_name:
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
            else:
                print(f"Warning: Could not find monitor for config '{config_name}'")
                success = False

        if success:
            print(f"Successfully applied profile '{profile_name}'")
        else:
            print(f"Some errors occurred while applying profile '{profile_name}'")

        # Refresh monitor state after changes
        if not self.dry_run:
            self.refresh_monitors()

        return success

    # def reload_hyprland(self):
    #     try:
    #         subprocess.run(["hyprctl", "reload"], check=True)
    #     except subprocess.CalledProcessError as e:
    #         print(f"Error reloading Hyprland: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Hyprland monitor and workspace manager"
    )
    parser.add_argument("-p", "--profile", help="Set monitor profile")
    parser.add_argument(
        "-r", "--reload", action="store_true", help="Reload Hyprland and Waybar"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Don't change anything, just show what would be done",
    )

    args = parser.parse_args()
    manager = HyprlandManager(dry_run=args.dry_run)

    if args.profile:
        manager.set_profile(args.profile)


if __name__ == "__main__":
    main()
