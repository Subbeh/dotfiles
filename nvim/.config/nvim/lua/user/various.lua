-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- ansible filetype
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd BufRead,BufNewFile *.yaml,*.yml if search('hosts:\|tasks:', 'nw') | set ft=yaml.ansible | endif
  augroup end
]]

