-- stylua: ignore start
-- SYSTEM
hl.bind("SUPER + SHIFT + R",              function () hl.dsp.exec_cmd("hyprctl reload") StartWaybar() end)
hl.bind("CTRL + ALT + DELETE",            hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- APPS
hl.bind("SUPER + RETURN",                 hl.dsp.exec_cmd(TERM))
hl.bind("SUPER + SPACE",                  hl.dsp.exec_cmd("pkill rofi || __rofi_launcher drun launcher"))

-- WINDOWS
hl.bind("SUPER + Q",                      hl.dsp.window.close("activewindow"))
hl.bind("SUPER + SHIFT + Q",              hl.dsp.window.close("activewindow"))
hl.bind("F9",                             hl.dsp.window.fullscreen({ mode = "maximized",                     action = "toggle", window = "activewindow" }))
hl.bind("F10",                            hl.dsp.window.fullscreen({ mode = "fullscreen",                    action = "toggle", window = "activewindow" }))
hl.bind("ALT + SHIFT + TAB",              hl.dsp.window.cycle_next("next"))
hl.bind("CTRL + TAB",                     hl.dsp.exec_cmd("__rofi_launcher window windows"))
hl.bind("SUPER + F",                      hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + H",                      hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L",                      hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K",                      hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J",                      hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + CTRL + SHIFT + H",       hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + SHIFT + L",       hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + mouse:272",              hl.dsp.window.drag(),                                              { mouse = true })
hl.bind("SUPER + SHIFT + mouse:272",      hl.dsp.window.resize(),                                            { mouse = true })

--- swap windows
hl.bind("SUPER + code:34",                hl.dsp.window.swap({ next = 1 }))
hl.bind("SUPER + code:35",                hl.dsp.window.swap({ prev = 1 }))

-- WORKSPACES
hl.bind("SUPER + TAB",                    hl.dsp.focus({ workspace = "previous" }))
hl.bind("ALT + TAB",                      hl.dsp.workspace.toggle_special("term"))
hl.bind("SUPER + SHIFT + TAB",            function() Func.toggle_hyprexpo() end)
hl.bind("SUPER + S",                      function() Func.toggle_special() end)
hl.bind("F12",                            Dropterm())
hl.bind("SUPER + CTRL + H",               hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + L",               hl.dsp.focus({ workspace = "e+1" }))
for i = 1,                                9 do
  hl.bind("SUPER + " .. i,                hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + CTRL + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + CTRL + M",               function() Func.move_all_workspaces(hl.get_active_monitor()) end)

-- WAYBAR
hl.bind("SUPER + CTRL + W",               function() StartWaybar(hl.get_active_monitor().name) end)
for i, m in ipairs(Monitors) do
  hl.bind("SUPER + CTRL + " .. i,         function() StartWaybar(m.name or m.desc) end)
end

-- MEDIA
hl.bind("XF86AudioRaiseVolume",           hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true,   repeating = true })
hl.bind("XF86AudioLowerVolume",           hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true,   repeating = true })
hl.bind("XF86AudioMute",                  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true,   repeating = true })
hl.bind("XF86AudioNext",                  hl.dsp.exec_cmd("playerctl next"),                                 { locked = true })
hl.bind("XF86AudioPause",                 hl.dsp.exec_cmd("playerctl play-pause"),                           { locked = true })
hl.bind("XF86AudioPlay",                  hl.dsp.exec_cmd("playerctl play-pause"),                           { locked = true })
hl.bind("XF86AudioPrev",                  hl.dsp.exec_cmd("playerctl previous"),                             { locked = true })

-- SCREENSHOTS
hl.bind("SUPER + SHIFT + 1",                hl.dsp.exec_cmd("hyprshot -m active -o $TEMP_DIR/screenshots"))
hl.bind("SUPER + SHIFT + 2",                hl.dsp.exec_cmd("hyprshot -m window -o $TEMP_DIR/screenshots"))
hl.bind("SUPER + SHIFT + 4",                hl.dsp.exec_cmd("hyprshot -m region -o $TEMP_DIR/screenshots"))

-- GESTURES
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up",         action = function() Func.toggle_hyprexpo("enable") end })
hl.gesture({ fingers = 3, direction = "down",       action = function() Func.toggle_hyprexpo("cancel") end })
