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
  },
}
