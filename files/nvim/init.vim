" remap leader
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>
let mapleader="\<Space>"

" set python hosts envs
let g:python_host_prog = $HOME.'/.pyenv/versions/nvim2/bin/python'
let g:python3_host_prog = $HOME.'/.pyenv/versions/nvim3/bin/python'

" configuration
set autoindent                                            " indent a new line the same amount as the line just typed
set backspace=indent,eol,start                            " make backspace work properly
set clipboard=unnamed,unnamedplus                         " cross-platform clipboard
set colorcolumn=80                                        " show line limit column
set completeopt=menuone,noselect,noinsert                 " autocomplete options
set cursorline                                            " highlight the current line for the cursor
set encoding=utf-8                                        " default file encoding
set fileformats=unix,dos,mac                              " use unix as the standard file type
set guicursor=                                            " disable changing cursor
set hidden                                                " hide buffers when abandoned instead of unload
set hlsearch                                              " highlight search results
set laststatus=2                                          " make sure status line appears
set list                                                  " show whitespace chars
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:· " whitespace chars to show
set matchtime=1                                           " speed up matching brackets
set mouse=a                                               " enable mouse
set noerrorbells                                          " no bells
set nomodeline                                            " ignore setting options from modelines
set nospell                                               " disable spelling
set noswapfile                                            " disable swapfile usage
set notitle                                               " dont set title, we have everything we need from statusbar
set novisualbell                                          " i said, no bells
set nowrap                                                " dont wrap lines
set number                                                " add line numbers
set relativenumber                                        " show relative numbers
set ruler                                                 " show line/column number on statusline
set shiftround                                            " round indent to multiple of 'shiftwidth'
set shortmess+=c                                          " hide annoying match messages
set showmatch                                             " show matching brackets
set signcolumn=yes                                        " keep signcolumn open all times
set smartindent                                           " enable smart indentation
set splitbelow splitright                                 " splits open bottom right
set timeoutlen=500                                        " smaller timeout for leader/esc
set ttimeoutlen=20                                        " keycode timeout
set updatetime=750                                        " lower screen update time for some plugins
set wildmenu                                              " menu for command line
set wildmode=longest:full,full                            " use tab to go through the menu

" set script encoding
scriptencoding utf-8

" plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'mhinz/vim-signify'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'sickill/vim-pasta'
Plug 'sjl/gundo.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'sheerun/vim-polyglot'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-vim-lsp'
Plug 'w0rp/ale'
Plug 'tpope/vim-sleuth'
call plug#end()

" onedark
set termguicolors
let g:onedark_hide_endofbuffer = 1
colorscheme onedark

" lightline
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'right': [ [ 'lineinfo' ],  [ 'percent' ], [ 'filetype', 'sleuth', 'fileencoding', 'fileformat' ] ]
    \ },
    \ 'component_function': {
    \   'sleuth': 'SleuthIndicator'
    \ },
    \ }

" vim-sleuth
let g:sleuth_automatic = 1

" easy-motion
let g:EasyMotion_do_mapping = 0

" signify
let g:signify_vcs_list = ['git']
let g:signify_sign_show_count = 0
let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_change = '~'

" fzf
let g:fzf_command_prefix = 'Fzf'
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'down': '10' }
let g:fzf_colors = {
    \ 'fg': ['fg', 'Normal'],
    \ 'bg': ['bg', 'Normal'],
    \ 'hl': ['fg', 'Comment'],
    \ 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+': ['fg', 'Statement'],
    \ 'info': ['fg', 'PreProc'],
    \ 'border': ['fg', 'Ignore'],
    \ 'prompt': ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker': ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header': ['fg', 'Comment']
    \ }
function! s:fzf_statusline()
    highlight fzf1 cterm=bold gui=bold ctermfg=black ctermbg=green guifg=#2c323d guibg=#98c379
    highlight fzf2 cterm=bold gui=bold ctermfg=white ctermbg=black guifg=#abb2bf guibg=#2c323d
    setlocal statusline=%#fzf1#\ FZF\ %#fzf2#
endfunction
augroup c_fzf
    autocmd!
    autocmd User FzfStatusLine call <SID>fzf_statusline()
augroup END

" nerdtree
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 0
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeMapChangeRoot = '.'
let g:NERDTreeMapCloseChildren = 'C'
let g:NERDTreeMapCloseDir = 'c'
let g:NERDTreeMapOpenSplit = 'x'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMouseMode = 2
let g:NERDTreeNaturalSort = 1
let g:NERDTreeWinSize = 25
augroup c_nerdtree
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" nerdcommenter
let g:NERDBlockComIgnoreEmpty = 0
let g:NERDCommentEmptyLines = 1
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1
let g:NERDToggleCheckAllLines = 1
let g:NERDTrimTrailingWhitespace = 1

