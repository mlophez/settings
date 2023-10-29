return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo", "Format", "FormatOnSaveEnable", "FormatOnSaveDisable" },
	opts = require("plugins.conform.config"),
	config = require("plugins.conform.setup"),
}
