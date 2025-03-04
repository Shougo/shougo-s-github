" _ {{{
" Disable automatically insert comment.
setl formatoptions-=t
setl formatoptions-=c
setl formatoptions-=r
setl formatoptions-=o
setl formatoptions+=mMBl

" Disable auto wrap.
if &l:textwidth != 70 && &filetype !=# 'help'
  setlocal textwidth=0
endif

if !&l:modifiable
  setlocal nofoldenable
  setlocal foldcolumn=0
  setlocal colorcolumn=
endif

" Disable conceal
setlocal conceallevel=0
" }}}

" python {{{
"setlocal foldmethod=indent
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
" }}}

" html {{{
setlocal includeexpr=v:fname->substitute('^\\/','','')
setlocal path+=./;/
" }}}

" go {{{
highlight default link goErr WarningMsg
match goErr /\<err\>/
" }}}

" vim {{{
setlocal shiftwidth=2 softtabstop=2
setlocal iskeyword+=:,#
setlocal indentkeys+=\\,endif,endfunction,endfor,endwhile,endtry
" }}}

" qf {{{
setlocal wrap
" }}}

" qfreplace {{{
setlocal nofoldenable
" }}}

" help {{{
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-

function! s:set_highlight(group) abort
  for group in ['helpBar', 'helpBacktick', 'helpStar', 'helpIgnore']
    execute 'highlight link' group a:group
  endfor
endfunction
call s:set_highlight('Special')

function! s:right_align(linenr) abort
  let m = a:linenr->getline()->matchlist(
        \ '^\(\%(\S\+ \?\)\+\)\?\s\+\([*|].\+[*|]\)')
  if m->empty()
    return
  endif
  call setline(a:linenr, m[1] .. ' '->repeat(
        \ &l:textwidth - len(m[1]) - len(m[2])) .. m[2])
endfunction
function! s:right_aligns(start, end) abort
  for linenr in range(a:start, a:end)
    call s:right_align(linenr)
  endfor
endfunction
command! -range -buffer RightAlign
      \ call s:right_aligns('<line1>'->expand(), '<line2>'->expand())

nnoremap <buffer> mm      <Cmd>RightAlign<CR>
xnoremap <silent><buffer> mm      :RightAlign<CR>
" }}}

" ruby {{{
setlocal iskeyword+=!
setlocal iskeyword+=?
setlocal shiftwidth=2 softtabstop=2 tabstop=2
" }}}

" typescript {{{
setlocal shiftwidth=2

" Disable GetTypescriptIndent()
setlocal indentexpr=
" }}}

" toml {{{
setlocal foldenable foldmethod=expr foldexpr=s:fold_expr(v:lnum)
function! s:fold_expr(lnum)
  const line = getline(a:lnum)
  return line ==# '' || line =~# '^\s\+'
endfunction
" }}}

" yaml {{{
setlocal iskeyword+=-

" Don't want to adjust the indent by "#".
setlocal indentkeys-=0#
" }}}
