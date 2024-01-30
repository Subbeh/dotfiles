local M = {
  "folke/trouble.nvim",
  keys = {
    { "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>cD", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Workspace Diagnostics" },
  },
}

return M
