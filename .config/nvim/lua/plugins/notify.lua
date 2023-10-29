return {
	"rcarriga/nvim-notify",
	lazy = false,
	keys = {
		{ "<cr>", ":NotifyDismiss<cr>", silent = true },
	},
	opts = {
		timeout = 5000,
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
	},
	config = function(_, opts)
		require("notify").setup(opts)

		vim.notify = require("notify")

		vim.api.nvim_create_user_command("NotifyDismiss", function()
			require("notify").dismiss({ silent = true, pending = true })
		end, {})
	end,
}
