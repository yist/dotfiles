set nocompatible
set backupdir=$HOME/.backup//
set directory=$HOME/.backup//
" Learder key
let mapleader=","


"-------------------------------------------------------------------------
" Package Management
"-------------------------------------------------------------------------
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
command! PackUpdate packadd minpac | call minpac#update()
command! PackClean  packadd minpac | call minpac#clean()

call minpac#add('yist/vim-style')

call minpac#add('bling/vim-airline')

call minpac#add('Valloric/YouCompleteMe')
let g:ycm_python_binary_path = 'python'

call minpac#add('Valloric/ListToggle')
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

call minpac#add('junegunn/fzf')

call minpac#add('junegunn/fzf.vim')
set rtp+=/usr/local/opt/fzf
noremap <silent> <C-P> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~30%' }
" git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* Ag call fzf#run({
\ 'source':  printf('ag --nogroup --column --color "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
vnoremap <silent> <leader>ag "zy :Ag <C-R>z<CR>


call minpac#add('Chiel92/vim-autoformat')
let g:formatters_python = ['yapf']
let g:formatdef_yapf = "'yapf --lines '.a:firstline.'-'.a:lastline"
noremap ,f :Autoformat<CR>

call minpac#add('davidhalter/jedi-vim')

call minpac#add('Vimjas/vim-python-pep8-indent')

call minpac#add('tmhedberg/SimpylFold')

call minpac#add('jlanzarotta/bufexplorer')

call minpac#add('w0rp/ale')
let g:ale_linters = {
\   'python': ['flake8'],
\}
let g:ale_python_yapf_executable='yapf'
let g:ale_python_yapf_use_global=1
let g:ale_lint_on_save = 0
let g:ale_lint_on_text_changed = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '▷'
let g:ale_sign_warning = '⁛'

call minpac#add('jgdavey/tslime.vim')
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
vmap <silent> <Leader><CR> <Plug>SendSelectionToTmux
nmap <silent> <Leader>rv <Plug>SetTmuxVars

call minpac#add('eshion/vim-sync')

hi clear
set termguicolors
colo smyck


" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"-------------------------------------------------------------------------
" Other configuraion
"-------------------------------------------------------------------------
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
au FileType qf setlocal wrap linebreak
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

autocmd FileType python setlocal fdm=indent completeopt-=preview sw=4 tw=100 |
    \ let &cc=101
autocmd FileType cpp setlocal completeopt-=preview sw=2 tw=80 |
    \ let &cc=81

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
  vmap <C-Q> "vgP
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

" All sorts of chars
" ---------------------
"  · ‥ ⁖ ⁘ ⁙ ⁚ ⁛ ⊙ ⋖ ⋗ ⟇ ⟑ ⦑ ⦒ ･ 𐄁
" ➠ ➟ ► ◄ ▻ ◅
" ⌦ ▶ ▷ ▸ ➔ ➡ ➤ ➧ ➲ ➽ ⦊⸩ ⸨ 】【
