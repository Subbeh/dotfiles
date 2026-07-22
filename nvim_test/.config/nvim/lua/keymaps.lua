local map = vim.keymap.set

map("n", "<Space>", "", { noremap = true, silent = true })

-- Word wrap aware navigation
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Window navigation
map("n", "<M-h>", "<C-w>h", { silent = true })
map("n", "<M-j>", "<C-w>j", { silent = true })
map("n", "<M-k>", "<C-w>k", { silent = true })
map("n", "<M-l>", "<C-w>l", { silent = true })
map("n", "<M-tab>", "<C-6>", { silent = true })

-- Center on search
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })
map("n", "*", "*zz", { silent = true })
map("n", "#", "#zz", { silent = true })

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste without overwriting register
map("x", "p", [["_dP]])

-- Move lines
map("x", "J", ":move '>+1<CR>gv-gv", { silent = true })
map("x", "K", ":move '<-2<CR>gv-gv", { silent = true })

-- Navigate buffers
map("n", "<S-l>", "<cmd>bn<cr>", { silent = true })
map("n", "<S-h>", "<cmd>bp<cr>", { silent = true })
map("n", "<A-Space>", "<cmd>b#<cr>", { silent = true })

-- Splits
map("n", "<C-\\>", "<cmd>vsplit<cr>", { silent = true })
map("n", "<C-w>\\", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<C-w>-", "<cmd>split<cr>", { desc = "Split horizontal" })

-- Select all
map("n", "==", "gg<S-v>G")

-- Copy to/from registers
map({ "n", "v" }, "<leader>Y", '"+y', { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete to void" })

-- Copy file path / contents
map("n", "<leader>xp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path" })

map("n", "<leader>xf", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.fn.setreg("+", table.concat(lines, "\n"))
  vim.notify("Copied buffer contents")
end, { desc = "Copy buffer contents" })

-- Quit
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
