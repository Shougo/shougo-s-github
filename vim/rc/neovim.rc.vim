"---------------------------------------------------------------------------
" For neovim:
"

tnoremap   <ESC><ESC>   <C-\><C-n>

" Share the histories
augroup MyAutoCmd
  autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
augroup END

