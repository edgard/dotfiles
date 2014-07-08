"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Bootstrap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" detect running os
let s:is_windows=has('win32') || has('win64')
let s:is_cygwin=has('win32unix')
let s:is_macvim=has('gui_macvim')

 if has('vim_starting')
  set all&
  set nocompatible
  if s:is_windows && !s:is_cygwin
    set runtimepath+=~/vimfiles/bundle/neobundle.vim/
  else
    set runtimepath+=~/.vim/bundle/neobundle.vim/
  endif
 endif

" disable filetype to bootstrap
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cache Dir Management
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" cachedir
if s:is_windows && !s:is_cygwin
  let s:cache_dir='~/vimfiles/cache'
else
  let s:cache_dir='~/.vim/.cache'
endif
function! s:get_cache_dir(suffix)
  return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction

" folder management
if exists('+undofile')
  set undofile
  let &undodir=s:get_cache_dir('undo')
endif
let g:ctrlp_cache_dir=s:get_cache_dir('ctrlp')
let g:neocomplcache_temporary_dir=s:get_cache_dir('neocomplcache')
let g:neosnippet#data_directory=s:get_cache_dir('neosnippet')
call EnsureExists(s:cache_dir)
call EnsureExists(&undodir)
call EnsureExists(g:ctrlp_cache_dir)
call EnsureExists(g:neocomplcache_temporary_dir)
call EnsureExists(g:neosnippet#data_directory)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Script Bundles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" bootstrap neobundle
if s:is_windows && !s:is_cygwin
  call neobundle#begin(expand('~/vimfiles/bundle/'))
else
  call neobundle#begin(expand('~/.vim/bundle/'))
endif
NeoBundleFetch 'Shougo/neobundle.vim'

" bundles
NeoBundle 'Shougo/neocomplcache.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'bling/vim-airline'
NeoBundle 'fisadev/vim-ctrlp-cmdpalette'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'godlygeek/tabular'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mbbill/undotree'
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
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
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
set wildignorecase
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store

set scrolloff=1
set sidescrolloff=5

set list
set listchars=trail:·

if s:is_windows && !s:is_cygwin
  set shell=c:\windows\system32\cmd.exe
elseif $SHELL =~ '/fish$'
  set shell=sh
endif
set noshelltemp

set autoread
set fileformats+=mac

set mouse=a
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

set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline

let mapleader=','
let g:mapleader=','

" gui configuration
if has('gui_running')
  if s:is_macvim
    set guifont=PragmataPro:h14
  elseif s:is_windows && !s:is_cygwin
    set guifont=PragmataPro:h12
  else
    set guifont=PragmataPro\ 12
  end
  if s:is_windows && !s:is_cygwin
    autocmd GUIEnter * simalt ~x
  else
    set lines=999 columns=9999
  endif
  set guioptions+=t
  set guioptions-=r  " remove right scroll bar
  set guioptions-=l  " remove left scroll bar
  set guioptions-=b  " remove bottom scroll bar
  set guioptions-=m  " hide menu bar
  set guioptions-=T  " hide tool bar
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Scripts Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif

" python mode
let g:jedi#popup_on_dot=0
let g:pymode_rope=0

" indent guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=1

" nerdtree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=0
let NERDTreeChDirMode=0
let NERDTreeShowBookmarks=0
let NERDTreeIgnore=['\.git','\.hg']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" fugitive
autocmd BufReadPost fugitive://* set bufhidden=delete

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
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd='CtrlP'
let g:ctrlp_custom_ignore='\.git$\|\.hg$\|\.svn$'
let g:ctrlp_working_path_mode='ra'
let g:ctrlp_switch_buffer='et'
let g:ctrlp_use_caching=1
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_max_files=20000
let g:ctrlp_mruf_max=250
let g:ctrlp_max_height=10
let g:ctrlp_follow_symlinks=1
let g:ctrlp_show_hidden=1

" startify
let g:startify_files_number=10
let g:startify_change_to_dir=1
let g:startify_change_to_vcs_root=1
let g:startify_enable_special=1
autocmd FileType startify setlocal buftype=

" nerdcommenter
let NERDSpaceDelims=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" buffer shortcuts
nnoremap <silent> <leader>n :enew<CR>
nnoremap <silent> <C-W> :bprevious <BAR> bdelete #<CR>
nnoremap <silent> <C-S> :w<CR>
nnoremap <silent> <C-Up> :bnext<CR>
nnoremap <silent> <C-Down> :bprevious<CR>

" mswin style shortcuts
vnoremap <C-X> "+x
vnoremap <S-Del> "+x
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
map <C-V> "+gP
map <S-Insert> "+gP
cmap <C-V> <C-R>+
cmap <S-Insert> <C-R>+
execute 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
execute 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
imap <S-Insert> <C-V>
vmap <S-Insert> <C-V>
noremap <C-Q> <C-V>
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>
noremap <C-Z> u
inoremap <C-Z> <C-O>u
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

" sudo write shortcut
if !s:is_windows && !s:is_macvim
  cmap w!! w !sudo tee % >/dev/null
endif

" disable search highlight
nnoremap <silent> <F10> :nohlsearch<CR>

" startify
nnoremap <silent> <F1> :Startify<CR>

" nerdtree
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F3> :NERDTreeFind<CR>

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

" fugitive
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gr :Gremove<CR>

" ctrlp command palette
nnoremap <silent> <C-O> :CtrlPCmdPalette<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Triggers/Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" go back to previous position of cursor if any
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe 'normal! g`"zvzz' |
  \ endif

" strip trailing whitespaces on save
autocmd BufWritePre * :call StripTrailingWhitespaces()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Finish Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
syntax enable
NeoBundleCheck
