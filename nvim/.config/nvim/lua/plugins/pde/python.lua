return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim",
  },

  config = function()
    require("mason-nvim-dap").setup {
      ensure_installed = {
        "python",
      },
    }

    require("dap-python").setup()
  end
}
