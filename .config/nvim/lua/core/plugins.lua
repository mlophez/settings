-- plugins list

local lazy = require("plugins.lazy")
local plugin = require("plugins.lazy.loader")

lazy.setup({
	-- UI --
	{
		"Mofiqul/dracula.nvim",
		name = "dracula",
		priority = 10000,
	},

	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 10000,
		opts = { style = "moon" },
	},

	{
		-- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
		-- vim.cmd.colorscheme("catppuccin-mocha")
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 10000,
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	{
		"gbprod/nord.nvim",
		name = "nord",
		priority = 10000,
		install = {
			colorscheme = { "nord" },
		},
	},

	{
		"akinsho/bufferline.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = require("plugins.bufferline.config"),
	},

	{
		"utilyre/barbecue.nvim",
		lazy = false,
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},

	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = require("plugins.lualine.config"),
		init = function()
			vim.o.laststatus = 3
		end,
	},

	{
		"rcarriga/nvim-notify",
		lazy = false,
		keys = {
			{ "<cr>", ":NotifyDismiss<cr>", silent = true },
		},
		config = function()
			require("plugins.notify")
		end,
	},

	{
		"folke/noice.nvim",
		lazy = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = require("plugins.noice"),
	},

	{
		"nvim-treesitter/nvim-treesitter",
		main = "nvim-treesitter.configs",
		build = ":TSUpdate",
		lazy = false,
		priority = 100,
		--event = "VimEnter",
		--cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		opts = require("plugins.treesitter.config"),
	},

	-- Files
	{
		"kyazdani42/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "m", ":NvimTreeToggle<cr>", silent = true },
			{ "<leader>e", ":NvimTreeFocusToggle<cr>", silent = true },
			{ "<C-e>", ":NvimTreeFocusToggle<cr>", silent = true },
			{ "<leader>b", ":NvimTreeClose<cr>", silent = true },
			-- { "<leader>e", ":NvimTreeOpen<cr>", silent = true },
		},
		config = function()
			require("plugins.nvimtree.setup")
		end,
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		name = "telescope",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			-- fzf integration --
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "junegunn/fzf.vim" },
			{ "tpope/vim-dispatch", cmd = { "Make", "Dispatch" } },
		},
		keys = {
			{ "<C-p>", ":Telescope find_files<cr>", silent = true },
			{ "<leader>f", ":Telescope find_files<cr>", silent = true },
			{ "<leader>r", ":Telescope live_grep<cr>", silent = true },
		},
		opts = require("plugins.telescope.config"),
	},

	---- LSP, FORMAT AND LINT
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("plugins.mason.setup")
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "Format", "FormatOnSaveEnable", "FormatOnSaveDisable" },
		config = function()
			require("plugins.conform.setup")
		end,
	},

	{
		-- https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		"neovim/nvim-lspconfig",
		version = false,
		--event = { "BufReadPost", "BufNewFile" },
		event = { "VeryLazy" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			require("plugins.cmp"),
			--"b0o/SchemaStore.nvim",
		},
		init = function()
			vim.opt.completeopt = { "menu", "menuone", "noselect" }
		end,
		config = function()
			require("plugins.lsp.setup")
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "Lint" },
		config = function()
			require("plugins.lint.setup")
		end,
	},

	-- utils --
	{
		"alexghergh/nvim-tmux-navigation",
		event = "VeryLazy",
		config = function()
			require("plugins.tmux")
		end,
	},

	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		lazy = false,
		event = "VeryLazy",
		config = function()
			require("plugins.indentblankline")
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = "VeryLazy",
		opts = { "*" },
	},

	--plugin("flutter"),
	-- 	"akinsho/toggleterm.nvim",
	-- 	"jackMort/ChatGPT.nvim",
	-- 	"rest-nvim/rest.nvim",
})

-- M.plugins = {
-- 	-- colorschemes ---
-- 	"folke/tokyonight.nvim",
-- 	"Mofiqul/dracula.nvim",
-- 	"catppuccin/nvim",
-- 	"gbprod/nord.nvim",
--
-- 	-- ui --
-- 	"akinsho/bufferline.nvim",
-- 	"utilyre/barbecue.nvim",
-- 	"nvim-lualine/lualine.nvim",
-- 	"rcarriga/nvim-notify",
-- 	"folke/noice.nvim",
--
-- 	-- files --
-- 	"kyazdani42/nvim-tree.lua",
-- 	"nvim-telescope/telescope.nvim",
--
-- 	-- installers --
-- 	"williamboman/mason.nvim",
--
-- 	-- parsers --
-- 	"nvim-treesitter/nvim-treesitter",
--
-- 	-- -- lsp, format, lint --
-- 	"neovim/nvim-lspconfig",
-- 	"stevearc/conform.nvim",
-- 	"mfussenegger/nvim-lint",
--
-- 	-- AutoComplete --
-- 	"hrsh7th/nvim-cmp",
--
-- 	-- markdown --
-- 	--"toppair/peek.nvim",
--
-- 	-- utils --
-- 	"alexghergh/nvim-tmux-navigation",
-- 	"lukas-reineke/indent-blankline.nvim",
-- 	"akinsho/toggleterm.nvim",
-- 	"jackMort/ChatGPT.nvim",
-- 	"rest-nvim/rest.nvim",
-- 	-- "xiyaowong/transparent.nvim",
--
-- 	-- "echasnovski/mini.comment",,
-- 	-- "echasnovski/mini.pairs",,
-- 	-- "rest-nvim/rest.nvim",,
-- 	-- -- "jakewvincent/mkdnflow.nvimplug",,
-- 	-- -- "kristijanhusak/vim-dadbod-ui",,
-- }
--
-- M.imports = {
-- 	{ import = "plugins.specs" },
-- }
--
-- function M.is(cname)
-- 	for _, name in pairs(M.plugins) do
-- 		if name == cname then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end
--
-- function M.load(name, spec)
-- 	--spec.name = name
-- 	spec.enabled = false
--
-- 	for _, cname in pairs(M.plugins) do
-- 		if spec[1] == cname or name == cname then
-- 			spec.enabled = true
-- 			return spec
-- 		end
-- 	end
--
-- 	return spec
-- end
--
-- return M
