local lsp = function()
	local msg = "none"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return msg
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return msg
	--str = str:gsub('[%p%c%s]', '')
end

local formatter = function()
	local msg = "none"

	local status, conform = pcall(require, "conform")
	if status then
		local lsp_format = require("conform.lsp_format")
		local lsp_formatters = lsp_format.get_format_clients({ bufnr = vim.api.nvim_get_current_buf() })
		local formatters = conform.list_formatters_for_buffer()

		if not vim.tbl_isempty(lsp_formatters) or not vim.tbl_isempty(formatters) then
			--print(vim.inspect(require("conform.lsp_format").get_format_clients({ bufnr = vim.api.nvim_get_current_buf() })))
			--print(vim.inspect(require("conform").list_formatters_for_buffer()))
			msg = ""

			if type(formatters[1]) == "table" then
				formatters = formatters[1]
			end

			for _, formatter in ipairs(lsp_formatters) do
				msg = msg .. formatter.name .. ", "
			end

			for _, formatter in ipairs(formatters) do
				msg = msg .. formatter .. ", "
			end

			if string.len(msg) > 2 then
				msg = msg:sub(1, -3)
			end
		end
	else
		msg = "disabled"
	end

	return msg
end

local loader = require("plugins.loader").load
return loader("lualine", {
	"nvim-lualine/lualine.nvim",

	lazy = false,
	event = "VimEnter",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	opts = {
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
				{ lsp, icon = "lsp:", color = { bg = "#630a4d", fg = "#ffffff", gui = "bold" } },
				{ formatter, icon = "formatter:", color = { bg = "#351454", fg = "#ffffff", gui = "bold" } },
				{ "filetype" },
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		tabline = {},
		extensions = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},

	init = function()
		vim.o.laststatus = 3
	end,
})
