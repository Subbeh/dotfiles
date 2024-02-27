local util = require "lspconfig/util"

return {
  -- cmd = { "ansiblels" },
  filetypes = { "ansible.yaml" },
  settings = {
    ansible = {
      ansible = {
        path = "ansible",
        useFullyQualifiedCollectionNames = true,
      },
      validation = {
        enabled = true,
        lint = {
          enabled = false,
          path = "ansible-lint",
        },
      },
      executionEnvironment = {
        enabled = false,
      },
      python = {
        interpreterPath = "python",
      },
      completion = {
        provideRedirectModules = true,
        provideModuleOptionAliases = true,
      },
    },
  },
}
