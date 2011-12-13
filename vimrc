" What:   My vimrc file
" Author: Joel D. Elkins <joel@elkins.com>
"
" References:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"------------------------------------------------------------------------------
" PATHOGEN                                                                 {{{1
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

"---------------------------------------------------------------------------}}}
" PLUGIN CONFIGURATION                                                     {{{1
let mapleader = ","
let g:sfe_mapLeader = ",s"
let g:molokai_original = 1
let g:CommandTScanDotDirectories = 1
let g:LustyJugglerShowKeys = 'a'
let g:sfe_gitLogOption = '-1000 --all --graph --date=short --pretty=format:"%h %ad | %s%d [%an]"'

"---------------------------------------------------------------------------}}}
" VIM SETTINGS                                                             {{{1
"  - TTY settings                                                          {{{2

if $TERM =~# 'screen\|xterm'
  " Almost always I am using putty (or gvim), which well supports 256 colors
  " The termcap is not accurate by default on my systems... so be it
  set t_Co=256
endif
set   ttyfast

"  - Colors                                                                {{{2

syntax on
autocmd ColorScheme * hi ColorColumn ctermbg=234 guibg=#3B3A32
colorscheme vividchalk
set nocompatible

"  - Tabulation                                                            {{{2

"  Non filetype specific defaults
set   tabstop=8
set   shiftwidth=8
set   softtabstop=0
set noexpandtab
" Preferences for various file types
augroup rubytab
  autocmd!
  autocmd BufEnter *.rb setlocal ts=2
  autocmd BufEnter *.rb setlocal sw=2
  autocmd BufEnter *.rb setlocal sts=2
  autocmd BufEnter *.rb setlocal expandtab
augroup END
augroup vimtab
  autocmd!
  autocmd BufEnter {*.vim,*vimrc,$MYVIMRC,$MYGVIMRC} setlocal ts=8
  autocmd BufEnter {*.vim,*vimrc,$MYVIMRC,$MYGVIMRC} setlocal sw=2
  autocmd BufEnter {*.vim,*vimrc,$MYVIMRC,$MYGVIMRC} setlocal sts=2
  autocmd BufEnter {*.vim,*vimrc,$MYVIMRC,$MYGVIMRC} setlocal noexpandtab
augroup END

" - Indendation and wrapping                                               {{{2

set   backspace=indent,eol,start
set   autoindent
set   wrap
set   textwidth=79
" Note: use 'set fo+=t' to enable wrapping of text. "c" does this for comments.
" See :help fo-table
set   formatoptions=qrn1ac

"  - Window Layout                                                         {{{2

set   scrolloff=3
set   visualbell
set   showmode
set   showcmd
set   report=2
if exists("&colorcolumn") " requires 7.3
  set colorcolumn=+1
endif
" Statuline configuration
set   ruler
set   laststatus=2
set   statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

"  - Editor behavior and features                                          {{{2

set   encoding=utf-8
set   hidden
set   wildmenu
set   wildmode=list:longest
set nocursorline
if exists("&relativenumber") " requires 7.3
  set relativenumber
endif
if exists("&undofile") " requires 7.3
  " I want undofile on by default unless the file is being controlled by SCM,
  " in which case the feature is much less useful, and possibly harmful
  " (considering it oculd have been edited in another repository).
  set undofile
  " turn it off if a .git or .hg directory is found above in the path
  autocmd BufEnter * call <SID>NoUndofileIfSCM(expand("<afile>"))
  function! s:NoUndofileIfSCM(targ)
    let dir = fnamemodify(a:targ, ":p:h")
    try
      if      sfe#findParentDirIncludingDir(dir, ".git") != '' || 
	    \ sfe#findParentDirIncludingDir(dir, ".hg")  != ''
	setlocal noundofile
      endif
    catch /E117/
      " We get here if the scmfrontend package is not installed
      if          isdirectory(dir . '/.git') ||      isdirectory(dir . '/.hg') ||
           \    isdirectory(dir . '../.git') ||    isdirectory(dir . '../.hg') ||
           \ isdirectory(dir . '../../.git') || isdirectory(dir . '../../.hg')
	setlocal noundofile
      endif
    endtry
  endfunction
endif

"  - Searching                                                             {{{2

nnoremap / /\v
vnoremap / /\v
set   ignorecase
set   smartcase
set   gdefault
set   incsearch
set   showmatch
set   hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

"  - Convenience maps                                                      {{{2

" Edit vimrc
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>w <C-w>v<C-w>l
" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Folding
nnoremap Z za

"---------------------------------------------------------------------------}}}
" FILE AND BUFFER EXPLORER                                                 {{{1

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
function! s:dynamic_buffer_explorer()
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

"---------------------------------------------------------------------------}}}
" SMALL SCRIPTS                                                            {{{1
"   This section is for small scripts that don't really warrant being a plugin

"   - PadToMark                                                            {{{2
" Utility function to line up tabular info. Pass in a mark name (e.g. "'a")
" and this will insert spaces to align the insertion point to the mark's
" virtcol (visual alignment, not byte alignment). Nothing happens if the
" point is to the right of the mark.
function! PadToMark(mk)
  let goal = virtcol(a:mk)
  let cur = virtcol(".")
  let dif = goal - cur
  if dif > 0
    exe "normal ".dif."i \e"
  endif
endfunction

" Create a series of maps ta, tb, ..., tz (one for each buffer-local mark)
" to call PadToMark with the corresponding mark name
" Usage is to put cursor on target column and define a mark with, e.g., ma.
" Then use, e.g., ta to tabulate other data to that mark position.
for m in range(26)
  let c = nr2char(char2nr('a') + m)
  exe 'nnoremap <silent> t' . c . " :call PadToMark(\"'" . c . '")<cr>'
endfor

" vim:fdm=marker:ai
