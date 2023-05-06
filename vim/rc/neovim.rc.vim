"---------------------------------------------------------------------------
" For neovim:
"

if has('vim_starting') && argv()->empty()
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

" Modifiable terminal
autocmd MyAutoCmd TermOpen * setlocal modifiable

let g:terminal_scrollback_buffer_size = 3000

autocmd MyAutoCmd TextYankPost *
      \ lua require'vim.highlight'.on_yank
      \ { higroup='IncSearch', timeout=100 }

" For neovide
let g:neovide_no_idle = v:true
let g:neovide_cursor_animation_length = 0
let g:neovide_cursor_trail_length = 0

if has('win32')
  set guifont=Firge:h13
else
  "set guifont=Courier\ 10\ Pitch\ 14
endif
