"---------------------------------------------------------------------------
" For neovim:
"

if has('vim_starting') && empty(argv())
  syntax off
endif

let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0

let g:python3_host_prog = '/usr/bin/python3'

if exists('&inccommand')
  set inccommand=nosplit
endif

if exists('&pumblend')
  set pumblend=20
  " For gonvim
  " autocmd MyAutoCmd InsertEnter * set pumblend=20
endif

if exists('&winblend')
  set winblend=20
endif

" Use cursor shape feature
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" Share the histories
" autocmd MyAutoCmd FocusGained *
"      \ if exists(':rshada') | rshada | wshada | endif

" Modifiable terminal
autocmd MyAutoCmd TermOpen * setlocal modifiable

let g:terminal_scrollback_buffer_size = 3000

autocmd MyAutoCmd TextYankPost * lua require'vim.highlight'.on_yank
      \ {higroup='IncSearch', timeout=150}
