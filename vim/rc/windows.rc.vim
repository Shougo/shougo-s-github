"---------------------------------------------------------------------------
" For Windows:
"

" In Windows, can't find exe, when $PATH isn't contained $VIM.
if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Shell settings.
" Use NYAOS.
"setglobal shell=nyaos.exe
"setglobal shellcmdflag=-e
"setglobal shellpipe=\|&\ tee
"setglobal shellredir=>%s\ 2>&1
"setglobal shellxquote=\"

" Use bash.
"setglobal shell=bash.exe
"setglobal shellcmdflag=-c
"setglobal shellpipe=2>&1\|\ tee
"setglobal shellredir=>%s\ 2>&1
"setglobal shellxquote=\"

" Change colorscheme.
" Don't override colorscheme.
if !exists('g:colors_name') && !has('gui_running')
  colorscheme darkblue
endif
" Disable error messages.
let g:CSApprox_verbose_level = 0

" Popup color.
hi Pmenu ctermbg=8
hi PmenuSel ctermbg=1
hi PmenuSbar ctermbg=0
