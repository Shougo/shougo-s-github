let g:J6uil_config_dir = expand('$CACHE/J6uil')
let g:J6uil_no_default_keymappings = 1
let g:J6uil_display_offline  = 0
let g:J6uil_display_online   = 0
let g:J6uil_echo_presence    = 1
let g:J6uil_display_icon     = 1
let g:J6uil_display_interval = 0
let g:J6uil_updatetime       = 1000
let g:J6uil_align_message    = 0

autocmd MyAutoCmd FileType J6uil call s:j6uil_settings()
autocmd MyAutoCmd FileType J6uil_say call s:j6uil_say_settings()

function! s:j6uil_settings() abort
  setlocal wrap
  setlocal nofoldenable
  setlocal foldcolumn=0
  nmap <buffer> o <Plug>(J6uil_open_say_buffer)
  nmap <silent> <buffer> <CR> <Plug>(J6uil_action_enter)
endfunction

function! s:j6uil_say_settings() abort
  setlocal wrap
  setlocal nofoldenable
  setlocal foldcolumn=0
endfunction
