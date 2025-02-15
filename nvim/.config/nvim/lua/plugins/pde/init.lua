return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "jbyuki/one-small-step-for-vimkind",
    },

    keys = {
      { "<leader>dd", function() require("dapui").toggle() end,                               desc = "Dap UI" },
      { "<leader>dB", function() require("telescope").extensions.dap.list_breakpoints {} end, desc = "Breakpoints" },
      { "<leader>dD", function() require("telescope").extensions.dap.commands {} end,         desc = "Commands" },
      { "<leader>dF", function() require("telescope").extensions.dap.frames {} end,           desc = "Frames" },
      { "<leader>dV", function() require("telescope").extensions.dap.variables {} end,        desc = "Variables" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                          desc = "Run to Cursor" },
      { "<leader>db", function() require("dap").step_back() end,                              desc = "Step Back" },
      { "<leader>dc", function() require("dap").continue() end,                               desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end,                              desc = "Step Into" },
      { "<leader>dl", function() require("osv").launch({ port = 8086 }) end,                  desc = "Lua Debugger" },
      { "<leader>do", function() require("dap").step_over() end,                              desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,                                  desc = "Pause" },
      { "<leader>dq", function() require("dap").close() end,                                  desc = "Quit" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                            desc = "Toggle Repl" },
      { "<leader>dt", function() require("dap").toggle_breakpoint() end,                      desc = "Toggle Breakpoint" },
      { "<leader>du", function() require("dap").step_out() end,                               desc = "Step Out" },
      { "<leader>dv", function() require("dap.ui.widgets").hover() end,                       desc = "Hover Variables" },
      { "<leader>dx", function() require("dap").disconnect() end,                             desc = "Disconnect" },
    },

    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
      require('telescope').load_extension('dap')
    end
  },
}
