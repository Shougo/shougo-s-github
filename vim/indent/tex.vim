" Vim indent file
" Language:     LaTeX
" Maintainer:   Johannes Tanzler <johannes.tanzler@aon.at>
" Created:      Sat, 16 Feb 2002 16:50:19 +0100
" Last Change:	Mit, 15 Jun 2005 01:04:35 +0200
" Last Update:  18th feb 2002, by LH :
"               (*) better support for the option
"               (*) use some regex instead of several '||'.
"               Oct 9th, 2003, by JT:
"               (*) don't change indentation of lines starting with '%'
"               2005/06/15, Moshe Kaminsky <kaminsky@math.huji.ac.il>
"               (*) New variables:
"                   g:tex_items, g:tex_itemize_env, g:tex_noindent_env
" Version: 0.4

" Options: {{{
"
" To set the following options (ok, currently it's just one), add a line like
"   let g:tex_indent_items = 1
" to your ~/.vimrc.
"
" * g:tex_indent_items
"
"   If this variable is set, item-environments are indented like Emacs does
"   it, i.e., continuation lines are indented with a shiftwidth.
"   
"   NOTE: I've already set the variable below; delete the corresponding line
"   if you don't like this behaviour.
"
"   Per default, it is unset.
"   
"              set                                unset
"   ----------------------------------------------------------------
"       \begin{itemize}                      \begin{itemize}  
"         \item blablabla                      \item blablabla
"           bla bla bla                        bla bla bla  
"         \item blablabla                      \item blablabla
"           bla bla bla                        bla bla bla  
"       \end{itemize}                        \end{itemize}    
"
"
" * g:tex_items
"
"   A list of tokens to be considered as commands for the beginning of an item 
"   command. The tokens should be separated with '\|'. The initial '\' should 
"   be escaped. The default is '\\bibitem\|\\item'.
"
" * g:tex_itemize_env
" 
"   A list of environment names, separated with '\|', where the items (item 
"   commands matching g:tex_items) may appear. The default is 
"   'itemize\|description\|enumerate\|thebibliography'.
"
" * g:tex_noindent_env
"
"   A list of environment names. separated with '\|', where no indentation is 
"   required. The default is 'document\|verbatim'.
"
" }}} 

if exists("b:did_indent") | finish
endif
let b:did_indent = 1

" Delete the next line to avoid the special indention of items
if !exists("g:tex_indent_items")
  let g:tex_indent_items = 1
endif
if g:tex_indent_items
  if !exists("g:tex_itemize_env")
    let g:tex_itemize_env = 'itemize\|description\|enumerate\|thebibliography'
  endif
  if !exists('g:tex_items')
    let g:tex_items = '\\bibitem\|\\item' 
  endif
else
  let g:tex_items = ''
endif

if !exists("g:tex_noindent_env")
  let g:tex_noindent_env = 'document\|verbatim'
endif

setlocal indentexpr=GetTeXIndent()
setlocal nolisp
setlocal nosmartindent
setlocal autoindent
exec 'setlocal indentkeys+=}' . substitute(g:tex_items, '^\|\(\\|\)', ',=', 'g')
let g:tex_items = '^\s*' . g:tex_items


" Only define the function once
if exists("*GetTeXIndent") | finish
endif



function GetTeXIndent()

  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " At the start of the file use zero indent.
  if lnum == 0 | return 0 
  endif

  let ind = indent(lnum)
  let line = getline(lnum)             " last line
  let cline = getline(v:lnum)          " current line


  " Add a 'shiftwidth' after beginning of environments.
  " Don't add it for \begin{document} and \begin{verbatim}
  ""if line =~ '^\s*\\begin{\(.*\)}'  && line !~ 'verbatim' 
  " LH modification : \begin does not always start a line
  if line =~ '\\begin{.*}'  && line !~ g:tex_noindent_env

    let ind = ind + &sw

    if g:tex_indent_items
      " Add another sw for item-environments
      if line =~ g:tex_itemize_env
        let ind = ind + &sw
      endif
    endif
  endif

  
  " Subtract a 'shiftwidth' when an environment ends
  if cline =~ '^\s*\\end' && cline !~ g:tex_noindent_env

    if g:tex_indent_items
      " Remove another sw for item-environments
      if cline =~ g:tex_itemize_env
        let ind = ind - &sw
      endif
    endif

    let ind = ind - &sw
  endif

  
  " Special treatment for 'item'
  " ----------------------------
  
  if g:tex_indent_items

    " '\item' or '\bibitem' itself:
    if cline =~ g:tex_items
      let ind = ind - &sw
    endif

    " lines following to '\item' are intented once again:
    if line =~ g:tex_items
      let ind = ind + &sw
    endif

  endif

  return ind
endfunction

