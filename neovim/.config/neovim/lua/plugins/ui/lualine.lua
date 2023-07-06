return {
  -- statusline plugin
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "meuter/lualine-so-fancy.nvim", -- Small collection of _fancy_ components for the lualine.nvim plugin
    },
    -- event = "VeryLazy",
    -- event = "VimEnter",
    lazy = false,
    config = function()
      local components = require "plugins.ui.utils.lualine"

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "onedark",
          component_separators = {},
          section_separators = {},
          disabled_filetypes = {
            statusline = { "lazy", "fugitive" },
            winbar = {
              "help",
              "lazy",
            },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { { "fancy_mode", width = 3 } },
          lualine_b = { components.git_repo, "branch" },
          lualine_c = {
            { "fancy_cwd", substitute_home = true },
            components.diff,
            { "fancy_diagnostics" },
            components.noice_command,
            components.noice_mode,
            components.separator,
            components.lsp_client,
          },
          lualine_x = { "filename", components.spaces, "encoding", "fileformat", "filetype", "progress" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "nvim-tree", "quickfix" },
      }
    end,
  },
}
