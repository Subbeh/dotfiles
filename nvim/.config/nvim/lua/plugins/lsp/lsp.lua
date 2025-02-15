return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "b0o/schemastore.nvim" },
    { "folke/lazydev.nvim" },
    { "mfussenegger/nvim-ansible" },
  },

  config = function()
    local opts = { noremap = true, silent = true }

    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
    vim.keymap.set({ "n", "v" }, "<leader>cc", function() vim.lsp.buf.code_action() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }))
    vim.keymap.set("n", "<leader>cd", function() vim.diagnostic.setloclist() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Show Diagnostics" }))
    vim.keymap.set("n", "<leader>cR", function() vim.lsp.buf.rename() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }))
    vim.keymap.set("n", "<leader>cs", function() vim.lsp.buf.workspace_symbol() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Workspace Symbol" }))
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, vim.tbl_deep_extend("force", opts, { desc = "Next Diagnostic" }))
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, vim.tbl_deep_extend("force", opts, { desc = "Previous Diagnostic" }))
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Definition" }))
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Reference" }))
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Declaration" }))
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Implementation" }))
    vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Type Definition" }))
    vim.keymap.set("n", "<leader>ch", function() vim.lsp.buf.signature_help() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
    vim.keymap.set({ "n", "x" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_deep_extend("force", opts, { desc = "LSP Format" }))

    local icons = require("config.icons")
    -- Configure diagnostic signs
    local signs = {
      Error = icons.diagnostics.Error,
      Warn = icons.diagnostics.Warning,
      Hint = icons.diagnostics.Hint,
      Info = icons.diagnostics.Information,
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Configure diagnostics with theme colors
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        source = "if_many",
        format = function(diagnostic)
          return string.format("%s", diagnostic.message)
        end,
        spacing = 4,
        severity_sort = true,
      },
      float = {
        border = "single",
        source = "if_many",
        header = "",
        prefix = "",
        focusable = false,
      },
      signs = {
        priority = 10,
        text = signs,
      },
      underline = true,
      update_in_insert = true, -- Update diagnostics in insert mode
      severity_sort = true,
    })

    -- Set diagnostic colors
    local colors = require("config.colors")
    local diagnostic_highlights = {
      string.format("highlight DiagnosticError guifg=%s gui=none", colors.red.base),
      string.format("highlight DiagnosticWarn guifg=%s gui=none", colors.yellow.base),
      string.format("highlight DiagnosticInfo guifg=%s gui=none", colors.blue.base),
      string.format("highlight DiagnosticHint guifg=%s gui=none", colors.cyan.base),
      string.format("highlight DiagnosticVirtualTextError guifg=%s guibg=NONE gui=none", colors.red.bright),
      string.format("highlight DiagnosticVirtualTextWarn guifg=%s guibg=NONE gui=none", colors.yellow.bright),
      string.format("highlight DiagnosticVirtualTextInfo guifg=%s guibg=NONE gui=none", colors.blue.bright),
      string.format("highlight DiagnosticVirtualTextHint guifg=%s guibg=NONE gui=none", colors.cyan.bright),
      string.format("highlight DiagnosticUnderlineError gui=undercurl guisp=%s", colors.red.base),
      string.format("highlight DiagnosticUnderlineWarn gui=undercurl guisp=%s", colors.yellow.base),
      string.format("highlight DiagnosticUnderlineInfo gui=undercurl guisp=%s", colors.blue.base),
      string.format("highlight DiagnosticUnderlineHint gui=undercurl guisp=%s", colors.cyan.base),
      -- Add floating window highlights
      string.format("highlight FloatBorder guifg=%s guibg=%s", colors.blue.base, colors.bg0),
      string.format("highlight NormalFloat guibg=%s", colors.bg0),
    }

    for _, highlight in ipairs(diagnostic_highlights) do
      vim.cmd(highlight)
    end

    -- Define default LSP handlers with themed window
    local handlers = {
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
        title = "",
        max_width = 80,
        max_height = 30,
        focusable = false,
        style = "minimal",
        title_pos = "left",
        border_hl = "FloatBorder",
        float_hl = "NormalFloat",
      }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
        title = "",
        focusable = false,
        style = "minimal",
        border_hl = "FloatBorder",
        float_hl = "NormalFloat",
      }),
    }

    -- Force diagnostic refresh on certain events
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
      callback = function()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients > 0 then
          vim.diagnostic.show()
        end
      end,
    })

    -- Set up mason first
    require("mason").setup()

    -- Load all LSP configurations from the servers directory
    local servers_path = vim.fn.stdpath("config") .. "/lua/plugins/lsp/servers"
    local server_configs = {}
    local ensure_installed = {}

    for _, file in ipairs(vim.fn.readdir(servers_path)) do
      if file:match("%.lua$") then
        local server_name = file:gsub("%.lua$", "")
        -- Load the configuration from our local file
        server_configs[server_name] = require("plugins.lsp.servers." .. server_name)
        table.insert(ensure_installed, server_name)
      end
    end

    -- Set up mason-lspconfig with ensure_installed
    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = ensure_installed,
      handlers = {
        function(server_name)
          local config = server_configs[server_name] or {}
          -- Merge our base config with server-specific config
          config.handlers = vim.tbl_deep_extend("force", handlers, config.handlers or {})
          require("lspconfig")[server_name].setup(config)
        end,
      },
    })
  end,
}
