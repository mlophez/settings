" init.vim

""" GLOBALS
let venvs = $PYTHONENVS
let terminal_theme = $ALACRITTY_THEME
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python3'
" let g:python3_host_prog = venvs . '/nvim/bin/python'
" let g:python3_host_prog = expand('~/.local/python/nvim/bin/python')
" let g:dracula_colorterm = 0

""" PLUGINS
call plug#begin(expand('~/.local/share/nvim/plugins'))

""" THEMES
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

""" APPAREANCE
Plug 'chrisbra/Colorizer'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'ap/vim-css-color'
" Plug 'ryanoasis/vim-devicons'
" Plug 'yggdroot/indentline'
" Plug 'itchyny/lightline.vim'
" Plug 'spacevim/spacevim'

""" EDITOR
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'junegunn/fzf.vim'
Plug 'justinhoward/fzf-neoyank'
Plug 'vimwiki/vimwiki'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'jiangmiao/auto-pairs'
" Plug 'jceb/vim-orgmode'
" Plug 'kiteco/vim-plugin'
" Plug 'pacha/vem-tabline'
" Plug 'jistr/vim-nerdtree-tabs'

""" AUTOCOMPLETE FRAMEWORKS
"Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "pip3 --user install pynvim neovim
" Plug 'zchee/deoplete-jedi'
" Plug 'davidhalter/jedi-vim'

""" LANG
Plug 'dart-lang/dart-vim-plugin'
Plug 'dag/vim-fish'
Plug 'peterhoeg/vim-qml'
Plug 'kamailio/vim-kamailio-syntax'
Plug 'ekalinin/dockerfile.vim'
Plug 'habamax/vim-godot'

""" UTILS
Plug 'diepm/vim-rest-console'
call plug#end()

""" DEOPLETE
let g:deoplete#enable_at_startup = 1

""" NERDTREE
let NERDTreeQuitOnOpen = 1

""" FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'rounded' } }
let g:fzf_tags_command = 'ctags -R'

let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info --color border:13'
let $FZF_DEFAULT_COMMAND = "rg -i --files --hidden --follow --glob '!.git/**'"
"""let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!.dart_tool/**' --glob '!.idea' --glob '!node_modules'"

""" AIRLINE 
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#ignore_bufadd_pat = 'gundo|undotree|vimfiler|tagbar|nerd_tree|startify|__REST_response__|!'

let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''

""" VIMWIKI
let g:vimwiki_folding='custom'
let g:vimwiki_list = [{'path': '~/Documents/Notes', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-' }, 
                    \ {'path': '~/Projects/archlinux/wiki', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-' },
                    \ {'path': '~/Share/Wiki', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-' }]

""" REST
let g:vrc_curl_opts = {
\  '--connect-timeout' : 10,
\  '-i': '',
\  '-s': '',
\  '--max-time': 10,
\  '--ipv4': '',
\  '-k': '',
\}

""" COC
let g:coc_global_extensions = [ 'coc-snippets',
                              \ 'coc-json',
                              \ 'coc-html', 
                              \ 'coc-css', 
                              \ 'coc-flutter',
                              \ 'coc-go',
                              \ 'coc-clangd',
                              \ 'coc-java',
                              \ 'coc-python',
                              \ 'coc-tsserver',
                              \ 'coc-vimlsp']

""" FUNCTIONS
" functions.vim
" execute 'bd ' . i
"         silent execute 'bwipeout' buf

function! CloseHiddenBuffers()
  let i = 0
  let n = bufnr('$')
  while i < n
    let i = i + 1
    if bufloaded(i) && bufwinnr(i) < 0
      echom i ." - ". bufwinnr(i) ." - ". bufwinid(i) ." - ". bufname(i)
    endif
  endwhile
endfun

function DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        if bufloaded(buf)
            execute 'bd '.buf
        endif
    endfor
endfunction

""" VIMWIKI
function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! PreviusIndex(lnum)
    let current = a:lnum

    while current >= 1
        if getline(current) =~? '\v^#.*$'
            return current
        endif

        let current -= 1
    endwhile

    return -2
endfunction

function! IndentLevel(lnum)
    if getline(a:lnum) =~? '\v^###'
        return 2
    endif
    if getline(a:lnum) =~? '\v^##'
        return 1
    endif
    if getline(a:lnum) =~? '\v^#'
        return 0
    endif
    return -1
endfunction

"function! IndentLevel(lnum)
"    return indent(a:lnum) / &shiftwidth
"endfunction

function! MarkdownCustomFolding(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let current = IndentLevel(a:lnum)
    let previusline = IndentLevel(a:lnum - 1)
    let previus = IndentLevel(PreviusIndex(a:lnum)) + 1

    if previusline != -1
        if current != -1
            echom getline(a:lnum) . ' - level: >' . current
            return '>' . current
        endif
        echom getline(a:lnum) . ' - level: >' . previus
        return '>' . previus
    endif

    if current != -1
        echom getline(a:lnum) . ' - level: ' . current
        return current
    endif


    echom getline(a:lnum) . ' - level: ' . previus
    return previus
endfunction

" function! MarkdownCustomFolding(lnum)
"     if getline(a:lnum) =~? '\v^\s*$'
"         return '-1'
"     endif
" 
"     if getline(a:lnum) =~? '\v^###'
"         return '3'
"     endif
"     if getline(a:lnum) =~? '\v^###'
"         return '2'
"     endif
"     if getline(a:lnum) =~? '\v^#'
"         return '1'
"     endif
" 
"     let this_indent = IndentLevel(a:lnum)
"     let next_indent = IndentLevel(NextNonBlankLine(a:lnum))
" 
"     if next_indent == this_indent
"         return this_indent
"     elseif next_indent < this_indent
"         return this_indent
"     elseif next_indent > this_indent
"         return '>' . next_indent
"     endif
" endfunction

function! MarkdownFoldText()
    let count = v:foldend - v:foldstart + 1
    "let current = getline(v:foldstart)

    return repeat(" ", 10) . "Tasks: [" . count . "] "
endfunction

""" *** COLORS ***
function! TaskMark()
    let line = getline('.')

    if line =~ '- *\[ \][^*]*$'
        execute 's/- *\[ \] */- \[ \] \*\*/g'
        execute 's/$/\*\*/g'
    endif

    if line =~ '\*'
        execute 's/\*//g'
    endif
endfunction

function! TaskMarkLevel(level)
    let line = getline('.')

    if line =~ '\[![1-9]\]'
        execute 's/ *\[![1-9]\]//g'
        "execute 's/(^[ \-\[\]]\+)([^@\[\]]*)(\[![1-9]\] *)(.*)//g'
    endif

    if a:level < 5
        execute 's/\(^[ \-\[\]]\+\)\([^@\[\]]*\)\(.*\)/\1\2[!'. a:level . '] \3/g'
        "execute 's/()( *$/ [!'. a:level . '])/g'
    endif
endfunction


function! OrgColors()
    syntax match title /^#.*$/
    syntax match flag /\[[^ X]\+\]/
    syntax match mark1 /[^\[\]]*\[!1\]/
    syntax match mark2 /[^\[\]]*\[!2\]/
    syntax match mark3 /[^\[\]]*\[!3\]/
    syntax match mark4 /[^\[\]]*\[!4\]/
    syntax match tags /@[[:alnum:]]*/

    syntax match header /^ *\*\+/
    syntax match line /^\v-.*$/ contains=flag,mark1,mark2,mark3,mark4,tags

    "syntax match Folded /^.*··$/ contains=flag,mark1,mark2,mark3,mark4

    highlight header gui=bold guifg=#DAFF33

    highlight title gui=bold guifg=#3CFF11

    highlight flag gui=bold guifg=#FA91FF
    highlight tags gui=bold guifg=#B8FFF0

    highlight mark1 gui=bold guifg=#FF3F3F
    highlight mark2 gui=bold guifg=#FFAD2E
    highlight mark3 gui=bold guifg=#1CF8FF
    highlight mark4 gui=bold guifg=white
    "highlight Folded guibg=None gui=bold guifg=#3CFF11
    "highlight Folded guibg=None gui=None guifg=white
