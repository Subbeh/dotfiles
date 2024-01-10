return {
  -- tab out from parentheses, quotes, and similar contexts
  "abecodes/tabout.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
  },
  config = true,
}
