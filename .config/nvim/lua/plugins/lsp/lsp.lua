-- https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		version = false,
		--event = { "BufReadPost", "BufNewFile" },
		--event = { "VeryLazy" },
		--cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		--dependencies = {
		--	"b0o/SchemaStore.nvim",
		--},
		init = function()
			vim.opt.completeopt = { "menu", "menuone", "noselect" }
		end,
		config = function(_, opts)
			require("plugins.lsp.servers")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			-- Autocompletion
			"hrsh7th/cmp-buffer", -- Optional
			"hrsh7th/cmp-path", -- Optional
			"hrsh7th/cmp-nvim-lsp", -- Required
			"hrsh7th/cmp-nvim-lua", -- Optional
			-- Snippets
			"L3MON4D3/LuaSnip", -- Required
			-- 'rafamadriz/friendly-snippets', -- Optional
		},
		opts = require("plugins.lsp.config"),
	},
}
