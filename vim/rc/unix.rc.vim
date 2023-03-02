"---------------------------------------------------------------------------
" For UNIX:
"

" Use sh.  It is faster
set shell=sh

" Set path.
let $PATH = '~/bin'->expand().':/usr/local/bin/:'.$PATH

if has('gui_running')
  finish
endif

"---------------------------------------------------------------------------
" For CUI:
"

" Enable 256 color terminal.
set t_Co=256

if !has('nvim')
  set term=xterm-256color

  " Change cursor shape.
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[0 q"
endif

" Disable the mouse.
set mouse=
