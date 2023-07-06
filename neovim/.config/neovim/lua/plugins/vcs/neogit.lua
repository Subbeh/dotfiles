return {
	{
		"TimUntersberger/neogit",
		cmd = "Neogit",
		opts = {
			integrations = { diffview = true },
			disable_commit_confirmation = true,
		},
		keys = {
			{ "<leader>gs", "<cmd>Neogit kind=tab<cr>", desc = "Status" },
		},
	},
}
