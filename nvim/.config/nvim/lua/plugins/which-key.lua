return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "mrjones2014/legendary.nvim",
      priority = 10000,
      lazy = false,
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  opts = {
    preset = "helix",
    delay = 0,
    win = {
      height = {
        max = math.huge,
      },
    },
    plugins = {
      spelling = {
        enabled = false,
      },
    },
    icons = {
      rules = false,
      breadcrumb = " ", -- symbol used in the command line area that shows your active key combo
      separator = "󱦰 ", -- symbol used between a key and it's label
      group = "󰹍 ", -- symbol prepended to a group
    },
    spec = {
      { "<leader>a",  group = "AI" },
      { "<leader>b",  group = "Buffers" },
      { "<leader>c",  group = "Code" },
      { "<leader>cr", group = "Refactor" },
      { "<leader>cx", group = "Trouble" },
      { "<leader>d",  group = "DAP" },
      { "<leader>dg", group = "Golang" },
      { "<leader>f",  group = "Find" },
      { "<leader>g",  group = "Git" },
      { "<leader>m",  group = "Misc" },
      { "<leader>p",  group = "Session" },
      { "<leader>s",  group = "System" },
      { "<leader>u",  group = "UI" },
      { "<leader>x",  group = "Copy" },
    },
  },
}
