let mapleader=","
scriptencoding utf-8
call plug#begin("~/.local/share/nvim/plugged")


  "{{{ Plugins for common purposes
  Plug 'nvim-treesitter/nvim-treesitter'
  "}}}

  "{{{ Plugins for color schemes
  Plug 'ayu-theme/ayu-vim'
  let ayucolor="dark"
  Plug 'drewtempelmeyer/palenight.vim'
  Plug 'jacoborus/tender.vim'
  Plug 'zeis/vim-kolor'
  Plug 'kiddos/malokai.vim'
  Plug 'kyoz/purify', { 'rtp': 'vim' }
  let g:purify_italic = 0      " default: 1
  let g:purify_inverse = 0     " default: 1
  Plug 'rafalbromirski/vim-aurora'
  Plug 'catppuccin/nvim'
  "}}}

  "{{{ Plugins for coding
  Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'

  " nvim-cmp suite
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  Plug 'ray-x/lsp_signature.nvim'

  Plug 'lukas-reineke/indent-blankline.nvim'




  "Plug 'dense-analysis/ale'
  "let g:ale_completion_enabled = 0

  "}}}

  "{{{ Plugins for file explorer
  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua'
  let g:nvim_tree_side = 'left' "left by default
  let g:nvim_tree_width = 40 "30 by default
  let g:nvim_tree_quit_on_open = 0 "0 by default, closes the tree when you open a file
  let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
  let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
  let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
  let g:nvim_tree_width_allow_resize  = 1 "0 by default, will not resize the tree when opening a file
  let g:nvim_tree_show_icons = {
      \ 'git': 1,
      \ 'folders': 1,
      \ 'files': 1,
      \ }
  "If 0, do not show the icons for one of 'git' 'folder' and 'files'
  "1 by default, notice that if 'files' is 1, it will only display
  "if nvim-web-devicons is installed and on your runtimepath

  " default will show icon by default if no icon is provided
  " default shows no icon by default
  let g:nvim_tree_icons = {
      \ 'default': "",
      \ 'symlink': "⇢",
      \ 'git': {
      \   'unstaged': "✗",
      \   'staged': "✓",
      \   'unmerged': "",
      \   'renamed': "➜",
      \   'untracked': "★"
      \   },
      \ 'folder': {
      \   'default': "◗",
      \   'open': "◠",
      \   'symlink': "↪",
      \   }
      \ }

  nnoremap <C-n> :NvimTreeToggle<CR>
  nnoremap <leader>r :NvimTreeRefresh<CR>
  nnoremap <leader>n :NvimTreeFindFile<CR>
  " NvimTreeOpen and NvimTreeClose are also available if you need them

  set termguicolors " this variable must be enabled for colors to be applied properly

  " a list of groups can be found at `:help nvim_tree_highlight`
  highlight NvimTreeFolderIcon guibg=blue




  "}}}

  "{{{ Plugin FZF
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  set rtp+=/usr/local/opt/fzf
  Plug 'junegunn/fzf.vim'
  let g:fzf_preview_window = 'down:30%'
  noremap <silent> <C-P> :Files<CR>
  noremap <silent> <leader>mru :FZFMru<CR>
  noremap <silent> <leader>his :Hist<CR>
  noremap <silent> <leader>b :Buffers<CR>
  let $FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS . ' --bind "alt-a:select-all,alt-d:deselect-all"'


  command! FZFMru call fzf#run({
  \ 'source':  reverse(s:all_files()),
  \ 'window':  'call FloatingFZF()',
  \ 'sink':    'edit',
  \ 'options': '-m -x +s'})

  function! s:all_files()
    return extend(
    \ filter(copy(v:oldfiles),
    \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
    \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
  endfunction

  " Using floating windows of Neovim to start fzf
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,0'

  function! FloatingFZF()
    let width = float2nr(&columns * 0.9)
    let height = float2nr(&lines * 0.6)
    let opts = { 'relative': 'editor',
               \ 'row': 0,
               \ 'col': (&columns - width),
               \ 'width': width,
               \ 'height': height }

    let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
  endfunction

  let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! s:get_registers() abort
  redir => l:regs
  silent registers
  redir END

  return split(l:regs, '\n')[1:]
endfunction

function! s:registers(...) abort
  let l:opts = {
        \ 'source': s:get_registers(),
        \ 'sink': {x -> feedkeys(matchstr(x, '\v^\S+\ze.*') . (a:1 ? 'P' : 'p'), 'x')},
        \ 'options': '--prompt="Reg> "'
        \ }
  call fzf#run(fzf#wrap(l:opts))
endfunction

command! -bang Registers call s:registers('<bang>' ==# '!')

  " git grep
  command! -bang -nargs=* GGrep
              \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)
  command! -bang -nargs=* Rg
              \ call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
  autocmd VimEnter * command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, {'options': '--no-preview'}, <bang>0)


  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

  function! s:ag_with_opts(arg, bang)
    let tokens  = split(a:arg)
    let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
    let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
    call fzf#vim#ag(query, ag_opts, a:bang ? {} : {'down': '40%'})
  endfunction
  autocmd VimEnter * command! -nargs=* -bang Ag call s:ag_with_opts(<q-args>, <bang>0)
  "nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
  nnoremap <silent> <Leader>ag :Ag <CR>
  vnoremap <silent> <leader>ag "zy :Ag <C-R>z<CR>
  nnoremap <silent> <Leader>t :Windows<CR>
  "}}}

"{{{ Plugins for menu/window etc.
Plug 'skywind3000/vim-quickui'
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'gruvbox'
let g:context_menu_k = [
			\ ["&Find", 'exec "Ack " . expand("<cword>")'],
			\ ["&Strip trailing whitespace", 'call StripTrailingWhitespaces()'],
			\ [ "--", ],
			\ ['Go to &definition',  'exec "ALEGoToDefinition"'],
			\ ['F&ind references',  'exec "ALEFindReferences"'],
			\ ['&Hover',  'exec "ALEHover"'],
			\ [ "--", ],
			\ ['Copy &relative path',  'exec "let @*=expand(\"%\")"'],
			\ ['Copy &filename',  'exec "let @*=expand(\"%:t\")"'],
			\ [ "--", ],
			\ ['S&ource init.vim',  'exec "source ~/.config/nvim/init.vim"'],
			\ ]
noremap <silent> <leader><leader>b :call quickui#tools#list_buffer('e')<CR>
noremap <silent> <leader><leader>t :call quickui#tools#list_buffer('tabedit')<CR>
nnoremap <silent> <leader><leader>m :call quickui#tools#clever_context('k', g:context_menu_k, {})<CR>


Plug 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

Plug 'MunifTanjim/nui.nvim'
Plug 'VonHeikemen/searchbox.nvim'

"Plug 'fatih/vim-go'

"}}}

"{{{ Plugins for find & replace
  Plug 'wincent/ferret'
  let g:FerretNvim=1
  let g:FerretHlsearch=1
"}}}

"{{{ Terminal
  set hidden
  Plug 'akinsho/toggleterm.nvim'
"}}}

"{{{ Plugins for other visual tweaks
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'

  let g:lightline = {
      \ 'colorscheme': 'catppuccin',
      \ 'separator': { 'left': "\ue0b8", 'right': "\ue0be" },
      \ 'subseparator': { 'left': "\ue0b9", 'right': "\ue0b9" },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }
  let g:lightline#bufferline#show_number=2
  let g:lightline#bufferline#number_map = {
        \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
        \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}
  set showtabline=2

  Plug 'frazrepo/vim-rainbow'
  let g:rainbow_active = 1
