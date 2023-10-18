-- init.lua --
if vim.loader and vim.fn.has("nvim-0.9.1") == 1 then
	vim.loader.enable()
end

require("core.options")
require("core.keymaps")
require("core.filetype")

require("plugins")

--vim.cmd.colorscheme("catppuccin-mocha")
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
