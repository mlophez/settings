-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- https://linovox.com/configuring-language-server-protocol-lsp-in-neovim/

local lspconfig = require("lspconfig")
local lsputil = require("lspconfig/util")
local root_pattern = lsputil.root_pattern

local defaults = lspconfig.util.default_config
local capabilities = defaults.capabilities

local status, cmp = pcall(require, "cmp_nvim_lsp")
if status then
	capabilities = cmp.default_capabilities()
	-- defaults.capabilities = vim.tbl_deep_extend("force", defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
end

vim.diagnostic.config({
	update_in_insert = false,
	underline = true,
	virtual_text = true,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, prefix = "\u{ea71}" },
	severity_sort = true,
})

-- lua --
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
				--library = {
				--	[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				--	[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				--	[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
				--},
				--maxPreload = 100000,
				--preloadFileSize = 10000,
			},
		},
	},
})

-- python --
lspconfig.pyright.setup({
	capabilities = capabilities,
})

-- terraform --
lspconfig.terraformls.setup({
	capabilities = capabilities,
})

-- go --
lspconfig.gopls.setup({
	capabilities = capabilities,
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

-- dart/flutter --
require("lspconfig").dartls.setup({
	capabilities = capabilities,
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	init_options = {
		closingLabels = true,
		flutterOutline = true,
		onlyAnalyzeProjectsWithOpenFiles = true,
		outline = true,
		suggestFromUnimportedLibraries = true,
	},
	root_dir = root_pattern("pubspec.yaml", ".git"),
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
			enableSnippets = true,
		},
	},
})

-- kotlin --
--require("lspconfig").kotlin_language_server.setup({
--	capabilities = capabilities,
--})