endfunction

"function! OrgProcess()
"python
"import vim
"
"EOF
"endfunction

" YamlFold
function! YamlFolds()
  let previous_level = indent(prevnonblank(v:lnum - 1)) / &shiftwidth
  let current_level = indent(v:lnum) / &shiftwidth
  let next_level = indent(nextnonblank(v:lnum + 1)) / &shiftwidth

  if getline(v:lnum + 1) =~ '^\s*$'
    return "="

  elseif current_level < next_level
    return next_level

  elseif current_level > next_level
    return ('s' . (current_level - next_level))

  elseif current_level == previous_level
    return "="

  endif

  return next_level
endfunction

function! YamlFoldText()
  let lines = v:foldend - v:foldstart
  return getline(v:foldstart) . '   (level ' . v:foldlevel . ', lines ' . lines . ')'
endfunction

""" SETTINGS
syntax on
filetype plugin on
set nocompatible
set title
set mouse-=a
set clipboard+=unnamedplus
set confirm
set nowrap
set tabstop=4 shiftwidth=4 softtabstop=4 shiftround expandtab
set hidden
set ignorecase
set smartcase
set spelllang=en,es
set number
set relativenumber
set cursorline
set background=dark
set encoding=utf-8
set termguicolors
set t_Co=256
autocmd TermOpen * setlocal nonumber norelativenumber
" highlight clear CursorLine
" highlight CursorLine gui=underline cterm=underline " guibg=Grey40
" colorscheme gruvbox
if terminal_theme == "dracula"
    colorscheme dracula
    let g:airline_theme = 'dracula'
elseif terminal_theme == "gruvbox"
    colorscheme gruvbox
    let g:airline_theme = 'gruvbox'
elseif terminal_theme == "nord"
    colorscheme nord
    let g:airline_theme = 'nord'
else
    colorscheme dracula
    let g:airline_theme = 'dracula'
    highlight Normal guibg=NONE ctermbg=NONE
endif

""" FILETYPE
augroup filetype_settings
    autocmd!
    autocmd FileType rest setlocal tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab
    autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab
    autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab
    autocmd FileType yaml setlocal foldlevel=99 foldmethod=expr foldexpr=YamlFolds() foldtext=YamlFoldText()
    autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab
    autocmd FileType xhtml setlocal tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab
augroup END


""" AIRLINE
set noshowmode
set showtabline=2

" """ COC
" set hidden
" set nobackup
" set nowritebackup
" set cmdheight=2
" set updatetime=300
" set shortmess+=c
" if has("patch-8.1.1564")
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


""" CUSTOM
augroup custom_settings
    autocmd!

    """ IMAGES 
    autocmd BufEnter *.png,*.jpg,*gif silent exec "! imv ".expand("%") | :bw

    """ NERDTREE
    " Exit Vim if NERDTree is the only window left.
    " autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    " If another buffer tries to replace NERDTree, put in the other window, and bring back NERDTree.
    autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
    " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * silent NERDTreeMirror

    """ VIMWIKI
    autocmd FileType vimwiki setlocal tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab
    autocmd BufNewFile,BufRead org.md setlocal foldenable foldmethod=indent foldtext=MarkdownFoldText() foldlevel=1
    autocmd BufEnter tasks.md call OrgColors()

    "autocmd BufNewFile,BufRead todo*.md setlocal foldenable foldmethod=expr foldexpr=MarkdownCustomFolding(v:lnum) foldtext=MarkdownFoldText() foldlevel=2
 
    """ REST
    autocmd FileType rest setlocal tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab
augroup END

""" KEYBINDINGS
"" Leader
let g:mapleader=','
nnoremap <leader><leader> :

"" Save files
nnoremap <C-s> :w<cr> " Guardar
nnoremap <C-x> :x<cr> " Guardar y Salir
inoremap <C-s> <esc>:w<cr> " Guardar
inoremap <C-x> <esc>:x<cr> " Guardar y Salir

