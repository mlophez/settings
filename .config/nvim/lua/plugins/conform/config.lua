local format_on_save = function(bufnr)
	if vim.g.autoformat == nil then
		vim.g.autoformat = true
	end

	if vim.b[bufnr].autoformat == nil then
		vim.b[bufnr].autoformat = true
	end

	if not vim.g.autoformat or not vim.b[bufnr].autoformat then
		return nil
	end

	return {
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	}
end

return {
	formatters = require("plugins.conform.formatters"),
	format_on_save = format_on_save,
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { { "prettier", "jq" } },
		xml = { "xmlformat" },
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
