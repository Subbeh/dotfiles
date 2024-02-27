return {
  -- structural search and replace
  {
    "cshuaimin/ssr.nvim",
    --stylua: ignore
    keys = {
      { "<leader>fs", function() require("ssr").open() end, mode = {"n", "x"}, desc = "Search and Replace (SSR)" },
    },
    opts = {
      border = "rounded",
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
  },
}
