return {
  -- lua functions
  {
    "nvim-lua/plenary.nvim",
  },

  -- enable sudo support
  {
    "lambdalisue/suda.vim",
    enabled = true,
    lazy = false,
    build = "npm install --prefix server",
    init = function()
      -- vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
      vim.api.nvim_create_user_command("W", ":SudaWrite", {})
    end,
  },
}
