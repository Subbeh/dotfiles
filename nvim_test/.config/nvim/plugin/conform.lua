vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  notify_on_error = true,
  format_on_save = function(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match("%.j2$") then return nil end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
  default_format_opts = { lsp_format = "fallback" },
  formatters_by_ft = {
    bash = { "shfmt" },
    go = { "goimports", "gofmt" },
    json = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "ruff_organize_imports", "ruff_format" },
    sh = { "shfmt" },
    yaml = { "prettier" },
    zsh = { "shfmt" },
  },
  formatters = {
    shfmt = { args = { "-i", "2", "-ci" } },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })
