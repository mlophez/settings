return {
	"nvim-telescope/telescope.nvim",
	name = "telescope",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		-- fzf integration --
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "junegunn/fzf.vim" },
		{ "tpope/vim-dispatch", cmd = { "Make", "Dispatch" } },
	},
	keys = {
		{ "<C-p>", ":Telescope find_files<cr>", silent = true },
		{ "<leader>f", ":Telescope find_files<cr>", silent = true },
		{ "<leader>r", ":Telescope live_grep<cr>", silent = true },
	},
	opts = require("plugins.telescope.config"),
}