" gundo
set undofile
let g:gundo_help = 0

" polyglot
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1

" vim-lsp
let g:lsp_diagnostics_enabled = 0
let g:lsp_highlight_references_enabled = 0
inoremap <expr> <Plug>(cr_prev) execute('let g:_prev_line = getline(".")')
inoremap <expr> <Plug>(cr_do) (g:_prev_line == getline('.') ? "\<cr>" : "")
inoremap <expr> <Plug>(cr_post) execute('unlet g:_prev_line')
imap <expr> <CR> (pumvisible() ? "\<Plug>(cr_prev)\<C-Y>\<Plug>(cr_do)\<Plug>(cr_post)" : "\<CR>")
augroup c_lsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'pyls']},
        \ 'whitelist': ['python'],
        \ })
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gols',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'gopls -mode stdio']},
        \ 'whitelist': ['go'],
        \ })
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'bashls',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
augroup END

" ncm2
let g:ncm2#complete_delay = 20
let g:ncm2#complete_length = 1
augroup c_ncm2
    autocmd!
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END

" ale
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = '--enable-all --disable=lll'
let g:ale_yaml_yamllint_options = '-d "{extends: default, rules: {line-length: {max: 999}}"'
" let g:ale_python_black_options = '--line-length 999'
" let g:ale_python_yapf_options = '--parallel --in-place --recursive --style="{based_on_style: pep8, column_limit: 999}"'
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:ale_sign_info = '●'
highlight ALEErrorSign ctermfg=9 guifg=#e06c75
highlight ALEWarningSign ctermfg=11 guifg=#e5c07b
highlight ALEInfoSign ctermfg=10 guifg=#98c379
let g:ale_linters = {
    \ 'ansible': ['ansible-lint'],
    \ 'dockerfile': ['hadolint'],
    \ 'go': ['golangci-lint'],
    \ 'json': ['jsonlint'],
    \ 'python': ['bandit', 'pylint'],
    \ 'sh': ['shellcheck'],
    \ 'terraform': ['tflint'],
    \ 'vim': ['vint'],
    \ 'yaml': ['yamllint'],
    \ }
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'go': ['goimports'],
    \ 'json': ['fixjson', 'prettier', 'jq'],
    \ 'python': ['isort', 'yapf', 'black'],
    \ 'sh': ['shfmt'],
    \ 'terraform': ['terraform'],
    \ 'yaml': ['prettier'],
    \ }
command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"

" keybindings
nnoremap Y y$
xnoremap > >gv
xnoremap < <gv

nnoremap <silent> <C-a> ^
xnoremap <silent> <C-a> ^
nnoremap <silent> <C-e> $
xnoremap <silent> <C-e> $
inoremap <silent> <C-a> <Esc>^i
inoremap <silent> <C-e> <Esc>$i

nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>i
nnoremap <silent> <C-d> :xa!<CR>
inoremap <silent> <C-d> <Esc>:xa!<CR>i

nnoremap <silent> <C-k> d$
xnoremap <silent> <C-k> d$
inoremap <silent> <C-k> <Esc>d$i

nnoremap <silent> <C-Right> <C-w>l
nnoremap <silent> <C-Left> <C-w>h
nnoremap <silent> <C-Up> <C-w>k
nnoremap <silent> <C-Down> <C-w>j

" leader mappings
let g:which_key_map = {}
call which_key#register('<Space>', 'g:which_key_map')
nnoremap <silent> <Leader> :<C-u>WhichKey '<Space>'<CR>

