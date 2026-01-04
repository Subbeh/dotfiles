return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "zapling/mason-conform.nvim",
  },

  config = function()
    require("mason").setup()

    require("conform").setup({
      -- Enable debug logging
      notify_on_error = true,
      log_level = vim.log.levels.DEBUG,

      -- Config
      format_on_save = function(bufnr)
        -- Skip .j2 files
        if vim.bo[bufnr].filetype == "yaml.j2" or vim.fn.expand("%", { buf = bufnr }):match("%.j2$") then
          return nil
        end
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
      default_format_opts = {
        lsp_format = "fallback",
      },

      -- Formatters
      formatters_by_ft = {
        bash = { "shfmt" },
        go = { "goimports", "gofmt" },
        json = { "prettier_json" },
        -- lua = { "stylua", lsp_format = "fallback" },
        markdown = { "prettier" },
        python = { "ruff_check", "ruff" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        yaml = { "prettier_yaml" },
        zsh = { "shfmt" },
      },

      -- Configure formatters
      formatters = {
        ruff = {
          command = "ruff",
          args = {
            "format",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
        },
        ruff_check = {
          command = "ruff",
          args = {
            "check",
            "--fix",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
        },
        shfmt = {
          args = { "-i", "2", "-ci" }, -- 2 space indentation and indent switch cases
        },
        prettier_json = {
          command = "prettier",
          args = {
            "--print-width",
            "120",
            "--tab-width",
            "2",
            "--use-tabs",
            "false",
            "--single-quote",
            "false",
            "--parser",
            "json",
          },
        },
        prettier_yaml = {
          command = "prettier",
          args = {
            "--print-width",
            "1000", -- Very high to prevent wrapping
            "--tab-width",
            "2",
            "--prose-wrap",
            "preserve",
            "--object-wrap",
            "preserve",
            "--parser",
            "yaml",
          },
        },
        terraform_fmt = {
          command = "terraform",
          args = { "fmt", "-" },
          stdin = true,
        },
      },
    })
    require("mason-conform").setup()
  end,
}
