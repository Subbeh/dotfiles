return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  keys = {
    { "<leader>fp", function() require("persistence").select() end,              desc = "Select Session" },
    { "<leader>ps", function() require("persistence").load() end,                desc = "Load Session" },
    { "<leader>pl", function() require("persistence").load({ last = true }) end, desc = "Select Session" },
    { "<leader>px", function() require("persistence").stop() end,                desc = "Discard Session" },
  },
  opts = {
    dir = vim.fn.stdpath("data") .. "/sessions",              -- directory where session files are saved
    options = { "buffers", "curdir", "tabpages", "winsize" }, -- session options
  },
}
