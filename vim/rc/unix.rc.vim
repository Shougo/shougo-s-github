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
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[0 q"

  " IME control
  " NOTE: Tera Term and mintty supports it.
  let &t_EI .= "\e[<0t"
endif

" Disable the mouse.
set mouse=
