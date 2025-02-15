return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "rshkarin/mason-nvim-lint",
  },

  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      ["yaml.ansible"] = { "ansible_lint" },
      go = { "golangcilint" },
      json = { "jsonlint" },
      lua = { "luacheck" },
      python = { "ruff" },
      yaml = { "yamllint" },
      tf = { "tflint" },
    }

    -- Configure specific linter options
    lint.linters.luacheck.args = {
      "--globals",
      "vim",
      "--formatter",
      "plain",
      "--codes",               -- Show error codes
      "--ranges",              -- Show error ranges
      "--max-line-length=999", -- Effectively disable line length warnings
      "-",                     -- Read from stdin
    }

    -- Configure yamllint options
    lint.linters.yamllint.args = {
      "-d",
      "{extends: default, rules: {line-length: disable}}",
      "-",
    }

    -- Create autocommand to trigger linting
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- Set up mason-nvim-lint with auto-installation of configured linters
    require("mason").setup()
    require("mason-nvim-lint").setup({
      -- Automatically install linters that are configured in linters_by_ft
      ensure_installed = {
        "golangci-lint",
      },
      automatic_installation = true,
    })

    -- Add a command to manually trigger linting
    vim.api.nvim_create_user_command("Lint", function()
      require("lint").try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
