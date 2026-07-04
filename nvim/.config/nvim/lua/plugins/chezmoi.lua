return {
  "xvzc/chezmoi.nvim",
  enabled = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("chezmoi").setup({
      edit = {
        watch = false,
        force = false,
        ignore_patterns = {
          "run_onchange_.*",
          "run_once_.*",
          "%.chezmoiignore",
          "%.chezmoitemplate",
          -- Add custom patterns here
        },
      },
      events = {
        on_open = {
          notification = {
            enable = true,
            msg = "Opened a chezmoi-managed file",
            opts = {},
          },
        },
        on_watch = {
          notification = {
            enable = true,
            msg = "This file will be automatically applied",
            opts = {},
          },
        },
        on_apply = {
          notification = {
            enable = true,
            msg = "Successfully applied",
            opts = {},
          },
        },
      },
      telescope = {
        select = { "<CR>" },
      },
    })

    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { os.getenv("HOME") .. "/*" },
      callback = function(ev)
        local bufnr = ev.buf
        vim.schedule(function()
          local target = vim.api.nvim_buf_get_name(bufnr)
          local source = require("chezmoi.commands.__base").execute({
            cmd = "source-path",
            targets = { target },
            on_stderr = function() end,
          })
          if source and #source > 0 then
            require("chezmoi.commands").edit({
              targets = { target },
              args = { "--watch" },
            })
          end
        end)
      end,
    })
  end,
}
