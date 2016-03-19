"---------------------------------------------------------------------------
" For Windows:
"

" In Windows, can't find exe, when $PATH isn't contained $VIM.
if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Change colorscheme.
" Don't override colorscheme.
if !exists('g:colors_name') && !has('gui_running')
  " Use ConEmu 256 color mode.
  " https://conemu.github.io/en/VimXterm.html
  colorscheme candy256
  set term=pcansi
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"

  " Use mouse in ConEmu console.
  set mouse=a
  inoremap <Esc>[62~ <C-X><C-E>
  inoremap <Esc>[63~ <C-X><C-Y>
  nnoremap <Esc>[62~ <C-E>
  nnoremap <Esc>[63~ <C-Y>

  " colorscheme darkblue

  " Change the popup menu color.
  " hi Pmenu ctermbg=8
  " hi PmenuSel ctermbg=1
  " hi PmenuSbar ctermbg=0
endif
