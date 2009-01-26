"=============================================================================
" FILE: syntax/vimshell.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>(Modified)
" Last Modified: 26 Jan 2009
" Usage: Just source this file.
"        source vimshell.vim
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Version: 2.7, for Vim 7.0
"-----------------------------------------------------------------------------
" ChangeLog: "{{{
"   2.7:
"     - Improved VimShellVariable color.
"   2.6:
"     - Improved VimShellSpecial color.
"     - Improved VimShellExe color.
"     - Improved VimShellSocket color.
"   2.5:
"     - Improved prompt color when non gui.
""}}}
"-----------------------------------------------------------------------------
" TODO: "{{{
"     - Nothing.
""}}}
" Bugs"{{{
"     -
""}}}
"=============================================================================

if version < 700
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

execute 'syn match VimShellPrompt ' . "'".g:VimShell_Prompt."'"
syn region   VimShellString   start=+'+ end=+'+ contained
syn region   VimShellString   start=+"+ end=+"+ contains=VimShellQuoted
syn region   VimShellString   start=+`+ end=+`+ contained
syn match   VimShellConstants         '\(^\|\s\)[[:digit:]]\+\(\s\|$\)\(\s*[[:digit:]]\+\)*'
syn match   VimShellExe               '\(^\|\s\)[[:alnum:]_.][[:alnum:]_.-]\+\*\(\s\|\n\)'
syn match   VimShellSocket            '\(^\|\s\)[[:alnum:]_.][[:alnum:]_.-]\+=\(\s\|\n\)'
syn match   VimShellArguments         '-\=-[[:alnum:]-]\+=\=' contained
syn match   VimShellQuoted            '\\.' contained
syn match   VimShellSpecial           '[|<>;&]' contained
syn match   VimShellSpecial           '!!\|!\d*' contained
syn match   VimShellVariable          '$[$[:alnum:]]\+' contained
syn match   VimShellVariable          '$[[:digit:]*@#?$!-]\+' contained
syn region   VimShellVariable  start=+${+ end=+}+ contained
syn region   VimShellVariable  start=+$((\s+ end=+\s))+ contained
if has('win32') || ('win64')
    syn match   VimShellArguments         '/[?[:alnum:]]\+' contained
    syn match   VimShellDirectory         '\(\.\|\w\)*\f[/\\]\f*'
    syn match   VimShellLink              '\([[:alnum:]_.-]\+\.lnk\)'
else
    syn match   VimShellDirectory         '/\=\(\.\|\w\)*\f/\f*'
    syn match   VimShellLink              '\(^\|\s\)[[:alnum:]_.][[:alnum:]_.-]\+@'
endif
execute "syn region   VimShellExe start='" . g:VimShell_Prompt . "' end='\\h[[:alpha:]_.-]*\\(\\s\\|\\n\\)' contained contains=VimShellPrompt,VimShellSpecial,VimShellConstants"
syn match VimShellExe '|\s*[[:alpha:]_.-]\+' contained contains=VimShellSpecial
syn match VimShellExe ';\s*[[:alpha:]_.-]\+' contained contains=VimShellSpecial
execute "syn region   VimShellLine start='" . g:VimShell_Prompt ."' end='$' keepend contains=VimShellExe,VimShellDirectory,VimShellConstants,VimShellArguments, VimShellQuoted,VimShellString,VimShellVariable,VimShellSpecial"

if has('gui_running')
    hi VimShellPrompt  gui=UNDERLINE guifg=#80ffff guibg=NONE
else
    hi def link VimShellPrompt Comment
endif

hi def link VimShellQuoted Special
hi def link VimShellString Constant
hi def link VimShellArguments Type
hi def link VimShellConstants Constant
hi def link VimShellSpecial PreProc
hi def link VimShellVariable Comment
hi def link VimShellNormal Normal
hi def link VimShellExe Statement
hi def link VimShellDirectory Preproc
hi def link VimShellSocket Constant
hi def link VimShellLink Comment

let b:current_syntax = "vimshell"
