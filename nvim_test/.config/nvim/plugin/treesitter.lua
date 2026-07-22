vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  once = true,
  callback = function(ev)
    if ev.data and ev.data.spec and ev.data.spec.name == "nvim-treesitter" then
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").setup({
  auto_install = true,
  ensure_installed = {
    "bash", "c", "comment", "css", "dockerfile", "go", "gomod", "gosum",
    "html", "javascript", "json", "lua", "luadoc", "make", "markdown",
    "markdown_inline", "python", "query", "regex", "sql", "terraform",
    "tmux", "vim", "vimdoc", "yaml",
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
