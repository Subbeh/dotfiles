-- core
require "core.launch"
require "core.options"
require "core.keymaps"
require "core.autocmds"

-- system
spec "plugins.tmux" -- tmux navigation
spec "plugins.telescope" -- fuzzy finder
spec "plugins.telescope-tabs" -- navigate through tabs
spec "plugins.whichkey" -- key bindings
spec "plugins.nvimtree" -- file explorer
spec "plugins.harpoon" -- bookmarks
spec "plugins.tabby" -- tabline -- TODO keybindings
spec "plugins.ufo" -- fold lines
spec "plugins.neotab" -- tab in and out of brackets etc.
spec "plugins.diffview" -- tabpage interface for diffs
spec "plugins.netrw" -- explorer
spec "plugins.project" -- project management
spec "plugins.autosession" -- session manager
spec "plugins.bqf" -- quickfix window
spec "plugins.navbuddy" -- popup with breadcrumbs
spec "plugins.package-info" -- dependency management
spec "plugins.vim-rooter" -- change working directory to root of project
spec "plugins.notify" -- popup window for notifications

-- ui
spec "plugins.colorscheme" -- colorschemes
spec "plugins.devicons" -- dev icons package
spec "plugins.lualine" -- status line
spec "plugins.breadcrumbs" -- provide context in winbar
spec "plugins.navic" -- provide context in winbar
spec "plugins.illuminate" -- word highlighting
spec "plugins.eyeliner" -- move faster with f/F indicators
spec "plugins.colorizer" -- colorize color codes
spec "plugins.dressing" -- vim.ui interface improvements
spec "plugins.fidget" -- embedded notifications and LSP progress messages
spec "plugins.rainbow" -- colored delimiters with treesitter
spec "plugins.todo" -- highlight and list todo comments
spec "plugins.ccc" -- color picker and highlighter
spec "plugins.bufresize" -- keep buffer dimensions in proportion

-- lsp / formatting
spec "plugins.mason" -- package manager for LSP, linters, and formatters
spec "plugins.lspconfig" -- lsp config manager
spec "plugins.cmp" -- auto completions
spec "plugins.schemastore" -- json and yaml schemas
spec "plugins.treesitter" -- code syntax parsing
spec "plugins.none-ls" -- hook into lsp features -- TODO
spec "plugins.comment" -- comment lines
spec "plugins.autopairs" -- autopair multiple characters
spec "plugins.autotag" -- auto close and rename HTML tags
spec "plugins.indent" -- add indentation guides
spec "plugins.dial" -- enhanced increments/decrements
spec "plugins.matchup" -- highlight, navigate, and operate on matching text
spec "plugins.refactoring" -- refactoring library
spec "plugins.treesj" -- split/join treesitter nodes

-- git
spec "plugins.fugitive" -- git wrapper
spec "plugins.gitsigns" -- git integration for buffers
spec "plugins.neogit" -- git UI -- TODO

-- debug
spec "plugins.neotest" -- testing framework -- TODO
spec "plugins.dap" -- debug adapter protocol client -- TODO
spec "plugins.trouble" -- diagnostics, references, quickfix, location list

-- pde
spec "plugins.pde.go" -- golang specific plugins

-- ai
spec "plugins.codeium" -- copilot alternative

-- lazy --
require "core.lazy" -- lazy plugin manager
