local spec = {
	"nvim-treesitter/nvim-treesitter",
	name = "treesitter",
	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	lazy = false,
	--event = "VimEnter",
	--cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
}

spec.opts = require("plugins.config.treesitter")

spec.config = function(_, opts)
	--require("nvim-treesitter.configs").setup(opts)
end

return spec
