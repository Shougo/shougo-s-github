" Vim syntax file
" Language:	objdump -D output
" Maintainer:	syndrowm <syndrowm@gmail.com>
" Last Change:	2010 Aug 13
" This is really just a modified version of syntax/asm.vim
" Have fun reversing.
" Modified by Matthias Kretz <kretz@kde.org> to look a little nicer for my
" tastes
" Modified by Shougo Matsushita <Shougo.Matsu@gmail.com>
" Some code from mixed.vim. http://www.vim.org/scripts/script.php?script_id=530

if exists("b:current_syntax")
  finish
endif

syn case ignore

" Read the C syntax to start with
runtime! syntax/c.vim
unlet b:current_syntax

" Match the labels and Assembly lines
syn match       cMixLabel                '^\x\+\s\+<.*>:$'
syn match       cMixAsm                  '^\s*\x\+:\s\+\x\+.*$' contains=asmLabel,decNumber,octNumber,hexNumber,binNumber,addressNum,machine,jumps,calls,alerts,xmmRegister,stackPointer,framePointer,instructionPtr,register,asmSpecialComment,asmComment,asmInclude,asmCond,asmMacro,asmDirective

"------------------------------------------------------------------
"   GUIDE
"
"  First Token breakdown 
"  00000084 <_main>:
"
"       ^       Beginning of line
"       \x\+    one or more hex
"       \s\+    one or more space
"       <.*>    zero or more characters enclosed within < >
"       :       literally :
"       $       End of Line.
"
"  Second Token breakdown
"  75:	69 64 0a 00 49 6e 76 	imul   $0x61766e49,0x0(%edx,%ecx,1),%esp
"
"       ^       Beginning of line
"       \s*     zero or more spaces
"       \x\+    one or more hex digit
"       :       literally ":"
"       \s\+    one or more space
"       \x\+    one or more hex
"       $       EOL
"-------------------------------------------------------------------

syn match asmLabel            '^\s*\x\+:'

" Various #'s as defined by GAS ref manual sec 3.6.2.1
" Technically, the first decNumber def is actually octal,
" since the value of 0-7 octal is the same as 0-7 decimal,
" I prefer to map it as decimal:
syn match decNumber		'0\+[1-7]\=[\t\n$,; ]'
syn match decNumber		'[1-9]\d*'
syn match octNumber		'0\o\+'
syn match hexNumber		'0[xX]\x\+'
syn match binNumber		'0[bB][01]*'
syn match machine		'\s\+\zs\x\+\ze\s\+'
syn match jumps			'\<j[a-z]\+\>'
syn match jumps			'\<jmpq\>'
syn match jumps			'\<retq\>'
syn match jumps			'\<leaveq\>'
syn match calls			'\<callq\?\>'
syn match alerts		'\*\*\+\w\+'

syn match xmmRegister		'\<xmm1\?\d\>'
syn match stackPointer		'\<[er]sp\>'
syn match framePointer		'\<[er]bp\>'
syn match instructionPtr	'\<[er]ip\>'
syn match register		'%\w\+'

syn match asmSpecialComment	';\*\*\*.*'
syn match asmComment		';.*'hs=s+1
syn match asmComment		'#.*'hs=s+1

syn match asmInclude		'\<\.include\>'
syn match asmCond		'\<\.if\>'
syn match asmCond		'\<\.else\>'
syn match asmCond		'\<\.endif\>'
syn match asmMacro		'\<\.macro\>'
syn match asmMacro		'\<\.endm\>'

syn match asmDirective		'\<\.[a-z][a-z]\+\>'


syn case match

" Define the default highlighting.
" The default methods for highlighting.  Can be overridden later
highlight def link asmSection	Special
highlight def link asmLabel	Label
highlight def link asmComment	Comment
highlight def link asmDirective	Statement

highlight def link asmInclude	Include
highlight def link asmCond	PreCondit
highlight def link asmMacro	Macro

highlight def link hexNumber	Type
highlight def link decNumber	Number
highlight def link octNumber	Number
highlight def link binNumber	Number
highlight def link machine 	Number	

highlight def link asmSpecialComment Comment
highlight def link asmType	Type

highlight def link jumps		PreProc
highlight def link calls		PreProc
highlight def link alerts		VisualNOS

highlight def link cMixLabel               DiffDelete

highlight def link asmSpecialComment Special
highlight def link asmType Type
highlight def link register Identifier
highlight def link xmmRegister Identifier
highlight def link framePointer Identifier
highlight def link instructionPtr Identifier

let b:current_syntax = "asm"

" vim: ts=8
