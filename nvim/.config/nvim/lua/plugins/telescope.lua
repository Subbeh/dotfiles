return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "cljoly/telescope-repo.nvim" },
    { "danielfalk/smart-open.nvim",                  branch = "0.2.x" },
    { "nvim-telescope/telescope-fzf-native.nvim" },
    { "kkharji/sqlite.lua" }, -- for smart-open.nvim
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },
    { "tsakirist/telescope-lazy.nvim" },
    { "ecthelionvi/NeoComposer.nvim" },                 -- TODO:
    { "debugloop/telescope-undo.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" }, -- TODO:
    { "xiyaowong/telescope-emoji.nvim" },
    { "2kabhishek/nerdy.nvim" },
    { "jvgrootveld/telescope-zoxide" },
    { "smartpde/telescope-recent-files" },
  },

  keys = {
    { "<leader><leader>", "<cmd>lua require('telescope').extensions.smart_open.smart_open({ cwd_only = true })<cr>", desc = "Find Files" },
    -- { "<leader><leader>", "<cmd>Telescope frecency workspace=CWD<cr>",                                             desc = "Find Files" },
    { "<leader>bb",       "<cmd>Telescope buffers previewer=false<cr>",                                              desc = "Buffers" },
    { "<leader>cu",       "<cmd>Telescope undo<cr>",                                                                 desc = "Undo" },
    { "<leader>cS",       "<cmd>Telescope lsp_document_symbols<cr>",                                                 desc = "LSP Document Symbols" },
    -- { "<leader>ff",       "<cmd>Telescope smart_open<cr>",                                                         desc = "Find Files (all)" },
    { "<leader>ff",       "<cmd>Telescope frecency<cr>",                                                             desc = "Frequent Files (all)" },
    { "<leader>fg",       "<cmd>Telescope live_grep<cr>",                                                            desc = "Grep" },
    { "<leader>fG",       "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",            desc = "Grep (args)" },
    -- { "<leader>fo",       "<cmd>Telescope oldfiles<cr>",                                                           desc = "Recent Files" },
    { "<leader>fo",       "<cmd>lua require('telescope').extensions.recent_files.pick()<cr>",                        desc = "Recent Files" },
    { "<leader>fO",       "<cmd>lua require('telescope').extensions.recent_files.pick({ only_cwd = true})<cr>",      desc = "Recent Files (workspace)" },
    -- { "<leader>fo",       "<cmd>Telescope frecency workspace=CWD<cr>",                                             desc = "Frequent Files (workspace)" },
    { "<leader>fp",       "<cmd>lua require('telescope').extensions.project.project{ display_type = 'full' }<cr>",   desc = "Projects" },
    { "<leader>fr",       "<cmd>Telescope repo list<cr>",                                                            desc = "Repositories" },
    { "<leader>fz",       "<cmd>Telescope zoxide list<cr>",                                                          desc = "Zoxide" },
    { "<leader>me",       "<cmd>Telescope emoji<cr>",                                                                desc = "Emojis" },
    { "<leader>mn",       "<cmd>Telescope nerdy<cr>",                                                                desc = "Nerd Fonts" },
    { "<leader>sc",       "<cmd>Telescope commands<cr>",                                                             desc = "Commands" },
    { "<leader>sh",       "<cmd>Telescope help_tags<cr>",                                                            desc = "Help" },
    { "<leader>sh",       "<cmd>Telescope highlights<cr>",                                                           desc = "Highlights" },
    { "<leader>sk",       "<cmd>Telescope keymaps<cr>",                                                              desc = "Keymaps" },
    { "<leader>sm",       "<cmd>Telescope macros<cr>",                                                               desc = "Macros" },
    { "<leader>sp",       "<cmd>Telescope lazy<cr>",                                                                 desc = "Plugins" },
    { "<leader>sR",       "<cmd>Telescope registers<cr>",                                                            desc = "Registers" },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_ivy({
          winblend = 10,
        }))
      end,
      desc = "Fuzzy Find",
    },
  },

  config = function()
    local icons = require("config.icons")
    local actions = require("telescope.actions")

    local function findFormat(_, path)
      local tail = vim.fs.basename(path)
      local parent = vim.fs.dirname(path)
      if parent == "." then
        return string.format("%-20s  ", tail)
      end
      return string.format("%-20s %s%-20s  ", tail, icons.kind.Folder, parent)
    end

    local function grepFormat(_, path)
      return string.format("%-30s  ", path)
    end

    local file_ignore_patterns = {
      "yarn%.lock",
      "Pipfile.lock",
      "node_modules/",
      "%.git/",
      "build/",
      "package%-lock%.json",
      "%.obsidian/",
      "%.terraform/",
      "%.stversions/",
      "%.direnv/",
    }

    require("telescope").setup({
      defaults = {
        prompt_prefix = " " .. icons.ui.FindFile .. " ",
        selection_caret = icons.ui.Forward,
        winblend = 20,
        mappings = {
          i = {
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          },
        },
        file_ignore_patterns = file_ignore_patterns,
      },

      pickers = {
        find_files = {
          find_command = {
            "rg",
            "--files",
            "--hidden",
          },
          previewer = true,
          hidden = true,
          path_display = findFormat,
          layout_config = {
            height = 0.70,
          },
        },
        grep_string = {
          additional_args = { "--hidden" },
        },
        live_grep = {
          additional_args = { "--hidden" },
          path_display = grepFormat,
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
      },

      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
        lazy = {
          mappings = {
            open_in_browser = "<C-x>",
          },
        },
        project = {
          base_dirs = {
            os.getenv("WORKSPACE_DIR"),
          },
          hidden_files = true,
          sync_with_nvim_tree = true,
        },
        repo = { -- TODO: `locate -r` error
          list = {
            fd_opts = {
              "--no-ignore-vcs",
              "--exclude=.stversions/",
            },
            search_dirs = {
              os.getenv("WORKSPACE_DIR"),
            },
          },
        },
        undo = {},
        smart_open = {
          ignore_patterns = {
            "*.git/*",
            "*.stversions/*",
            "*.direnv/*",
          },
        },
      },
    })

    local load_extension = require("telescope").load_extension
    load_extension("emoji")
    load_extension("frecency")
    load_extension("fzf")
    load_extension("live_grep_args")
    load_extension("nerdy")
    load_extension("project")
    load_extension("recent_files")
    load_extension("repo")
    load_extension("smart_open")
    load_extension("undo")
    load_extension("zoxide")
  end,
}
