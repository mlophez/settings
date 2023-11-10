-- init.lua
require("core.options")
require("core.mappings")
require("core.filetype")
require("core.autocmds")
require("core.plugins")

vim.api.nvim_create_user_command("PluginCheck", function()
	local plugins = require("lazy").plugins()
	for _, plug in ipairs(plugins) do
		print(plug[1])
		print(plug.loaded)
	end
end, {})
