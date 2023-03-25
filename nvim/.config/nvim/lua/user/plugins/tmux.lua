local status_ok, tmux = pcall(require, "nvim-tmux-navigation")
if not status_ok then
  return
end

tmux.setup {
  disable_when_zoomed = true -- defaults to false
}

vim.keymap.set('n', "<C-h>", tmux.NvimTmuxNavigateLeft)
vim.keymap.set('n', "<C-j>", tmux.NvimTmuxNavigateDown)
vim.keymap.set('n', "<C-k>", tmux.NvimTmuxNavigateUp)
vim.keymap.set('n', "<C-l>", tmux.NvimTmuxNavigateRight)
vim.keymap.set('n', "<C-\\>", tmux.NvimTmuxNavigateLastActive)
vim.keymap.set('n', "<C-Space>", tmux.NvimTmuxNavigateNext)
