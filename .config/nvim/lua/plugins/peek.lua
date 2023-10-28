local loader = require("plugins.loader").load
return loader("peek", {
	"toppair/peek.nvim",

	ft = "markdown",

	opts = {
		auto_load = false,
		close_on_bdelete = true,
		syntax = false,
		theme = "dark",
		update_on_change = true,
		app = "webview",
		filetype = { "markdown" },
		throttle_at = 200000,
		throttle_time = "auto",
	},

	config = function(_, opts)
		require("peek").setup(opts)
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	end,
})
