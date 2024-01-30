return {
  -- plugin for splitting/joining blocks of code
  "Wansmer/treesj",
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<leader>cj", "<cmd>TSJToggle<cr>", desc = "Toggle TreeSJ" },
  },
  config = function()
    require("treesj").setup {
      use_default_keymaps = false,
    }
  end,
}
