return {
	"nvim-lualine/lualine.nvim",
	name = "lualine",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
  opts = require("plugins.lualine.opts"),
  init = function()
	  vim.o.laststatus = 3
  end,
}
