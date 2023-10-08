return {
	"williamboman/mason.nvim",
  enabled = Plugins.mason,
  lazy = false,
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
	config = function(_, opts)
    require("mason").setup(opts)
		require("mason-tool-installer").setup({
			auto_update = true,
			ensure_installed = {
				-- lsp
				"lua-language-server", -- lua_ls
				"yaml-language-server", -- yamlls
				"terraform-ls", -- terraformls
				"pyright",
				-- formatters
				"stylua",
				"isort",
				"black",
				"prettier",
				"yamlfmt",
				-- linters
				"pylint",
				"tflint",
				"tfsec",
			},
		})
	end,
}

-- return {
-- 	"williamboman/mason-lspconfig.nvim",
-- 	enabled = false,
-- 	dependencies = {
-- 		"williamboman/mason.nvim",
-- 	},
-- 	opts = {
-- 		automatic_installation = true,
-- 		ensure_installed = {
-- 			"lua_ls",
-- 			"yamlls",
-- 			"terraformls",
-- 			"pyright",
-- 		},
-- 	},
-- }
