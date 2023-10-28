-- https://www.lazyvim.org/plugins/lsp

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local opts = {
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	defaults = {
		lazy = true,
	},
	checker = {
		enabled = false,
	},
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
}

return function(plugins)
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end

	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup(plugins, opts)
end
