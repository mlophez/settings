-- https://www.lazyvim.org/plugins/lsp

local plugins = {
	-- colors ---
	{ "folke/tokyonight.nvim" },
	{ "Mofiqul/dracula.nvim" },
	{ "catppuccin/nvim" },

	-- ui --
	{ "akinsho/bufferline.nvim", lazy = false },
	{ "utilyre/barbecue.nvim", lazy = false },
	{ "nvim-lualine/lualine.nvim", lazy = false },
	{ "rcarriga/nvim-notify" },
	{ "folke/noice.nvim" },
	-- "xiyaowong/transparent.nvim",
	-- "stevearc/dressing.nvim",

	-- files --
	{ "kyazdani42/nvim-tree.lua" },
	{ "nvim-telescope/telescope.nvim" },

	-- parsers --
	{ "nvim-treesitter/nvim-treesitter" },

	-- installers --
	{ "williamboman/mason.nvim" },

	-- lsp, format, lint --
	{ "neovim/nvim-lspconfig" },
	{ "stevearc/conform.nvim" },
	{ "mfussenegger/nvim-lint" },

	-- AutoComplete --
	{ "hrsh7th/nvim-cmp" },

	-- utils --
	{ "alexghergh/nvim-tmux-navigation" },
	{ "akinsho/toggleterm.nvim" },
	{ "echasnovski/mini.comment" },
	{ "echasnovski/mini.pairs" },
	{ "rest-nvim/rest.nvim" },
	-- {"jakewvincent/mkdnflow.nvim" },
	-- {"kristijanhusak/vim-dadbod-ui" },
}

local opts = {
	plugins = {
		{ import = "plugins.spec" },
		plugins,
	},
	settings = {
		lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
		defaults = {
			lazy = true,
			version = "*",
			--cond = function(plugin)
			--	for _, p in pairs(plugins) do
			--		if plugin[1] == p[1] then
			--			return true
			--		end
			--	end
			--	for key, value in pairs(plugin) do
			--		print(key, value)
			--	end
			--	return false
			--end,
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
	},
}

-----------
-- setup --
-----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
require("lazy").setup(opts.plugins, opts.settings)
