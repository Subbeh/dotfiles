vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
  filename = {
    kubeconfig = "yaml",
    tmux = "sh",
    [".cursorrules"] = "markdown",
  },
})

-- Override j2 detection for yaml.j2 and yml.j2 files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yaml.j2", "*.yml.j2" },
  callback = function()
    vim.bo.filetype = "yaml"
  end,
})
