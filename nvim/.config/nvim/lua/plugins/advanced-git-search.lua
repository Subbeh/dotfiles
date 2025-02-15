return {
	"aaronhallaert/advanced-git-search.nvim",
	cmd = { "AdvancedGitSearch" },
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"tpope/vim-fugitive",
		"tpope/vim-rhubarb",
	},
	keys = {
		{ "<leader>gS", "<cmd>AdvancedGitSearch<cr>", desc = "Search" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				advanced_git_search = {},
			},
		})

		require("telescope").load_extension("advanced_git_search")
	end,
}
