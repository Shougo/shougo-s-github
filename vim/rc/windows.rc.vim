"---------------------------------------------------------------------------
" For Windows:
"

" In Windows, can't find exe, when $PATH isn't contained $VIM.
if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Shell settings.
" Use NYAOS.
"SetFixer set shell=nyaos.exe
"SetFixer set shellcmdflag=-e
"SetFixer set shellpipe=\|&\ tee
"SetFixer set shellredir=>%s\ 2>&1
"SetFixer set shellxquote=\"

" Use bash.
"SetFixer set shell=bash.exe
"SetFixer set shellcmdflag=-c
"SetFixer set shellpipe=2>&1\|\ tee
"SetFixer set shellredir=>%s\ 2>&1
"SetFixer set shellxquote=\"

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
