-- lua setup
-- package.path = package.path .. ';' .. vim.fn.stdpath("config") .. "/lua/core/?.lua"

local require = require

local function custom_require(module_name)
  local success, module = pcall(require, module_name)
  if not success then
    return require(module_name .. "." .. module_name:match("([^%.]+)$") )
  end
  return module
end

_G.require = custom_require
