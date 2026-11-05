" hook_add {{{
let g:goda_hex#config_dir = '$BASE_DIR/goda-hex'->expand()

nnoremap [Space]x <Cmd>call goda_hex#start(#{path: '%:p'->expand()})<CR>
" }}}

" hook_source {{{
" }}}

" goda-hex-hex {{{
nnoremap <buffer> q
      \ <Cmd>call goda_hex#ui#hex#do_action('quit')<CR>
nnoremap <buffer> e
      \ <Cmd>call goda_hex#ui#hex#do_action('change')<CR>
nnoremap <buffer> E
      \ <Cmd>call goda_hex#ui#hex#do_action('change', #{ type: 'string' })<CR>
nnoremap <buffer> <C-e>
      \ <Cmd>call goda_hex#ui#hex#do_action('change', #{ type: 'number' })<CR>
nnoremap <buffer> i
      \ <Cmd>call goda_hex#ui#hex#do_action('insert')<CR>
nnoremap <buffer> I
      \ <Cmd>call goda_hex#ui#hex#do_action('insert', #{ type: 'string' })<CR>
nnoremap <buffer> C
      \ <Cmd>call goda_hex#ui#hex#do_action('copy')<CR>
nnoremap <buffer> x
      \ <Cmd>call goda_hex#ui#hex#do_action('remove')<CR>
nnoremap <buffer> P
      \ <Cmd>call goda_hex#ui#hex#do_action('paste')<CR>
nnoremap <buffer> p
      \ <Cmd>call goda_hex#ui#hex#do_action('inspect')<CR>
nnoremap <buffer> <C-p>
      \ <Cmd>call goda_hex#ui#hex#do_action('inspect', #{ type: 'number' })<CR>
nnoremap <buffer> <C-n>
      \ <Cmd>call goda_hex#ui#hex#do_action('inspect', #{ type: 'floating' })<CR>
nnoremap <buffer> s
      \ <Cmd>call goda_hex#ui#hex#do_action('checksum', #{
      \   method: 'Please input checksum method: '->input(),
      \ })<CR>
nnoremap <buffer> S
      \ <Cmd>call goda_hex#ui#hex#do_action('save')<CR>
nnoremap <buffer> u
      \ <Cmd>call goda_hex#ui#hex#do_action('undo')<CR>
nnoremap <buffer> <C-r>
      \ <Cmd>call goda_hex#ui#hex#do_action('redo')<CR>
nnoremap <buffer> <Space><Space>
      \ <Cmd>call goda_hex#ui#hex#do_action('selectAddress')<CR>
nnoremap <buffer> F
      \ <Cmd>call goda_hex#ui#hex#do_action('search')<CR>
nnoremap <buffer> /
      \ <Cmd>call goda_hex#ui#hex#do_action('search', #{
      \   type: 'string',
      \ })<CR>
nnoremap <buffer> ?
      \ <Cmd>call goda_hex#ui#hex#do_action('search', #{
      \   type: 'string', direction: 'backward',
      \ })<CR>
nnoremap <buffer> J
      \ <Cmd>call goda_hex#ui#hex#do_action('jump')<CR>
nnoremap <buffer> n
      \ <Cmd>call goda_hex#ui#hex#do_action('nextSearch')<CR>
nnoremap <buffer> D
      \ <Cmd>call goda_hex#ui#hex#do_action('nextDiff')<CR>
nnoremap <buffer> Y
      \ <Cmd>call goda_hex#ui#hex#do_action('yank', #{ type: 'string' })<CR>
nnoremap <buffer> r
      \ <Cmd>call goda_hex#ui#hex#do_action('substitute', #{ type: 'hex' })<CR>
nnoremap <buffer> R
      \ <Cmd>call goda_hex#ui#hex#do_action('substitute', #{ type: 'string' })<CR>
nnoremap <buffer> <Space>r
      \ <Cmd>call goda_hex#restart(b:goda_hex_name)<CR>
" }}}
