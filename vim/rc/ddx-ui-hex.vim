" ddx-hex {{{
nnoremap <buffer> q
      \ <Cmd>call ddx#ui#hex#do_action('quit')<CR>
nnoremap <buffer> e
      \ <Cmd>call ddx#ui#hex#do_action('change')<CR>
nnoremap <buffer> E
      \ <Cmd>call ddx#ui#hex#do_action('change', #{ type: 'string' })<CR>
nnoremap <buffer> i
      \ <Cmd>call ddx#ui#hex#do_action('insert')<CR>
nnoremap <buffer> I
      \ <Cmd>call ddx#ui#hex#do_action('insert', #{ type: 'string' })<CR>
nnoremap <buffer> c
      \ <Cmd>call ddx#ui#hex#do_action('copy')<CR>
nnoremap <buffer> x
      \ <Cmd>call ddx#ui#hex#do_action('remove')<CR>
nnoremap <buffer> p
      \ <Cmd>call ddx#ui#hex#do_action('paste')<CR>
nnoremap <buffer> s
      \ <Cmd>call ddx#ui#hex#do_action('checksum', #{
      \   method: 'Please input checksum method: '->input()
      \ })<CR>
nnoremap <buffer> S
      \ <Cmd>call ddx#ui#hex#do_action('save')<CR>
nnoremap <buffer> u
      \ <Cmd>call ddx#ui#hex#do_action('undo')<CR>
nnoremap <buffer> <C-r>
      \ <Cmd>call ddx#ui#hex#do_action('redo')<CR>
nnoremap <buffer> <Space><Space>
      \ <Cmd>call ddx#ui#hex#do_action('selectAddress')<CR>
nnoremap <buffer> ?
      \ <Cmd>call ddx#ui#hex#do_action('search', #{ type: 'string' })<CR>
nnoremap <buffer> J
      \ <Cmd>call JumpAddress()<CR>
nnoremap <buffer> N
      \ <Cmd>call ddx#ui#hex#do_action('nextDiff')<CR>
nnoremap <buffer> Y
      \ <Cmd>call ddx#ui#hex#do_action('yank', #{ type: 'string' })<CR>
nnoremap <buffer> r
      \ <Cmd>call ddx#ui#hex#do_action('substitute', #{ type: 'hex' })<CR>
nnoremap <buffer> R
      \ <Cmd>call ddx#ui#hex#do_action('substitute', #{ type: 'string' })<CR>
nnoremap <buffer> <C-r>
      \ <Cmd>call ddx#ui#hex#do_action('resize')<CR>
nnoremap <buffer> <Space>r
      \ <Cmd>call ddx#restart(b:ddx_ui_name)<CR>

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
