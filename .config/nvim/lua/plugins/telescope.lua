return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"kyazdani42/nvim-web-devicons",
		-- fzf integration --
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "junegunn/fzf.vim" },
		{ "tpope/vim-dispatch", cmd = { "Make", "Dispatch" } },
	},
	opts = {
		defaults = {
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
					["<leader>q"] = "close",
				},
			},
		},
	},
	keys = {
		{ "<C-p>", ":Telescope find_files<cr>" },
		{ "<leader>f", ":Telescope find_files<cr>" },
		{ "<leader>r", ":Telescope live_grep<cr>" },
	},
	enabled = vim.g.plugins.telescope,
}
