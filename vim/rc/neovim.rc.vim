"---------------------------------------------------------------------------
" For neovim:
"

if has('vim_starting') && empty(argv())
  " Disable auto syntax loading
  syntax off
endif

let g:loaded_node_provider = v:false
let g:loaded_perl_provider = v:false
let g:loaded_python_provider = v:false
let g:loaded_ruby_provider = v:false

let g:python3_host_prog = has('win32') ? 'python.exe' : 'python3'

set inccommand=nosplit

set pumblend=20

set winblend=20

" Use cursor shape feature
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" Share the histories
" autocmd MyAutoCmd FocusGained *
"      \ if exists(':rshada') | rshada | wshada | endif

" Modifiable terminal
autocmd MyAutoCmd TermOpen * setlocal modifiable

let g:terminal_scrollback_buffer_size = 3000

autocmd MyAutoCmd TextYankPost * lua require'vim.highlight'.on_yank
     \ {higroup='IncSearch', timeout=100}

" For neovide
let g:neovide_no_idle = v:true
let g:neovide_cursor_animation_length = 0
let g:neovide_cursor_trail_length = 0

" For nvui
if exists('g:nvui')
  set guifont=Courier\ 10\ Pitch:h14,VL\ Gothic:h14
  call rpcnotify(1, 'NVUI_ANIMATIONS_ENABLED', v:false)
  call rpcnotify(1, 'NVUI_CURSOR_HIDE_TYPE', v:true)

  " Note: nvui does not use 'titlestring'
  autocmd MyAutoCmd
        \ BufWritePost,TextChanged,TextChangedI,BufEnter,DirChanged *
        \ call rpcnotify(1, 'NVUI_TB_TITLE', printf('%s%s%s (%s)',
        \ &l:readonly ? '[-]' : '',
        \ &l:modified ? '[+]' : '',
        \ expand('%:p:~:.'),
        \ fnamemodify(getcwd(), ':~')))
endif

if has('win32')
  set guifont=Firge:h13
else
  "set guifont=Courier\ 10\ Pitch\ 14
endif
