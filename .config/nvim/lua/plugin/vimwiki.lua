
let g:vimwiki_folding='custom'
let g:vimwiki_list = [{'path': '~/Documents/Notes', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-' }, 
                    \ {'path': '~/Projects/archlinux/wiki', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-' },
                    \ {'path': '~/Share/Wiki', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-' }]

vim.op
use {

'vimwiki/vimwiki',

config = function()
vim.g.vimwiki_list = {
'path' = '/home/xx/Documents/singularityOffice/wiki',
'syntax' = 'markdown',
'ext' = '.md',
}
}
