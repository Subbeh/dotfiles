return {
  -- fuzzy finder over lists
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      "nvim-telescope/telescope-file-browser.nvim",
      "stevearc/aerial.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "aaronhallaert/advanced-git-search.nvim",
      "benfowler/telescope-luasnip.nvim",
      {
        "ecthelionvi/NeoComposer.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        enabled = false,
        opts = {},
      },
    },
    cmd = "Telescope",
    -- stylua: ignore
    config = function(_, _)
      local telescope = require "telescope"
      local icons = require "config.icons"
      local actions = require "telescope.actions"
      local actions_layout = require "telescope.actions.layout"
      local transform_mod = require("telescope.actions.mt").transform_mod
      local custom_actions = transform_mod {
        -- VisiData
        visidata = function(prompt_bufnr)
          -- Get the full path
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end
          local full_path = content.cwd .. require("plenary.path").path.sep .. content.value

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open the file with VisiData
          local utils = require "utils"
          utils.open_term("vd " .. full_path, { direction = "float" })
        end,

        -- File browser
        file_browser = function(prompt_bufnr)
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end

          local full_path = content.cwd
          if content.filename then
            full_path = content.filename
          elseif content.value then
            full_path = full_path .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open file browser
          -- vim.cmd("Telescope file_browser select_buffer=true path=" .. vim.fs.dirname(full_path))
          require("telescope").extensions.file_browser.file_browser { select_buffer = true, path = vim.fs.dirname(full_path) }
        end,
      }
      local mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["?"] = actions_layout.toggle_preview,
          ["<C-s>"] = custom_actions.visidata,
          ["<A-f>"] = custom_actions.file_browser,
        },
        n = {
          ["s"] = custom_actions.visidata,
          ["<A-f>"] = custom_actions.file_browser,
        },
      }

      local opts = {
        defaults = {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          mappings = mappings,
          -- border = {},
          -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          path_display = { "smart" },
        },
        pickers = {
          find_files = {
            layout_config = {
              height = 0.70
            },
            previewer = true,
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--unrestricted",
              "-g", "!.git",
              "-g", "!.direnv",
            },
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
          },
        },
        extensions = {
          file_browser = {
            theme = "dropdown",
            previewer = false,
            hijack_netrw = true,
            mappings = mappings,
          },
          project = {
            hidden_files = false,
            theme = "dropdown",
          },
        },
      }

      telescope.setup(opts)
      telescope.load_extension "fzf"
      telescope.load_extension "file_browser"
    end,
  },
}
