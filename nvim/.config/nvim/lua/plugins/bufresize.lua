return {
  {
    "kwkarlwang/bufresize.nvim",
    config = function()
      local opts = { noremap = true, silent = true }
      require("bufresize").setup {
        register = {
          keys = {
            { "n", "g=", ":horizontal resize +5<cr>", opts },
            { "n", "g-", ":horizontal resize -5<cr>", opts },
            { "n", "+", ":vertical resize +5<cr>", opts },
            { "n", "_", ":vertical resize -5<cr>", opts },
          },
          trigger_events = { "BufWinEnter", "WinEnter" },
        },
        resize = {
          keys = {},
          trigger_events = { "VimResized" },
          increment = 5,
        },
      }
    end,
  },
}
