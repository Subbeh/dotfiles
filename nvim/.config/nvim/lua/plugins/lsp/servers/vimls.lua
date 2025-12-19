return {
  cmd = { "vim-language-server", "--stdio" },
  filetypes = { "vim" },
  init_options = {
    iskeyword = "@,48-57,_,192-255,-#",
    vimruntime = vim.env.VIMRUNTIME,
    runtimepath = vim.o.runtimepath,
    diagnostic = { enable = true },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 8,
    },
  },
}
