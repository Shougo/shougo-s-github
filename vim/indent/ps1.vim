" Vim indent file
" Language:		PowerShell
" Maintainer:	Lior Elia - http://blogs.msdn.com/lior
" Version:		2.0
" Last Change:	2009 Oct 18
" Changelist:	
" 	Ver		Date		By			Fixed indentation of...
" 	-----	----------	--------	-----------------------------------------
"	1.0		2009-10-04	LiorE		Comment rows
" 	2.0		2009-10-18	LiorE		Lines after (.*), comments after '{' or
"					 				'}' and many many other things. I've made
"					 				this a major version change because there
"					 				are many changes in the behavior.

" Dedicated to my loving and supporting family: Anat, Amit and Ofir.

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal cindent cinoptions& cinoptions+=+0

" Set the function to do the work.
setlocal indentexpr=GetPsIndent()

let b:undo_indent = "set cin< cino< indentkeys< indentexpr<"

" Only define the function once.
if exists("*GetPsIndent")
	finish
endif

function! Log(text)
		" Enable the line below for debugging
		" call confirm(a:text)
endfunction

function! SkipPsComments(startline)
	let lnum = a:startline
	while lnum > 1
		let lnum = prevnonblank(lnum)
		if getline(lnum) =~ '^\s*#'
			let lnum = lnum - 1
		else
			break
		endif
	endwhile
	return lnum
endfunction

function GetPsIndent()

	" PowerShell is almost like C; use the built-in C indenting and then correct the comment/precompiler duality.
	let theIndent = cindent(v:lnum)
	let prevLine = SkipPsComments(v:lnum-1)
if (prevLine > 0) 
	let prevLineIndent = indent(prevLine)
else
	let prevLineIndent = 0
endif

	call Log("prevline " . prevLine . " - Indent is " . prevLineIndent)
	" if prev line ends with paranthesis (...) it messes the indentation
	if getline(prevLine) =~ '(.*)$'
		" set the indent to be the same of the prev non blank non comment line
		let theIndent = prevLineIndent
		if getline(v:lnum) =~ '^[^{]*}'
			" remove one indentation level, clsoing a block
			let theIndent -= &sw
		endif
	endif

	" comment lines are mishandled as precompiler directives ('#') so fix that.
	
	call Log("before comment - Indent is " . theIndent)
	" if current line is a comment...
	if getline(v:lnum) =~ '^\s*#'
		let theIndent = prevLineIndent
		" if prev line opened a block - 
		if getline(prevLine) =~ '{$'
			" indent once more, because we're in a beginning of a block
			let theIndent += &sw
		elseif getline(prevLine) =~ '([^)]*$'
			" indent twice more, because we're in a beginning of a parameters
			" block which gets indented twice by cindent, for some obscure
			" reason...
			let theIndent += &sw
			let theIndent += &sw
		endif
	endif
	call Log("After - Indent is " . theIndent)
	return theIndent
endfunction

