return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>r", "<cmd>lua require('spectre').toggle()<cr>", silent = true },
	},
	opts = {
		mapping = {
			["run_current_replace"] = {
				map = "<leader>cr",
				cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
				desc = "replace current line",
			},
			["run_replace"] = {
				map = "<leader>r",
				cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
				desc = "replace all",
			},
		},
	},
}
