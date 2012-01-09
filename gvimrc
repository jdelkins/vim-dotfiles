" What:   My gvimrc
" Author: Joel D. Elkins <joel@elkins.com>

" Appearance
set columns=132
set lines=50

" Default font choice
if has("gui_win32")
  "set gfn=DejaVu_Sans_Mono:h9:cANSI
  set gfn=Envy_Code_R:h10:cANSI
elseif has("gui_gtk2")
  set gfn=Envy\ Code\ R\ 10
elseif has("gui_macvim")
  set gfn=Envy\ Code\ R:h13
endif
