--- @class Config
local Config = {}

--- Initialises globals, selects the monitor profile, and loads all subsystems.
Config.setup = function()
  TERM = "kitty"
  Utils = require("lib.utils")
  Func = require("lib.functions")
  require("lib.waybar") -- defines global StartWaybar
  require("lib.dropterm") -- defines global Dropterm

  require("modules.env")
  require("modules.settings")
  require("modules.rules")
  require("modules.events")
  require("modules.binds")

  -- Selects the profile and applies the monitor layout now (for hyprctl reload) and
  -- on start/hotplug. Sets the globals Monitors + Panel. Runs last so its start
  -- handler applies the layout after Hyprland has enumerated outputs.
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
  require("config.monitors").init()
end

return Config
