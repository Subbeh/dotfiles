if not require("config").pde.markdown then
  return {}
end

return {
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        marksman = {},
        -- zk = {},
      },
    },
  },
}
