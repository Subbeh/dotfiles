TERM = "kitty"
FILEMANAGER = "thunar"

-- Per-machine monitor profiles. A profile is selected at load by matching the
-- internal eDP-1 panel's description against `panel` (see Func.select_profile).
-- Machines that match no profile fall back to a generic layout built from the
-- connected outputs. Within a profile all monitors are declared; Hyprland
-- ignores absent ones, so docked/undocked works without extra branching.
Profiles = {
  -- stylua: ignore start
  x1 = {
    panel = "CSOT", -- substring of eDP-1's description on this laptop (hyprctl monitors all)
    monitors = {
      { key = "laptop", name = "eDP-1",                                    mode = "1920x1200", position = "0x0",        scale = 1,    ws = "3" },
      { key = "ext1",   desc = "LG Electronics LG ULTRAFINE 504NTUW6F878", mode = "3840x2160", position = "0x-1800",    scale = 1.25, ws = "1" },
      { key = "ext2",   desc = "LG Electronics LG HDR 4K 308NTTQFK265",    mode = "3840x2160", position = "3072x-1800", scale = 1.25, ws = "2", default = true, waybar = true },
    },
  },
  -- stylua: ignore end
}

Utils = require("hyprland.lib.utils")
Func = require("hyprland.lib.functions")

Func.select_profile()

require("hyprland.lib.dropterm")
require("hyprland.lib.waybar")
require("hyprland.lib.dynamic_layout")
require("hyprland.config")
require("hyprland.rules")
require("hyprland.monitors")
require("hyprland.events")
require("hyprland.binds")
