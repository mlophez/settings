return {
	"stevearc/conform.nvim",
  enabled = Plugins.conform,
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			svelte = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { { "prettier", "jq" } },
			yaml = { { "prettier", "yamlfmt" } },
			markdown = { "prettier" },
			graphql = { "prettier" },
			lua = { "stylua" },
			python = { "isort", "black" },
			terraform = { "terraform_fmt" },
			-- Use the "*" filetype to run formatters on all filetypes.
			-- ["*"] = { "codespell" },
			-- ["*"] = { "trim_whitespace" },
			-- Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
			["_"] = { "trim_whitespace" },
		},
		format_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		},
	},
	config = function()
		local conform = require("conform")
		vim.keymap.set({ "n", "v" }, "<leader>e", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			})
		end)
	end,
}
