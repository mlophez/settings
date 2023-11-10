local opts = require("plugins.nvimtree.config")
require("nvim-tree").setup(opts)

--require("nvim-tree.api").tree.open()
--vim.cmd("wincmd p")

vim.api.nvim_create_user_command("NvimTreeFocusToggle", function()
	if vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
		vim.cmd("wincmd p")
	else
		require("nvim-tree.api").tree.focus()
	end
end, {})

vim.api.nvim_create_user_command("NvimTreeToggle", function()
	if vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
		require("nvim-tree.api").tree.close()
	else
		require("nvim-tree.api").tree.focus()
	end
end, {})
