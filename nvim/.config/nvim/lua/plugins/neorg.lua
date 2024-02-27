return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    -- tag = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
    -- stylua: ignore
    keys = {
      { "<leader>ns", "<cmd>Neorg index<cr>", desc = "Start Neorg", },
      { "<leader>nx", "<cmd>Neorg return<cr>", desc = "Exit Neorg", },
      { "<leader>nt", "<cmd>Neorg toggle-concealer<cr>", desc = "Toggle concealer", },
      { "<leader>nw", "<cmd>Telescope neorg switch_workspace<cr>", desc = "Switch Workspace", },
    },

    config = function()
      -- fix concealer
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.norg" },
        command = "set conceallevel=3",
      })

      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {
            config = {
              icon_preset = "varied",
              icons = {
                delimiter = {
                  horizontal_line = {
                    highlight = "@neorg.delimiters.horizontal_line",
                  },
                },
                code_block = {
                  content_only = true,
                  width = "content",
                  padding = {
                    left = 1,
                    right = 1,
                  },
                  conceal = true,

                  nodes = { "ranged_verbatim_tag" },
                  highlight = "CursorLine",
                  insert_enabled = true,
                },
              },
            },
          },
          ["core.integrations.telescope"] = {},
          -- ["core.completion"] = {}, -- Adds completion
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                tech = "/data/notes/tech",
                study = "/data/notes/study",
                work = "/data/notes/work",
              },
              default_workspace = "tech",
            },
          },
        },
      }

      local neorg_callbacks = require "neorg.core.callbacks"
      neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
        -- Map all the below keybinds only when the "norg" mode is active
        keybinds.map_event_to_mode("norg", {
          n = { -- Bind keys in normal mode
            { "<C-s>", "core.integrations.telescope.find_linkable" },
          },

          i = { -- Bind in insert mode
            { "<C-l>", "core.integrations.telescope.insert_link" },
          },
        }, {
          silent = true,
          noremap = true,
        })
      end)
    end,
  },
}
