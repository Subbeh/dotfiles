return {
  -- legend for keymaps, commands, and autocmds
  {
    "mrjones2014/legendary.nvim",
    opts = {
      which_key = { auto_register = true },
    },
  },

  -- key bindings
  {
    "folke/which-key.nvim",
    dependencies = {
      "mrjones2014/legendary.nvim",
    },
    event = "VeryLazy",
    opts = {
      setup = {
        show_help = true,
        marks = true,
        registers = true,
        plugins = { spelling = true },
        ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<space>", "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
        show_keys = true, -- show the currently pressed key and its label as a message in the command line
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
      },

      defaults = {
        prefix = "<leader>",
        mode = { "n", "v" },
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true, -- use `nowait` when creating keymaps
      },

      mappings = {
        ["/"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find" },
        ["<space>"] = { "<cmd>Telescope find_files<cr>", "Find File" },
        e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        -- w = { "<cmd>update!<cr>", "Save" },
        L = { "<cmd>Lazy<cr>", "Lazy" },
        M = { "<cmd>Mason<cr>", "Mason" },
        q = {
          name = "+Quit/Session",
          q = {
            function()
              require("utils").quit()
            end,
            "Quit",
          },
          t = { "<cmd>tabclose<cr>", "Close Tab" },
        },
        b = {
          name = "+Buffer",
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
        c = {
          name = "+Code",
          j = { "<cmd>TSJToggle<cr>", "Toggle TreeSJ" },
          t = { "<cmd>TodoTrouble<cr>", "ToDo (Trouble)" },
          T = { "<cmd>TodoTelescope<cr>", "ToDo" },
          d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
          D = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
        },
        f = {
          name = "+Find",
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>Telescope commands<cr>", "Commands" },
          f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search in buffer" },
          g = { "<cmd>Telescope live_grep<cr>", "Grep" },
          h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
          m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
          r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
          R = { "<cmd>Telescope registers<cr>", "Registers" },
          k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        },
        m = {
          name = "+Misc",
          c = { "<cmd>ColorizerToggle<cr>", "Toggle Colorizer" },
          l = { "<cmd>Legendary<cr>", "Key mappings" },
          m = {
            function()
              require("mini.map").toggle {}
            end,
            "Toggle Minimap",
          },
          n = {
            function()
              require("nvim-navbuddy").open()
            end,
            "Code Outline (navbuddy)",
          },
          z = {
            function()
              require("mini.misc").zoom()
            end,
            "Toggle Zoom",
          },
        },
        r = { name = "+Refactor" },
        s = {
          name = "+Session",
          s = {
            function()
              require("persistence").load()
            end,
            "Restore Session",
          },
          l = {
            function()
              require("persistence").load { last = true }
            end,
            "Restore Last Session",
          },
          d = {
            function()
              require("persistence").stop()
            end,
            "Don't Save Current Session",
          },
        },
        w = {
          name = "+Window",
          s = { "<cmd>vsplit<cr>", "Split Window" },
        },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts.setup)
      wk.register(opts.mappings, opts.defaults)
    end,
  },
}
