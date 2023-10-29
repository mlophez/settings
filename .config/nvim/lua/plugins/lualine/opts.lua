local widgets = require("plugins.lualine.widgets")
return {
	options = {
		theme = "auto",
		icons_enabled = true,
		global_status = true,
		disabled_filetypes = {
			statusline = {
				"NvimTree",
				"TelescopePrompt",
				"lazy",
				"mason",
			},
		},
		ignore_focus = {
			"NvimTree",
			"TelescopePrompt",
			"lazy",
			"mason",
		},
	},
	tabline = {},
	extensions = {},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{ "branch", icon = "" },
			{ "diff" },
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = " ",
				},
			},
		},
		lualine_c = {},
		lualine_x = {
			{ widgets.lspserver, icon = "lsp:", color = { bg = "#630a4d", fg = "#ffffff", gui = "bold" } },
			{ widgets.formatter, icon = "formatter:", color = { bg = "#351454", fg = "#ffffff", gui = "bold" } },
			{ "filetype" },
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
}


