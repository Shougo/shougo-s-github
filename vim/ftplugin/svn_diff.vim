" Show svn diff on footer.
" Language: svn
" Version:  0.2.3
" Author:   thinca <thinca+vim@gmail.com>
" License:  Creative Commons Attribution 2.1 Japan License
"           <http://creativecommons.org/licenses/by/2.1/jp/deed.en>
" URL:      http://gist.github.com/307495
"
" ChangeLog: {{{
" 0.2.3   2010-03-18
"         - Improved syntax timing.
"         - Added the include guard.
"
" 0.2.2   2010-03-17
"         - Remove \r on tail.
"         - Improved file name escape.
"         - Improved view.
"
" 0.2.1   2010-03-16
"         - Improved for added/removed files.
"         - Improved for property changes.
"
" 0.2.0   2010-03-05
"         - Use :read! instead of system() to detect encoding automatically.
"         - Check whether b:current_syntax exists.
"
" 0.1.0   2010-02-19
"         - Initial version.
" }}}

if exists('b:loaded_ftplugin_svn_diff')
  finish
endif
let b:loaded_ftplugin_svn_diff = 1



function! s:get_file_list()
  let list = []
  silent global/^[ADM_]/call add(list, substitute(getline('.'), '^..\s*\(.*\)', '\1', ''))
  return list
endfunction



function! s:syntax()
  unlet! b:current_syntax
  syntax include @svnDiff syntax/diff.vim
  syntax region svnDiff start="^=\+$" end="^\%$" contains=@svnDiff
  let b:current_syntax = 'svn'
endfunction




function! s:show_diff()
  let list = s:get_file_list()
  if empty(list)
    return
  endif

  let q = '"'
  call map(list, 'q . substitute(v:val, "[!%#]", "\\\\\\0", "g") . q')

  $put =[]

  let lang = $LANG
  let $LANG = 'C'
  execute '$read !svn diff' join(list, ' ')
  let $LANG = lang
  % substitute/\r$//e

  if exists('b:current_syntax')
    call s:syntax()
  else
    augroup ftplugin-svn-diff
      autocmd! Syntax svn call s:syntax() | autocmd! ftplugin-svn-diff
    augroup END
  endif

  global/^Index:/-1put =[]
  1
endfunction

call s:show_diff()
