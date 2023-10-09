return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "Lint" },
	opts = {
		python = { "pylint" },
		terraform = { "tflint", "tfsec" },
		-- yaml = { "sonarlint-language-server" },
		-- lua = { "luacheck" },
	},
	config = function(_, opts)
		local lint = require("lint")

		lint.linters_by_ft = opts

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.api.nvim_create_user_command("Lint", function()
			lint.try_lint()
		end, {})
	end,
	enabled = Plugins.lint,
}
