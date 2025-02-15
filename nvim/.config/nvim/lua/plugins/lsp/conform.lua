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
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      default_format_opts = {
        lsp_format = "fallback",
      },

      -- Formatters
      formatters_by_ft = {
        bash = { "shfmt" },
        go = { "goimports", "gofmt" },
        json = { "prettier" },
        lua = { "lsp" },
        python = { "ruff" },
        sh = { "shfmt" },
        yaml = { "yamlfmt" },
        zsh = { "shfmt" },
      },

      -- Configure formatters
      formatters = {
        shfmt = {
          args = { "-i", "2", "-ci" }, -- 2 space indentation and indent switch cases
        },
        prettier = {
          args = {
            "--print-width",
            "120",
            "--tab-width",
            "2",
            "--use-tabs",
            "false",
            "--single-quote",
            "false",
          },
        },
        yamlfmt = {
          prepend_args = {
            "-formatter",
            "include_document_start=true,indent=2,retain_line_breaks_single=true",
          },
        },
      },
    })
    require("mason-conform").setup()
  end,
}
