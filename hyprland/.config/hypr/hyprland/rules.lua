-- WORKSPACE RULES
hl.workspace_rule({ workspace = "1", persistent = true, monitor = "desc:" .. Monitors.ext1.desc })
hl.workspace_rule({ workspace = "2", persistent = true, monitor = "desc:" .. Monitors.ext2.desc, default = true })
hl.workspace_rule({ workspace = "3", persistent = true, monitor = Monitors.laptop.name })

-- WINDOW RULES
hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})
-- hl.window_rule({
--   name = "fix-xwayland-no-focus",
--   match = { xwayland = true },
--   no_focus = true,
-- })
hl.window_rule({
  name = "fix-xwayland-float",
  match = { xwayland = true },
  float = true,
})

--- Apps
hl.window_rule({
  name = "float-pavucontrol",
  match = { class = "org.pulseaudio.pavucontrol" },
  float = true,
  size = "900 900",
})
hl.window_rule({
  name = "float-firefox",
  match = {
    class = "firefox",
    title = "^(Firefox - Choose User Profile|Opening |Extension: |Firefox — Sharing Indicator)",
  },
  float = true,
})
hl.window_rule({
  name = "virt-manager",
  match = {
    class = "virt-manager",
    title = "^(Virtual Machine Manager|QEMU/KVM - Connection Details)",
  },
  float = true,
})
hl.window_rule({
  name = "float-thunar",
  match = { class = "Thunar" },
  float = true,
  size = "1100 900",
})
hl.window_rule({
  name = "fix-pinentry-focus",
  match = { class = "(pinentry-)(.*)" },
  stay_focused = true,
})

--- File pickers floating & centered
hl.window_rule({
  name = "float-file-pickers",
  match = { title = "^(Open File|Open Folder|Open|Save|Save As|Export|Import|Choose File|Rename)$" },
  float = true,
  center = true,
})

--- xdg-desktop-portal dialogs
hl.window_rule({
  name = "float-xdg-portal",
  match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-hyprland)$" },
  float = true,
  center = true,
})
hl.window_rule({
  name = "no-border-xdg-portal",
  match = { class = "^(xdg-desktop-portal-gtk)$" },
  border_size = 0,
})

-- LAYERS
hl.layer_rule({
  name = "rofi-anim",
  match = { namespace = "rofi" },
  animation = "popin 90%",
})
