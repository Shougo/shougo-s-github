"---------------------------------------------------------------------------
" For Windows:
"

" In Windows, can't find exe, when $PATH isn't contained $VIM.
if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Shell settings.
" Use NYAOS.
"set shell=nyaos.exe
"set shellcmdflag=-e
"set shellpipe=\|&\ tee
"set shellredir=>%s\ 2>&1
"set shellxquote=\"

" Use bash.
"set shell=bash.exe
"set shellcmdflag=-c
"set shellpipe=2>&1\|\ tee
"set shellredir=>%s\ 2>&1
"set shellxquote=\"

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
