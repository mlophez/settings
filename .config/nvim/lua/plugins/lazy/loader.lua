return function(plugin)
	local module_name = "plugins." .. plugin
	local success, module = pcall(require, module_name)
	if not success then
		return require(module_name .. "." .. module_name:match("([^%.]+)$"))
	end
	return module
end
