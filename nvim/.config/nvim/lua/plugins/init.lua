-- TODO: https://github.com/exosyphon/nvim/blob/main/lua/plugins.lua
-- neogit
-- oil
-- neotest
-- tabby?
-- octo

return {
  -- stylua: ignore start
  { "nvim-lua/plenary.nvim" },
  { "nvim-mini/mini.nvim" },
  { "nvim-mini/mini.icons" },
  { "nvim-mini/mini.align", opts = {} },
  { "nvim-tree/nvim-web-devicons" },
  { "chentoast/marks.nvim",       event = "VeryLazy",                                            opts = {} },
  { "tpope/vim-fugitive",         keys = { { "<leader>gg", "<cmd>Git<cr>", desc = "Fugitive" } } },
  { "numToStr/Comment.nvim",      opts = {} },
  { "windwp/nvim-autopairs",      event = "InsertEnter",                                         config = true },
  -- { "rmagatti/auto-session",      lazy = false }, -- TODO: debug
  { "monaqa/dial.nvim" }, -- TODO: is enabled?
  { "stevearc/dressing.nvim",     opts = {} },
  { "kawre/neotab.nvim",          event = "InsertEnter",                                         opts = {} },
  { "ibhagwan/fzf-lua" },
  { "HiPhish/jinja.vim" },

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
