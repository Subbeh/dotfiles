local M = {
  "projekt0n/github-nvim-theme",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

function M.config()
  require("github-theme").setup({
    specs = {
      github_dark = {
        cursor = "#87afd7",
        grey_dark = "#303030",
        grey = "#444444",
        grey_light = "#626262",
        white = "#d7d7d7",
        red = "#ff5f5f",
        green = "#afd787",
        yellow = "#d7d7af",
        blue = "#87d7ff",
        magenta = "#d7afd7",
        cyan = "#87d7af",
      },
    },
    groups = {
      all = {
        Normal = { fg = "fg1", bg = "grey_dark" },

        -- statusline
        StatusLine = { fg = "grey", bg = "blue" },

        -- winbar
        WinBar = { style = "bold" },

        -- tabby
        TabLineFill = { bg = "grey_dark" },
        TabLine = { bg = "grey_dark" },
        TabLineSel = { bg = "grey" },

        -- nvim-notify
        NotifyWARNBody = { link = "Normal" },
        NotifyINFOBody = { link = "Normal" },
        NotifyDEBUGBody = { link = "Normal" },
        NotifyERRORBorder = { fg = "blue" },
        NotifyWARNBorder = { fg = "blue" },
        NotifyINFOBorder = { fg = "blue" },
        NotifyDEBUGBorder = { fg = "blue" },
        NotifyTRACEBorder = { fg = "blue" },
        NotifyERRORIcon = { fg = "blue" },
        NotifyWARNIcon = { fg = "blue" },
        NotifyINFOIcon = { fg = "blue" },
        NotifyDEBUGIcon = { fg = "blue" },
        NotifyTRACEIcon = { fg = "blue" },
        NotifyERRORTitle = { fg = "blue" },
        NotifyWARNTitle = { fg = "blue" },
        NotifyINFOTitle = { fg = "blue" },
        NotifyDEBUGTitle = { fg = "blue" },
        NotifyTRACETitle = { fg = "blue" },
      },
    },
  })

  vim.cmd.colorscheme "github_dark"
end

return M
