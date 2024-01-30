local M = {
  "folke/which-key.nvim",
  dependencies = {
    {
      "mrjones2014/legendary.nvim", -- add global keymappings automatically
      setup = {
        which_key = { auto_register = true },
      },
    },
  },
  event = "VeryLazy",
}

function M.config()
  local mappings = {
    ["<space>"] = { "<cmd>Telescope find_files<cr>", "Find File" },

    h = { "<cmd>nohlsearch<CR>", "NOHL" },
    a = {
      name = "Tab",
      n = { "<cmd>$tabnew<cr>", "New Empty Tab" },
      N = { "<cmd>tabnew %<cr>", "New Tab" },
      o = { "<cmd>tabonly<cr>", "Only" },
      h = { "<cmd>-tabmove<cr>", "Move Left" },
      l = { "<cmd>+tabmove<cr>", "Move Right" },
    },
    c = { name = "Code" },
    b = {
      name = "Buffer",
      r = { "<cmd>e!<cr>", "Reload Buffer" },
      c = { "<cmd>close<cr>", "Close Buffer" },
      d = {
        function()
          require("mini.bufremove").delete(0, false)
        end,
        "Delete Buffer",
      },
      D = {
        function()
          require("mini.bufremove").delete(0, true)
        end,
        "Delete Buffer (Force)",
      },
      h = { "<cmd>BufferLineMovePrev<cr>", "Move buffer left" },
      l = { "<cmd>BufferLineMoveNext<cr>", "Move buffer right" },
    },
    d = {
      name = "Debug",
      a = { name = "Global" },
      g = { name = "Go" },
      u = { name = "UI" },
    },
    f = { name = "Find" },
    g = { name = "Git" },
    l = { name = "LSP" },
    L = {
      name = "Lazy",
      L = { "<cmd>Lazy<cr>", "Lazy" },
    },
    m = { name = "Misc" },
    p = { name = "Plugins" },
    r = { name = "Refactor" },
    t = { name = "Test" },
    T = { name = "Treesitter" },
    w = {
      name = "Window",
      v = { "<cmd>vsplit<CR>", "Split" },
    },
  }

  local which_key = require "which-key"
  which_key.setup {
    show_help = true,
    marks = true,
    registers = true,
    plugins = { spelling = true },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<space>", "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
    triggers = "auto", -- automatically setup triggers
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
    window = {
      border = "rounded", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      spacing = 3,
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    key_labels = {
      -- override the label used to display some keys. It doesn't effect WK in any other way.
      ["<space>"] = "space",
      -- ["<cr>"] = "RET",
      -- ["<tab>"] = "TAB",
    },
  }

  local opts = {
    prefix = "<leader>",
    mode = { "n", "v" },
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  }

  which_key.register(mappings, opts)
end

return M
