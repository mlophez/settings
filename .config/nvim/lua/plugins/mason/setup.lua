local opts = require("plugins.mason.config")
require("mason").setup(opts)

vim.api.nvim_create_user_command("MasonInstallAll", function()
	local mr = require("mason-registry")
	for _, name in pairs(opts.ensure_installed) do
		local p = mr.get_package(name)
		if not p:is_installed() then
			vim.cmd("MasonInstall " .. name)
		end
	end
end, {})

-- local augroup = vim.api.nvim_create_augroup("MasonAutoInstall", { clear = true })
-- vim.api.nvim_create_autocmd({ "UIEnter" }, {
-- 	group = augroup,
-- 	callback = function()
-- 		local mr = require("mason-registry")
-- 		for _, name in pairs(opts.ensure_installed) do
-- 			local p = mr.get_package(name)
-- 			if not p:is_installed() then
-- 				vim.cmd("MasonInstall " .. name)
-- 			end
-- 		end
-- 	end,
-- })
