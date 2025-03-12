-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Press q to close windows
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "netrw",
    "qf",
    "git",
    "help",
    "man",
    "lspinfo",
    "fugitive",
    "spectre_panel",
    "AvanteInput",
    "tsplayground",
    "TelescopePrompt",
    "",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close!<CR>
      set nobuflisted
    ]]
  end,
})

-- Press q to quit
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "man",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :q<CR>
      set nobuflisted
    ]]
  end,
})

-- Highlight line on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
