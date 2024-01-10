local opt = vim.opt

opt.autoindent = true
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 0
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true
opt.diffopt = "internal,filler,closeoff,vertical"
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.joinspaces = false
opt.laststatus = 3
opt.listchars = { tab = ">⋮" }
opt.list = true
opt.mouse = "v"
opt.number = true
opt.numberwidth = 2
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.ruler = false
opt.scrollback = 100000
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showcmd = false
opt.showmode = false
opt.showtabline = 1
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 1000
opt.title = true
opt.undofile = true
opt.updatetime = 100
opt.wildmode = "longest:full,full"
opt.wrap = false
opt.fillchars = opt.fillchars + "eob: "
opt.fillchars:append {
  stl = " ",
}

opt.shortmess:append "c"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2
