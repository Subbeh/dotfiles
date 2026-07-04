return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    { "<leader>X",   "<cmd>Trouble diagnostics toggle focus=true win.type = split win.position=right<cr>",              desc = "Trouble" },
    { "<leader>cxx", "<cmd>Trouble diagnostics toggle focus=true filter.buf=0 win.type = split win.position=right<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>cxs", "<cmd>Trouble symbols toggle focus=false<cr>",                                                     desc = "Symbols (Trouble)" },
    { "<leader>cxl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",                                      desc = "LSP Definitions / references / ... (Trouble)", },
    { "<leader>cxo", "<cmd>Trouble loclist toggle<cr>",                                                                 desc = "Location List (Trouble)" },
    { "<leader>cxq", "<cmd>Trouble qflist toggle<cr>",                                                                  desc = "Quickfix List (Trouble)" },
  },
}
