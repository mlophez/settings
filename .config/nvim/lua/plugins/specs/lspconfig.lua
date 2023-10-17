-- https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local loader = require("plugins.loader").load
return loader("nvim-lspconfig", {
	"neovim/nvim-lspconfig",

	version = false,
	event = { "BufReadPost", "BufNewFile" },
	--event = { "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },

	--dependencies = {
	--	"b0o/SchemaStore.nvim",
	--},

	config = function(_, opts)
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		require("plugins.lsp.servers")

		--local lspconfig = require("lspconfig")
		--local util = require("lspconfig/util")
		--local lsp_defaults = lspconfig.util.default_config
		-- Language Servers

		--lsp_defaults.capabilities = vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- vim.api.nvim_create_autocmd('LspAttach', {
		--   desc = 'LSP actions',
		--   callback = function(event)
		--     local opts = {buffer = event.buf}
		--
		--     vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
		--     vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		--     vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		--     vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		--     vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		--     vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		--     vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
		--     vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		--     vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
		--     vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		--
		--     vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
		--     vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
		--     vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
		--   end
		-- })
	end,
})
