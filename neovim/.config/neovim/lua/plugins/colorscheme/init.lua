return {
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    config = function()
      require("styler").setup {
        themes = {
          markdown = { colorscheme = "gruvbox" },
          help = { colorscheme = "gruvbox" },
        },
      }
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup {
        palettes = {},
        specs = {
          github_dark = {
            cursor = "#87afd7",
            black0 = "#303030",
            black0 = "#303030",
            black1 = "#444444",

            red0 = "#ff5f5f",
            red1 = "#ff5f5f",

            green0 = "#afd787",
            green1 = "#afd787",

            yellow0 = "#d7d7af",
            yellow1 = "#d7d7af",

            blue0 = "#87d7ff",
            blue1 = "#87d7ff",

            magenta0 = "#d7afd7",
            magenta1 = "#d7afd7",

            cyan0 = "#87d7af",
            cyan1 = "#87d7af",

            white0 = "#626262",
            white1 = "#d7d7d7",

            bg1 = "#303030",
          },
        },
      }
      vim.cmd "colorscheme github_dark"
    end,
  },
  {
    "folke/tokyonight.nvim",
    -- lazy = false,
    -- priority = 1000,
    opts = {
      style = "storm",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    -- config = function(_, opts)
    --   local tokyonight = require "tokyonight"
    --   tokyonight.setup(opts)
    --   tokyonight.load()
    -- end,
  },
  { "catppuccin/nvim", lazy = false, enabled = false, name = "catppuccin" },
  { "rebelot/kanagawa.nvim", lazy = false, name = "kanagawa" },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    config = function()
      require("gruvbox").setup()
    end,
  },
}
