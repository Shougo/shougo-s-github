" Vim indent file
" Language:		JavaScript
" Author: 		Preston Koprivica (pkopriv2@gmail.com)	
" URL:
" Last Change: 	April 30, 2010

" 0. Standard Stuff
" =================

" Only load one indent script per buffer
if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

" Set the global log variable 1 = logging enabled, 0 = logging disabled
if !exists("g:js_indent_log")
	let g:js_indent_log = 1
endif

setlocal indentexpr=GetJsIndent(v:lnum)
setlocal indentkeys=0{,0},o,O,e,!<Tab>,*<Return>

" 1. Variables
" ============


" Inline comments (for anchoring other statements)
let s:js_line_comment = '\s*\(//.*\)*'

" Simple Objects
let s:js_object_beg = '[{\[]\s*'
let s:js_object_end = '^[^][{}]*[}\]][;,]\=\s*'

" Simple control blocks (those not beginngin with "{")
let s:js_s_cntrl_beg = '^\s*\(\(\(if\|for\|with\|while\)\s*(.*)\)\|\(try\|do\)\)\s*' 		
let s:js_s_cntrl_mid = '^\s*\(\(\(else\s*if\|catch\)\s*(.*)\)\|\(finally\|else\)\)\s*'

" Multi line control blocks (those beginning with "{")
let s:js_m_cntrl_beg = s:js_s_cntrl_beg . '\s*{\s*'
let s:js_m_cntrl_mid = '}\=\s*' . s:js_s_cntrl_mid . '\s*{\s*'
let s:js_m_cntrl_end = '^[^{]*}\s*\(while\s*(.*)\)\=\s*;\=\s*'

" Multi line declarations & invocations
let s:js_multi_beg = '([^()]*\s*'
let s:js_s_multi_end = '^[^()]*)\s*'
let s:js_m_multi_end = s:js_s_multi_end . '\s*{\s*'

" Multi line invocation
let s:js_multi_invok_beg = s:js_multi_beg
let s:js_multi_invok_end = s:js_s_multi_end . '[;,]\{1}\s*'

" Special switch control
let s:js_s_switch_beg = 'switch\s*(.*)\s*' "Actually not allowed. 
let s:js_m_switch_beg = s:js_s_switch_beg . '\s*{\s*'
let s:js_switch_mid = '^.*\(case.*\|default\)\s*:\s*'

" Single line comment (// xxx)
let s:syn_comment = '\(Comment\|String\)'

" 2. Aux. Functions
" =================


" = Method: GetNonCommentLine
"
" Grabs the nearest non-commented line
function! s:GetNonCommentLine(lnum)
	let lnum = prevnonblank(a:lnum)

	while lnum > 0
		if s:IsComment(lnum)
			let lnum = prevnonblank(lnum - 1)
		else
			return lnum
		endif
	endwhile

	return lnum
endfunction



" = Method: IsInComment
"
" Determines whether the specified position is contained in a comment. "Note:
" This depends on a 
function! s:IsInComment(lnum, cnum) 
	return synIDattr(synID(a:lnum, a:cnum, 1), 'name') =~? s:syn_comment
endfunction



" = Method: IsComment
" 
" Determines whether a line is a comment or not.
function! s:IsComment(lnum)
	let line = getline(a:lnum)

	return s:IsInComment(a:lnum, 1) && s:IsInComment(a:lnum, strlen(line)) "Doesn't absolutely work.  Only Probably!
endfunction



" = Method: Log
"
" Logs a message to the stdout.
function! s:Log(msg)
	if g:js_indent_log
		echo "LOG: " . a:msg
	endif
endfunction



" 3. Indenter
" ===========
function! GetJsIndent(lnum)
	" Grab the first non-comment line prior to this line
	let pnum = s:GetNonCommentLine(a:lnum-1)

	" First line, start at indent = 0
	if pnum == 0
		call s:Log("No, noncomment lines prior to: ")
		return 0
	endif

	" Grab the second non-comment line prior to this line
	let ppnum = s:GetNonCommentLine(pnum-1)

	call s:Log("Line: " . a:lnum)
	call s:Log("PLine: " . pnum)
	call s:Log("PPLine: " . ppnum)

	" Grab the lines themselves.
	let line = getline(a:lnum)
	let pline = getline(pnum)
	let ppline = getline(ppnum)

	" Determine the current level of indentation
	let ind = indent(pnum)

	" Handle: Mutli-Line Block Invocation/Function Declaration
	" ========================================================
	if pline =~ s:js_multi_beg . s:js_line_comment . '$'
		if line !~ s:js_multi_invok_end
			call s:Log("Pline matched multi invoke/declare")
			return ind + &sw
		endif 
	endif

	if pline =~ s:js_s_multi_end . s:js_line_comment . '$'
		call s:Log("Pline matched multi end without inline {")
		if line =~ s:js_object_beg . s:js_line_comment . '$'
			call s:Log("Line matched object beg")
			return ind - &sw
		else
			call s:Log("line didn't match object beginning")
			return ind 
		endif
	endif

	if pline =~ s:js_m_multi_end . s:js_line_comment . '$'
		call s:Log("Pline matched multi end with inline {")
		if line =~ s:js_object_end . s:js_line_comment . '$'
			call s:Log("Line matched object end")
			return ind - &sw
		else
			call s:Log("Line didn't matched object end")
			return ind
		endif
	endif

	if ppline =~ s:js_s_multi_end . s:js_line_comment . '$' &&
				\ pline !~ s:js_object_beg . s:js_line_comment . '$'
		call s:Log("PPLine matched multi invoke/declaration end without inline {")
		return ind - &sw
	endif

	" Handle: Multi-Line Invocation
	" =============================
	if pline =~ s:js_multi_invok_beg . s:js_line_comment . '$'
		call s:Log("PLine matched multi line invoke")
		if line =~ s:js_multi_invok_end . s:js_line_comment . '$'
			call s:Log("Pline matched multi line invoke end")
			return ind
		else 
			call s:Log("Pline didn't match multi line invoke end")
			return ind + &sw
		endif 
	endif

	if line =~ s:js_multi_invok_end . s:js_line_comment . '$'
		call s:Log("Pline matched multi invocation end")
		return ind - &sw
	endif


	" Handle: Switch Control Blocks
	" =============================
	if pline =~ s:js_m_switch_beg . s:js_line_comment . '$'
		call s:Log("PLine matched switch cntrl beginning")
		return ind
	endif

	if pline =~ s:js_switch_mid
		call s:Log("PLine matched switch cntrl mid")
		if line =~ s:js_switch_mid || line =~ s:js_object_end . s:js_line_comment . '$'
			call s:Log("Line matched a cntrl mid")
			return ind
		else
			call s:Log("Line didnt match a cntrl mid")
			return ind + &sw
		endif 
	endif

	if line =~ s:js_switch_mid " Doesn't need end anchor
		call s:Log("Line matched switch cntrl mid")
		return ind - &sw
	endif

	" Handle: Single Line Control Blocks
	" ==========================
	if pline =~ s:js_s_cntrl_beg . s:js_line_comment . '$'
		call s:Log("Pline matched single line control beg")
		if line =~ s:js_s_cntrl_mid. s:js_line_comment . '$' || line =~ s:js_object_beg. s:js_line_comment . '$'
			call s:Log("Line matched single line control mid")
			return ind
		else
			call s:Log("Line didn't match single line control mid")
			return ind + &sw
		endif
	endif

	if pline =~ s:js_s_cntrl_mid . s:js_line_comment . '$'
		call s:Log("Pline matched single line control mid")
		if line =~ s:js_s_cntrl_mid . s:js_line_comment . '$' || line =~ s:js_object_beg . s:js_line_comment . '$' 
			call s:Log("Line matched single line control mid")
			return ind
		else
			call s:Log("Line didn't match single line control mid")
			return ind + &sw
		endif
	endif

	if line =~ s:js_s_cntrl_mid . s:js_line_comment . '$'
		call s:Log("Line matched single line control mid")
		if pline =~ s:js_m_cntrl_end . s:js_line_comment . '$'
			call s:Log("PLine matched multi line control end")
			return ind
		else
			call s:Log("Pline didn't match object end")
			return ind - &sw
		endif
	endif

	if ( ppline =~ s:js_s_cntrl_beg . s:js_line_comment . '$' || ppline =~ s:js_s_cntrl_mid . s:js_line_comment . '$' ) &&
				\ pline !~ s:js_object_beg . s:js_line_comment . '$'
		call s:Log("PPLine matched single line control beg or mid")
		return ind - &sw
	endif


	" Handle: {}
	" ==========
	if line =~ '^[^{]*}' && !s:IsComment(a:lnum) && line !~ '"[^}]*}[^}]*"'
		call s:Log("Line matched closing bracket")

		" Save the cursor position.
		let curpos = getpos(".")

		" Set the cursor position to the beginning of the line (default
		" behavior when using ==)
		call setpos(".", [0, a:lnum, 1, 0])

		" Search for the opening tag
		let mnum = searchpair('{', '', '}', 'bW', 
					\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? s:syn_comment' )
		
		"Restore the cursor position
		call setpos(".", curpos)

		let mind = indent(mnum)
		let mline = getline(mnum)

		call s:Log("Matched found at: " . mnum)

		if mline =~ s:js_m_multi_end " Fixes multi line invocation
			call s:Log("MLine matched multi line invocation")
			return mind - &sw
		else
			return mind
		endif
	endif

	if pline =~ '{[^}]*$' && pline !~ '"[^{]*{[^{]*"'
		call s:Log("Pline matched opening {")
		return ind + &sw
	endif

	" Handle: []
	" ==========
	if line =~ '^[^\[]*\]' && !s:IsComment(a:lnum) && line !~ '"[^\]]*\][^\]]*"'
		call s:Log("Line matched closing ]")
		
		" Save the cursor position.
		let curpos = getpos(".")

		" Set the cursor position to the beginning of the line (default
		" behavior when using ==)
		call setpos(".", [0, a:lnum, 1, 0])

		" Search for the opening tag
		let mnum = searchpair('\[', '', '\]', 'bW', 
					\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? s:syn_comment' )
		
		"Restore the cursor position
		call setpos(".", curpos)

		call s:Log("Matched found at: " . mnum)
		return indent(mnum)
	endif

	if pline =~ '\[[^\]]*$' && pline !~ '"[^\[]*\[[^\[]*"'
		call s:Log("Pline matched opening [")
		return ind + &sw
	endif

	call s:Log("Line didn't match anything.  Retaining indent")
	return ind
endfunction
