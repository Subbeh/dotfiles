if not require("config").pde.terraform then
  return {}
end

return {
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        terraformls = {
          filetypes = { "tf" },
        },
        tflint = {},
      },
    },
  },
}
