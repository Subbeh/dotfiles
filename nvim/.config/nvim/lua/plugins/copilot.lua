return {
  {
    "zbirenbaum/copilot.lua",
    cond = vim.loop.os_uname().sysname == "Darwin", -- Only enable on macOS
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
        },
      },
      panel = { enabled = false },
      filetypes = {
        ["*"] = true,
      },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = vim.loop.os_uname().sysname == "Darwin", -- Only enable on macOS
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    keys = {
      { "<leader>aA", "<cmd>CopilotChat<cr>", desc = "Copilot Chat" },
    },
    opts = {},
  },
}
