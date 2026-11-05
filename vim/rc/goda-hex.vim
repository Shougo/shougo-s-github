" hook_add {{{
let g:goda_hex#config_dir = '$BASE_DIR/goda-hex'->expand()

nnoremap [Space]x <Cmd>call goda_hex#start(#{path: '%:p'->expand()})<CR>
" }}}

" hook_source {{{
" }}}
