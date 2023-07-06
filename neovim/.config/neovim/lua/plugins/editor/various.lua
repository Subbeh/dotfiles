return {
  -- enable repeating supported plugin maps with "."
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- delete/change/add parentheses/quotes/tags
  { "tpope/vim-surround", event = "BufReadPre" },
}
