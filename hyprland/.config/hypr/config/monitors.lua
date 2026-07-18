local M = {}

local function is_connected(monitor, live)
  Utils.debug("TEST 1: " .. #live)
  for _, mon in ipairs(live) do
    Utils.debug("TEST 2: " .. mon.description)
    Utils.debug("TEST 3: " .. monitor)
    -- Utils.debug("CHECKING: " .. mon.description .. " == " .. monitor.desc)
    -- if mon.description == monitor.desc then
    --   return true
    -- end
  end
  return false
end

local function match_profile(live)
  for _, profile in ipairs(PROFILES) do
    for monitor in pairs(profile.monitors) do
      if is_connected(monitor, live) then
        Utils.debug("CONNECTED:" .. monitor.desc)
      end
    end
  end
end

local function reload_layout()
  local live = hl.get_monitors()
  if #live > 0 then
    match_profile(live)
  end
end

M.init = function()
  hl.timer(function()
    reload_layout()
    hl.on("monitor.added", reload_layout)
  end, { timeout = 500, type = "oneshot" })
end

return M
