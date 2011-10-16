setlocal foldmethod=expr foldexpr=MyHelpFold(v:lnum)
setlocal foldtext=MyHelpFoldText()

function! MyHelpFold(lnum)  " {{{2
  let line = getline(a:lnum)
  let next = getline(a:lnum + 1)
  let prev = getline(a:lnum - 1)
  if line =~ '^=\{78}$'
    return 1
  elseif next =~ '^=\{78}$'
    return '<1'
  elseif line =~ '^-\{78}$'
    return 2
  elseif next =~ '^-\{78}$'
    return '<2'
  " elseif line =~ '^\S.\+\*$' && prev !~ '\*$' && prev !~ '^\(.\)\1\+$'
    " return 3
  " elseif next =~ '^\S.\+\*$' && line !~ '\*$'
    " return '<3'
  endif
  return '='
endfunction

function! MyHelpFoldText()  " {{{2
  let base = '+-' . v:folddashes . printf('%3d', v:foldend - v:foldstart) . ' 行:'
  let line = getline(v:foldstart)
  if line =~ '^\(.\)\1\+$'
    let line = getline(v:foldstart + 1)
  endif
  if line =~ '\t\|\s\{4,}'
    let [head, tail] = matchlist(line, '^\(.\{-}\)\%(\t\|\s\{4,}\)\s*\(.*\)$')[1 : 2]
    let line = head . repeat(' ', 78 - strdisplaywidth(base . head . tail)) . tail
  endif
  return base . line
endfunction