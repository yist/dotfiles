" Packages

call minpac#add('yist/vim-style')

call minpac#add('bling/vim-airline')
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 0
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

call minpac#add('prabirshrestha/async.vim')
call minpac#add('prabirshrestha/vim-lsp')
call minpac#add('ryanolsonx/vim-lsp-python')
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}},
                \ })
endif
call minpac#add('prabirshrestha/asyncomplete.vim')
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_remove_duplicates = 1
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
call minpac#add('prabirshrestha/asyncomplete-lsp.vim')

"call minpac#add('Valloric/YouCompleteMe')
"let g:ycm_python_binary_path = 'python'

"call minpac#add('lifepillar/vim-mucomplete')
"set completeopt-=preview
"set completeopt+=menuone,noinsert
"let g:mucomplete#enable_auto_at_startup = 1
"let g:mucomplete#delayed_completion = 1
"let g:mucomplete#always_use_completeopt = 1
"" For python
"let g:jedi#popup_on_dot = 1  " It may be 1 as well
"" For C++
"let g:clang_library_path = '/usr/local/opt/llvm/lib/libclang.dylib'
"let g:clang_user_options = '-std=c++14'
"let g:clang_complete_auto = 1

"call minpac#add('artur-shaik/vim-javacomplete2')


call minpac#add('Valloric/ListToggle')
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

call minpac#add('junegunn/fzf')

call minpac#add('junegunn/fzf.vim')
set rtp+=/usr/local/opt/fzf
noremap <silent> <C-P> :FZF<CR>
noremap <silent> <leader>fb :Buffers<CR>
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

command! -bang -nargs=* Ag
            \ call fzf#vim#ag_raw('--hidden --nogroup --color ' . <q-args>,
            \                 <bang>0 ? fzf#vim#with_preview('up:60%')
            \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
            \                 <bang>0)
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
vnoremap <silent> <leader>ag "zy :Ag <C-R>z<CR>


call minpac#add('Chiel92/vim-autoformat')
let g:formatters_python = ['black']
let g:formatdef_black = '"black -q --line-length=100 --skip-string-normalization --py36 ".(&textwidth ? "-l".&textwidth : "")." -"'
noremap ,f :Autoformat<CR>


"call minpac#add('davidhalter/jedi-vim')

"call minpac#add('Vimjas/vim-python-pep8-indent')

call minpac#add('tmhedberg/SimpylFold')

call minpac#add('jlanzarotta/bufexplorer')

call minpac#add('w0rp/ale')
let g:ale_linters = {
            \   'python': ['black'],
            \}
let g:ale_python_yapf_executable='yapf'
let g:ale_python_yapf_use_global=1
let g:ale_python_black_use_global=1
let g:ale_python_black_options='--line-length=100 --skip-string-normalization --py36'
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '-⦒'
let g:ale_sign_warning = '▸▸'

call minpac#add('jgdavey/tslime.vim')
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
vmap <silent> <Leader><CR> <Plug>SendSelectionToTmux
nmap <silent> <Leader>rv <Plug>SetTmuxVars

call minpac#add('fatih/vim-go')
let g:go_metalinter_autosave = 0
let g:go_list_autoclose = 1

"call minpac#add('eshion/vim-sync')

call minpac#add('airblade/vim-gitgutter')

call minpac#add('yuttie/hydrangea-vim')