" nnoremap <leader>q :q<cr>
" nnoremap <silent> <leader>q :q<cr>
" nnoremap <silent> <leader>Q :bufdo bd<cr>:q<cr>
nnoremap <silent> <leader>q :q<cr>
nnoremap <silent> <leader>Q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>x :x<cr>
nnoremap <silent> <BS> :bd<cr>

"" Copy and Paste
inoremap <C-p> <esc>pi
inoremap <C-y> <esc>yyi
inoremap <C-d> <esc>ddi

"" Escape
tnoremap <Esc> <C-\><C-n>
tnoremap jk <C-\><C-n>
inoremap jk <esc>
vnoremap jk <esc>
cnoremap jk <esc>

""Terminal
" nnoremap <leader>r aclear<cr><up><up><cr><C-\><C-n>

"" Reload config
nnoremap <leader>R :so ~/.config/nvim/init.vim<cr>

""Folding
nnoremap <space> za

"" No category
"map <c-t> <esc>:tabnew<cr>
"map <c-pageup> :tabpcr>
"map <c-pagedown> :tabn<cr>
"nmap <Tab> :bnext<cr>
"nmap <S-Tab> :bprevious<cr>
nnoremap <f4> :set relativenumber!<cr>
nnoremap <f11> :set paste!<cr>

"" Terminal
" nnoremap <leader>t :edit term://fish<cr>

"" Buffers (Airline)
nnoremap <silent> <leader>1 :bfirst<cr>
nnoremap <silent> <leader>2 :bfirst<cr>:bn<cr>
nnoremap <silent> <leader>3 :bfirst<cr>:2bn<cr>
nnoremap <silent> <leader>4 :bfirst<cr>:3bn<cr>
nnoremap <silent> <leader>5 :bfirst<cr>:4bn<cr>
nnoremap <silent> <leader>6 :bfirst<cr>:5bn<cr>
nnoremap <silent> <leader>7 :bfirst<cr>:6bn<cr>
nnoremap <silent> <leader>8 :bfirst<cr>:7bn<cr>
nnoremap <silent> <leader>9 :bfirst<cr>:8bn<cr>
nnoremap <silent> <leader>0 :bfirst<cr>:9bn<cr>

"" Buffers
nnoremap <silent> <TAB> :bnext<cr>
nnoremap <silent> <S-TAB> :bprev<cr>
" nnoremap <silent> <leader>1 :b1<cr>
" nnoremap <silent> <leader>2 :b2<cr>
" nnoremap <silent> <leader>3 :b3<cr>
" nnoremap <silent> <leader>4 :b4<cr>
" nnoremap <silent> <leader>5 :b5<cr>
" nnoremap <silent> <leader>6 :b6<cr>
" nnoremap <silent> <leader>7 :b7<cr>
" nnoremap <silent> <leader>8 :b8<cr>
" nnoremap <silent> <leader>9 :b9<cr>
" nnoremap <silent> <leader>0 :b10<cr>


"" Tabs
" nnoremap <leader>t :tabnew<cr>
" nnoremap <leader>1 :tabn1<cr>
" nnoremap <leader>2 :tabn2<cr>
" nnoremap <leader>3 :tabn3<cr>
" nnoremap <leader>4 :tabn4<cr>
" nnoremap <leader>5 :tabn5<cr>
" nnoremap <leader>6 :tabn6<cr>
" nnoremap <leader>7 :tabn7<cr>
" nnoremap <leader>8 :tabn8<cr>
" nnoremap <leader>9 :tabn9<cr>
" nnoremap <leader>0 :tabn10<cr>

"" Splits
nnoremap <leader>h :vsplit<cr><C-w><Right>
nnoremap <leader>v :split<cr><C-w><Down>

nnoremap <leader>j <C-w><Left>
nnoremap <leader>k <C-w><Down>
nnoremap <leader>l <C-w><Up>
nnoremap <leader>ñ <C-w><Right>

nnoremap <leader><Left> <C-w><Left>
nnoremap <leader><Down> <C-w><Down>
nnoremap <leader><Up> <C-w><Up>
nnoremap <leader><Right> <C-w><Right>

