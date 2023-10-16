local loader = require("plugins.loader").load
return loader("barbecue", {
	"utilyre/barbecue.nvim",

	lazy = false,
	event = "VimEnter",

	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
		-- "nvim-tree/nvim-web-devicons",
	},

	opts = {},
})
