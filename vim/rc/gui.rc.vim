"---------------------------------------------------------------------------
" Views:

if has('win32')
  " For Windows.

  " set guifontwide=VL\ Gothic:h11
  " set guifontwide=Ricty:h12

  " set guifont=Ricty:h12
  " set guifont=Courier\ New:h11
  " set guifont=VL\ Gothic:h11
  " set guifont=Consolas:h12
  " set guifont=Inconsolata:h12
  " set guifont=HackGen:h12
  set guifont=Firge:h12

  " Number of pixel lines inserted between characters.
  set linespace=2

  " Use DirectWrite
  "set renderoptions=type:directx

  " Width of window.
  set columns=230
  " Height of window.
  set lines=55
else
  " For Linux.

  set guifontwide=VL\ Gothic\ 13

  "set guifont=Courier\ 10\ Pitch\ 14
  set guifont=monospace\ 14

  if &columns < 170
    " Width of window.
    set columns=170
  endif
  if &lines < 40
    " Height of window.
    set lines=40
  endif
endif

" Don't override colorscheme.
if !('g:colors_name'->exists())
  colorscheme candy
endif

"---------------------------------------------------------------------------
" Options:

set mouse=
set mousemodel=

" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide

" Hide toolbar and menus.
set guioptions-=Tt
set guioptions-=m
" Scrollbar is always off.
set guioptions-=rL
" Not guitablabel.
set guioptions-=e
" Confirm without window.
set guioptions+=c
" set guioptions+=!
" Use dark mode.
set guioptions+=d

" Don't flick cursor.
set guicursor&
set guicursor+=a:blinkon0
