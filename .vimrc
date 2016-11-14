set nocompatible
set backupdir=$HOME/.backup//
set directory=$HOME/.backup//

"-------------------------------------------------------------------------
" Vundle configuration
"
" To set up Vundle, run this:
"   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
" NOTE: comments after Plugin command are NOT allowed..
"-------------------------------------------------------------------------
filetype off      " Required by Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" let Vundle manage Vundle, required
 Plugin 'VundleVim/Vundle.vim'

" My Plugins
" ----------
Plugin 'yist/vim-indenthi'
Plugin 'yist/vim-codefolding'
"Plugin 'yist/vim-onewinresolve'
Plugin 'yist/vim-style'
Plugin 'yist/ScrollColors'
Plugin 'Valloric/YouCompleteMe'
let g:ycm_python_binary_path = 'python'
Plugin 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
set rtp+=~/.fzf
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~30%' }
Plugin 'sentientmachine/Pretty-Vim-Python'
Plugin 'Chiel92/vim-autoformat'
let g:formatters_python = ['yapf']
let g:formatdef_yapf = "'yapf --lines '.a:firstline.'-'.a:lastline"
Plugin 'tpope/vim-fugitive'
noremap ,f :Autoformat<CR>
Plugin 'davidhalter/jedi-vim'
autocmd FileType python setlocal completeopt-=preview cc=100
"Plugin 'ervandew/supertab'
Plugin 'bufexplorer.zip'
let g:bufExplorerSplitBelow=1        " Split new window below current.
map <silent> <F6> :call BufExplorerHorizontalSplit()<CR>
Plugin 'ShowMarks'
let showmarks_enable=0
hi link ShowMarksHLl LineNr         " lowercased marks
hi link ShowMarksHLu LineNr         " uppercased marks
hi link ShowMarksHLo Comment        " other marks
hi link ShowMarksHLm WarningMsg     " multiple marks on the same line
hi clear SignColumn
hi link SignColumn LineNr
Plugin 'scrooloose/syntastic'
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['python'],
                           \ 'passive_filetypes': [] }
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_enable_signs = 1
let g:syntastic_always_populate_loc_list = 1
Plugin 'Yggdroot/indentLine'
" utf-8 vertical:|¦┆│ ⟊⦚╎║┊┆┇┋⋮
"let g:indentLine_char='⋮'
let g:indentLine_char=':'
let g:indentLine_color_term=234
let g:indentLine_noConcealCursor=1
let g:indentLine_bufNameExclude = ['.*pipertmp.*']
" Obsoleted by YouCompleteMe
"Plugin 'SuperTab'
"Plugin 'SirVer/ultisnips'
"let g:UltiSnipsExpandTrigger       = "<C-Y>"
"let g:UltiSnipsListSnippets        = "<C-L>"
"let g:UltiSnipsJumpForwardTrigger  = "<C-J>"
"let g:UltiSnipsJumpBackwardTrigger = "<C-K>"
Plugin 'vim-scripts/Mark--Karkat'
Plugin 'vim-scripts/grep.vim'
Plugin 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#buffer_nr_format = '%s: '
let g:airline#extensions#tabline#fnamemod = ':~:.'
let g:airline#extensions#syntastic#enabled = 1
" ❯ ❩ ❭ ❫ 〉⟩ ▶  »
" ❮ ❨ ❰ ❪〈 ⟨
"let g:airline#extensions#tabline#left_sep = '⸩'
"let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_left_sep = '⸩'
let g:airline_right_sep = '⸨'
"let g:airline_theme='simple'
let g:airline_powerline_fonts = 0
Plugin 'terryma/vim-multiple-cursors'
Plugin 'jgdavey/tslime.vim'
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
vmap <silent> <Leader><CR> <Plug>SendSelectionToTmux
nmap <silent> <Leader>rv <Plug>SetTmuxVars
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"-------------------------------------------------------------------------
" Other configuraion
"-------------------------------------------------------------------------
set nobackup
let g:enable_local_swap_dirs=1
set complete-=i
set enc=UTF-8
set laststatus=2
" Size and style
set shiftwidth=2 softtabstop=2 expandtab
set autoindent nocindent nosmartindent
set hlsearch
set number
set incsearch
set sm
set nohidden
set nolist
set title
set fcs=vert:\|,fold:･
set cul
set nowrap
set wildmenu
set background=dark
set t_ut=
set backspace=indent,eol,start
syntax on
cabbr <expr> %% expand('%:p:h')
au FileType qf setlocal wrap linebreak
au FileType python setl sw=4 tw=100 cc=100
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif
" Change cursor shape in different mode. Works for
"  - iTerm2 on Mac OS X
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" Toggle cursor line highlight with Normal/Insert mode change
:autocmd InsertEnter,InsertLeave * set cul!
" complimentary highlight group
hi! link ColorColumn CursorLine
if (has("gui_running"))
  if &diff
    colo jellybean
  else
    colo summerfruit256
  endif
  set columns=88
  set lines=36
  set lcs=tab:↦\ ,trail:·,extends:§,precedes:§
  set sbr=\ \ »\ \ \ \ \
  set cpoptions+=n
  set swb=usetab
  set guioptions-=b
  set guioptions-=h
  set guioptions-=T
  set guioptions+=a
  "set guifont=Luxi_Mono:h11:cANSI
  "set guifont=Luxi\ Mono\ 18
  set guifont=LMMono9\ 12
  set sessionoptions-=options
