return {
	"rest-nvim/rest.nvim",
	main = "rest-nvim",
	ft = "http",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		skip_ssl_verification = true,
	},
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "http",
			callback = function()
				local opts = { noremap = true, silent = true, buffer = tonumber(vim.fn.expand("<abuf>", 10)) }
				vim.keymap.set("n", "<cr>", "<Plug>RestNvim", opts)
			end,
		})
	end,
}
