local spec = {
	"nvim-telescope/telescope.nvim",
	name = "telescope",
	cmd = "Telescope",

	dependencies = {
		{ "nvim-lua/plenary.nvim", name = "plenary" },
		{ "nvim-tree/nvim-web-devicons" },
		-- fzf integration --
		{ "nvim-telescope/telescope-fzf-native.nvim", name = "telescope-fzf-native", build = "make" },
		{ "junegunn/fzf.vim", name = "fzf" },
		{ "tpope/vim-dispatch", name = "dispatch", cmd = { "Make", "Dispatch" } },
	},
}

spec.keys = {
	{ "<C-p>", ":Telescope find_files<cr>", silent = true },
	{ "<leader>f", ":Telescope find_files<cr>", silent = true },
	{ "<leader>r", ":Telescope live_grep<cr>", silent = true },
}

spec.opts = {
	defaults = {
		disable_devicons = true,
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		mappings = {
			i = {
				["<esc>"] = "close",
				["<C-c>"] = "close",
			},
			n = {
				["<esc>"] = "close",
				["<C-c>"] = "close",
				["q"] = "close",
			},
		},
	},
}

return spec
