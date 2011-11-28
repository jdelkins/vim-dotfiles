
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

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
"nnoremap <leader>d :silent Explore<cr>
"nnoremap <leader>d :call perlbrws#enter()<cr>
nnoremap <leader>t :CommandT<cr>
