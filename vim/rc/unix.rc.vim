"---------------------------------------------------------------------------
" For UNIX:
"

" Use sh.  It is faster
set shell=sh

" Set path.
let $PATH = '~/bin'->expand().':/usr/local/bin/:'.$PATH

"---------------------------------------------------------------------------
" For CUI:
"

if !has('gui_running')
  " Disable the mouse.
  set mouse=
endif

if !has('gui_running') && !has('nvim')
  " Enable 256 color terminal.
  set t_Co=256

  set term=xterm-256color

  " Change cursor shape.
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[0 q"

  " For non xterm
  "let &t_SI = "\e]50;CursorShape=1\x07"
  "let &t_EI = "\e]50;CursorShape=0\x07"

  " Change cursor color.
  let &t_SC = "\e]12;"
  let &t_EC = "\x07"

  " IME control
  " NOTE: Tera Term and mintty supports it.
  "let &t_EI .= "\e[<0t"
endif
