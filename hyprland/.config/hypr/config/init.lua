--- @class Config
local Config = {}

--- Initialises globals, selects the monitor profile, and loads all subsystems.
Config.setup = function()
  TERM = "kitty"
  Utils = require("lib.utils")
  Func = require("lib.functions")
  require("lib.waybar") -- defines global StartWaybar
  require("lib.dropterm") -- defines global Dropterm

  local Monitors = require("config.monitors")
  Monitors.select() -- sets globals Monitors (active ordered list) + Panel

  require("modules.env")
  require("modules.settings")
  require("modules.rules")
  Monitors.apply() -- hl.monitor() + persistent workspace rules
  require("modules.events")
  require("modules.binds")
end

return Config