"" Resize
" nnoremap <silent> <C-j> :vertical resize +1<cr>
" nnoremap <silent> <C-k> :resize -1<cr>
" nnoremap <silent> <C-l> :resize +1<cr>
" nnoremap <silent> <C-p> :vertical resize -1<cr>

nnoremap <silent> <C-Left> :vertical resize +5<cr>
nnoremap <silent> <C-Down> :resize -5<cr>
nnoremap <silent> <C-Up> :resize +5<cr>
nnoremap <silent> <C-Right> :vertical resize -5<cr>

"" Navigations
nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ñ l

vnoremap j h
vnoremap k j
vnoremap l k
vnoremap ñ l

xnoremap j h
xnoremap k j
xnoremap l k
xnoremap ñ l

" inoremap <C-j> <Left>
" inoremap <C-k> <Down>
" inoremap <C-l> <Up>
" inoremap <C-ñ> <Right>

" Set in alacritty terminal
" tnoremap <C-j> <Left>
" tnoremap <C-k> <Down>
" tnoremap <C-l> <Up>
" tnoremap ñ <Right>
" 
" cnoremap <C-j> <Left>
" cnoremap <C-k> <Down>
" cnoremap <C-l> <Up>
" cnoremap ñ <Right>

nnoremap hñ A
nnoremap hj I

"" Learn real vim
inoremap <esc> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
nnoremap : <nop>
nnoremap Q <nop>
nnoremap q <nop>

""" Filetype
augroup filetype_general
    autocmd!
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType dart setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType python setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType tf setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END

""" NerdTree
noremap <silent> <leader>e :NERDTreeRefreshRoot<cr>:NERDTreeToggle<cr>

""" Fuzzy Finder
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>t :Files<cr>
nnoremap <silent> <leader>f :Rg<cr>
nnoremap <silent> <C-p> :Files<cr>
inoremap <silent> <C-p> <esc>:Files<cr>

" nnoremap <leader>t :FZF<cr>
" nnoremap <leader>b i<up>

""" VIMWIKI
nnoremap <silent> tt :VimwikiIndex 1<cr>
nnoremap <silent> t1 :VimwikiIndex 1<cr>
nnoremap <silent> t2 :VimwikiIndex 2<cr>
nnoremap <silent> t3 :VimwikiIndex 3<cr>
nnoremap <silent> t4 :VimwikiIndex 4<cr>
nnoremap <silent> t5 :VimwikiIndex 5<cr>
nnoremap <silent> gt :VimwikiTOC<cr>
nnoremap <silent> hh :silent exec "!zsh -i -c 'wiki-screenshot &> /dev/null'"<cr>

"  """ COC
"  nnoremap <silent> gd <Plug>(coc-definition)
"  nnoremap <silent> gy <Plug>(coc-type-definition)
"  nnoremap <silent> gi <Plug>(coc-implementation)
"  nnoremap <silent> gr <Plug>(coc-references)
"  if has('nvim')
"    inoremap <silent><expr> <c-space> coc#refresh()
"  else
"    inoremap <silent><expr> <c-@> coc#refresh()
"  endif

""" CUSTOM
augroup custom_keys
    autocmd!

    """ VIMWIKI
    autocmd FileType vimwiki nnoremap <silent> <buffer> mm :call TaskMark()<cr>
    autocmd FileType vimwiki nnoremap <silent> <buffer> <BS> :bd<cr>
    autocmd FileType vimwiki nnoremap <silent> <buffer> n :VimwikiNextLink<cr>
    "autocmd FileType vimwiki nmap <silent> <TAB> :bnext<cr>
    "autocmd FileType vimwiki nmap <silent> <S-TAB> :bprev<cr>
" nnoremap <silent> <leader>1 :b1<cr>
" nnoremap <silent> <leader>2 :b2<cr>
" nnoremap <silent> <leader>3 :b3<cr>
" nnoremap <silent> <leader>4 :b4<cr>
" nnoremap <silent> <leader>5 :b5<cr>
" nnoremap <silent> <leader>6 :b6<cr>
" nnoremap <silent> <leader>7 :b7<cr>
" nnoremap <silent> <leader>8 :b8<cr>
" nnoremap <silent> <leader>9 :b9<cr>
" nnoremap <silent> <leader>0 :b10<cr>


