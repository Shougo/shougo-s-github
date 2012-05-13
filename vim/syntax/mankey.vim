" Vim syntax file
"  Language:	Man keywords page
"  Maintainer:	Charles E. Campbell, Jr.
"  Last Change:	Aug 12, 2008
"  Version:    	2
"    (used by plugin/manpageview.vim)
"
"  History:
"    2: hi default link -> hi default link
"    1:	The Beginning
" ---------------------------------------------------------------------
"  Initialization:
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
syn clear

" ---------------------------------------------------------------------
"  Highlighting Groups: matches, ranges, and keywords
syn match mankeyTopic	'^\S\+'		skipwhite nextgroup=mankeyType,mankeyBook
syn match mankeyType	'\[\S\+\]'	contained skipwhite nextgroup=mankeySep,mankeyBook contains=mankeyTypeDelim
syn match mankeyTypeDelim	'[[\]]'	contained
syn region mankeyBook	matchgroup=Delimiter start='(' end=')'	contained skipwhite nextgroup=mankeySep
syn match mankeySep		'\s\+-\s\+'	

" ---------------------------------------------------------------------
"  Highlighting Colorizing Links:
command! -nargs=+ HiLink hi default link <args>

HiLink mankeyTopic		Statement
HiLink mankeyType		Type
HiLink mankeyBook		Special
HiLink mankeyTypeDelim	Delimiter
HiLink mankeySep		Delimiter

delc HiLink
let b:current_syntax = "mankey"
