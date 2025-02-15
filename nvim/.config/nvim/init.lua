-- Load minimal configuration when running in VSCode
if vim.g.vscode then
  -- Load only essential configurations
  require("config.vscode_options")
  require("config.vscode_keymaps")
else
  -- Only bootstrap lazy.nvim if not in VSCode
  if not vim.g.vscode then
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out,                            "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)
  end

  -- Load core configurations first
  require("config.options")
  require("config.keymaps")
  require("config.autocmds")
  -- require("config.diagnostics")

  -- Full Neovim configuration with lazy.nvim
  require("lazy").setup({
    -- Import all plugins
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "plugins.pde" },
    -- Import colorscheme
    { import = "config.colorscheme" },

    defaults = {
      lazy = true,
    },
    install = { colorscheme = { "github_dark" } },
    checker = { enabled = true },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })

  -- Set up Lazy key mapping
  vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
end
