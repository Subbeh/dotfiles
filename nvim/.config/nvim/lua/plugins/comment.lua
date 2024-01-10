local M = {
  "numToStr/Comment.nvim",
  lazy = false,
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
}

function M.config()
  local require_ok, wk = pcall(require, "which-key")
  if require_ok then
    wk.register {
      ["<leader>/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment" },
    }

    wk.register {
      ["<leader>/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment", mode = "v" },
    }
  end

  require("Comment").setup {
    ignore = "^$",
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  }

  require("ts_context_commentstring").setup {
    enable_autocmd = false,
  }
end

return M
