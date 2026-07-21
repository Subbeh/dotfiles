local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = vim.g.mapleader
g.loaded_perl_provider = 0
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

opt.autoindent = true                                               --  Enable auto-indentation
opt.autoread = true                                                 --  Enable auto-reload
opt.backup = false                                                  --  Disable backup files
opt.breakindent = true                                              --  Preserve indentation in wrapped text
opt.clipboard = "unnamedplus"                                       --  Use system clipboard
opt.cmdheight = 0                                                   --  Hide command line unless needed
opt.colorcolumn = "+1"
opt.complete = "o,F,.,w,b,u,t"
-- opt.completeopt = { "menuone", "noselect" }                         --  Completion options
opt.completeopt = { "menuone", "noselect", "noinsert", "popup", "preinsert" }
-- opt.conceallevel = 0                                                --  Show text normally
opt.conceallevel = 2
opt.confirm = true                                                  --  Prompt to save changes before closing
opt.cursorline = true                                               --  Highlight current line
-- opt.diffopt = "internal,filler,closeoff,vertical"                   --  Diff options
opt.equalalways = false
opt.expandtab = true                                                --  Convert tabs to spaces
opt.fileencoding = "utf-8"                                          --  Set file encoding
-- opt.fillchars:append("fold: ")
-- opt.fillchars:append { stl = " " }                                  --  Status line fill character
opt.fillchars = opt.fillchars + "eob: "                             --  Hide ~ at end of buffer
opt.foldenable = false
-- opt.foldlevelstart = 99
-- opt.foldmethod = "expr"
-- opt.foldtext = ""
-- opt.formatoptions = "cqrnj"
opt.guicursor = ""                                                  --  Use block cursor
opt.hidden = true                                                   --  Allow switching buffers without saving
opt.hlsearch = true                                                 --  Highlight search results
opt.ignorecase = true                                               --  Case-insensitive searching
-- opt.inccommand = "nosplit"                                          --  Preview substitutions live
opt.inccommand = "split"
-- opt.isfname:append("@-@")                                           --  Allow @ in filenames
opt.joinspaces = false                                              --  No double spaces with join
opt.jumpoptions:append("stack")
opt.laststatus = 3                                                  --  Global statusline
opt.linebreak = true
opt.list = true                                                     --  Show invisible characters
opt.listchars = { tab = "⋮" }                                      --  Show tab characters
opt.modeline = true
opt.mouse = "v"                                                     --  Enable mouse in visual mode
opt.number = true                                                   --  Show line numbers
opt.numberwidth = 2                                                 --  Width of line number column
opt.pumblend = 10                                                   --  Popup menu transparency
opt.pumheight = 10                                                  --  Maximum number of items in popup menu
opt.pummaxwidth = 60
opt.pumwidth = 30
opt.relativenumber = true                                           --  Show relative line numbers
opt.ruler = false                                                   --  Hide line and column number
opt.scrollback = 100000                                             --  Scrollback buffer size
opt.scrolloff = 8                                                   --  Lines of context when scrolling
opt.sessionoptions = { "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos" }
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } --  Session save options
opt.shiftround = true                                               --  Round indent to multiple of shiftwidth
opt.shiftwidth = 2                                                  --  Size of indent
opt.shortmess:append("a")
-- opt.shortmess:append { W = true, I = true, c = true, C = true }     --  Reduce message verbosity
opt.showbreak = (" "):rep(3)
opt.showcmd = false                                                 --  Hide command in status line
opt.showmode = false                                                --  Hide mode in command line
opt.showtabline = 1                                                 --  Show tabline when needed
opt.sidescrolloff = 8                                               --  Columns of context when scrolling
opt.signcolumn = "yes:1"
-- opt.signcolumn = "yes"                                              --  Always show sign column
opt.smartcase = true                                                --  Case-sensitive if search has uppercase
opt.smartindent = true                                              --  Smart autoindenting
opt.smoothscroll = true
opt.softtabstop = -1
opt.spelloptions = { "camel" }
opt.splitbelow = true                                               --  Open new splits below
opt.splitkeep = "screen"                                            --  Keep text on screen when splitting
opt.splitright = true                                               --  Open new splits to the right
opt.swapfile = false                                                --  Disable swap files
opt.switchbuf = { "useopen", "uselast" }
opt.tabstop = 2                                                     --  Spaces per tab
opt.termguicolors = true                                            --  Enable 24-bit RGB colors
opt.timeoutlen = 1000                                               --  Time to wait for mapped sequence
opt.title = true                                                    --  Set window title
opt.undofile = true                                                 --  Enable persistent undo
opt.undolevels = 500
-- opt.updatetime = 100                                                --  Faster completion
opt.updatetime = 500
opt.wildignore:append({ "*.o", "*.rej", "*.so", "*~", "*.pyc", "*pycache*", "Cargo.lock" })
-- opt.wildmode = "longest:full,full"                                  --  Command-line completion mode
opt.wildmode = { "longest:full", "full", "noselect" }
opt.winborder = "single"
opt.wrap = false                                                    --  Disable line wrap
opt.wrapscan = false

vim.cmd "set whichwrap+=<,>,[,],h,l"        --  Allow keys to move past line ends
vim.cmd [[set iskeyword+=-]]                --  Treat dash as part of words
