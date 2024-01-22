return {
	"famiu/bufdelete.nvim",
	lazy = false,
	keys = {
		{ "<BS>", ":lua require('bufdelete').bufdelete(0, true)<cr>", silent = true },
	},
}
