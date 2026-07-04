return {
	{
		"nvim-pack/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>fs", function() require("spectre").toggle() end, desc = "Spectre (Search/Replace)" },
    },
	},
}
