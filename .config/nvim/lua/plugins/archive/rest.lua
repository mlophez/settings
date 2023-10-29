local loader = require("plugins.loader").load
return loader("rest", {
	"rest-nvim/rest.nvim",

	main = "rest-nvim",
	ft = "http",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	opts = {
		skip_ssl_verification = true,
	},

	config = function(_, opts)
		require("rest-nvim").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "http",
			callback = function()
				local kopts = { noremap = true, silent = true, buffer = tonumber(vim.fn.expand("<abuf>", 10)) }
				vim.keymap.set("n", "<cr>", "<Plug>RestNvim", kopts)
			end,
		})
	end,
})
