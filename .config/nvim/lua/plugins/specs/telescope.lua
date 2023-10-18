local loader = require("plugins.loader").load
return loader("telescope", {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",

		-- fzf integration --
		{ "nvim-telescope/telescope-fzf-native.nvim", name = "telescope-fzf-native", build = "make" },
		{ "junegunn/fzf.vim", name = "fzf" },
		{ "tpope/vim-dispatch", name = "vim-dispatch", cmd = { "Make", "Dispatch" } },
	},

	keys = {
		{ "<C-p>", ":Telescope find_files<cr>", silent = true },
		{ "<leader>f", ":Telescope find_files<cr>", silent = true },
		{ "<leader>r", ":Telescope live_grep<cr>", silent = true },
	},

	opts = {
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
	},
})
