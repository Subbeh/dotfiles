return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  -- lazy = true,
  ft = "markdown",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {},
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    },
  },
  keys = {
    { "<leader>N", "<cmd>Obsidian<cr>", desc = "Notes", },
  },
  config = function()
    require("obsidian").setup({

      workspaces = {
        {
          name = "Notes",
          path = os.getenv("NOTES_DIR"),
        },
      },
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },

      ui = {
        enable = false, -- using render-markdown.nvim instead
      },
    })
  end
}
