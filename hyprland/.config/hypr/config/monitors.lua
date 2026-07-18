local M = {}

local function is_connected(monitor, live)
  for _, mon in ipairs(live) do
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
  return true
end

local function get_profile(live)
  for _, profile in ipairs(PROFILES) do
    if match_profile(profile, live) then
      return profile.name
    end
  end
end

local function apply_profile(profile)
  for _, p in ipairs(PROFILES) do
    if p.name == profile then
      Utils.debug("APPLYING: " .. p.name)
      for _, mon in ipairs(p.monitors) do
        Utils.debug("TEST")
      end
    end
  end
end

local function reload_layout()
  local live = hl.get_monitors()
  if #live > 0 then
    local profile = get_profile(live)
    if profile then
      apply_profile(profile)
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
