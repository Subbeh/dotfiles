return {
  "dreamsofcode-io/nvim-dap-go",
  ft = "go",
  dependencies = {
    "mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim",
  },
  keys = {
    { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Test", },
    { "<leader>dgl", function() require("dap-go").debug_last() end, desc = "Test Last", },
  },

  config = function()
    require("dap-go").setup {
      dap_configuration = {
        type = "go",
        name ="Attach remote",
        mode = "remote",
        request = "attach"
      },

      delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        args = {},
        build_flags = {},
      }
    }

    require("mason-nvim-dap").setup {
      ensure_installed = {
        "delve",
      },
    }
  end,
}
