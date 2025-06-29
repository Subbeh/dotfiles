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
        json = { "prettier_json" },
        lua = { "lsp" },
        markdown = { "prettier" },
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
        yamlfmt = {
          prepend_args = {
            "-formatter",
            "include_document_start=true,indent=2,retain_line_breaks_single=true,pad_line_comments=2",
          },
        },
      },
    })
    require("mason-conform").setup()
  end,
}
