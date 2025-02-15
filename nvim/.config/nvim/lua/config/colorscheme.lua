local colors = require "config.colors"
local hlgroups = { -- TODO: add to individual plugins
  LineNr = { fg = colors.fg2 },

  -- Noice
  NoicePopupBorder = { fg = colors.blue.base },
  NoiceCmdlinePopup = { fg = colors.fg0 },
  NoiceCmdlineInputText = { fg = colors.blue.base },
  NoiceCmdlinePrompt = { fg = colors.blue.base },
  NoiceCmdlinePopupBorder = { fg = colors.blue.base },
  NoiceCmdlineIcon = { fg = colors.magenta.base },

  -- Notifications
  NotifyINFOBody = { fg = colors.fg0 },
  NotifyINFOBorder = { fg = colors.fg2 },
  NotifyINFOTitle = { fg = colors.fg2 },
  NotifyINFOIcon = { fg = colors.magenta.base },

  -- Rainbow Delimiters
  RainbowDelimiterRed = { fg = colors.red.bright },
  RainbowDelimiterYellow = { fg = colors.yellow.base },
  RainbowDelimiterBlue = { fg = colors.blue.base },
  RainbowDelimiterOrange = { fg = colors.yellow.bright },
  RainbowDelimiterGreen = { fg = colors.green.base },
  RainbowDelimiterViolet = { fg = colors.magenta.base },
  RainbowDelimiterCyan = { fg = colors.cyan.base },

  -- Navic
  WinBar = { fg = colors.fg2 },
  NavicText = { fg = colors.fg2 },
  NavicSeparator = { fg = colors.fg3 },

  -- Snacks
  SnacksIndent = { fg = colors.bg0 },
  SnacksIndentScope = { fg = colors.fg2 },
  SnacksIndentChunk = { fg = colors.cyan.base },
}

return {
  "projekt0n/github-nvim-theme",
  name = "github-theme",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require("github-theme").setup {
      -- options = { -- TODO:
      -- 	darken = {
      -- 		floats = false,
      -- 	},
      -- },
      specs = {
        all = colors,
      },
      groups = {
        all = hlgroups,
      },
    }

    vim.cmd "colorscheme github_dark"
  end,
}
