return {
	-- https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	"neovim/nvim-lspconfig",
	version = false,
	event = { "BufReadPost", "BufNewFile" },
	--event = { "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	dependencies = {
		"weilbith/nvim-code-action-menu",
		--"b0o/SchemaStore.nvim",

		-- Autocomplete
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp", -- Required
	},
	init = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
	end,
	config = function()
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

		-- keymaps --
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "ca", "<cmd>CodeActionMenu<cr>", opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				--vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
				--vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				--vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
				--vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
				--vim.keymap.set("n", "<space>wl", function()
				--	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				--end, opts)
				--vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
				--vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

				--vim.keymap.set("n", "<space>f", function()
				--	vim.lsp.buf.format({ async = true })
				--end, opts)
			end,
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

		-- rust --
		--require("lspconfig").rust_analyzer.setup({})

		-- html --
		lspconfig.emmet_language_server.setup({})

		-- css --
		lspconfig.tailwindcss.setup({})

		-- typescript --
		lspconfig.tsserver.setup({})

		-- astro --
		lspconfig.astro.setup({
			--on_attach = function(client)
			--	client.resolved_capabilities.document_formatting = false
			--	client.server_capabilities.documentFormattingProvider = false
			--end,
			init_options = {
				typescript = {
					tsdk = vim.fs.normalize("/usr/lib/node_modules/typescript/lib"),
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
					lineLength = 120,
				},
			},
		})

		-- kotlin --
		--require("lspconfig").kotlin_language_server.setup({
		--	capabilities = capabilities,
		--})
	end,
}
