return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo", "Format", "FormatOnSaveEnable", "FormatOnSaveDisable" },
	config = function()
		local conform = require("conform")

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

		conform.setup({
			formatters = {
				-- jsonnnet --
				jsonnetfmt = {
					command = "jsonnetfmt",
					args = { "-" },
					stdin = true,
					inherit = true,
					exit_codes = { 0 },
				},
			},
			format_on_save = format_on_save,
			formatters_by_ft = {
				lua = { "stylua" },
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
				-- yaml = { { "prettier", "yamlfmt" } },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				terraform = { "terraform_fmt" },
				jsonnet = { "jsonnetfmt" },
				rust = { "rustfmt" },
				--sql = { "sql_formatter" },
				-- Use the "*" filetype to run formatters on all filetypes.
				-- ["*"] = { "codespell" },
				["*"] = { "trim_whitespace" },
				["_"] = { "trim_whitespace" },
			},
		})
	end,
}
