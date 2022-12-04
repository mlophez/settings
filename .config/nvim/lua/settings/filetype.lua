-- filetype.lua

vim.cmd([[
  augroup filetype
    autocmd!
    autocmd BufNewFile,BufRead *.tf set filetype=hcl
  augroup end
]])