"" Tabs
" nnoremap <leader>t :tabnew<cr>
" nnoremap <leader>1 :tabn1<cr>
" nnoremap <leader>2 :tabn2<cr>
" nnoremap <leader>3 :tabn3<cr>
" nnoremap <leader>4 :tabn4<cr>
" nnoremap <leader>5 :tabn5<cr>
" nnoremap <leader>6 :tabn6<cr>
" nnoremap <leader>7 :tabn7<cr>
" nnoremap <leader>8 :tabn8<cr>
" nnoremap <leader>9 :tabn9<cr>
" nnoremap <leader>0 :tabn10<cr>

"" Splits
nnoremap <leader>h :vsplit<cr><C-w><Right>
nnoremap <leader>v :split<cr><C-w><Down>

nnoremap <leader>j <C-w><Left>
nnoremap <leader>k <C-w><Down>
nnoremap <leader>l <C-w><Up>
nnoremap <leader>ñ <C-w><Right>

nnoremap <leader><Left> <C-w><Left>
nnoremap <leader><Down> <C-w><Down>
nnoremap <leader><Up> <C-w><Up>
nnoremap <leader><Right> <C-w><Right>

"" Resize
" nnoremap <silent> <C-j> :vertical resize +1<cr>
" nnoremap <silent> <C-k> :resize -1<cr>
" nnoremap <silent> <C-l> :resize +1<cr>
" nnoremap <silent> <C-p> :vertical resize -1<cr>

nnoremap <silent> <C-Left> :vertical resize +5<cr>
nnoremap <silent> <C-Down> :resize -5<cr>
nnoremap <silent> <C-Up> :resize +5<cr>
nnoremap <silent> <C-Right> :vertical resize -5<cr>

"" Navigations
nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ñ l

vnoremap j h
vnoremap k j
vnoremap l k
vnoremap ñ l

xnoremap j h
xnoremap k j
xnoremap l k
xnoremap ñ l

" inoremap <C-j> <Left>
" inoremap <C-k> <Down>
" inoremap <C-l> <Up>
" inoremap <C-ñ> <Right>

" Set in alacritty terminal
" tnoremap <C-j> <Left>
" tnoremap <C-k> <Down>
" tnoremap <C-l> <Up>
" tnoremap ñ <Right>
" 
" cnoremap <C-j> <Left>
" cnoremap <C-k> <Down>
" cnoremap <C-l> <Up>
" cnoremap ñ <Right>

nnoremap hñ A
nnoremap hj I

"" Learn real vim
inoremap <esc> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
nnoremap : <nop>
nnoremap Q <nop>
nnoremap q <nop>

""" Filetype
augroup filetype_general
    autocmd!
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType dart setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType python setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType tf setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END

""" NerdTree
noremap <silent> <leader>e :NERDTreeRefreshRoot<cr>:NERDTreeToggle<cr>

""" Fuzzy Finder
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>t :Files<cr>
nnoremap <silent> <leader>f :Rg<cr>
nnoremap <silent> <C-p> :Files<cr>
inoremap <silent> <C-p> <esc>:Files<cr>

" nnoremap <leader>t :FZF<cr>
" nnoremap <leader>b i<up>

""" VIMWIKI
nnoremap <silent> tt :
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F12> :call TaskMarkLevel(0)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F1> :call TaskMarkLevel(1)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F2> :call TaskMarkLevel(2)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F3> :call TaskMarkLevel(3)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F4> :call TaskMarkLevel(4)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F5> :call TaskMarkLevel(5)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F6> :call TaskMarkLevel(6)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F7> :call TaskMarkLevel(7)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F8> :call TaskMarkLevel(8)<cr>
    autocmd BufNewFile,BufRead org.md nnoremap <silent> <buffer> <F9> :call TaskMarkLevel(9)<cr>

    """ REST
    autocmd FileType rest nnoremap <silent> <leader>r :call VrcQuery()<cr>
augroup END
