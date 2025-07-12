return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>ft", "<cmd>TodoTelescope keywords=TODO<cr>", desc = "Todos" },
  },
  config = function()
    local colors = require("config.colors")

    require("todo-comments").setup({
      keywords = {
        FIX = {
          color = colors.red.base,
        },
        TODO = { icon = "󰙒 ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󱎫 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)]], -- pattern or table of patterns, used for highlighting (vim regex)
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", colors.red.base },
        warning = { "DiagnosticWarn", "WarningMsg", colors.yellow.bright },
        info = { "DiagnosticInfo", colors.blue.base },
        hint = { "DiagnosticHint", colors.cyan.base },
        default = { "Identifier", colors.magenta.base },
        test = { "Identifier", colors.magenta.bright },
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]], -- ripgrep regex
      },
    })
  end,
}
