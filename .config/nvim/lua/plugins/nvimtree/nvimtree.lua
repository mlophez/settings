return {
	"kyazdani42/nvim-tree.lua",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "m", ":NvimTreeToggle<cr>", silent = true },
		{ "<leader>e", ":NvimTreeFocusToggle<cr>", silent = true },
		{ "<C-e>", ":NvimTreeFocusToggle<cr>", silent = true },
		{ "<leader>b", ":NvimTreeClose<cr>", silent = true },
		--{ "<leader>e", ":NvimTreeOpen<cr>", silent = true },
	},
	opts = require("plugins.nvimtree.config"),
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
	config = function(_, opts)
		require("nvim-tree").setup(opts)
		--require("nvim-tree.api").tree.open()
		--vim.cmd("wincmd p")

		vim.api.nvim_create_user_command("NvimTreeFocusToggle", function()
			if vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
				vim.cmd("wincmd p")
			else
				require("nvim-tree.api").tree.focus()
			end
		end, {})

		vim.api.nvim_create_user_command("NvimTreeToggle", function()
			if vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
				require("nvim-tree.api").tree.close()
			else
				require("nvim-tree.api").tree.focus()
			end
		end, {})
	end,
}
