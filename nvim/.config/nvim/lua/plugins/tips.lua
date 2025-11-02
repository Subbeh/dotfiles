return {
  "saxon1964/neovim-tips",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  opts = {
    daily_tip = 0,
    bookmark_symbol = " ",
  },
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>mt", ":NeovimTips<CR>", { desc = "Neovim tips", noremap = true, silent = true })
  end,
}
