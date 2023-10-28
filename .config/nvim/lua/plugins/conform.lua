local spec = {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo", "Format", "FormatOnSaveEnable", "FormatOnSaveDisable" },
}

spec.opts = {
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
		-- Use the "*" filetype to run formatters on all filetypes.
		-- ["*"] = { "codespell" },
		-- ["*"] = { "trim_whitespace" },
		-- Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
		["_"] = { "trim_whitespace" },
	},
	format_on_save = function(bufnr)
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
	end,
	formatters = require("plugins.config.formatters"),
}

spec.config = function(_, opts)
	local conform = require("conform")
	conform.setup(opts)

	vim.api.nvim_create_user_command("Format", function()
		conform.format({
			lsp_fallback = true,
			async = false,
			timeout_ms = 3000,
		})
	end, {})

	vim.api.nvim_create_user_command("FormatOnSaveDisable", function(args)
		if args.bang then
			-- FormatDisable! will disable formatting just for this buffer
			vim.b.autoformat = false
		else
			vim.g.autoformat = false
		end
	end, { desc = "Disable autoformat-on-save", bang = true })

	vim.api.nvim_create_user_command("FormatOnSaveEnable", function()
		vim.b.autoformat = true
		vim.g.autoformat = true
	end, { desc = "Re-enable autoformat-on-save" })
end

return spec
