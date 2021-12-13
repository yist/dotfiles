let mapleader=","
scriptencoding utf-8

set termguicolors
set encoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1


set clipboard=unnamed
nnoremap <leader><leader> :b#<CR>
set showbreak=↪\ 
set list
set listchars=tab:│\ ,trail:·,nbsp:␣,extends:⟩,precedes:⟨
set mouse=a
set number
set lbr
syntax on

nmap j gj
nmap k gk
vmap j gj
vmap k gk

nmap <silent> ` :e #<CR>
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


au BufRead,BufNewFile *.mwyml set filetype=yaml


set fillchars=vert:┃ "

" vim: ft=vim fdm=marker
