-- Dynamic window layout: reserve 40% on the left of workspace 1's monitor while
-- it holds a single tiled window, so that lone window doesn't stretch across the
-- full width of the wide external display. Only active on the 3-monitor profile
-- (laptop + 2 external, the legacy "ext" profile).
function DynamicLayout()
  if #hl.get_monitors() ~= 3 then
    return
  end

  local ws = hl.get_active_workspace()

  if Utils.get_monitor({ id = ws.monitor.name }).name == "ext1" then
    local tiled = hl.get_windows({ workspace = 1, floating = false })
    -- local reserved = #tiled == 1 and math.floor(ws.monitor.width / ws.monitor.scale * 0.4) or 0
    local reserved = #tiled == 1 and math.floor(ws.monitor.width * 0.4) or 0

    Utils.debug(reserved)
    -- hl.monitor({
    --   output = ws.monitor.name,
    --   mode = ws.monitor.mode,
    --   position = ws.monitor.position,
    --   scale = ws.monitor.scale,
    --   reserved_area = { top = 0, right = 0, bottom = 0, left = reserved },
    -- })
  end

  --   local i = 0
  --   local target
  --   for _, window in ipairs(hl.get_workspace_windows(ws)) do
  --     if window.floating == false and window.fullscreen == 0 then
  --       i = i + 1
  --       target = window
  --     end
  --   end
  --
  --   if i == 1 then
  --     Utils.debug("TEST")
  --   end
  -- end

  -- local ws = hl.get_workspace(1)
  -- if ws == nil or ws.monitor == nil then
  --   return
  -- end

  -- local monitor = ws.monitor

  -- Utils.debug(monitor)
  -- -- Count only tiled (non-floating) windows on workspace 1.
  -- local tiled = hl.get_windows({ workspace = 1, floating = false })
  -- local reserved = #tiled == 1 and math.floor(monitor.width / monitor.scale * 0.4) or 0
  --
  -- hl.monitor({
  --   output = monitor.name,
  --   reserved_area = { top = 0, right = 0, bottom = 0, left = reserved },
  -- })
end
