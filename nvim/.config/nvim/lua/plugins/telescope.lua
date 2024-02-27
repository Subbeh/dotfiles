local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-project.nvim",
    "ahmedkhalf/project.nvim",
    "cljoly/telescope-repo.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "aaronhallaert/advanced-git-search.nvim",
    "tsakirist/telescope-lazy.nvim",
    "ecthelionvi/NeoComposer.nvim",
  },

  keys = {
    { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },

    { "<leader>bb", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find" },

    { "<leader>fb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
    { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>ff", "<cmd>Telescope frecency<cr>", desc = "Frequent Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find Text" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find local" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
    { "<leader>fr", "<cmd>Telescope repo list<cr>", desc = "Repositories" },
    { "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers" },
    -- { "<leader>fs", require("auto-session.session-lens").search_session, desc = "Sessions" },
    -- { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Find String" },

    { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
    { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Checkout commit(for current file)" },

    { "<leader>Lp", "<cmd>Telescope lazy<cr>", desc = "Plugin" },

    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>le", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },

    { "<leader>mm", "<cmd>Telescope macros<cr>", desc = "Macros" },
  },
}

function M.config()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
      vim.api.nvim_buf_call(ctx.buf, function()
        vim.fn.matchadd("TelescopeParent", "\t\t.*$")
        vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
      end)
    end,
  })

  local icons = require "core.icons"
  local actions = require "telescope.actions"

  local function filenameFirst(_, path)
    local tail = vim.fs.basename(path)
    local parent = vim.fs.dirname(path)
    if parent == "." then
      return tail
    end
    return string.format("%s\t\t%s", tail, parent)
  end

  require("telescope").setup {
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "smart" },
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" },
      -- sorting_strategy = nil,
      -- layout_strategy = nil,
      -- layout_config = {},
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
        "--glob=!.obsidian/",
        "--glob=!.terraform/",
        "--glob=!node_modules/",
      },

      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
        },
      },
    },
    pickers = {
      live_grep = {
        -- theme = "dropdown",
      },

      grep_string = {
        -- theme = "dropdown",
      },

      find_files = {
        find_command = {
          "rg",
          "--files",
          "--hidden",
          "--glob=!.git/",
          "--glob=!.obsidian/",
          "--glob=!.terraform/",
          "--glob=!node_modules/",
        },
        -- theme = "dropdown",
        previewer = true,
        hidden = true,
        path_display = filenameFirst,
        layout_config = {
          height = 0.70,
        },
      },

      buffers = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },

      colorscheme = {
        enable_preview = true,
      },

      lsp_references = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_definitions = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_declarations = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_implementations = {
        theme = "dropdown",
        initial_mode = "normal",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
      repo = {
        list = {
          fd_opts = {
            "--no-ignore-vcs",
          },
          search_dirs = {
            "/data/workspace",
          },
        },
      },
    },
  }
end

return M
