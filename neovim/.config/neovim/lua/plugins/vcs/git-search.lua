return {
	-- Search your git history by commit message, content and author
	{
		"aaronhallaert/advanced-git-search.nvim",
		config = function()
			require("telescope").load_extension("advanced_git_search")
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-fugitive",
		},
	},
}
