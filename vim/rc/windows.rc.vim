"---------------------------------------------------------------------------
" For Windows:
"

" In Windows, can't find exe, when $PATH isn't contained $VIM.
if $PATH !~? $'\(^\|;\){$VIM->escape('\\')}\(;\|$\)'
  let $PATH = $'{$VIM};{$PATH}'
endif

" Change colorscheme.
" Don't override colorscheme.
if !has('gui_running') && !has('nvim')
  set t_Co=256

  if '$ConEmuPID'->exists()
    " Use ConEmu 256 color mode.
    " https://conemu.github.io/en/VimXterm.html
    set term=xterm
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"

    " Use mouse in ConEmu console.
    set mouse=a
    inoremap <Esc>[62~ <C-X><C-E>
    inoremap <Esc>[63~ <C-X><C-Y>
    nnoremap <Esc>[62~ <C-E>
    nnoremap <Esc>[63~ <C-Y>
  endif
endif
