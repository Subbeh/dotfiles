vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })

require("fidget").setup({
  notification = {
    window = { normal_hl = "Comment", y_padding = 1 },
    override_vim_notify = true,
  },
  progress = {
    display = { done_icon = "✓" },
  },
})
