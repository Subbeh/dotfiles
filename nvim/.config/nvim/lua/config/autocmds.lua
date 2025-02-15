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
    "",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
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

-- Auto close nvim-tree
-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
--   pattern = "NvimTree_*",
--   callback = function()
--     local layout = vim.api.nvim_call_function("winlayout", {})
--     if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
--       vim.cmd("confirm quit")
--     end
--   end
-- })

-- -- Set ansible filetype
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "**/ansible/**/*.yaml", "**/ansible/**/*.yml" },
--   callback = function(event)
--     local buf = vim.api.nvim_get_current_buf()
--     vim.api.nvim_buf_set_option(buf, "filetype", "yaml.ansible")
--   end,
-- })
