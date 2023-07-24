" hook_add {{{
let g:foo = 'bar'
" }}}
" cpp {{{
let g:bar = 'baz'
" }}}
" Use vim9script
" hook_source {{{
def Foo()
  g:foo = 'bar'
enddef

call Foo()
" }}}
