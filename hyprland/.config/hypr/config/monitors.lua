local M = {}

local function is_connected(monitor, live)
  for _, mon in ipairs(live) do
    Utils.debug("IS_CON: " .. mon.description .. " == " .. MONITORS[monitor].desc)
    if mon.description == MONITORS[monitor].desc then
      return true
    end
  end
  return false
end

local function match_profile(profile, live)
  for monitor in pairs(profile.monitors) do
    if not is_connected(monitor, live) then
      return false
    end
  end
  Utils.debug("PROFILE MATCH: " .. profile.name)
  return true
end

local function get_profile(live)
  for _, profile in ipairs(PROFILES) do
    if match_profile(profile, live) then
      return profile.name
    end
  end
end

local function get_monitor(desc)
  for name, item in pairs(MONITORS) do
    if item.desc == desc then
      return name
    end
  end
end

local function logical_width(cat)
  local px = tonumber(cat.mode:match("(%d+)x"))
  return math.floor(px / (cat.scale or 1) + 0.5)
end

local function apply_profile(profile, live)
  for _, p in ipairs(PROFILES) do
    if p.name == profile then
      local x = 0
      for _, mon in ipairs(live) do
        local name = get_monitor(mon.description)
        local role = name and p.monitors[name]
        if role then
          local cat = MONITORS[name]
          local scale = cat.scale or 1
          hl.monitor({
            output = "desc:" .. mon.description,
            mode = cat.mode,
            position = x .. "x0",
            scale = tostring(scale),
          })
          if role.ws then
            for _, n in ipairs(role.ws) do
              hl.workspace_rule({
                workspace = tostring(n),
                monitor = "desc:" .. mon.description,
                persistent = true,
              })
            end
          end
          if role.waybar then
            StartWaybar(mon.description)
          end
          x = x + logical_width(cat)
        else
          hl.monitor({
            output = "desc:" .. mon.description,
            disabled = true,
          })
        end
      end
    end
  end
end

local function reload_layout()
  local live = hl.get_monitors()
  if #live > 0 then
    local profile = get_profile(live)
    if profile then
      apply_profile(profile, live)
    end
  end
end

M.init = function()
  hl.timer(function()
    reload_layout()
    hl.on("monitor.added", reload_layout)
  end, { timeout = 500, type = "oneshot" })
end

return M
