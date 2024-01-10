local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "meuter/lualine-so-fancy.nvim", -- Small collection of _fancy_ components for the lualine.nvim plugin
  },
}

function M.config()
  local icons = require "core.icons"
  local diff = {
    "diff",
    colored = false,
    symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- Changes the symbols used by the diff.
  }

  local diagnostics = {
    "diagnostics",
    sections = { "error", "warn" },
    colored = false, -- Displays diagnostics status in color if set to true.
    always_visible = true, -- Show diagnostics even if there are none.
  }

  -- theme
  local custom_onedark = require "lualine.themes.onedark"
  custom_onedark.normal.c.bg = "#303030"

  require("lualine").setup {
    options = {
      theme = custom_onedark,
      component_separators = {},
      section_separators = {},
      always_divide_middle = true,
      globalstatus = true,

      ignore_focus = { "NvimTree" },
    },
    sections = {
      lualine_a = {
        { "fancy_mode", width = 3 },
      },
      lualine_b = {
        "fancy_branch",
        -- "fancy_diff",
      },
      -- lualine_c = { diagnostics },
      lualine_c = {
        "fancy_filetype",
      },
      lualine_x = {
        { "fancy_cwd", substitute_home = true },
        "fileformat",
      },
      lualine_y = { "diagnostics" },
      lualine_z = {
        "progress",
      },
    },
    extensions = { "quickfix", "man", "fugitive" },
  }
end

return M
