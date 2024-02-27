local M = {
  "SmiteshP/nvim-navic",
}

function M.config()
  local icons = require "core.icons"
  require("nvim-navic").setup {
    icons = icons.kind,
    highlight = true,
    lsp = {
      auto_attach = true,
    },
    separator = " " .. icons.ui.ChevronRight .. " ",
  }
end

return M
