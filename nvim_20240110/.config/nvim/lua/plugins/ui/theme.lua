return {
	-- github theme
	{
		"projekt0n/github-nvim-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({
				specs = {
					github_dark = {
						cursor = "#87afd7",
						grey_dark = "#303030",
						grey = "#444444",
						grey_light = "#626262",
						white = "#d7d7d7",
						red = "#ff5f5f",
						green = "#afd787",
						yellow = "#d7d7af",
						blue = "#87d7ff",
						magenta = "#d7afd7",
						cyan = "#87d7af",
					},
				},
				groups = {
					all = {
						Normal = { fg = "fg1", bg = "grey_dark" },

						-- statusline
						StatusLine = { fg = "grey", bg = "blue" },

						-- nvim-notify
						NotifyWARNBody = { link = "Normal" },
						NotifyINFOBody = { link = "Normal" },
						NotifyDEBUGBody = { link = "Normal" },
						NotifyERRORBorder = { fg = "blue" },
						NotifyWARNBorder = { fg = "blue" },
						NotifyINFOBorder = { fg = "blue" },
						NotifyDEBUGBorder = { fg = "blue" },
						NotifyTRACEBorder = { fg = "blue" },
						NotifyERRORIcon = { fg = "blue" },
						NotifyWARNIcon = { fg = "blue" },
						NotifyINFOIcon = { fg = "blue" },
						NotifyDEBUGIcon = { fg = "blue" },
						NotifyTRACEIcon = { fg = "blue" },
						NotifyERRORTitle = { fg = "blue" },
						NotifyWARNTitle = { fg = "blue" },
						NotifyINFOTitle = { fg = "blue" },
						NotifyDEBUGTitle = { fg = "blue" },
						NotifyTRACETitle = { fg = "blue" },
					},
				},
			})
			vim.cmd("colorscheme github_dark")
		end,
	},

	-- onedark theme
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				style = "warm",
				colors = {
					bg0 = "#303030",
					fg = "#f2f2f2",
					purple = "#d7afd7",
					green = "#b2e697",
					orange = "#c99a6e",
					blue = "#87d7ff",
					yellow = "#d7d7af",
					cyan = "#80dfff",
				},
			})
			vim.cmd("colorscheme github_dark")
		end,
	},
}
