TERM = "kitty"
FILEMANAGER = "thunar"

Monitors = {
  -- stylua: ignore start
  laptop = {
    name = "eDP-1",
    mode = "1920x1080",
    position = "0x0",
    scale = 1,
  },
  ext1 = {
    desc = "LG Electronics LG ULTRAFINE 504NTUW6F878",
    mode = "3840x2160",
    position = "0x-1800",
    scale = 1.25,
  },
  ext2 = {
    desc = "LG Electronics LG HDR 4K 308NTTQFK265",
    mode = "3840x2160",
    position = "3072x-1800",
    scale = 1.25,
  },
}

Utils = require("hyprland.lib.utils")
Func = require("hyprland.lib.functions")

require("hyprland.lib.dropterm")
require("hyprland.lib.waybar")
require("hyprland.lib.dynamic_layout")
require("hyprland.env")
require("hyprland.config")
require("hyprland.rules")
require("hyprland.monitors")
require("hyprland.events")
require("hyprland.binds")
