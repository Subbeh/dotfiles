return {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>cn", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
  },
  opts = {
    icons = require("config.icons").kind,

    lsp = { auto_attach = true }
  },
}
