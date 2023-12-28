local format_on_save = function(bufnr)
	local lsp_fallback_enabled = true

	if vim.g.autoformat == nil then
		vim.g.autoformat = true
	end

	if vim.b[bufnr].autoformat == nil then
		vim.b[bufnr].autoformat = true
	end

	if not vim.g.autoformat or not vim.b[bufnr].autoformat then
		return nil
	end

	-- Check if lsp fallback --
	if vim.bo[bufnr].filetype == "astro" then
		lsp_fallback_enabled = false
	end

	return {
		lsp_fallback = lsp_fallback_enabled,
		async = false,
		timeout_ms = 2000,
	}
end

return {
	formatters = require("plugins.conform.formatters"),
	format_on_save = format_on_save,
	formatters_by_ft = {
		html = { "prettier" },
		css = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		astro = {},
		svelte = { "prettier" },
		json = { { "prettier", "jq" } },
		--xml = { "xmlformat" },
		yaml = { { "prettier", "yamlfmt" } },
		markdown = { "prettier" },
		graphql = { "prettier" },
		lua = { "stylua" },
		python = { "isort", "black" },
		terraform = { "terraform_fmt" },
		jsonnet = { "jsonnetfmt" },
		--sql = { "sql_formatter" },
		-- Use the "*" filetype to run formatters on all filetypes.
		-- ["*"] = { "codespell" },
		-- ["*"] = { "trim_whitespace" },
		-- Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
		["_"] = { "trim_whitespace" },
	},
}
