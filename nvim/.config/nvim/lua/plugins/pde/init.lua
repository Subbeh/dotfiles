return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
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
      local mason_dap = require("mason-nvim-dap")
      local dap = require("dap")
      local ui = require("dapui")
      local dap_virtual_text = require("nvim-dap-virtual-text")

      -- Dap Virtual Text
      dap_virtual_text.setup()

      -- Helper function to get Python path
      local function get_python_path()
        -- First check for VIRTUAL_ENV (set by direnv)
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
          return venv .. "/bin/python"
        end
        
        -- Fall back to checking local venv directories
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
          return cwd .. "/venv/bin/python"
        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
          return cwd .. "/.venv/bin/python"
        else
          return "/usr/bin/python"
        end
      end

      mason_dap.setup({
        ensure_installed = { "python" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      -- Configurations
      dap.configurations = {
        python = {
          {
            -- The first three options are required by nvim-dap
            type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = "launch",
            name = "Launch file",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}", -- This configuration will launch the current file if used.
            pythonPath = get_python_path,
          },
          {
            type = "python",
            request = "launch",
            name = "Launch file with args",
            program = "${file}",
            args = function()
              local args = {}
              local input = vim.fn.input("Arguments: ")
              for arg in string.gmatch(input, "%S+") do
                table.insert(args, arg)
              end
              return args
            end,
            pythonPath = get_python_path,
          },
        },
      }

      -- Dap UI

      ui.setup()
      --
      -- vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end
  },
}
