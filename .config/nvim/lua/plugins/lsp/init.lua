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
		dependencies = {
			require("plugins.cmp"),
			--"b0o/SchemaStore.nvim",
		},
		init = function()
			vim.opt.completeopt = { "menu", "menuone", "noselect" }
		end,
		config = function(_, opts)
			require("plugins.lsp.servers")
		end,
	},
}
