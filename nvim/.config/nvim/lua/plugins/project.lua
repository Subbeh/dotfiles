return {
  "ahmedkhalf/project.nvim",
  keys = {
    { "<leader>r", "<cmd>ProjectRoot<cr>", desc = "Goto Root" },
  },
  config = function()
    require("project_nvim").setup({
      manual_mode = true,
      detection_methods = { "pattern", "lsp" },
      patterns = { ">dots", ">projects", ".git", "go.mod", "_darcs", "Makefile", "package.json", ".obsidian", "__pycache__" },
      exclude_dirs = { "~/.local/*", "/opt/*", "*/temp/*" },
      silent_chdir = false,
      scope_chdir = "tab",
    })
  end,
}
