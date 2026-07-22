vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters_by_ft = {
  go = { "golangcilint" },
  lua = { "luacheck" },
  python = { "ruff" },
  yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function() lint.try_lint() end,
})
