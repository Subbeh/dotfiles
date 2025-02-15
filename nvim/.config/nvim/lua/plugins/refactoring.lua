return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
    -- stylua: ignore
    keys = {
      { "<leader>crs", function() require("telescope").extensions.refactoring.refactors() end,     mode = { "v" },      desc = "Refactor", },
      { "<leader>cri", function() require("refactoring").refactor("Inline Variable") end,          mode = { "n", "v" }, desc = "Inline Variable" },
      { "<leader>crb", function() require('refactoring').refactor('Exract Block') end,             mode = { "n" },      desc = "Extract Block" },
      { "<leader>crf", function() require('refactoring').refactor('Exract Block To File') end,     mode = { "n" },      desc = "Extract Block to File" },
      { "<leader>crP", function() require('refactoring').debug.printf({ below = false }) end,      mode = { "n" },      desc = "Debug Print" },
      { "<leader>crp", function() require('refactoring').debug.print_var({ normal = true }) end,   mode = { "n" },      desc = "Debug Print Variable" },
      { "<leader>crc", function() require('refactoring').debug.cleanup({}) end,                    mode = { "n" },      desc = "Debug Cleanup" },
      { "<leader>crf", function() require('refactoring').refactor('Extract Function') end,         mode = { "v" },      desc = "Extract Function" },
      { "<leader>crF", function() require('refactoring').refactor('Extract Function to File') end, mode = { "v" },      desc = "Extract Function to File" },
      { "<leader>crx", function() require('refactoring').refactor('Extract Variable') end,         mode = { "v" },      desc = "Extract Variable" },
      { "<leader>crp", function() require('refactoring').debug.print_var({}) end,                  mode = { "v" },      desc = "Debug Print Variable" },
    },
		config = function()
			require("refactoring").setup()
			require("telescope").load_extension("refactoring")
		end,
	},
}
