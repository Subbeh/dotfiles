vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┋" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "┃" },
  },
})

local gs = require("gitsigns")
vim.keymap.set("n", "<leader>gj", function() gs.nav_hunk("next") end, { desc = "Next hunk" })
vim.keymap.set("n", "<leader>gk", function() gs.nav_hunk("prev") end, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gl", gs.blame_line, { desc = "Blame line" })
vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage" })
vim.keymap.set("n", "<leader>gd", function() gs.diffthis("HEAD") end, { desc = "Diff HEAD" })
