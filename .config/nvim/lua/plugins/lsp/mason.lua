return {
	"williamboman/mason.nvim",
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
	init = function()
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
				"prettierd",
				-- linters
				"pylint",
				"tflint",
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
