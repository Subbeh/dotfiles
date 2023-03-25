local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.mason"
require("user.lsp.handlers").setup()
require "user.lsp.null-ls"

local status_fidget, fidget = pcall(require, "fidget")
if not status_fidget then
  return
end

fidget.setup()
