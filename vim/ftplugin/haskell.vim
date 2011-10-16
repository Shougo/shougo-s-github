setlocal expandtab
setlocal noignorecase
setlocal suffixesadd=.hs
setlocal cpoptions+=M

setlocal shiftwidth=1

"iabbrev case case of<Left><Left><Left>
"iabbrev W where
"iabbrev M module
"iabbrev In instance
"iabbrev Im import

" try gf on import line, or ctrl-x ctrl-i, or [I, [i, ..
setlocal include=^import\\s*\\(qualified\\)\\?\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.'
setlocal suffixesadd=hs,lhs,hsc

" For omnifunc.
compiler ghc

"setlocal completefunc=CompleteHaddock

"inoremap <C-T> _<BS><ESC>:call <SID>Indent()<CR>i
inoremap <buffer><silent><C-t> _<ESC>:call <SID>Indent()<CR>a<BS>
inoremap <buffer><silent><C-v> _<ESC>:call <SID>Unindent()<CR>a<BS>

function! s:Indent()
    let pos = getpos('.')
    let lnum = pos[1]
    let cnum = pos[2]

    if lnum == 1
        return
    endif

    let line = getline('.')

    " if line =~ '^\s*$' | execute 'normal a ' | endif
    normal! ^kW

    let indent_pos = getpos('.')
    if indent_pos[1] == lnum - 1
        normal! j
    else
        call cursor(lnum, 0)
        normal! ^
        let indent_pos = getpos('.')
        let indent_pos[2] += g:haskell_indent_other
        " call cursor(lnum - 1, 0)
        " normal! ^
        " let indent_pos = getpos('.')
    endif

    " s/^\s*/\=repeat(' ', line =~ '^\s*$' ? indent_pos[2] : indent_pos[2] - 1)/
    s/^\s*/\=repeat(' ', indent_pos[2] - 1)/
    let new_line = getline('.')

    call cursor(lnum, cnum + len(new_line) - len(line))

endfunction

function! s:Unindent()
    let pos = getpos('.')
    let lnum = pos[1]
    let cnum = pos[2]

    if lnum == 1
        return
    endif

    let line = getline('.')

    " if line =~ '^\s*$' | execute 'normal a ' | endif
    normal! ^
    let cnum2 = getpos('.')[2]

    if cnum2 == 1
        call cursor(lnum, cnum)
        return
    endif

    normal B
    let indent_pos = getpos('.')
    while indent_pos[2] >= cnum2
        normal! B
        let indent_pos = getpos('.')
    endwhile

    call cursor(lnum, 0)

    " s/^\s*/\=repeat(' ', line =~ '^\s*$' ? indent_pos[2] : indent_pos[2] - 1)/
    s/^\s*/\=repeat(' ', indent_pos[2] - 1)/
    let new_line = getline('.')

    call cursor(lnum, cnum + len(new_line) - len(line))

endfunction
