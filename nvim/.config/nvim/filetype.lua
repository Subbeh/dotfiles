vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})
vim.filetype.add({
  filename = {
    kubeconfig = "yaml",
    [".cursorrules"] = "markdown",
  },
})
vim.filetype.add({
  filename = {
    tmux = "sh",
  },
})
