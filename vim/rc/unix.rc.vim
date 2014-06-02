"---------------------------------------------------------------------------
" For UNIX:
"

if exists('$WINDIR') || !executable('zsh')
  " Cygwin.

  " Use bash.
  set shell=bash
else
  " Use zsh.
  set shell=zsh
endif

" Set path.
let $PATH = expand('~/bin').':/usr/local/bin/:'.$PATH

if has('gui_running')
  finish
endif

"---------------------------------------------------------------------------
" For CUI:
"

" Enable 256 color terminal.
set t_Co=256

if &term =~# 'xterm'
  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function! XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  noremap <special> <expr> <Esc>[200~ XTermPasteBegin('0i')
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin('')
  cnoremap <special> <Esc>[200~ <nop>
  cnoremap <special> <Esc>[201~ <nop>

  " Optimize vertical split.
  " Note: Newest terminal is needed.
  " let &t_ti .= "\e[?6;69h"
  " let &t_te .= "\e7\e[?6;69l\e8"
  " let &t_CV = "\e[%i%p1%d;%p2%ds"
  " let &t_CS = "y"
endif

if has('gui')
  " Use CSApprox.vim
  NeoBundleSource csapprox

  " Convert colorscheme in Konsole.
  let g:CSApprox_konsole = 1
  let g:CSApprox_attr_map = {
        \ 'bold' : 'bold',
        \ 'italic' : '', 'sp' : ''
        \ }
  if !exists('g:colors_name')
    execute 'colorscheme' globpath(&runtimepath,
          \ 'colors/candy.vim') != '' ? 'candy' : 'desert'
  endif
else
  " Use guicolorscheme.vim
  NeoBundleSource vim-guicolorscheme

  autocmd MyAutoCmd VimEnter,BufAdd *
        \ if !exists('g:colors_name') | GuiColorScheme candy

  " Disable error messages.
  let g:CSApprox_verbose_level = 0
endif

" Change cursor shape.
if &term =~ "xterm"
  let &t_SI = "\<Esc>]12;lightgreen\x7"
  let &t_EI = "\<Esc>]12;white\x7"
endif
