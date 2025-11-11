" ddx-hex {{{
nnoremap <buffer> q
      \ <Cmd>call ddx#ui#hex#do_action('quit')<CR>
nnoremap <buffer> e
      \ <Cmd>call ddx#ui#hex#do_action('change')<CR>
nnoremap <buffer> E
      \ <Cmd>call ddx#ui#hex#do_action('change', #{ type: 'string' })<CR>
nnoremap <buffer> i
      \ <Cmd>call ddx#ui#hex#do_action('insert')<CR>
nnoremap <buffer> x
      \ <Cmd>call ddx#ui#hex#do_action('remove')<CR>
nnoremap <buffer> S
      \ <Cmd>call ddx#ui#hex#do_action('save')<CR>
nnoremap <buffer> u
      \ <Cmd>call ddx#ui#hex#do_action('undo')<CR>
nnoremap <buffer> <C-r>
      \ <Cmd>call ddx#ui#hex#do_action('redo')<CR>
nnoremap <buffer> <Space>
      \ <Cmd>call ddx#ui#hex#do_action('selectAddress')<CR>
nnoremap <buffer> J
      \ <Cmd>call JumpAddress()<CR>

function! JumpAddress()
  const input = 'Jump to the address: 0x'->input()
  if input == ''
    return
  endif

  const hex = input->str2nr(16)
  if hex == 0 && input !~# '^0\+$'
    return
  endif

  call ddx#jump(b:ddx_ui_name, hex)
endfunction
" }}}
