return {
	{
		"nvim-pack/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>fs", function() require("spectre").open() end, desc = "Search and Replace (Spectre)" },
    },
	},
}
