local lspconfig = require("lspconfig")
local lsputil = require("lspconfig/util")
-- lua --
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})

-- python --
lspconfig.pyright.setup({})

-- terraform --
lspconfig.terraformls.setup({})

-- go --
lspconfig.gopls.setup({
	--capabilities = capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = lsputil.root_pattern("go.work", "go.mod", ".git"),
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
