return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = require("plugins.lualine.config"),
	init = function()
		vim.o.laststatus = 3
	end,
}
