-- init.lua
require("config.options")
require("config.mappings")
require("config.filetype")
require("config.autocmds")
require("config.plugins")

--vim.api.nvim_create_user_command("PluginCheck", function()
--	local plugins = require("lazy").plugins()
--	for _, plug in ipairs(plugins) do
--		print(plug[1])
--		print(plug.loaded)
--	end
--end, {})
