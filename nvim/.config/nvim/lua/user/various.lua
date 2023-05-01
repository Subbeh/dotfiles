-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- ansible filetype
vim.cmd [[
  augroup AnsibleFT
    autocmd!
    autocmd BufRead,BufNewFile *.yml,*.yml if search('hosts:\|tasks:', 'nw') | set ft=yaml.ansible | endif
    autocmd BufRead,BufNewFile **/tasks/*.yml,**/playbooks/*.yml,**/group_vars/*/*.yml,**/host_vars/*.yml set ft=yaml.ansible
  augroup end
]]
