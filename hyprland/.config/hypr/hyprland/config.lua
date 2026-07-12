hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    layout = "master",
    resize_on_border = true,
    no_focus_fallback = true,
  },

  decoration = {
    dim_inactive = true,
    dim_strength = 0.2,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },

  input = {
    numlock_by_default = true,
    repeat_delay = 250,
    repeat_rate = 35,
    special_fallthrough = true,
  },

  gestures = {
    workspace_swipe_invert = false,
    workspace_swipe_cancel_ratio = 0.1,
    workspace_swipe_create_new = false,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
    -- enable_swallow = true,
    swallow_regex = "(kitty)",
    allow_session_lock_restore = true,
    close_special_on_empty = false,
    on_focus_under_fullscreen = 1,
    exit_window_retains_fullscreen = true,
    initial_workspace_tracking = 0,
    key_press_enables_dpms = true,
  },

  binds = {
    scroll_event_delay = 0,
    workspace_back_and_forth = true,
    hide_special_on_workspace_change = true,
    allow_workspace_cycles = true,
  },

  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },

  debug = {
    disable_logs = false,
    error_position = 1,
  },

  dwindle = {
    preserve_split = true,
    smart_split = true,
  },

  master = {
    mfact = 0.6,
    orientation = "right",
  },

  scrolling = {},
})

hl.device({
  name = "tpps/2-elan-trackpoint",
  accel_profile = "flat",
  sensitivity = 0.5,
})

-- ANIMATIONS
hl.config({
  animations = {
    enabled = true,
  },
})

-- stylua: ignore start
hl.curve("linear",       { type = "bezier", points = { { 0,    0 },    { 1,   1 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2,  0 },    { 0,   0.1 } } })
hl.curve("md3_decel",    { type = "bezier", points = { { 0.05, 0.7 },  { 0.1, 1 } } })
hl.curve("md3_accel",    { type = "bezier", points = { { 0.3,  0 },    { 0.8, 0.15 } } })
hl.curve("menu_decel",   { type = "bezier", points = { { 0.1,  1 },    { 0,   1 } } })
hl.curve("menu_accel",   { type = "bezier", points = { { 0.38, 0.04 }, { 1,   0.07 } } })

-- hl.animation({ leaf = "windowsIn",        enabled = true, speed = 3,  bezier = "md3_decel",    style = "popin 60%" })
-- hl.animation({ leaf = "windowsOut",       enabled = true, speed = 3,  bezier = "md3_accel",    style = "popin 60%" })
hl.animation({ leaf = "windowsMove",         enabled = true, speed = 2,  bezier = "md3_standard", style = "popin 60%" })
hl.animation({ leaf = "border",              enabled = true, speed = 10, bezier = "linear" })
hl.animation({ leaf = "fadeIn",              enabled = true, speed = 4,  bezier = "md3_decel" })
hl.animation({ leaf = "fadeOut",             enabled = true, speed = 4,  bezier = "md3_accel" })
hl.animation({ leaf = "fadeSwitch",          enabled = true, speed = 5,  bezier = "md3_accel" })
hl.animation({ leaf = "fadeDim",             enabled = true, speed = 3,  bezier = "linear" })
hl.animation({ leaf = "fadeShadow",          enabled = true, speed = 3,  bezier = "linear" })
hl.animation({ leaf = "workspaces",          enabled = true, speed = 7,  bezier = "menu_decel",   style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 4,  bezier = "menu_decel",   style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2,  bezier = "menu_accel",   style = "slide bottom" })