nnoremap <silent> <Leader>ta :ALEToggleFixer<CR>:echo 'ALE Fixer is' get(g:, 'ale_fix_on_save', 0) ? 'enabled' : 'disabled'<CR>
nnoremap <silent> <Leader>tc :setlocal spell!<CR>
nnoremap <silent> <expr> <Leader>th (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
nnoremap <silent> <Leader>tl :setlocal nolist!<CR>
nnoremap <silent> <Leader>tn :setlocal nonumber! norelativenumber!<CR>
nnoremap <silent> <expr> <Leader>ts (&signcolumn == 'yes' ? ':set signcolumn=no' : ':set signcolumn=yes')."\n"
nnoremap <silent> <Leader>tw :setlocal wrap! breakindent!<CR>
let g:which_key_map['t'] = {
    \ 'name': '+toggle',
    \ 'a': 'ale-fixers',
    \ 'c': 'spell-checker',
    \ 'h': 'highlight-search',
    \ 'l': 'hidden-chars',
    \ 'n': 'line-numbers',
    \ 's': 'sign-column',
    \ 'w': 'line-wrap',
    \ }

nnoremap <silent> <Leader>qc :cclose<CR>
nnoremap <silent> <Leader>qn :cnext<CR>
nnoremap <silent> <Leader>qo :copen<CR>
nnoremap <silent> <Leader>qp :cprevious<CR>
nnoremap <silent> <Leader>qr :crewind<CR>
let g:which_key_map['q'] = {
    \ 'name': '+quickfix',
    \ 'c': 'close-window',
    \ 'n': 'next-message',
    \ 'o': 'open-window',
    \ 'p': 'previous-message',
    \ 'r': 'rewind-messages',
    \ }

nmap <Leader>ct <Plug>NERDCommenterToggle
xmap <Leader>ct <Plug>NERDCommenterToggle
let g:which_key_map['c'] = {
    \ 'name': '+comment',
    \ '$': 'comment-to-eol',
    \ 'A': 'comment-append',
    \ 'a': 'alt-delimiters',
    \ 'b': 'comment-both-aligned',
    \ 'c': 'comment-line',
    \ 'i': 'comment-invert',
    \ 'l': 'comment-left-aligned',
    \ 'm': 'comment-minimal',
    \ 'n': 'comment-nested',
    \ 's': 'comment-sexy',
    \ 't': 'toggle-comment',
    \ 'u': 'uncomment',
    \ 'y': 'comment-yank',
    \ }

nnoremap <silent> <Leader>fd :NERDTreeToggle<CR>
nnoremap <silent> <Leader>fo :FzfFiles<CR>
nnoremap <silent> <Leader>fr :FzfHistory<CR>
let g:which_key_map['f'] = {
    \ 'name': '+file',
    \ 'd': 'drawer-toggle',
    \ 'o': 'open-file',
    \ 'r': 'recent-files'
    \ }

nnoremap <silent> <Leader>bb :enew<CR>
nnoremap <silent> <Leader>bc :bdelete<CR>
nnoremap <silent> <Leader>bn :bnext<CR>
nnoremap <silent> <Leader>bo :FzfBuffers<CR>
nnoremap <silent> <Leader>bp :bprevious<CR>
nnoremap <silent> <Leader>bu :GundoToggle<CR>
nnoremap <silent> <Leader>bv :vnew<CR>
nnoremap <silent> <Leader>bw :bwipeout<CR>
nnoremap <silent> <Leader>bx :new<CR>
let g:which_key_map['b'] = {
    \ 'name': '+buffer',
    \ 'b': 'create-new',
    \ 'c': 'close',
    \ 'n': 'next',
    \ 'o': 'open-list',
    \ 'p': 'previous',
    \ 'u': 'undo-tree',
    \ 'v': 'create-new-vertical',
    \ 'w': 'wipeout',
    \ 'x': 'create-new-horizontal'
    \ }

nnoremap <silent> <Leader>a= :Tabularize /=<CR>
xnoremap <silent> <Leader>a= :Tabularize /=<CR>
nnoremap <silent> <Leader>a: :Tabularize /:\zs/l0l1<CR>
xnoremap <silent> <Leader>a: :Tabularize /:\zs/l0l1<CR>
nnoremap <silent> <Leader>a; :Tabularize /;<CR>
xnoremap <silent> <Leader>a; :Tabularize /;<CR>
let g:which_key_map['a'] = {
    \ 'name': '+align' ,
    \ '=': 'align-equal',
    \ ':': 'align-colon',
    \ ';': 'align-semicolon',
    \ }

nmap <nowait> <Leader><Leader> <Plug>(easymotion-bd-w)
xmap <nowait> <Leader><Leader> <Plug>(easymotion-bd-w)
let g:which_key_map[' '] = 'easy-motion-word'

nnoremap <silent> <Leader>ld :LspDefinition<CR>
nnoremap <silent> <Leader>lh :LspHover<CR>
nnoremap <silent> <Leader>li :LspImplementation<CR>
nnoremap <silent> <Leader>lr :LspReferences<CR>
nnoremap <silent> <Leader>lt :LspTypeDefinition<CR>
let g:which_key_map['l'] = {
    \ 'name': '+language-server' ,
    \ 'd': 'definition',
    \ 'h': 'hover',
    \ 'i': 'implementation',
    \ 'r': 'references',
    \ 't': 'type-definition'
    \ }

nnoremap <silent> <LeadeR>sh :FzfHistory/<CR>
nnoremap <silent> <Leader>sc :FzfHistory:<CR>
nnoremap <silent> <Leader>sf :FzfRg<CR>
nnoremap <silent> <Leader>sl :FzfBLines<CR>
let g:which_key_map['s'] = {
    \ 'name': '+search' ,
    \ 'c': 'command-history',
    \ 'f': 'inside-files',
    \ 'h': 'search-history',
    \ 'l': 'lines-in-buffer'
    \ }
