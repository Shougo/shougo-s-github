"---------------------------------------------------------------------------
" For neovim:
"

tnoremap   <ESC>      <C-\><C-n>
tnoremap   jj         <C-\><C-n>
tnoremap   j<Space>   j
tnoremap <expr> ;  vimrc#sticky_func()

nnoremap <Leader>t    :<C-u>terminal<CR>
nnoremap !            :<C-u>terminal<Space>

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

if has('vim_starting')
  syntax off
endif

" Share the histories
autocmd MyAutoCmd CursorHold * if exists(':rshada') | rshada | wshada | endif

nnoremap <silent> [Window]<Space>
      \ :<C-u>Denite file_rec:~/.vim/rc<CR>
nnoremap <silent> / :<C-u>Denite line<CR>
nnoremap <silent> * :<C-u>DeniteCursorWord line<CR>
nnoremap <silent> [Window]s :<C-u>Denite file_point
      \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`
      \ file_mru<CR>

nnoremap <silent> [Window]n :<C-u>Denite dein<CR>
nnoremap <silent> ;g :<C-u>Denite -buffer-name=grep grep<CR>
nnoremap <silent> n :<C-u>Denite -buffer-name=grep -resume -mode=normal<CR>
nnoremap <silent> ft :<C-u>Denite filetype<CR>
