local M = {}

function M.basic_text_objects()
  local chars = { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?" }
  for _, char in ipairs(chars) do
    for _, mode in ipairs { "x", "o" } do
      vim.api.nvim_set_keymap(mode, "i" .. char, string.format(":<C-u>silent! normal! f%sF%slvt%s<CR>", char, char, char), { noremap = true, silent = true })
      vim.api.nvim_set_keymap(mode, "a" .. char, string.format(":<C-u>silent! normal! f%sF%svf%s<CR>", char, char, char), { noremap = true, silent = true })
    end
  end
end

function M.quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "qa!"
      end
    end)
  else
    vim.cmd "qa!"
  end
end

function M.find_files()
  local opts = {}
  local telescope = require "telescope.builtin"

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

function M.reload_module(name)
  require("plenary.reload").reload_module(name)
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

return M
