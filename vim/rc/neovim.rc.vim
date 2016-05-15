"---------------------------------------------------------------------------
" For neovim:
"

tnoremap   <ESC>      <C-\><C-n>
tnoremap   jj         <C-\><C-n>
tnoremap   j<Space>   j

nnoremap <Leader>t    :<C-u>terminal<CR>
nnoremap !            :<C-u>terminal<Space>

set mouse=

" Set terminal colors
let s:num = 0
for s:color in [
      \ '#6c6c6c', '#ff6666', '#66ff66', '#ffd30a',
      \ '#1e95fd', '#ff13ff', '#1bc8c8', '#c0c0c0',
      \ '#383838', '#ff4444', '#44ff44', '#ffb30a',
      \ '#6699ff', '#f820ff', '#4ae2e2', '#ffffff',
      \ ]
  let g:terminal_color_{s:num} = s:color
  let s:num += 1
endfor

" Use cursor shape feature
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Use true color feature
if exists('+termguicolors')
  set termguicolors
endif

" Share the histories
augroup MyAutoCmd
  autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
augroup END

autocmd BufEnter * call s:init_neovim_qt()

function! s:init_neovim_qt() abort "{{{
  if $NVIM_GUI == ''
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
  "    set columns=170
  " endif
  " if &lines < 40
  "   " Height of window.
  "    set lines=40
  " endif
endfunction"}}}
