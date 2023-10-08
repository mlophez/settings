return {
	"williamboman/mason.nvim",
	enabled = Plugins.mason,
	lazy = false,
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	opts = {
		mason = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		installer = {
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
				"luacheck",
				"sonarlint-language-server",
			},
		},
	},
	config = function(_, opts)
		require("mason").setup(opts.mason)
		require("mason-tool-installer").setup(opts.installer)
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
