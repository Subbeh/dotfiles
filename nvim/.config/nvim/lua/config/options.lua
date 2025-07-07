local opt = vim.opt

opt.autoindent = true                                               --  Enable auto-indentation
opt.autoread = true                                                 --  Enable auto-reload
opt.breakindent = true                                              --  Preserve indentation in wrapped text
opt.clipboard = "unnamedplus"                                       --  Use system clipboard
opt.cmdheight = 0                                                   --  Hide command line unless needed
opt.completeopt = { "menuone", "noselect" }                         --  Completion options
opt.conceallevel = 0                                                --  Show text normally
opt.confirm = true                                                  --  Prompt to save changes before closing
opt.cursorline = true                                               --  Highlight current line
opt.diffopt = "internal,filler,closeoff,vertical"                   --  Diff options
opt.expandtab = true                                                --  Convert tabs to spaces
opt.fileencoding = "utf-8"                                          --  Set file encoding
opt.hidden = true                                                   --  Allow switching buffers without saving
opt.hlsearch = true                                                 --  Highlight search results
opt.ignorecase = true                                               --  Case-insensitive searching
opt.inccommand = "nosplit"                                          --  Preview substitutions live
opt.joinspaces = false                                              --  No double spaces with join
opt.laststatus = 3                                                  --  Global statusline
opt.list = true                                                     --  Show invisible characters
opt.mouse = "v"                                                     --  Enable mouse in visual mode
opt.number = true                                                   --  Show line numbers
opt.numberwidth = 2                                                 --  Width of line number column
opt.pumblend = 10                                                   --  Popup menu transparency
opt.pumheight = 10                                                  --  Maximum number of items in popup menu
opt.relativenumber = true                                           --  Show relative line numbers
opt.ruler = false                                                   --  Hide line and column number
opt.scrollback = 100000                                             --  Scrollback buffer size
opt.scrolloff = 8                                                   --  Lines of context when scrolling
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } --  Session save options
opt.shiftround = true                                               --  Round indent to multiple of shiftwidth
opt.shiftwidth = 2                                                  --  Size of indent
opt.shortmess:append { W = true, I = true, c = true, C = true }     --  Reduce message verbosity
opt.showcmd = false                                                 --  Hide command in status line
opt.showmode = false                                                --  Hide mode in command line
opt.showtabline = 1                                                 --  Show tabline when needed
opt.sidescrolloff = 8                                               --  Columns of context when scrolling
opt.signcolumn = "yes"                                              --  Always show sign column
opt.smartcase = true                                                --  Case-sensitive if search has uppercase
opt.smartindent = true                                              --  Smart autoindenting
opt.splitbelow = true                                               --  Open new splits below
opt.splitkeep = "screen"                                            --  Keep text on screen when splitting
opt.splitright = true                                               --  Open new splits to the right
opt.tabstop = 2                                                     --  Spaces per tab
opt.termguicolors = true                                            --  Enable 24-bit RGB colors
opt.guicursor = ""                                                  --  Use block cursor
opt.timeoutlen = 1000                                               --  Time to wait for mapped sequence
opt.title = true                                                    --  Set window title
opt.undofile = true                                                 --  Enable persistent undo
opt.swapfile = false                                                --  Disable swap files
opt.backup = false                                                  --  Disable backup files
opt.updatetime = 100                                                --  Faster completion
opt.isfname:append("@-@")                                           --  Allow @ in filenames
opt.wildmode = "longest:full,full"                                  --  Command-line completion mode
opt.wrap = false                                                    --  Disable line wrap
opt.fillchars = opt.fillchars + "eob: "                             --  Hide ~ at end of buffer
opt.fillchars:append { stl = " " }                                  --  Status line fill character

opt.listchars = {
  tab = "⋮",
} --  Show tab characters

--  folding
opt.foldcolumn = "0"                        --  Width of fold column
opt.foldmethod = "expr"                     --  Use treesitter for folding
opt.foldexpr = "nvim_treesitter#foldexpr()" --  Expression for fold levels
opt.foldenable = false                      --  Start with folds open
opt.foldtext = ""                           --  No custom fold text
opt.foldnestmax = 3                         --  Maximum fold nesting
opt.foldlevel = 99                          --  Initial fold level
opt.foldlevelstart = 99                     --  Start with all folds open

opt.shortmess:append "c"                    --  Don't show completion messages

vim.cmd "set whichwrap+=<,>,[,],h,l"        --  Allow keys to move past line ends
vim.cmd [[set iskeyword+=-]]                --  Treat dash as part of words

vim.g.netrw_banner = 1                      --  Show netrw banner
vim.g.loaded_netrwPlugin = 1                --  Enable netrw plugin
vim.g.netrw_mouse = 2                       --  Enable mouse in netrw

-- misc
-- Enable word wrap for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true -- Break lines at word boundaries
  end,
})
