local CLASS = "dropterm"
local prev_ws = nil

hl.window_rule({
  match = { class = "^" .. CLASS .. "$" },
  workspace = "special:dropterm",
  opacity = "0.8",
  float = true,
  no_blur = true,
  no_dim = true,
  -- pin = true,
  size = { "monitor_w*0.8", "monitor_h*0.5" },
  move = { "monitor_w*0.1", "0" },
  animation = "slidefadevert -15%",
})

local function resize_dropterm()
  local monitor = hl.get_active_monitor()
  if not monitor then
    return
  end
  local scale = monitor.scale or 1
  local mw = monitor.width / scale
  local mh = monitor.height / scale
  local w = math.floor(mw * 0.8)
  local h = math.floor(mh * 0.5)
  local x = monitor.x + math.floor(mw * 0.1)
  local y = monitor.y
  local win = "class:^" .. CLASS .. "$"
  hl.dispatch(hl.dsp.window.resize({ x = w, y = h, window = win }))
  hl.dispatch(hl.dsp.window.move({ x = x, y = y, window = win }))
end

function Dropterm()
  return function()
    local active = hl.get_active_special_workspace() and hl.get_active_special_workspace() or hl.get_active_workspace()
    if active.name == "special:" .. CLASS then
      hl.dispatch(hl.dsp.workspace.toggle_special(CLASS))
      if prev_ws and prev_ws.name == "special:term" then
        hl.dispatch(hl.dsp.workspace.toggle_special("term"))
      end
    else
      prev_ws = active
      local ws = hl.get_workspace("special:" .. CLASS)
      if ws == nil or ws.is_empty then
        hl.exec_cmd("uwsm app -- kitty --class " .. CLASS .. " -o font_size=9 -o window_padding_width='20 10 10 10'" .. " -e zsh -c 'tmux new-session -A -s " .. CLASS .. "'")
      else
        hl.dispatch(hl.dsp.workspace.toggle_special(CLASS))
        resize_dropterm()
      end
    end
  end
end