"}}}

call plug#end()

lua require("init")


function! g:StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

set termguicolors
set background=dark
colorscheme catppuccin
set encoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1


set clipboard=unnamed
set showbreak=↪\
set list
set listchars=tab:│\ ,trail:·,nbsp:␣,extends:⟩,precedes:⟨
set fillchars=vert:┃ "
set mouse=a
set number
set lbr
set expandtab
set ts=4
set shiftwidth=4
set softtabstop=4
syntax on

nmap j gj
nmap k gk
vmap j gj
vmap k gk

map <c-h> gT
map <c-l> gt
" use SHIFT-SPACE and CTRL-SHIFT-SPACE to switch buffer
nnoremap  <silent>   <C-Space>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <M-Space>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
" Close buffer without losing split/window
nmap <leader><leader>d :ene<CR>:bw #<CR>:bp<CR>
" current time
cmap timestr "=strftime(" %Y/%m/%d %H:%M:%S ")<CR>P
" switch to last buffer
nmap <silent> ` :e #<CR>
" get rid of trailing spaces
map <silent> gc :%s/\s\+$//e<CR>
" enter/leave paste mode.
map gp :set invpaste<CR>:set paste?<CR>
" Browse current file directory
command! -nargs=0 E :e %:p:h
" Browse current file directory in a new tab
command! -nargs=0 B :tabnew %:p:h


" Use TAB for completion
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

"inoremap <tab> <c-r>=InsertTabWrapper()<cr>

"inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


" for netrw
let g:netrw_sort_sequence     = '[\/]$,*'
let g:netrw_list_hide = '.*\.fuse_hidden'
let g:netrw_liststyle=3
let g:netrw_winsize=20
let g:netrw_wiw=30
" Check file change
au CursorHold * checktime

au BufRead,BufNewFile *.mwyml set filetype=yaml
au BufWritePre *.vim :call StripTrailingWhitespaces()

" Copy current file name (relative/absolute) to system clipboard
if has("mac") || has("gui_macvim") || has("gui_mac")
  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @*=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cF :let @*=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>ct :let @*=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @*=expand("%:p:h")<CR>
endif

"{{{ Adjustment for GUI
" Copy current file name (relative/absolute) to system clipboard (Linux version)
if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
  " relative path (src/foo.txt)
  nnoremap <leader>cf :let @+=expand("%")<CR>

  " absolute path (/something/src/foo.txt)
  nnoremap <leader>cF :let @+=expand("%:p")<CR>

  " filename (foo.txt)
  nnoremap <leader>ct :let @+=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @+=expand("%:p:h")<CR>
endif
"}}}

map <leader>r :source ~/.config/nvim/init.vim<CR>

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled=0


set completeopt=menu,menuone,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

lua << EOF


local nvim_lsp = require('lspconfig')
--nvim_lsp.pyright.setup{
--    python = {
--        pythonPath = '/Users/yi/.pyenvs/python3/bin/python3'
--    }
--}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

cfg = {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
               -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10, -- only show one line of comment set to 0 if you do not want API comments be shown

  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ",  -- Panda for parameter
  hint_scheme = "String",
  use_lspsaga = false,  -- set to true if you want to use lspsaga popup
  handler_opts = {
    border = "double"   -- double, single, shadow, none
  },
  decorator = {"`", "`"}  -- or decorator = {"***", "***"}  decorator = {"**", "**"} see markdown help

}

require'lsp_signature'.on_attach(cfg)

require("nvim-web-devicons").set_icon {
  txt = {
    icon = "☰",
    color = "#428850",
    cterm_color = "65",
    name = "Text"
  },
  cfg = {
    icon = "⚒",
    color = "#428850",
    cterm_color = "65",
    name = "Config"
  },
  lua = {
    icon = "☾",
    color = "#428850",
    cterm_color = "65",
    name = "Lua"
  },
  [".gitattributes"] = {
    icon = "⎇",
    color = "#41535b",
    cterm_color = "59",
    name = "GitConfig",
  },
  [".gitmodules"] = {
    icon = "⎇",
    color = "#41535b",
    cterm_color = "59",
    name = "GitConfig",
  },
  [".gitignore"] = {
    icon = "⎇",
    color = "#41535b",
    cterm_color = "59",
    name = "GitConfig",
  },
}

require'nvim-tree'.setup {
disable_netrw       = true,
hijack_netrw        = true,
open_on_setup       = false,
ignore_ft_on_setup  = {},
update_to_buf_dir   = {
  enable = true,
  auto_open = true,
},
auto_close          = false,
open_on_tab         = false,
hijack_cursor       = false,
update_cwd          = false,
diagnostics         = {
  enable = false,
  icons = {
    hint = "",
    info = "",
    warning = "",
    error = "",
  }
},
update_focused_file = {
  enable      = false,
  update_cwd  = false,
  ignore_list = {}
},
system_open = {
  cmd  = nil,
  args = {}
},
view = {
  width = 30,
  height = 30,
  side = 'left',
  auto_resize = false,
  mappings = {
    custom_only = false,
    list = {}
  }
}
}


-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "jedi_language_server", "gopls"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

-- Setup nvim-cmp.
local cmp = require('cmp')

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
  end,
},
mapping = {
  ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
  }),
  ['<Tab>'] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  })
},
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['gopls'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach()
    end,
}
require('lspconfig')['jedi_language_server'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach()
    end,
}

-- Setup toggleterm
require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = "3", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = "curved",
    width = 100,
    height = 30,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}



EOF


" vim: ft=vim fdm=marker
