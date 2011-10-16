" Vim filetype plugin file.
" Language:	Digital Mars D language
" Maintainer:	Liang HUANG <solotony@sohu.com>
" Last Change:	2005 Sep 7

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

setlocal ts=4 sw=4 cin et
compiler dmd

"
" Causes all comment folds to be opened and closed using z[ and z]
" respectively.
"
" Causes all block folds to be opened and closed using z{ and z} respectively.
"

function! <SID>FoldOnlyMatching(re, op)
	mark Z
	normal gg
	let s:lastline = -1
	while s:lastline != line('.')
		if match(getline(line('.')), a:re) != -1
			exec 'normal ' . a:op
		endif
		let s:lastline = line('.')
		normal zj
	endwhile
	normal 'Z
	unlet s:lastline
endfunction

nnoremap <silent> z[ :call <SID>FoldOnlyMatching('/[*][*]', 'zo')<CR>
nnoremap <silent> z] :call <SID>FoldOnlyMatching('/[*][*]', 'zc')<CR>
nnoremap <silent> z{ :call <SID>FoldOnlyMatching('[ \t]*{', 'zo')<CR>
nnoremap <silent> z} :call <SDI>FoldOnlyMatching('[ \t]*{', 'zc')<CR>

" Set 'formatoptions' to break comment lines but not other lines, and insert
" the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql
setlocal includeexpr=substitute(v:fname,'\\.','/','g') 
setlocal include=\\s\*\\(private\\)\\?\\s\*import\\s
if has('win32') || has('win64')
    setlocal path=.,C:/opt/dmd/src/phobos,C:/opt/dmd/src/druntime/import
else
    setlocal path=.,/usr/local/include/d,~/dlib
endif
setlocal suffixesadd=.d


" The following lines enable the macros/matchit.vim plugin for
" extended matching with the % key.

set cpo-=C
if exists("loaded_matchit")

  let b:match_ignorecase = 0
  let b:match_words =
    \ '\<\%(do\|function\|if\)\>:' .
    \ '\<\%(return\|else\|elseif\)\>:' .
    \ '\<end\>,' .
    \ '\<repeat\>:\<until\>'

endif " exists("loaded_matchit")

" Enable comment and overload highlights.
let d_comment_strings = 1
let d_hl_operator_overload = 1

