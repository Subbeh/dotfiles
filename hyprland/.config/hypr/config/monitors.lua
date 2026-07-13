--- Profile selection + left-to-right monitor placement.
---
--- Reads the globals MONITORS (ordered hardware catalog) and PROFILES (ordered;
--- each references catalog monitors by name and attaches ws pins + a waybar flag),
--- picks the most-specific profile whose monitors are all connected, computes each
--- monitor's position from its mode/scale, and applies hl.monitor + workspace rules.
local M = {}

--- Index MONITORS by name.
--- @return table<string, table>
local function catalog()
  local by_name = {}
  for _, m in ipairs(MONITORS) do
    by_name[m.name] = m
  end
  return by_name
end

--- Live monitor matching a catalog entry's description (fallback: name), or nil.
--- @param cat table catalog entry with a `desc` field
--- @param live table[] result of hl.get_monitors()
--- @return table|nil
local function connected(cat, live)
  for _, mon in ipairs(live) do
    if mon.description == cat.desc or mon.name == cat.desc then
      return mon
    end
  end
  return nil
end

--- Logical width of a monitor in layout pixels (mode width / scale, rounded).
--- @param cat table catalog entry with `mode` and optional `scale`
--- @return integer
local function logical_width(cat)
  local px = tonumber(cat.mode:match("(%d+)x"))
  return math.floor(px / (cat.scale or 1) + 0.5)
end

--- Count the monitors a profile declares.
--- @param profile table
--- @return integer
local function monitor_count(profile)
  local n = 0
  for _ in pairs(profile.monitors) do
    n = n + 1
  end
  return n
end

--- True when every monitor a profile declares is currently connected.
--- @param profile table
--- @param by_name table<string, table>
--- @param live table[]
--- @return boolean
local function profile_matches(profile, by_name, live)
  for name in pairs(profile.monitors) do
    local cat = by_name[name]
    if not cat or not connected(cat, live) then
      return false
    end
  end
  return true
end

--- Selects the active profile and builds the global Monitors list + Panel.
--- Picks the most-specific (most monitors) profile whose monitors are all connected.
M.select = function()
  local live = hl.get_monitors()
  local by_name = catalog()

  local chosen
  for _, profile in ipairs(PROFILES) do
    if profile_matches(profile, by_name, live) then
      if not chosen or monitor_count(profile) > monitor_count(chosen) then
        chosen = profile
      end
    end
  end

  Monitors = {}
  Panel = nil
  if not chosen then
    return
  end

  -- Walk the catalog in order so monitors are placed left-to-right.
  local x = 0
  for _, cat in ipairs(MONITORS) do
    local role = chosen.monitors[cat.name]
    if role then
      local entry = {
        name = cat.name,
        desc = cat.desc,
        mode = cat.mode,
        scale = cat.scale or 1,
        position = x .. "x0",
        ws = role.ws,
        waybar = role.waybar,
      }
      Monitors[#Monitors + 1] = entry
      if role.waybar then
        Panel = cat.desc
      end
      x = x + logical_width(cat)
    end
  end
end

--- Applies monitor modes/positions and persistent workspace rules for the active list.
M.apply = function()
  for _, m in ipairs(Monitors) do
    Utils.debug("TEST: " .. m.name .. " - " .. m.mode .. " - " .. m.position .. " - " .. m.scale)
    hl.monitor({
      output = "desc:" .. m.desc,
      mode = m.mode,
      position = m.position,
      scale = tostring(m.scale),
    })
    if m.ws then
      for _, n in ipairs(m.ws) do
        hl.workspace_rule({
          workspace = tostring(n),
          monitor = "desc:" .. m.desc,
          persistent = true,
        })
      end
    end
  end
end

--- Selects the profile, applies the layout, and moves waybar onto the panel.
local function layout()
  M.select()
  M.apply()
  if Panel then
    StartWaybar(Panel)
  end
end

--- Runs the layout now (handles `hyprctl reload`, when monitors are live) and
--- re-runs it on startup + hotplug. hl.get_monitors() is empty at config-load on a
--- cold boot, so the hyprland.start handler is what applies the layout then.
M.init = function()
  layout()
  hl.on("hyprland.start", layout)
  hl.on("monitor.added", layout)
  hl.on("monitor.removed", layout)
end

return M
