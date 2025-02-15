return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  cmd = "Gitsigns",
  dependencies = {
    "nvimtools/none-ls.nvim",
  },
  keys = {
    { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk" },
    { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                          desc = "Preview Hunk" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                            desc = "Reset Hunk" },
    { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",                            desc = "Blame" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                          desc = "Reset Buffer" },
    { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                            desc = "Stage Hunk" },
    { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                       desc = "Undo Stage Hunk" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                                         desc = "Git Diff" },
  },
  config = function()
    local icons = require("config.icons")
    local colors = require("config.colors")
    local null_ls = require("null-ls")

    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green.bright })

    require("gitsigns").setup({
      signs = {
        add = { text = icons.ui.BoldLineMiddle },
        change = { text = icons.ui.BoldLineDashedMiddle },
        delete = { text = icons.ui.TriangleShortArrowRight },
        topdelete = { text = icons.ui.TriangleShortArrowRight },
        changedelete = { text = icons.ui.BoldLineMiddle },
      },
    })

    null_ls.register(null_ls.builtins.code_actions.gitsigns)
  end,
}
