-- filetype.lua

vim.cmd([[
  augroup filetype
    autocmd!
    autocmd BufNewFile,BufRead *.tf set filetype=hcl
    autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy
  augroup end
]])
