"---------------------------------------------------------------------------
" For UNIX:
"

" Use sh.  It is faster
set shell=sh

" Set path.
let $PATH = expand('~/bin').':/usr/local/bin/:'.$PATH

let g:terminal_ansi_colors = [
      \ '#6c6c6c', '#ff6666', '#66ff66', '#ffd30a',
      \ '#1e95fd', '#ff13ff', '#1bc8c8', '#c0c0c0',
      \ '#383838', '#ff4444', '#44ff44', '#ffb30a',
      \ '#6699ff', '#f820ff', '#4ae2e2', '#ffffff',
      \ ]

if has('gui_running')
  finish
endif

"---------------------------------------------------------------------------
" For CUI:
"

" Enable 256 color terminal.
set t_Co=256

if has('nvim')
  " Set terminal colors
  let s:num = 0
  for s:color in g:terminal_ansi_colors
    let g:terminal_color_{s:num} = s:color
    let s:num += 1
  endfor
  unlet! s:num
  unlet! s:color
else
  set term=xterm-256color

  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function! s:XTermPasteBegin(ret) abort
    setlocal paste
    return a:ret
  endfunction

  noremap <special> <expr> <Esc>[200~ s:XTermPasteBegin('0i')
  inoremap <special> <expr> <Esc>[200~ s:XTermPasteBegin('')
  cnoremap <special> <Esc>[200~ <nop>
  cnoremap <special> <Esc>[201~ <nop>

  " Optimize vertical split.
  " Note: Newest terminal is needed.
  " let &t_ti .= "\e[?6;69h"
  " let &t_te .= "\e7\e[?6;69l\e8"
  " let &t_CV = "\e[%i%p1%d;%p2%ds"
  " let &t_CS = "y"

  " Change cursor shape.
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[0 q"

  if exists('+confirm')
    set confirm
  endif
endif

" Enable true color
if exists('+termguicolors')
  set termguicolors
endif

" Disable the mouse.
set mouse=

" Colorscheme
colorscheme candy
