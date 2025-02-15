local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- TODO: https://github.com/exosyphon/nvim/blob/main/lua/exosyphon/remaps.lua

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap("n", "<Space>", "", opts)
keymap("n", "<C-i>", "<C-i>", opts)

-- normal mode --
-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better window navigation
keymap("n", "<m-h>", "<C-w>h", opts)
keymap("n", "<m-j>", "<C-w>j", opts)
keymap("n", "<m-k>", "<C-w>k", opts)
keymap("n", "<m-l>", "<C-w>l", opts)
keymap("n", "<m-tab>", "<c-6>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- Scrolling
-- keymap("n", "<C-d>", "<C-d>zz")
-- keymap("n", "<C-u>", "<C-u>zz")

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Keep clipboard after replacing
keymap("x", "p", [["_dP]])

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bp<CR>", opts)
keymap("n", "<S-h>", ":bn<CR>", opts)

-- Split windows
keymap("n", "<C-\\>", ":vsplit<CR>", opts)

-- Select all
keymap("n", "==", "gg<S-v>G", opts)

-- Paste without overwriting register
keymap("v", "p", '"_dP', opts)
--
-- Copy text to " register
keymap("n", "<leader>Y", "\"+y", { desc = "Yank into \" register" })
keymap("v", "<leader>Y", "\"+y", { desc = "Yank into \" register" })
keymap("n", "<leader>Y", "\"+Y", { desc = "Yank into \" register" })

-- Delete text to " register
keymap("n", "<leader>D", "\"_d", { desc = "Delete into \" register" })
keymap("v", "<leader>D", "\"_d", { desc = "Delete into \" register" })

-- Close all
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Close All" })

-- Run lua code under cursor
keymap("v", "<leader>l", "<cmd>...'<,'>lua<cr>", { desc = "Run lua" })

-- Code folding
-- local function close_all_folds()
--   vim.api.nvim_exec2("%foldc!", { output = false })
-- end
-- local function open_all_folds()
--   vim.api.nvim_exec2("%foldo!", { output = false })
-- end

-- vim.keymap.set("n", "<leader>zo", open_all_folds, { desc = "Open all" })
-- vim.keymap.set("n", "<leader>zc", close_all_folds, { desc = "Close all" })
