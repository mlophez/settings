-- Plugins
vim.g.plugins = {
	-- ui --
	lualine = true,
	bufferline = true,
	nvim_notify = true,
	-- installers --
	mason = true,
	-- files --
	nvim_tree = true,
	telescope = true,
	-- term --
	toggleterm = true,
	-- lang --
	treesitter = true,
	-- formatter --
	conform = true,
	-- lsp --
	nvim_lspconfig = true,
	nvim_cmp = true,
	nvim_lint = true,
	-- utils --
	tmux_navigation = true,
	mini_comment = false,
	mini_pairs = false,
}

-- https://www.lazyvim.org/plugins/lsp
--
-- LAZY SETUP
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- local lazy_plugins_paths = {
-- 	{ import = "plugins.core" },
-- 	{ import = "plugins.lsp" },
-- 	{ import = "plugins.ui" },
-- 	{ import = "plugins.utils" },
-- }

local lazy_opts = {
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
	default = {
		lazy = true,
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
require("lazy").setup("plugins", lazy_opts)
