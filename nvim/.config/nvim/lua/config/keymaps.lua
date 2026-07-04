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
keymap("n", "<S-l>", ":bn<CR>", opts)
keymap("n", "<S-h>", ":bp<CR>", opts)
keymap("n", "<A-Space>", ":b#<CR>", opts)

-- Split windows
keymap("n", "<C-\\>", ":vsplit<CR>", opts)

-- Select all
keymap("n", "==", "gg<S-v>G", opts)

-- Paste without overwriting register
keymap("v", "p", '"_dP', opts)
--
-- Copy text to " register
keymap({ "n", "v" }, "<leader>Y", "\"+y", { desc = "Yank into \" register" })
keymap({ "n", "v" }, "<leader>D", "\"_d", { desc = "Delete into \" register" })

-- Copy file path and contents to clipboard
keymap("n", "<leader>xp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("Copied path: " .. path)
end, { desc = "Copy full file path to clipboard" })

keymap("n", "<leader>xf", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(lines, "\n")
	vim.fn.setreg("+", content)
	print("Copied buffer contents to clipboard")
end, { desc = "Copy buffer contents to clipboard" })

-- Close all
keymap("n", "<leader>q", "<cmd>qa<cr>", { desc = "Close All" })

-- Run lua code under cursor
keymap("v", "<leader>l", "<cmd>...'<,'>lua<cr>", { desc = "Run lua" })

-- Window management
keymap("n", "<C-w>\\", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
keymap("n", "<C-w>-", "<cmd>split<cr>", { desc = "Split window horizontally" })
-- keymap("n", "<leader>wq", "<cmd>close<cr>", { desc = "Close window" })
-- keymap("n", "<leader>wQ", "<cmd>only<cr>", { desc = "Close other windows" })
-- keymap("n", "<leader>w=", "<C-w>=", { desc = "Equal window width" })
-- keymap("n", "<leader>wH", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- keymap("n", "<leader>wL", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
-- keymap("n", "<leader>wJ", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- keymap("n", "<leader>wK", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
