return {
	"nvim-treesitter/nvim-treesitter",
	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	lazy = false,
	--event = "VimEnter",
	--cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	opts = require("plugins.treesitter.config"),
}
