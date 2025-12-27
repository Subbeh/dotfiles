return {
  filetypes = { "yaml", "yaml.ansible" },
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
      validate = true,
      hover = true,
      completion = true,
      format = { enable = true },
      customTags = { "!vault scalar" },
      lint = {
        commas = "ignore",
        comments = "disable",
      }
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  },
}
