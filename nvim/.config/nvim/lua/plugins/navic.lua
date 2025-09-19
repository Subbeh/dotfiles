return {
  "SmiteshP/nvim-navic", -- TODO: is loaded?
  dependencies = {
    "LunarVim/breadcrumbs.nvim",
    "neovim/nvim-lspconfig",
  },

  config = function()
    local navic = require("nvim-navic")
    local icons = require("config.icons")

    require("breadcrumbs").setup()

    vim.lsp.config.clangd = {
      cmd = { "clangd" },
      on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
      end,
    }

    navic.setup({
      icons = icons.kind,
      highlight = true,
      lsp = {
        auto_attach = true,
      },
      separator = " " .. icons.ui.ChevronRight .. " ",
    })
  end,
}
