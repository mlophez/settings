local loader = require("plugins.loader").load
return loader("indent-blankline", {
	"lukas-reineke/indent-blankline.nvim",

	main = "ibl",
	lazy = false,
	event = "VeryLazy",
	--event = { "BufReadPre", "BufNewFile" },

	opts = {
		indent = { char = "▏" },
		scope = {
			show_start = false,
			show_end = false,
		},
		exclude = {
			buftypes = {
				"nofile",
				"terminal",
			},
			filetypes = {
				"help",
				"startify",
				"aerial",
				"alpha",
				"dashboard",
				"lazy",
				"neogitstatus",
				"NvimTree",
				"neo-tree",
				"Trouble",
			},
		},
	},
})
