local loader = require("plugins.loader").load
return {
	loader("dracula", {
		"Mofiqul/dracula.nvim",
		lazy = false,
		priority = 10000,
		config = function()
			vim.cmd.colorscheme("dracula")
		end,
	}),

	loader("tokyonight", {
		"folke/tokyonight.nvim",
		priority = 10000,
		opts = { style = "moon" },
		--vim.cmd.colorscheme("tokyonight")
	}),

	loader("catppuccin", {
		"catppuccin/nvim",
		priority = 10000,
		-- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
		--vim.cmd.colorscheme("catppuccin-mocha")
	}),

	loader("nord", {
		"gbprod/nord.nvim",
		priority = 10000,
		install = {
			colorscheme = { "nord" },
		},
		--vim.cmd.colorscheme("nord")
	}),
}
