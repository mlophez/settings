return {
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	defaults = {
		lazy = true,
		--version = "*",
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
