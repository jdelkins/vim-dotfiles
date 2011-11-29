" A lot of these ideas came from:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" Joel D. Elkins <joel@elkins.com>
" 2011-05-25

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Plugin defaults
let g:molokai_original = 1
let g:CommandTScanDotDirectories = 1

syntax on

colorscheme molokai
set nocompatible

set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set nocursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set undofile

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>w <C-w>v<C-w>l

" Note this autocmd is necessary because we are dynamically mapping based on
" whether plugins are installed, which is not knowable normally when .vimrc
" is processed. Workaround is to use a VimEnter hook to do the job later.
autocmd VimEnter * call <SID>dynamic_remaps()
function! s:dynamic_remaps()
	if exists(":Perlbrws")
		nnoremap <leader>d :Perlbrws<cr>
	else
		nnoremap <leader>d :Explore<cr>
	endif
	if exists(":CommandT")
		nnoremap <leader>t :CommandT<cr>
	endif
endfunction

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
