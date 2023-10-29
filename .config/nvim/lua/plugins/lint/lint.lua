return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "Lint" },
	opts = {
		python = { "pylint" },
		terraform = { "tflint", "tfsec" },
	},
	config = require("plugins.lint.setup"),
}
