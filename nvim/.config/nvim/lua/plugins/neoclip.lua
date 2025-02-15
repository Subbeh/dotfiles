return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("neoclip").setup()
    vim.keymap.set("n", "<leader>sc", "<cmd>Telescope neoclip<CR>", { desc = "Clipboard" })
  end,
}
