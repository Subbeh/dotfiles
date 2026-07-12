local Config = require("config") ---@class Config

MONITORS = {
  -- stylua: ignore start
  { name = "internal_xps", desc = "Sharp Corporation 0x14AE",                 mode = "1920x1080" },
  { name = "lg_27",        desc = "LG Electronics LG ULTRAFINE 504NTUW6F878", mode = "3840x2160", scale = 1.25 },
  { name = "lg_32",        desc = "LG Electronics LG HDR 4K 308NTTQFK265",    mode = "3840x2160", scale = 1.25 },
}

PROFILES = {
  {
    name = "undocked",
    monitors = {
      internal_xps = {
        ws = { 1, 2, 3 },
        waybar = true,
      },
    },
  },
  {
    name = "docked",
    monitors = {
      internal_xps = {},
      lg_27 = {
        ws = { 1 },
      },
      lg_32 = {
        ws = { 2, 3 },
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
