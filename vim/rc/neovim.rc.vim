"---------------------------------------------------------------------------
" For neovim:
"

tnoremap   <ESC><ESC>   <C-\><C-n>

" Share the histories
augroup MyAutoCmd
  autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
augroup END

" Use cursor shape feature
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Use true color feature
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
