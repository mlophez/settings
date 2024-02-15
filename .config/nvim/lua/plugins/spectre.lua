return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>R", "<cmd>lua require('spectre').toggle()<cr>", silent = true },
	},
}
