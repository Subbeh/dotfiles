return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    config = function()
      require("render-markdown").setup({
        completions = { blink = { enabled = true } },
        heading = {
          width = { "full", "block" },
          min_width = 50,
        },
      })

      -- Disable markdown rendering for all README.md files
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.md",
        callback = function()
          local filename = vim.fn.expand("%:t")

          if filename == "README.md" then
            vim.b.render_markdown_enabled = false
            require("render-markdown").disable()
          end
        end,
      })
    end,
  },
}
