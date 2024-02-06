return {
	"f-person/git-blame.nvim",
	enabled = false,
	lazy = false,
	--event = { "BufWritePre" },
	config = function()
		require("gitblame").setup({
			virtual_text_column = 80,
		})
	end,
}
