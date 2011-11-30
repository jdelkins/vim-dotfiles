" A lot of these ideas came from:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" Joel D. Elkins <joel@elkins.com>
" 2011-05-25

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Plugin defaults
let mapleader = ","
let g:sfe_mapLeader = ",s"
let g:molokai_original = 1
let g:CommandTScanDotDirectories = 1
let g:LustyJugglerShowKeys = 'a'

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
set report=25

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
set colorcolumn=+1
hi ColorColumn ctermbg=darkgrey guibg=#3E3D32

nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>w <C-w>v<C-w>l

" Note this autocmd is necessary because we are dynamically mapping based on
" whether plugins are installed, which is not knowable normally when .vimrc
" is processed. Workaround is to use a VimEnter hook to do the job later.
autocmd VimEnter * call <SID>dynamic_file_explorer()
autocmd VimEnter * call <SID>dynamic_buffer_explorer()

" Decide which filebrowser to make the default
function! s:dynamic_file_explorer()
	if exists(":LustyFilesystemExplorerFromHere")
		nnoremap <silent> <leader>d :LustyFilesystemExplorerFromHere<cr>
		" On Windows, due to poor design or a qutoting bug in Lusty, we need
		" to convert backslashes to slashes. For that we use a helper func.
		if exists("+shellslash") && !&shellslash
			command -nargs=? -complete=dir D :call <SID>CallLusty('<args>')
		else
			command -nargs=? -complete=dir D :LustyFilesystemExplorer <args>
		endif
	elseif exists(":Perlbrws")
		nnoremap <silent> <leader>d :Perlbrws<cr>
		command -nargs=? -complete=dir D :Perlbrws <args>
	else
		nnoremap <silent> <leader>d :Explore<cr>
		command -nargs=? -complete=dir D :Explore <args>
	endif
endfunction

" Decide which buffer browser to make the default
function s:dynamic_buffer_explorer()
	if exists(":LustyJuggler")
		nnoremap <silent> <leader>b :LustyJuggler<cr>
		nnoremap <silent> <leader><tab> :LustyJugglePrevious<cr>
	elseif exists(":CommandTBuffer")
		"note that Command-T has a perfectly good buffer browser mapped by
		"default to <leader>b. the <leader><tab> function is replicated here
		nnoremap <silent> <leader><tab> :b#<cr>
	else
		"If both aren't installed, then use :ls
		nnoremap <silent> <leader>b :ls<cr>
		nnoremap <silent> <leader><tab> :b#<cr>
	endif
endfunction

" Helper function to call LustyFilesystemExplorer with a directory-completed
" argument. A little tricky since Lusty (currently) has a little bug that
" doesn't properly escape backslashes. Note that an untested alternative may
" be to use the 'shellslash' option
function! s:CallLusty(dir)
	let l:d = substitute(substitute(a:dir, '\\\(\S\=\)', '/\1', 'g'), '/$', '', '')
	exe ":LustyFilesystemExplorer" l:d
endfunction

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
