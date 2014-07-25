"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Bootstrap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set all&
set nocompatible
set runtimepath+=~/.vim/bundle/neobundle.vim/

" disable to bootstrap
syntax off
filetype off


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ensureexists
function! EnsureExists(path)
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path))
  endif
endfunction

" strip trailing whitespace on save
function! StripTrailingWhitespaces()
  let l=line('.')
  let c=col('.')
  %s/\s\+$//ge
  call cursor(l, c)
endfunction

" buffer delete function
function! s:CommandW()
  let l:bufcount=len(filter(range(1, bufnr('$')), 'buflisted(v:val) == 1'))
  if l:bufcount == 1
    quitall
  else
    bdelete
  endif
endfunction
command! -bar CommandW call s:CommandW()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cache Dir Management
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" cachedir
let s:cache_dir='~/.vim/.cache'
function! s:get_cache_dir(suffix)
  return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction

" folder management
if exists('+undofile')
  set undofile
  let &undodir=s:get_cache_dir('undo')
endif
let g:ctrlp_cache_dir=s:get_cache_dir('ctrlp')
call EnsureExists(s:cache_dir)
call EnsureExists(&undodir)
call EnsureExists(g:ctrlp_cache_dir)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Script Bundles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" bootstrap neobundle
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" bundles
NeoBundle 'SirVer/ultisnips'
NeoBundle 'Valloric/YouCompleteMe.git', { 'build' : { 'unix' : './install.sh' } }
NeoBundle 'bling/vim-airline'
NeoBundle 'fisadev/vim-ctrlp-cmdpalette'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'godlygeek/tabular'
NeoBundle 'honza/vim-snippets'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mbbill/undotree'
NeoBundle 'mhinz/vim-signify'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'rking/ag.vim'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'terryma/vim-expand-region'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'chase/vim-ansible-yaml'

" finish loading neobundle
call neobundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" misc options
set nobackup
set noswapfile

scriptencoding utf-8
set encoding=utf-8
set nrformats-=octal

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set complete-=i
set smarttab

set autoindent
set copyindent
set shiftround

set backspace=indent,eol,start
set virtualedit=onemore

set ttimeout
set ttimeoutlen=100

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set matchtime=2

set wildmenu
set wildmode=list:full
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store

set scrolloff=1
set sidescrolloff=5

set list
set listchars=trail:·

if $SHELL =~ '/fish$'
  set shell=sh
endif
set noshelltemp

set autoread
set fileformats+=mac

set mousehide
set ttyfast
set lazyredraw
set viewoptions=folds,options,cursor,unix,slash
set laststatus=2
set display+=lastline
set nofoldenable
set ruler
set showcmd
set title
set splitbelow
set splitright
set number
set noshowmode
set nowrap
set linebreak
set hidden
set confirm
set shortmess+=filmnrxoOtT

set noerrorbells visualbell t_vb=

set cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline

let mapleader=','
let g:mapleader=','


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Scripts Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" python mode
let g:jedi#popup_on_dot=0
let g:pymode_rope=0

" indent guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=1

" solarized
set t_Co=16
set background=dark
colorscheme solarized
let g:solarized_termcolors=16
let g:solarized_visibility='low'

" airline
let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'

" ctrlp
let g:ctrlp_map='<D-p>'
let g:ctrlp_cmd='CtrlPMixed'
let g:ctrlp_custom_ignore='\.git$\|\.hg$\|\.svn$'
let g:ctrlp_working_path_mode=0
let g:ctrlp_switch_buffer='e'
let g:ctrlp_use_caching=1
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_max_files=20000
let g:ctrlp_mruf_max=250
let g:ctrlp_max_height=10
let g:ctrlp_follow_symlinks=1
let g:ctrlp_show_hidden=1
let g:ctrlp_match_window='bottom,order:btt,min:1,max:10,results:50'

" startify
let g:startify_files_number=10
let g:startify_change_to_dir=1
let g:startify_change_to_vcs_root=1
let g:startify_enable_special=1
autocmd FileType startify setlocal buftype=

" nerdcommenter
let NERDSpaceDelims=1
let NERDMenuMode=0
let NERDDefaultNesting=0

" nerdtree
let NERDTreeCascadeOpenSingleChildDir=1
let NERDTreeChDirMode=0
let NERDTreeHijackNetrw=1
let NERDTreeMinimalUI=1
let NERDTreeMouseMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeShowBookmarks=0
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git','\.hg','\.svn']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" youcompleteme
let g:ycm_key_list_select_completion=['<C-TAB>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-S-TAB>', '<Up>']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" buffer shortcuts
nmap <silent> <D-w> :CommandW<CR>
imap <silent> <D-w> <Esc>:CommandW<CR>
nmap <silent> <D-n> :enew<CR>
imap <silent> <D-n> <Esc>:enew<CR>
nmap <silent> <D-M-LEFT> :bprevious<CR>
imap <silent> <D-M-LEFT> <Esc>:bprevious<CR>
nmap <silent> <D-M-RIGHT> :bnext<CR>
imap <silent> <D-M-RIGHT> <Esc>:bnext<CR>

" sudo write shortcut
cmap w!! w !sudo tee % >/dev/null

" disable search highlight
nnoremap <silent> <F10> :nohlsearch<CR>

" startify
nnoremap <silent> <F1> :Startify<CR>

" nerdtree
nnoremap <silent> <F2> :NERDTreeToggle<CR>

" undotree
nnoremap <silent> <F5> :UndotreeToggle<CR>

" tabular
nmap <leader>a& :Tabularize /&<CR>
vmap <leader>a& :Tabularize /&<CR>
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:<CR>
vmap <leader>a: :Tabularize /:<CR>
nmap <leader>a:: :Tabularize /:\zs<CR>
vmap <leader>a:: :Tabularize /:\zs<CR>
nmap <leader>a, :Tabularize /,<CR>
vmap <leader>a, :Tabularize /,<CR>
nmap <leader>a<Bar> :Tabularize /<Bar><CR>
vmap <leader>a<Bar> :Tabularize /<Bar><CR>

" ctrlp command palette
nnoremap <silent> <D-o> :CtrlPCmdPalette<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Triggers/Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" go back to previous position of cursor if any, except if git commit
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe 'normal! g`"zvzz' |
  \ endif
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" strip trailing whitespaces on save
autocmd BufWritePre * :call StripTrailingWhitespaces()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Finish Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
filetype on
filetype plugin indent on
NeoBundleCheck
