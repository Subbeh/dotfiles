return {
  -- add indentation guides to all lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = false,
    opts = {
      char = "│",
      filetype_exclude = { "help", "dashboard", "NvimTree", "Trouble", "lazy", "mason" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
}
