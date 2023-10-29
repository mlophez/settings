-- https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
return {
	"neovim/nvim-lspconfig",
	name = "nvim-lsp",
	lazy = false,
	version = false,
	--event = { "BufReadPost", "BufNewFile" },
	--event = { "VeryLazy" },
	--cmd = { "LspInfo", "LspInstall", "LspUninstall" },

	--dependencies = {
	--	"b0o/SchemaStore.nvim",
	--},

	config = function(_, opts)
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		require("plugins.lsp.servers")
	end,
}
