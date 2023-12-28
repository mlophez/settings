return {
	PATH = "prepend", -- '"prepend"' | '"append"' | '"skip"'

	ensure_installed = {
		-- lsp
		"lua-language-server", -- lua_ls
		"yaml-language-server", -- yamlls
		"terraform-ls", -- terraformls
		"pyright",
		"gopls",
		"emmet-language-server",
		"typescript-language-server",
		"astro-language-server",
		"tailwindcss-language-server",

		-- formatters
		"stylua",
		"isort",
		"black",
		"prettier",
		"yamlfmt",
		"xmlformatter",
		--"sql-formatter",

		-- linters
		"pylint",
		"tflint",
		"tfsec",
		"luacheck",
		--"sonarlint-language-server",
	},

	ui = {
		icons = {
			package_pending = " ",
			package_installed = "󰄳 ",
			package_uninstalled = " 󰚌",
		},

		keymaps = {
			toggle_server_expand = "<CR>",
			install_server = "i",
			update_server = "u",
			check_server_version = "c",
			update_all_servers = "U",
			check_outdated_servers = "C",
			uninstall_server = "X",
			cancel_installation = "<C-c>",
		},
	},
	max_concurrent_installers = 10,
}
