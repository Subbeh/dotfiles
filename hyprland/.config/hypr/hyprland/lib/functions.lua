--- @class Func
local Func = {}

--- Select the active machine profile by matching the internal eDP-1 panel's
--- description against Profiles[*].panel. Falls back to a generic layout built
--- from the connected outputs. Sets the Monitors and Panel globals.
Func.select_profile = function()
  local live = hl.get_monitors()
  local internal
  for _, m in ipairs(live) do
    if m.name == "eDP-1" then
      internal = m
      break
    end
  end

  Profile = nil
  if internal then
    for name, p in pairs(Profiles) do
      if internal.description:find(p.panel, 1, true) then
        Profile = p
        Profile.name = name
        break
      end
    end
  end

  if not Profile then
    Profile = Func.build_fallback(live, internal)
    Profile.name = "generic"
  end

  Monitors = Profile.monitors
  Panel = "eDP-1"
  for _, m in ipairs(Monitors) do
    if m.key == "laptop" then
      Panel = m.name
    end
  end
end

--- Build a generic profile from the connected outputs: the internal panel
--- becomes "laptop", the rest "ext1..N", each at preferred mode / auto position.
--- No workspace pins, so Hyprland distributes workspaces normally.
Func.build_fallback = function(live, internal)
  local mons, idx = {}, 0
  for _, m in ipairs(live) do
    if internal and m.name == internal.name then
      mons[#mons + 1] = { key = "laptop", name = m.name, mode = "preferred", position = "auto", scale = 1 }
    else
      idx = idx + 1
      mons[#mons + 1] = { key = "ext" .. idx, name = m.name, mode = "preferred", position = "auto", scale = 1 }
    end
  end
  return { monitors = mons }
end

Func.toggle_hyprexpo = function(action)
  if hl.plugin and hl.plugin.hyprexpo then
    hl.plugin.hyprexpo.expo("toggle")
  else
    action = action or "toggle"
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch \"hl.dsp.exec_raw('hyprexpo:expo " .. action .. "')\""))
  end
end

Func.toggle_special = function()
  if hl.get_active_special_workspace() then
    if hl.get_active_special_workspace().name == "special:term" then
      hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace().name }))
    end
  else
    hl.dispatch(hl.dsp.window.move({ workspace = "special:term" }))
  end
end

Func.reload_layout = function()
  -- Put waybar on the profile's preferred monitor if it's live, else the panel.
  local target = Panel
  for _, m in ipairs(Monitors) do
    if m.waybar then
      for _, mon in ipairs(hl.get_monitors()) do
        if (m.name and mon.name == m.name) or (m.desc and mon.description:find(m.desc, 1, true)) then
          target = mon.name
        end
      end
    end
  end
  StartWaybar(target)
  hl.dispatch(hl.dsp.focus({ workspace = "2" }))
end

Func.lid_closed = false

Func.set_lid = function(closed)
  Func.lid_closed = closed
  Func.apply_outputs()
end

Func.apply_outputs = function()
  local externals = 0
  for _, mon in ipairs(hl.get_monitors()) do
    if mon.name ~= Panel then
      externals = externals + 1
    end
  end
  hl.monitor({ output = Panel, disabled = Func.lid_closed and externals > 0 })
  Func.reload_layout()
end

Func.bitwarden_float = function(window)
  if window.title == "Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox" then
    hl.dispatch(hl.dsp.window.float(window))
    local x, y = Utils.percent_to_px(20, 50)
    hl.dispatch(hl.dsp.window.resize({ x = x, y = y, window = window }))
    hl.timer(function()
      hl.dispatch(hl.dsp.window.center({ window = window }))
    end, { timeout = 500, type = "oneshot" })
  end
end

Func.move_all_workspaces = function(monitor)
  for _, ws in ipairs(hl.get_workspaces()) do
    if not ws.special then
      Utils.debug(ws.id)
      hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = monitor }))
    end
  end
end

return Func
