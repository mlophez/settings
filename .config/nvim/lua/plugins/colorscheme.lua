return {
	{
		"Mofiqul/dracula.nvim",
		name = "dracula",
		priority = 10000,
	},

	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 10000,
		opts = { style = "moon" },
	},

	{
		-- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
		-- vim.cmd.colorscheme("catppuccin-mocha")
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 10000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = {
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"gbprod/nord.nvim",
		name = "nord",
		priority = 10000,
		install = {
			colorscheme = { "nord" },
		},
	},
}
