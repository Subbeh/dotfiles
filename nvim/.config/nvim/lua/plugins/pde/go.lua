return {
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Test", },
      { "<leader>dgl", function() require("dap-go").debug_last() end, desc = "Test Last", },
    },

    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}
