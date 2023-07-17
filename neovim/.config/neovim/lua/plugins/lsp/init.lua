return {
  -- Quickstart configs for Nvim LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim", -- LSP package manager
      "williamboman/mason-lspconfig.nvim", -- use lspconfig with mason.nvim
      "jay-babu/mason-null-ls.nvim", -- closes some gaps that exist between mason.nvim and null-ls
      "dundalek/lazy-lsp.nvim", -- auto install LSP servers
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = {} }, -- Neovim setup for init.lua and plugin development
      { "j-hui/fidget.nvim", config = true, tag = "legacy" }, -- Standalone UI for nvim-lsp progress
      { "smjonas/inc-rename.nvim", config = true }, -- command for LSP renaming with immediate visual feedback
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
              hint = {
                enable = true,
              },
            },
          },
        },
        dockerls = {},
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          -- root_dir = lsp_utils.root_pattern("go.work", "go.mod", ".git"),
        },
      },
      setup = {
        lua_ls = function(_, _)
          local lsp_utils = require "plugins.lsp.utils"
          lsp_utils.on_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "lua_ls" then
              vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end, { buffer = buffer, desc = "OSV Run" })
              vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end, { buffer = buffer, desc = "OSV Launch" })
            end
          end)
        end,
      },
      format = {
        timeout_ms = 3000,
      },
    },
    config = function(plugin, opts)
      require("plugins.lsp.servers").setup(plugin, opts)
    end,
  },

  -- install and manage LSP servers, DAP servers, linters, and formatters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "gopls",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require "null-ls"
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },

  -- closes some gaps that exist between mason.nvim and null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = nil,
      automatic_installation = true,
      automatic_setup = false,
    },
  },

  -- VS Code like winbar
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    enabled = false, -- use lspsaga
    config = true,
  },

  -- pretty list for showing diagnostics, references, telescope results, quickfix and location lists
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
  },

  -- improve neovim lsp experience
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
    },
  },
}
