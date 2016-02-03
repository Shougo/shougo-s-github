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

autocmd CursorHold * call s:init_neovim_qt()

function! s:init_neovim_qt() abort "{{{
  if !has('gui_running')
    return
  endif

  " Neovim-qt Guifont command
  command! -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', '<args>')
        \ | let g:Guifont = '<args>'

  " Set the font
  if !exists('g:Guifont')
    Guifont Courier 10 Pitch:h14
  endif

  " if &columns < 170
  "   " Width of window.
  "   setglobal columns=170
  " endif
  " if &lines < 40
  "   " Height of window.
  "   setglobal lines=40
  " endif
endfunction"}}}
