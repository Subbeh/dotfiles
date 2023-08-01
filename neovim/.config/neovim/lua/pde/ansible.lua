if not require("config").pde.ansible then
  return {}
end

return {
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ansiblels = {
          filetypes = { "ansible.yaml" },
          settings = {
            ansible = {
              ansible = {
                path = "ansible",
                useFullyQualifiedCollectionNames = true,
              },
              ansibleLint = {
                enabled = true,
                path = "ansible-lint",
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
        },
      },
    },
  },
}
