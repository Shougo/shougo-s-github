" hook_add {{{
let g:goda_term#config_dir = '$BASE_DIR/goda-term'->expand()

nnoremap [Space]t <Cmd>call goda_term#start(#{
      \   name: t:->get('goda_term_ui_terminal_last_name',
      \                 'terminal-' .. win_getid()),
      \   ui: 'terminal',
      \ })<CR>
" }}}

" hook_source {{{

" }}}
