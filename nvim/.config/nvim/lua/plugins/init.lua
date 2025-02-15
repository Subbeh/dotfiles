-- TODO: https://github.com/exosyphon/nvim/blob/main/lua/plugins.lua
-- neogit
-- oil
-- neotest
-- tabby?
-- octo

return {
  { "nvim-lua/plenary.nvim" },
  { "echasnovski/mini.nvim" },
  { "echasnovski/mini.icons" },
  { "nvim-tree/nvim-web-devicons" },
  { "chentoast/marks.nvim",       event = "VeryLazy",                                            opts = {} },
  { "RRethy/vim-illuminate",      config = function() require("illuminate") end },
  { "tpope/vim-fugitive",         keys = { { "<leader>gg", "<cmd>Git<cr>", desc = "Fugitive" } } },
  { "numToStr/Comment.nvim",      opts = {} },
  { "windwp/nvim-autopairs",      event = "InsertEnter",                                         config = true },
  { "rmagatti/auto-session",      lazy = false }, -- TODO: debug
  { "monaqa/dial.nvim" },                         -- TODO: is enabled?
  { "stevearc/dressing.nvim",     opts = {} },
  { "kawre/neotab.nvim",          event = "InsertEnter",                                         opts = {} },
  { "ibhagwan/fzf-lua" },

  {
    "sindrets/diffview.nvim", -- TODO: add keymaps
    event = "VeryLazy",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  },

  {
    "kylechui/nvim-surround", -- TODO: keybindings
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  {
    "brenoprata10/nvim-highlight-colors",

    keys = {
      { "<leader>uc", "<cmd>HighlightColors Toggle<cr>", desc = "Toggle HighlightColors" },
    },

    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },
}
