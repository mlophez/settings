-- https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local loader = require("plugins.loader").load
return loader("nvim-lspconfig", {
	"neovim/nvim-lspconfig",

	event = { "BufReadPost", "BufNewFile" },
	--event = { "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },

	--dependencies = {
	--	"b0o/SchemaStore.nvim",
	--},

	config = function(_, opts)
		vim.opt.completeopt = { "menu", "menuone", "noselect" }

		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")
		local lsp_defaults = lspconfig.util.default_config

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

		-- Language Servers
		-- lua --
		-- lspconfig.lua_ls.setup({
		-- 	settings = {
		-- 		Lua = {
		-- 			diagnostics = {
		-- 				globals = { "vim" },
		-- 			},
		-- 			workspace = {
		-- 				library = {
		-- 					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
		-- 					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
		-- 					[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
		-- 				},
		-- 				maxPreload = 100000,
		-- 				preloadFileSize = 10000,
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- python --
		lspconfig.pyright.setup({})

		-- terraform --
		lspconfig.terraformls.setup({})

		-- go --
		lspconfig.gopls.setup({
			--capabilities = capabilities,
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_dir = util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
					},
				},
			},
		})

		-- yamls --
		-- lspconfig.yamlls.setup({
		-- 	settings = {
		-- 		yaml = {
		-- 			trace = {
		-- 				server = "verbose",
		-- 			},
		-- 			schemas = {
		-- 				["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
		-- 				--["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
		-- 				--["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
		-- 				--["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
		-- 				--["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
		-- 				--["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
		-- 				--["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
		-- 				--["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
		-- 				--["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
		-- 				--["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
		-- 				--["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
		-- 				--["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
		-- 				--["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.6/all.json"] = "*.yaml",
		-- 			},
		-- 		},
		-- 	},
		-- })
	end,
})
