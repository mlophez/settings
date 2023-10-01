-- filetype.lua

-- autocmd BufNewFile,BufRead *.tf set filetype=hcl
vim.cmd([[
  augroup filetype
    autocmd!
    autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy
  augroup end
]])

