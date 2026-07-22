vim.pack.add({ "https://github.com/williamboman/mason.nvim" })
vim.pack.add({ "https://github.com/b0o/schemastore.nvim" })

require("mason").setup()

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Type definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help" })
vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>cs", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = "●", source = "if_many", spacing = 4 },
  float = { border = "single", source = "if_many" },
  signs = { text = {
    [vim.diagnostic.severity.ERROR] = " ",
    [vim.diagnostic.severity.WARN] = " ",
    [vim.diagnostic.severity.HINT] = "󰌶 ",
    [vim.diagnostic.severity.INFO] = " ",
  }},
  underline = true,
  severity_sort = true,
})

-- Server configurations
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.sum" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true },
    },
  },
})

vim.lsp.config("pyright", {
  filetypes = { "python" },
  settings = {
    pyright = { disableOrganizeImports = true },
    python = { analysis = { ignore = { "*" } } },
  },
})

vim.lsp.config("ruff", {
  filetypes = { "python" },
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  filetypes = { "yaml" },
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
      validate = true,
      hover = true,
      completion = true,
      customTags = { "!vault scalar" },
    },
  },
})

vim.lsp.config("bashls", {
  filetypes = { "sh", "bash", "zsh" },
  settings = { bashIde = { shellcheckArguments = "--exclude=SC2155" } },
})

vim.lsp.enable({ "gopls", "pyright", "ruff", "lua_ls", "yamlls", "bashls" })
