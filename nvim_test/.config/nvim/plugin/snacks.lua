vim.pack.add({ "https://github.com/folke/snacks.nvim" })
vim.pack.add({ "https://github.com/folke/persistence.nvim" })

require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.picker.smart()" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "󰊄 ", key = "g", desc = "Grep", action = ":lua Snacks.picker.grep()" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = "󰈆 ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, cwd = true },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    },
  },
  gitbrowse = { enabled = true },
  picker = { enabled = true },
  quickfile = { enabled = true },
  rename = { enabled = true },
})

-- Picker keymaps
local snacks = require("snacks")
vim.keymap.set("n", "<leader><leader>", function() snacks.picker.smart() end, { desc = "Find files" })
vim.keymap.set("n", "<tab>", function() snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fg", function() snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>ff", function() snacks.picker.files() end, { desc = "Files" })
vim.keymap.set("n", "<leader>fo", function() snacks.picker.recent() end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fh", function() snacks.picker.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader>sk", function() snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sc", function() snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sR", function() snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>cS", function() snacks.picker.lsp_symbols() end, { desc = "LSP symbols" })
vim.keymap.set("n", "<leader>/", function() snacks.picker.lines() end, { desc = "Buffer lines" })
vim.keymap.set({ "n", "v" }, "<leader>gB", function() snacks.gitbrowse() end, { desc = "Git browse" })

-- Sessions
require("persistence").setup({
  dir = vim.fn.stdpath("data") .. "/sessions/",
  options = { "buffers", "curdir", "tabpages", "winsize" },
})

vim.keymap.set("n", "<leader>fp", function() require("persistence").select() end, { desc = "Sessions" })
vim.keymap.set("n", "<leader>fs", function() require("persistence").load() end, { desc = "Load session" })
vim.keymap.set("n", "<leader>fl", function() require("persistence").load({ last = true }) end, { desc = "Last session" })