else
  set tw=0
  set cc=80
  if &diff
    colo jellybean
  else
    colo molokai
  endif
  set ttymouse=xterm2
  set mouse=r
  nnoremap <C-K> <C-V>
endif

let mapleader=","

" Key mappings
" -------------------------
nmap j gj
nmap k gk
vmap j gj
vmap k gk
map <M-Left> :bp<CR>
map <M-Right> :bn<CR>
map <M-Down> :bn<CR>bd#<CR>
map <F12> :set hls!<CR>
map <F2> :w<CR>
map <silent> <F6> :BufExplorer<CR>
" spellcheck
map <F8> :setlocal spell spelllang=en_us<CR>
" auto-formatting
map <F11> :setlocal fo+=tcqwal<CR>
" current time
cmap timestr "=strftime(" %Y/%m/%d %H:%M:%S ")<CR>P
" switch to last buffer
nmap <silent> ` :e #<CR>
" get rid of trailing spaces
map <silent> gc :%s/[ <Tab>]\+$//<CR>
" enter/leave paste mode.
map gp :set invpaste<CR>:set paste?<CR>
" select color scheme
command! -nargs=0 C call FavColo()
" Terminal config choice
command! -nargs=0 T call DoNotMessUpTerminal()
" Browse current file directory
command! -nargs=0 E :e %:p:h
" Browse current file directory in a new tab
command! -nargs=0 B :tabnew %:p:h
if (has("gui_running"))
  " Change window height
  map <M-[> :set lines-=5<CR>
  map <M-]> :set lines+=5<CR>
  " Change line space
  map <M-,> :set linespace-=1<CR>
  map <M-.> :set linespace+=1<CR>
  map <M-/> :set linespace&<CR>
else
  vmap <C-C> :set paste<CR><ESC>"vy
  vmap <C-V> "vgP
endif
" Builtin plugin settings
" -------------------------
" for netrw
let g:netrw_sort_sequence     = '[\/]$,*'
let g:netrw_list_hide = '.*\.fuse_hidden'
" Check file change
au CursorHold * checktime
" White spaces
" -------------------------
fun! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun
command! TrimWhitespace call TrimWhitespace()
" All sorts of chars
" ---------------------
"  · ‥ ⁖ ⁘ ⁙ ⁚ ⁛ ⊙ ⋖ ⋗ ⟇ ⟑ ⦑ ⦒ ･ 𐄁
" ➠ ➟ ► ◄ ▻ ◅
" ⌦ ▶ ▷ ▸ ➔ ➡ ➤ ➧ ➲ ➽ ⦊⸩ ⸨ 】【
