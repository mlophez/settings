local loader = require("plugins.loader").load
return loader("mason", {
	"williamboman/mason.nvim",

	lazy = false,

	opts = {
		PATH = "prepend", -- '"prepend"' | '"append"' | '"skip"'

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
		ensure_installed = {
			-- lsp
			"lua-language-server", -- lua_ls
			"yaml-language-server", -- yamlls
			"terraform-ls", -- terraformls
			"pyright",
			"gopls",
			-- formatters
			"stylua",
			"isort",
			"black",
			"prettier",
			"yamlfmt",
			"xmlformatter",
			-- linters
			"pylint",
			"tflint",
			"tfsec",
			"luacheck",
			--"sonarlint-language-server",
		},
	},

	config = function(_, opts)
		require("mason").setup(opts)

		local augroup = vim.api.nvim_create_augroup("MasonAutoInstall", { clear = true })
		vim.api.nvim_create_autocmd({ "UIEnter" }, {
			group = augroup,
			callback = function()
				local mr = require("mason-registry")
				for _, name in pairs(opts.ensure_installed) do
					local p = mr.get_package(name)
					if not p:is_installed() then
						vim.cmd("MasonInstall " .. name)
					end
				end
			end,
		})
	end,
})
