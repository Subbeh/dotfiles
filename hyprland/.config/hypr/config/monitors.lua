local M = {}

M.get_profile = function()
  for _, profile in ipairs(PROFILES) do
    for monitor in pairs(profile.monitors) do
      Utils.debug("MON: " .. monitor)
    end
  end
end

M.init = function()
  get_profile()
end

return M
