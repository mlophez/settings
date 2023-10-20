-- filetype.lua

-- help --
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help" },
	command = "wincmd o",
})

-- autocmd BufNewFile,BufRead *.tf set filetype=hcl
vim.cmd([[
  augroup filetype
    autocmd!
    autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy
  augroup end
]])

--vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--	group = vim.api.nvim_create_augroup("filetype", { clear = true }),
--	callback = function()
--    vim.bo.filetype = "groovy"
--	end,
--})
