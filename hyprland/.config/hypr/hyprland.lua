local Config = require("config") ---@class Config

MONITORS = {
  internal_x1 = {
    desc = "BOE 0x094C",
    mode = "1920x1200",
  },
  internal_xps = {
    desc = "Sharp Corporation 0x14AE",
    mode = "1920x1080",
  },
  lg_27 = {
    desc = "LG Electronics LG ULTRAFINE 504NTUW6F878",
    mode = "3840x2160",
    scale = 1.25,
  },
  lg_32 = {
    desc = "LG Electronics LG HDR 4K 308NTTQFK265",
    mode = "3840x2160",
    scale = 1.25,
  },
}

PROFILES = {
  {
    name = "docked",
    monitors = {
      internal_x1 = {},
      lg_27 = {
        ws = { 1 },
      },
      lg_32 = {
        ws = { 2, 3 },
        waybar = true,
      },
    },
  },
  {
    name = "undocked",
    monitors = {
      internal_x1 = {
        ws = { 1, 2, 3 },
        waybar = true,
      },
    },
  },
  {
    name = "xps",
    monitors = {
      internal_xps = {
        ws = { 1, 2, 3 },
        waybar = true,
      },
    },
  },
}

--- Initialises the Hyprland session: applies machine config and loads all subsystems.
local function init()
  Config.setup()
end

init()
