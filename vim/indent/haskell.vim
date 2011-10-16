if exists('b:did_indent')
    finish
endif

let b:did_indent = 1

if !exists('g:haskell_indent_if')
    " if bool
    " >>>then ...
    " >>>else ...
    let g:haskell_indent_if = 3
endif

if !exists('g:haskell_indent_case')
    " case xs of
    " >>>>>[] -> ...
    " >>>>>(y:ys) -> ...
    let g:haskell_indent_case = 5
endif

setlocal indentexpr=GetHaskellIndent()
setlocal indentkeys=!^F,o,O

function! GetHaskellIndent()
    let line = substitute(getline(getpos('.')[1] - 1), '\t', repeat(' ', &tabstop), 'g')

    if line =~ '[!#$%&*+./<=>?@\\^|~-]$\|\<do$'
        return match(line, '\s*where \zs\|\S') + &shiftwidth
    endif

    if line =~ '{$'
        return match(line, '\s*where \zs\|\S') + &shiftwidth
    endif

    if line =~ '^\(instance\|class\).*\&.*where$'
        return &shiftwidth
    endif

    if line =~ ')$'
        let pos = getpos('.')
        normal k$
        let paren_end   = getpos('.')
        normal %
        let paren_begin = getpos('.')
        call setpos('.', pos)
        if paren_begin[1] != paren_end[1]
            return paren_begin[2] - 1
        endif
    endif

    if line !~ '\<else\>'
        let s = match(line, '\<if\>.*\&.*\zs\<then\>')
        if s > 0
            return s
        endif

        let s = match(line, '\<if\>')
        if s > 0
            return s + g:haskell_indent_if
        endif
    endif

    let s = match(line, '\<do\s\+\zs[^{]\|\<where\s\+\zs\w\|\<let\s\+\zs\S\|^\s*\zs|\s')
    if s > 0
        return s
    endif

    let s = match(line, '\<case\>')
    if s > 0
        return s + g:haskell_indent_case
    endif

    return match(line, '\S')
endfunction
