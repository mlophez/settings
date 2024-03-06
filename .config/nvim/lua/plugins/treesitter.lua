return {
	"nvim-treesitter/nvim-treesitter",
	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	lazy = false,
	priority = 100,
	--event = "VimEnter",
	--cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	opts = {
		ensure_installed = {
			"bash",
			"python",
			"go",
			"c",
			"cpp",
			"json",
			"lua",
			"typescript",
			"tsx",
			"html",
			"css",
			"javascript",
			"typescript",
			"rust",
			"java",
			"yaml",
			"markdown",
			"markdown_inline",
			"hcl",
			"http",
			"json",
			"xml",
			"sql",
			"terraform",
			"dart",
			"query",
			"astro",
		},
		ignore_install = { "phpdoc" },
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
			use_languagetree = true,
			disable = { "css" },
		},
	},
	--init = function()
	--	vim.opt.foldmethod = "expr"
	--	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

	--	local treesitterau = vim.api.nvim_create_augroup("treesitter", { clear = true })
	--	vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
	--		group = treesitterau,
	--		callback = function()
	--			vim.cmd("normal zR")
	--		end,
	--	})
	--end,
}
