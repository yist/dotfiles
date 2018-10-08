set nocompatible
set backupdir=$HOME/.backup//
set directory=$HOME/.backup//
" Learder key
let mapleader=","

" Detect OS
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif


"-------------------------------------------------------------------------
" Package Management
"-------------------------------------------------------------------------
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
command! PackUpdate packadd minpac | call minpac#update()
command! PackClean  packadd minpac | call minpac#clean()

source $HOME/.pkgs.vimrc

"-------------------------------------------------------------------------
" Other configuraion
"-------------------------------------------------------------------------
hi clear
set termguicolors
colo maui


" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set nobackup
let g:enable_local_swap_dirs=1
set complete-=i
set enc=UTF-8
set laststatus=2
" Size and style
set shiftwidth=4 softtabstop=4 expandtab smarttab
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
set lazyredraw
set magic

" Use Unix as the standard file type
set ffs=unix,mac,dos

syntax on
filetype plugin indent on
cabbr <expr> %% expand('%:p:h')
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
au FileType qf setlocal wrap linebreak

if g:os == "Darwin"
    " Change cursor shape in different mode. Works for
    "  - iTerm2 on Mac OS X
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
elseif g:os == "Linux"
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' | 
    \   silent execute '!echo -ne "\e[6 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[4 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

" Toggle cursor line highlight with Normal/Insert mode change
:autocmd InsertEnter,InsertLeave * set cul!
" complimentary highlight group
hi! link ColorColumn CursorLine

autocmd FileType python setlocal fdm=indent completeopt-=preview sw=4 tw=100 |
    \ let &cc=101
autocmd FileType cpp setlocal completeopt-=preview sw=2 tw=80 |
    \ let &cc=81
autocmd FileType go setlocal tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
autocmd FileType netrw setl bufhidden=wipe

" netrw
" -------------------------
let g:netrw_liststyle=3
let g:netrw_winsize=20
let g:netrw_wiw=30


" Key mappings
" -------------------------
nmap j gj
nmap k gk
vmap j gj
vmap k gk
map <c-h> gT
map <c-l> gt
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
" Browse current file directory
command! -nargs=0 E :e %:p:h
" Browse current file directory in a new tab
command! -nargs=0 B :tabnew %:p:h
" Copy/Paste to system clipboard
if has('unix')
    if has('mac')     " Works for Homebrew VIM
        set clipboard=unnamed
    else
        set clipboard=unnamedplus
    endif
endif
" Switch to Terminal-Normal mode
if has('terminal')
    tnoremap <Esc> <C-W>N
endif

if (has("gui_running"))
  " Change window height
  map <M-[> :set lines-=5<CR>
  map <M-]> :set lines+=5<CR>
  " Change line space
  map <M-,> :set linespace-=1<CR>
  map <M-.> :set linespace+=1<CR>
  map <M-/> :set linespace&<CR>
  set guioptions=aegimrLtT
else
  vmap <C-C> :set paste<CR><ESC>"vy
  vmap <C-Q> "vgP
endif

if &diff
    color molokai
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

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


" Style adjustment
hi clear MatchParen
hi link MatchParen Title

" All sorts of chars
" ---------------------
"  · ‥ ⁖ ⁘ ⁙ ⁚ ⁛ ⊙ ⋖ ⋗ ⟇ ⟑ ⦑ ⦒ ･ 𐄁
" ➠ ➟ ► ◄ ▻ ◅
" ⌦ ▶ ▷ ▸ ➔ ➡ ➤ ➧ ➲ ➽ ⦊⸩ ⸨ 】【
