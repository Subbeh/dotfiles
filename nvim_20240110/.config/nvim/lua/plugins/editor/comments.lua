return {
  -- comments
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
    config = function(_, _)
      local opts = {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
      require("Comment").setup(opts)
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function(_, _)
      local opts = {
        enable_autocmd = false,
      }
      require("ts_context_commentstring").setup(opts)
    end,
  },
}
