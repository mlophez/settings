return {
	"famiu/bufdelete.nvim",
	enable = false,
	lazy = false,
	keys = {
		{ "<BS>", ":lua require('bufdelete').bufdelete(0, true)<cr>", silent = true },
	},
}
