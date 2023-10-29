return {
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		lazy = false,
		event = "VeryLazy",
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
	},
}
