return {
  "j-hui/fidget.nvim",
  lazy = false,

  keys = {
    { "<leader>sl", "<cmd>Fidget history<cr>", desc = "Notifications" },
  },

  opts = {
    notification = {
      window = {
        normal_hl = "Comment", -- Base highlight group in the notification window
        y_padding = 1,         -- Padding from bottom edge of window boundary
      },
      override_vim_notify = true,
    },

    progress = {
      display = {
        done_icon = require("config.icons").ui.Check,
      },
    },

    integration = {
      ["nvim-tree"] = {
        enable = true,
      },
    },
  },
}
