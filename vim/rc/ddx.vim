" hook_add {{{
nnoremap [Space]x <Cmd>Ddx -path=`'%'->expand()`<CR>
" }}}

" hook_source {{{
call ddx#custom#load_config('$BASE_DIR/ddx.ts'->expand())
" }}}
