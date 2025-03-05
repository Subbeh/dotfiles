return {
  {
    "nvim-treesitter/nvim-treesitter", -- TODO: update ensure_installed
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nvim-treesitter/playground" },
      { "nvim-treesitter/nvim-treesitter-context" },
      { "LiadOz/nvim-dap-repl-highlights" },
      { "RRethy/nvim-treesitter-endwise" }, -- TODO: test if works
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>ct", "<cmd>TSPlaygroundToggle<cr>", desc = "TSPlayground" },
    },
    opts = {
      auto_install = true,
      ensure_installed = {
        "arduino",
        "awk",
        "bash",
        "c",
        "comment",
        "css",
        "csv",
        "dap_repl",
        "dockerfile",
        "go",
        "helm",
        "html",
        "hyprlang",
        "javascript",
        "jq",
        "json",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "printf",
        "python",
        "query",
        "regex",
        "sql",
        "ssh_config",
        "terraform",
        "tmux",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "org", "markdown" },
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
      fold = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
      matchup = {
        enable = true,
      },
      endwise = {
        enable = true,
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end

      vim.filetype.add({
        extension = { rasi = "rasi" },
        pattern = {
          [".*/hypr/.*%.conf"] = "hyprlang",
        },
      })

      require("nvim-dap-repl-highlights").setup() -- must be setup before nvim-treesitter
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>cj", "<cmd>TSJToggle<cr>", desc = "Toggle TreeSJ" },
    },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 240,
      })
    end,
  },
}
