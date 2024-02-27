return {
  {
    "nvim-pack/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>fS", function() require("spectre").toggle() end, desc = "Search and Replace (Spectre)" },
    },
  },
}
