--- @class Utils
local Utils = {}

Utils.debug = function(msg)
  hl.notification.create({
    text = "DEBUG: " .. tostring(msg),
    timeout = 5000,
  })
  return true
end

--- Convert width/height percentages of a monitor into logical pixels.
--- Useful for size-based dispatchers (e.g. window.resize) which take numeric
--- pixels rather than percentage strings.
--- @param x_pct number percentage of monitor width (0-100)
--- @param y_pct number percentage of monitor height (0-100)
--- @param monitor table? monitor object, defaults to the active monitor
--- @return integer x, integer y sizes in layout (logical) coordinates
Utils.percent_to_px = function(x_pct, y_pct, monitor)
  local mon = monitor or hl.get_active_monitor()
  local x = math.floor(mon.width / mon.scale * x_pct / 100)
  local y = math.floor(mon.height / mon.scale * y_pct / 100)
  return x, y
end

Utils.get_monitor = function(query)
  local live = hl.get_monitors()

  for key, cfg in pairs(Monitors) do
    local mon
    for _, m in ipairs(live) do
      if (cfg.name and m.name == cfg.name) or (cfg.desc and m.description:find(cfg.desc, 1, true)) then
        mon = m
        break
      end
    end

    local info = {
      name = key,
      id = mon and mon.name or cfg.name,
      desc = mon and mon.description or cfg.desc,
    }

    if (query.name and query.name == info.name) or (query.id and query.id == info.id) or (query.desc and info.desc and info.desc:find(query.desc, 1, true)) then
      return info
    end
  end

  return nil
end

return Utils
