local spec = {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo", "Format", "FormatOnSaveEnable", "FormatOnSaveDisable" },
  opts = require("plugins.conform.opts")
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
