local loader = require("plugins.loader").load
return loader("lualine", {
	"nvim-lualine/lualine.nvim",

	lazy = false,
	event = "VimEnter",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	opts = {
		options = {
			theme = "auto",
			icons_enabled = true,
			global_status = true,
		},
		--ignore_focus = {},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { { "branch", icon = "" } },
			lualine_c = { { "diagnosis", sources = { "nvim" } }, "diff" },
			lualine_y = { "filetype" },
			lualine_z = { "location" },
		},
		tabline = {},
		extensions = {},
	},
})
