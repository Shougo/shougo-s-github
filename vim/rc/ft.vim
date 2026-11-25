" _ {{{
" Disable automatically insert comment.
setlocal formatoptions-=t
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal formatoptions+=mMBl]

" Disable conceal
setlocal conceallevel=0

" Disable auto wrap.
if &l:textwidth != 70 && &filetype !=# 'help'
  setlocal textwidth=0
endif

if !&l:modifiable
  setlocal nofoldenable
  setlocal foldcolumn=0
  setlocal colorcolumn=
endif
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
call matchadd('goErr', '\<err\>')

" --- goimports ----------------------------------------------------------
function! s:run(cmd, lines) abort
  let out = job#system(a:cmd, a:lines)
  if job#status()
    echohl ErrorMsg | echomsg out->join(' | ') | echohl None
    return v:null
  endif
  return out
endfunction

function! s:goimports() abort
  if !'goimports'->executable()
    return
  endif

  let lines = 1->getline('$')->join("\n")

  " goimports has no -s, so run 'gofmt -s' separately (not as a pipe:
  " a failing gofmt would feed empty input to goimports and wipe the buffer).
  let out = s:run(['gofmt', '-s'], lines)
  if out is v:null | return | endif

  let out = s:run(
        \ ['goimports', '-srcdir', '%:p'->expand()->shellescape()], out)
  if out is v:null || out ==# lines | return | endif

  let view = winsaveview()
  call setline(1, out->split("\n"))
  if '$'->line() > out->len()
    silent execute (out->len() + 1) .. ',$delete _'
  endif
  call winrestview(view)
endfunction

autocmd MyAutoCmd BufWritePre <buffer> call s:goimports()
" }}}

" vim {{{
setlocal shiftwidth=2 softtabstop=2
setlocal iskeyword+=\:,#
setlocal indentkeys+=\\,endif,endfunction,endfor,endwhile,endtry
" }}}

" qf {{{
setlocal wrap
" }}}

" help {{{
setlocal iskeyword+=^{
setlocal iskeyword+=^}

" Tag jump
nnoremap <buffer> tt  g<C-]>
nnoremap <buffer> tp  <Cmd>pop<CR>

function! s:set_highlight(group) abort
  for group in ['helpBar', 'helpBacktick', 'helpStar', 'helpIgnore']
    execute 'highlight link' group a:group
  endfor
endfunction
call s:set_highlight('Special')

function! s:right_align(linenr) abort
  if !&l:modifiable
    return
  endif

  let m = a:linenr->getline()->matchlist(
        \ '^\(\%(\S\+ \?\)\+\)\?\s\+\([*|].\+[*|]\)')
  if m->empty()
    return
  endif

  const cnt = [
        \   0, &l:textwidth
        \      - m[1]->strdisplaywidth()
        \      - m[2]->strdisplaywidth()
        \ ]->max()
  const spaces = ' '->repeat(cnt)
  call setline(a:linenr, m[1] .. spaces .. m[2])
endfunction
function! s:right_aligns(start, end) abort
  for linenr in range(a:start, a:end)
    if linenr > a:start
      silent! undojoin
    endif
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
setlocal foldenable foldmethod=expr foldexpr=TomlFold(v:lnum)
function! TomlFold(lnum) abort
  const line = getline(a:lnum)
  return line ==# '' || line =~# '^\s\+' ? 1 : 0
endfunction
" }}}

" yaml {{{
setlocal iskeyword+=-

" Don't want to adjust the indent by "#".
setlocal indentkeys-=0#
" }}}

" lua {{{
setlocal shiftwidth=2 softtabstop=2
" }}}
