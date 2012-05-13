" Vim syntax file
" Language:	Scheme (R5RS)
" Last Change:	2007 Jun 16
" Maintainer:	Sergey Khorev <sergey.khorev@gmail.com>
" Original author:	Dirk van Deun <dirk@igwe.vub.ac.be>

" Modifier:	yamada <yamada-remove-this-part@tir.jp>
"		( http://e.tir.jp/wiliki?vim:scheme.vim )
" $Id$

" This script incorrectly recognizes some junk input as numerals:
" parsing the complete system of Scheme numerals using the pattern
" language is practically impossible: I did a lax approximation.
 
" MzScheme extensions can be activated with setting is_mzscheme variable
" Gauche extensions can be activated with setting is_gauche variable

" Initializing:

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" this defines first for nested srfi-62 comment
" ( http://www.ac.cyberhome.ne.jp/~yakahaira/vimdoc/syntax.html#:syn-priority )
syn region schemeSrfi62CommentParen start="(" end=")" contains=schemeSrfi62CommentParen transparent
syn region schemeSrfi62CommentParen start="\[" end="\]" contains=schemeSrfi62CommentParen transparent

" Fascist highlighting: everything that doesn't fit the rules is an error...

syn match	schemeError	oneline    ![^ \t()\[\]";]*!
syn match	schemeError	oneline    ")"

" Quoted and backquoted stuff

syn region schemeQuoted matchgroup=Delimiter start="['`]" end=![ \t()\[\]";]!me=e-1 contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc

syn region schemeQuoted matchgroup=Delimiter start="['`](" matchgroup=Delimiter end=")" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeQuoted matchgroup=Delimiter start="['`]#(" matchgroup=Delimiter end=")" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc

syn region schemeStrucRestricted matchgroup=Delimiter start="(" matchgroup=Delimiter end=")" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeStrucRestricted matchgroup=Delimiter start="#(" matchgroup=Delimiter end=")" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc

" Popular Scheme extension:
" using [] as well as ()
syn region schemeQuoted matchgroup=Delimiter start="['`]\[" matchgroup=Delimiter end="\]" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeQuoted matchgroup=Delimiter start="['`]#\[" matchgroup=Delimiter end="\]" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeStrucRestricted matchgroup=Delimiter start="\[" matchgroup=Delimiter end="\]" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeStrucRestricted matchgroup=Delimiter start="#\[" matchgroup=Delimiter end="\]" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc

syn region schemeUnquote matchgroup=Delimiter start="," end=![ \t\[\]()";]!me=e-1 contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeUnquote matchgroup=Delimiter start=",@" end=![ \t\[\]()";]!me=e-1 contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc

syn region schemeUnquote matchgroup=Delimiter start=",(" end=")" contains=ALL
syn region schemeUnquote matchgroup=Delimiter start=",@(" end=")" contains=ALL

syn region schemeUnquote matchgroup=Delimiter start=",#(" end=")" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeUnquote matchgroup=Delimiter start=",@#(" end=")" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc

syn region schemeUnquote matchgroup=Delimiter start=",\[" end="\]" contains=ALL
syn region schemeUnquote matchgroup=Delimiter start=",@\[" end="\]" contains=ALL

syn region schemeUnquote matchgroup=Delimiter start=",#\[" end="\]" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc
syn region schemeUnquote matchgroup=Delimiter start=",@#\[" end="\]" contains=ALLBUT,schemeStruc,schemeSyntax,schemeFunc

" R5RS Scheme Functions and Syntax:

if version < 600
  set iskeyword=33,35-38,42,43,45-58,60-90,94,95,97-122,126,_
else
  setlocal iskeyword=33,35-38,42,43,45-58,60-90,94,95,97-122,126,_
endif

set lispwords=
set lispwords+=lambda,and,or,if,cond,case,define,let,let*,letrec
set lispwords+=begin,do,delay,set!,else,=>
set lispwords+=quote,quasiquote,unquote,unquote-splicing
set lispwords+=define-syntax,let-syntax,letrec-syntax,syntax-rules
syn keyword schemeSyntax lambda and or if cond case define let let* letrec
syn keyword schemeSyntax begin do delay set! else =>
syn keyword schemeSyntax quote quasiquote unquote unquote-splicing
syn keyword schemeSyntax define-syntax let-syntax letrec-syntax syntax-rules

syn keyword schemeFunc not boolean? eq? eqv? equal? pair? cons car cdr set-car!
syn keyword schemeFunc set-cdr! caar cadr cdar cddr caaar caadr cadar caddr
syn keyword schemeFunc cdaar cdadr cddar cdddr caaaar caaadr caadar caaddr
syn keyword schemeFunc cadaar cadadr caddar cadddr cdaaar cdaadr cdadar cdaddr
syn keyword schemeFunc cddaar cddadr cdddar cddddr null? list? list length
syn keyword schemeFunc append reverse list-ref memq memv member assq assv assoc
syn keyword schemeFunc symbol? symbol->string string->symbol number? complex?
syn keyword schemeFunc real? rational? integer? exact? inexact? = < > <= >=
syn keyword schemeFunc zero? positive? negative? odd? even? max min + * - / abs
syn keyword schemeFunc quotient remainder modulo gcd lcm numerator denominator
syn keyword schemeFunc floor ceiling truncate round rationalize exp log sin cos
syn keyword schemeFunc tan asin acos atan sqrt expt make-rectangular make-polar
syn keyword schemeFunc real-part imag-part magnitude angle exact->inexact
syn keyword schemeFunc inexact->exact number->string string->number char=?
syn keyword schemeFunc char-ci=? char<? char-ci<? char>? char-ci>? char<=?
syn keyword schemeFunc char-ci<=? char>=? char-ci>=? char-alphabetic? char?
syn keyword schemeFunc char-numeric? char-whitespace? char-upper-case?
syn keyword schemeFunc char-lower-case?
syn keyword schemeFunc char->integer integer->char char-upcase char-downcase
syn keyword schemeFunc string? make-string string string-length string-ref
syn keyword schemeFunc string-set! string=? string-ci=? string<? string-ci<?
syn keyword schemeFunc string>? string-ci>? string<=? string-ci<=? string>=?
syn keyword schemeFunc string-ci>=? substring string-append vector? make-vector
syn keyword schemeFunc vector vector-length vector-ref vector-set! procedure?
syn keyword schemeFunc apply map for-each call-with-current-continuation
syn keyword schemeFunc call-with-input-file call-with-output-file input-port?
syn keyword schemeFunc output-port? current-input-port current-output-port
syn keyword schemeFunc open-input-file open-output-file close-input-port
syn keyword schemeFunc close-output-port eof-object? read read-char peek-char
syn keyword schemeFunc write display newline write-char call/cc
syn keyword schemeFunc list-tail string->list list->string string-copy
syn keyword schemeFunc string-fill! vector->list list->vector vector-fill!
syn keyword schemeFunc force with-input-from-file with-output-to-file
syn keyword schemeFunc char-ready? load transcript-on transcript-off eval
syn keyword schemeFunc dynamic-wind port? values call-with-values
syn keyword schemeFunc scheme-report-environment null-environment
syn keyword schemeFunc interaction-environment

" ... so that a single + or -, inside a quoted context, would not be
" interpreted as a number (outside such contexts, it's a schemeFunc)

syn match	schemeDelimiter	oneline    !\.[ \t\[\]()";]!me=e-1
syn match	schemeDelimiter	oneline    !\.$!
" ... and a single dot is not a number but a delimiter

" This keeps all other stuff unhighlighted, except *stuff* and <stuff>:

syn match	schemeOther	oneline    ,[a-z!$%&*/:<=>?^_~+@%-][-a-z!$%&*/:<=>?^_~0-9+.@%]*,
syn match	schemeError	oneline    ,[a-z!$%&*/:<=>?^_~+@%-][-a-z!$%&*/:<=>?^_~0-9+.@%]*[^-a-z!$%&*/:<=>?^_~0-9+.@ \t\[\]()";]\+[^ \t\[\]()";]*,

syn match	schemeOther	oneline    "\.\.\."
syn match	schemeError	oneline    !\.\.\.[^ \t\[\]()";]\+!
" ... a special identifier

syn match	schemeConstant	oneline    ,\*[-a-z!$%&*/:<=>?^_~0-9+.@]*\*[ \t\[\]()";],me=e-1
syn match	schemeConstant	oneline    ,\*[-a-z!$%&*/:<=>?^_~0-9+.@]*\*$,
syn match	schemeError	oneline    ,\*[-a-z!$%&*/:<=>?^_~0-9+.@]*\*[^-a-z!$%&*/:<=>?^_~0-9+.@ \t\[\]()";]\+[^ \t\[\]()";]*,

syn match	schemeConstant	oneline    ,<[-a-z!$%&*/:<=>?^_~0-9+.@]*>[ \t\[\]()";],me=e-1
syn match	schemeConstant	oneline    ,<[-a-z!$%&*/:<=>?^_~0-9+.@]*>$,
syn match	schemeError	oneline    ,<[-a-z!$%&*/:<=>?^_~0-9+.@]*>[^-a-z!$%&*/:<=>?^_~0-9+.@ \t\[\]()";]\+[^ \t\[\]()";]*,

" Non-quoted lists, and strings:

syn region schemeStruc matchgroup=Delimiter start="(" matchgroup=Delimiter end=")" contains=ALL
syn region schemeStruc matchgroup=Delimiter start="#(" matchgroup=Delimiter end=")" contains=ALL

syn region schemeStruc matchgroup=Delimiter start="\[" matchgroup=Delimiter end="\]" contains=ALL
syn region schemeStruc matchgroup=Delimiter start="#\[" matchgroup=Delimiter end="\]" contains=ALL

" Simple literals:
syn region schemeString start=+\%(\\\)\@<!"+ skip=+\\[\\"]+ end=+"+

" Comments:

syn match	schemeSrfi62Comment	oneline    ,#;[a-z!$%&*/:<=>?^_~+@#%-][-a-z!$%&*/:<=>?^_~0-9+.@#%]*,
syn match	schemeError		oneline    ,#;[a-z!$%&*/:<=>?^_~+@#%-][-a-z!$%&*/:<=>?^_~0-9+.@#%]*[^-a-z!$%&*/:<=>?^_~0-9+.@ \t\[\]()";]\+[^ \t\[\]()";]*,
syn match	schemeSrfi62Comment	oneline    ,#;['`][a-z!$%&*/:<=>?^_~+@#%-][-a-z!$%&*/:<=>?^_~0-9+.@#%]*,
syn match	schemeError		oneline    ,#;['`][a-z!$%&*/:<=>?^_~+@#%-][-a-z!$%&*/:<=>?^_~0-9+.@#%]*[^-a-z!$%&*/:<=>?^_~0-9+.@ \t\[\]()";]\+[^ \t\[\]()";]*,
syn region schemeSrfi62Comment matchgroup=Comment start="#;(" matchgroup=Comment end=")" contains=schemeSrfi62CommentParen
syn region schemeSrfi62Comment matchgroup=Comment start="#;\[" matchgroup=Comment end="\]" contains=schemeSrfi62CommentParen
syn region schemeSrfi62Comment matchgroup=Comment start="#;['`](" matchgroup=Comment end=")" contains=schemeSrfi62CommentParen
syn region schemeSrfi62Comment matchgroup=Comment start="#;['`]\[" matchgroup=Comment end="\]" contains=schemeSrfi62CommentParen
syn match	schemeComment	";.*$"

" Writing out the complete description of Scheme numerals without
" using variables is a day's work for a trained secretary...

syn match	schemeOther	oneline    ![+-][ \t\[\]()";]!me=e-1
syn match	schemeOther	oneline    ![+-]$!
"
" This is a useful lax approximation:
syn match	schemeNumber	oneline    "[-+0-9.][-#+/0-9a-f@i.boxesfdl]*"
syn match	schemeError	oneline    ![-+0-9.][-#+/0-9a-f@i.boxesfdl]*[^-#+/0-9a-f@i.boxesfdl \t\[\]()";][^ \t\[\]()";]*!
syn match	schemeNumber	oneline    "#[-#+/0-9a-f@i.boxesfdl]+"
syn match	schemeError	oneline    !#[-#+/0-9a-f@i.boxesfdl]+[^-#+/0-9a-f@i.boxesfdl \t\[\]()";][^ \t\[\]()";]*!
syn match	schemeNumber	oneline    "[-+]inf\.0"
syn match	schemeError	oneline    "[-+]inf\.0[^-#+/0-9a-f@i.boxesfdl \t\[\]()";][^ \t\[\]()";]*"
syn match	schemeNumber	oneline    "+nan\.0"
syn match	schemeError	oneline    "+nan\.0[^-#+/0-9a-f@i.boxesfdl \t\[\]()";][^ \t\[\]()";]*"

syn match	schemeBoolean	oneline    "#[tf]"
syn match	schemeError	oneline    !#[tf][^ \t\[\]()";]\+!

syn match	schemeChar	oneline    "#\\"
syn match	schemeChar	oneline    "#\\."
syn match	schemeError	oneline    !#\\.[^ \t\[\]()";]\+!
syn match	schemeChar	oneline    "#\\space"
syn match	schemeError	oneline    !#\\space[^ \t\[\]()";]\+!
syn match	schemeChar	oneline    "#\\newline"
syn match	schemeError	oneline    !#\\newline[^ \t\[\]()";]\+!

if exists("b:is_mzscheme") || exists("is_mzscheme")
    " MzScheme extensions
    " multiline comment
    syn region	schemeComment start="#|" end="|#"

    " #%xxx are the special MzScheme identifiers
    syn match schemeOther oneline    "#%[-a-z!$%&*/:<=>?^_~0-9+.@#%]\+"
    " anything limited by |'s is identifier
    syn match schemeOther oneline    "|[^|]\+|"

    syn match	schemeChar	oneline    "#\\\%(return\|tab\)"

    " Modules require stmt
    syn keyword schemeExtSyntax module require dynamic-require lib prefix all-except prefix-all-except rename
    " modules provide stmt
    syn keyword schemeExtSyntax provide struct all-from all-from-except all-defined all-defined-except
    " Other from MzScheme
    syn keyword schemeExtSyntax with-handlers when unless instantiate define-struct case-lambda syntax-case
    syn keyword schemeExtSyntax free-identifier=? bound-identifier=? module-identifier=? syntax-object->datum
    syn keyword schemeExtSyntax datum->syntax-object
    syn keyword schemeExtSyntax let-values let*-values letrec-values set!-values fluid-let parameterize begin0
    syn keyword schemeExtSyntax error raise opt-lambda define-values unit unit/sig define-signature 
    syn keyword schemeExtSyntax invoke-unit/sig define-values/invoke-unit/sig compound-unit/sig import export
    syn keyword schemeExtSyntax link syntax quasisyntax unsyntax with-syntax

    syn keyword schemeExtFunc format system-type current-extension-compiler current-extension-linker
    syn keyword schemeExtFunc use-standard-linker use-standard-compiler
    syn keyword schemeExtFunc find-executable-path append-object-suffix append-extension-suffix
    syn keyword schemeExtFunc current-library-collection-paths current-extension-compiler-flags make-parameter
    syn keyword schemeExtFunc current-directory build-path normalize-path current-extension-linker-flags
    syn keyword schemeExtFunc file-exists? directory-exists? delete-directory/files delete-directory delete-file
    syn keyword schemeExtFunc system compile-file system-library-subpath getenv putenv current-standard-link-libraries
    syn keyword schemeExtFunc remove* file-size find-files fold-files directory-list shell-execute split-path
    syn keyword schemeExtFunc current-error-port process/ports process printf fprintf open-input-string open-output-string
    syn keyword schemeExtFunc get-output-string
    " exceptions
    syn keyword schemeExtFunc exn exn:application:arity exn:application:continuation exn:application:fprintf:mismatch
    syn keyword schemeExtFunc exn:application:mismatch exn:application:type exn:application:mismatch exn:break exn:i/o:filesystem exn:i/o:port
    syn keyword schemeExtFunc exn:i/o:port:closed exn:i/o:tcp exn:i/o:udp exn:misc exn:misc:application exn:misc:unsupported exn:module exn:read
    syn keyword schemeExtFunc exn:read:non-char exn:special-comment exn:syntax exn:thread exn:user exn:variable exn:application:mismatch
    syn keyword schemeExtFunc exn? exn:application:arity? exn:application:continuation? exn:application:fprintf:mismatch? exn:application:mismatch?
    syn keyword schemeExtFunc exn:application:type? exn:application:mismatch? exn:break? exn:i/o:filesystem? exn:i/o:port? exn:i/o:port:closed?
    syn keyword schemeExtFunc exn:i/o:tcp? exn:i/o:udp? exn:misc? exn:misc:application? exn:misc:unsupported? exn:module? exn:read? exn:read:non-char?
    syn keyword schemeExtFunc exn:special-comment? exn:syntax? exn:thread? exn:user? exn:variable? exn:application:mismatch?
    " Command-line parsing
    syn keyword schemeExtFunc command-line current-command-line-arguments once-any help-labels multi once-each 

    " syntax quoting, unquoting and quasiquotation
    syn region schemeUnquote matchgroup=Delimiter start="#," end=![ \t\[\]()";]!me=e-1 contains=ALL
    syn region schemeUnquote matchgroup=Delimiter start="#,@" end=![ \t\[\]()";]!me=e-1 contains=ALL
    syn region schemeUnquote matchgroup=Delimiter start="#,(" end=")" contains=ALL
    syn region schemeUnquote matchgroup=Delimiter start="#,@(" end=")" contains=ALL
    syn region schemeUnquote matchgroup=Delimiter start="#,\[" end="\]" contains=ALL
    syn region schemeUnquote matchgroup=Delimiter start="#,@\[" end="\]" contains=ALL
    syn region schemeQuoted matchgroup=Delimiter start="#['`]" end=![ \t()\[\]";]!me=e-1 contains=ALL
    syn region schemeQuoted matchgroup=Delimiter start="#['`](" matchgroup=Delimiter end=")" contains=ALL
endif


if exists("b:is_chicken") || exists("is_chicken")
    " multiline comment
    syntax region schemeMultilineComment start=/#|/ end=/|#/ contains=schemeMultilineComment

    syn match schemeOther oneline    "##[-a-z!$%&*/:<=>?^_~0-9+.@#%]\+"
    syn match schemeExtSyntax oneline    "#:[-a-z!$%&*/:<=>?^_~0-9+.@#%]\+"

    syn keyword schemeExtSyntax unit uses declare hide foreign-declare foreign-parse foreign-parse/spec
    syn keyword schemeExtSyntax foreign-lambda foreign-lambda* define-external define-macro load-library
    syn keyword schemeExtSyntax let-values let*-values letrec-values ->string require-extension
    syn keyword schemeExtSyntax let-optionals let-optionals* define-foreign-variable define-record
    syn keyword schemeExtSyntax pointer tag-pointer tagged-pointer? define-foreign-type
    syn keyword schemeExtSyntax require require-for-syntax cond-expand and-let* receive argc+argv
    syn keyword schemeExtSyntax fixnum? fx= fx> fx< fx>= fx<= fxmin fxmax
    syn keyword schemeExtFunc ##core#inline ##sys#error ##sys#update-errno

    " here-string
    syn region schemeString start=+#<<\s*\z(.*\)+ end=+^\z1$+
 
    if filereadable(expand("<sfile>:p:h")."/cpp.vim")
	unlet! b:current_syntax
	syn include @ChickenC <sfile>:p:h/cpp.vim
	syn region ChickenC matchgroup=schemeOther start=+(\@<=foreign-declare "+ end=+")\@=+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+foreign-declare\s*#<<\z(.*\)$+hs=s+15 end=+^\z1$+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeOther start=+(\@<=foreign-parse "+ end=+")\@=+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+foreign-parse\s*#<<\z(.*\)$+hs=s+13 end=+^\z1$+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeOther start=+(\@<=foreign-parse/spec "+ end=+")\@=+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+foreign-parse/spec\s*#<<\z(.*\)$+hs=s+18 end=+^\z1$+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+#>+ end=+<#+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+#>?+ end=+<#+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+#>!+ end=+<#+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+#>\$+ end=+<#+ contains=@ChickenC
	syn region ChickenC matchgroup=schemeComment start=+#>%+ end=+<#+ contains=@ChickenC
    endif

    " suggested by Alex Queiroz
    syn match schemeExtSyntax oneline    "#![-a-z!$%&*/:<=>?^_~0-9+.@#%]\+"
    syn region schemeString start=+#<#\s*\z(.*\)+ end=+^\z1$+ 
endif


if exists("b:is_gauche") || exists("is_gauche")
    " Gauche extensions
    " multiline comment
    syntax region schemeMultilineComment start=/#|/ end=/|#/ contains=schemeMultilineComment

    " #/xxx/ are the special Gauche identifiers for regexp
    syn region schemeRegexp start=+\%(\\\)\@<!#/+ skip=+\\[\\/]+ end=+/+

    " anything limited by |'s is identifier
    syn match schemeOther oneline    "|[^|]\+|"

    " SharpBang
    syn match	schemeSharpBang	oneline    "#!.*"

    " include (use hoge)
    syn match	schemeInclude	oneline    "(use .*)"
    syn match	schemeInclude	oneline    "(require .*)"
    syn match	schemeInclude	oneline    "(import .*)"

    " misc
    syn match	schemeInterpolation	oneline    "#`"
    syn match	schemeInterpolation	oneline    "#?="

    " char
    "syn match	schemeChar	oneline    "#\\space"
    "syn match	schemeError	oneline    !#\\space[^ \t\[\]()";]\+!
    "syn match	schemeChar	oneline    "#\\newline"
    "syn match	schemeError	oneline    !#\\newline[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\nl"
    syn match	schemeError	oneline    !#\\nl[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\lf"
    syn match	schemeError	oneline    !#\\lf[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\return"
    syn match	schemeError	oneline    !#\\return[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\cr"
    syn match	schemeError	oneline    !#\\cr[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\tab"
    syn match	schemeError	oneline    !#\\tab[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\ht"
    syn match	schemeError	oneline    !#\\ht[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\page"
    syn match	schemeError	oneline    !#\\page[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\esc"
    syn match	schemeError	oneline    !#\\esc[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\escape"
    syn match	schemeError	oneline    !#\\escape[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\del"
    syn match	schemeError	oneline    !#\\del[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\delete"
    syn match	schemeError	oneline    !#\\delete[^ \t\[\]()";]\+!
    syn match	schemeChar	oneline    "#\\null"
    syn match	schemeError	oneline    !#\\null[^ \t\[\]()";]\+!

    " this part was auto-generated.
    " module
    syn keyword schemeExtFunc binary.io
    syn keyword schemeExtFunc binary.pack
    syn keyword schemeExtFunc compat.jfilter
    syn keyword schemeExtFunc compat.norational
    syn keyword schemeExtFunc compat.stk
    syn keyword schemeExtFunc control.job
    syn keyword schemeExtFunc control.thread-pool
    syn keyword schemeExtFunc crypt.bcrypt
    syn keyword schemeExtFunc dbd.null
    syn keyword schemeExtFunc dbi
    syn keyword schemeExtFunc dbm
    syn keyword schemeExtFunc dbm.fsdbm
    syn keyword schemeExtFunc dbm.gdbm
    syn keyword schemeExtFunc display-error
    syn keyword schemeExtFunc file.filter
    syn keyword schemeExtFunc file.util
    syn keyword schemeExtFunc gauche.array
    syn keyword schemeExtFunc gauche.auxsys
    syn keyword schemeExtFunc gauche.cgen
    syn keyword schemeExtFunc gauche.cgen.cise
    syn keyword schemeExtFunc gauche.cgen.literal
    syn keyword schemeExtFunc gauche.cgen.precomp
    syn keyword schemeExtFunc gauche.cgen.stub
    syn keyword schemeExtFunc gauche.cgen.type
    syn keyword schemeExtFunc gauche.cgen.unit
    syn keyword schemeExtFunc gauche.charconv
    syn keyword schemeExtFunc gauche.collection
    syn keyword schemeExtFunc gauche.condutil
    syn keyword schemeExtFunc gauche.config
    syn keyword schemeExtFunc gauche.defvalues
    syn keyword schemeExtFunc gauche.dictionary
    syn keyword schemeExtFunc gauche.experimental.app
    syn keyword schemeExtFunc gauche.experimental.lamb
    syn keyword schemeExtFunc gauche.experimental.ref
    syn keyword schemeExtFunc gauche.fcntl
    syn keyword schemeExtFunc gauche.fileutil
    syn keyword schemeExtFunc gauche.hashutil
    syn keyword schemeExtFunc gauche.hook
    syn keyword schemeExtFunc gauche.interactive
    syn keyword schemeExtFunc gauche.interactive.info
    syn keyword schemeExtFunc gauche.interpolate
    syn keyword schemeExtFunc gauche.libutil
    syn keyword schemeExtFunc gauche.listener
    syn keyword schemeExtFunc gauche.logger
    syn keyword schemeExtFunc gauche.macroutil
    syn keyword schemeExtFunc gauche.modutil
    syn keyword schemeExtFunc gauche.mop.instance-pool
    syn keyword schemeExtFunc gauche.mop.propagate
    syn keyword schemeExtFunc gauche.mop.singleton
    syn keyword schemeExtFunc gauche.mop.validator
    syn keyword schemeExtFunc gauche.net
    syn keyword schemeExtFunc gauche.package
    syn keyword schemeExtFunc gauche.package.build
    syn keyword schemeExtFunc gauche.package.compile
    syn keyword schemeExtFunc gauche.package.fetch
    syn keyword schemeExtFunc gauche.package.util
    syn keyword schemeExtFunc gauche.parameter
    syn keyword schemeExtFunc gauche.parseopt
    syn keyword schemeExtFunc gauche.partcont
    syn keyword schemeExtFunc gauche.portutil
    syn keyword schemeExtFunc gauche.procedure
    syn keyword schemeExtFunc gauche.process
    syn keyword schemeExtFunc gauche.record
    syn keyword schemeExtFunc gauche.regexp
    syn keyword schemeExtFunc gauche.reload
    syn keyword schemeExtFunc gauche.selector
    syn keyword schemeExtFunc gauche.sequence
    syn keyword schemeExtFunc gauche.serializer
    syn keyword schemeExtFunc gauche.sortutil
    syn keyword schemeExtFunc gauche.stringutil
    syn keyword schemeExtFunc gauche.syslog
    syn keyword schemeExtFunc gauche.termios
    syn keyword schemeExtFunc gauche.test
    syn keyword schemeExtFunc gauche.threads
    syn keyword schemeExtFunc gauche.time
    syn keyword schemeExtFunc gauche.treeutil
    syn keyword schemeExtFunc gauche.uvector
    syn keyword schemeExtFunc gauche.version
    syn keyword schemeExtFunc gauche.vm.debugger
    syn keyword schemeExtFunc gauche.vm.insn
    syn keyword schemeExtFunc gauche.vm.insn-core
    syn keyword schemeExtFunc gauche.vm.profiler
    syn keyword schemeExtFunc gauche.vport
    syn keyword schemeExtFunc math.const
    syn keyword schemeExtFunc math.mt-random
    syn keyword schemeExtFunc next-method
    syn keyword schemeExtFunc parser.peg
    syn keyword schemeExtFunc rfc.822
    syn keyword schemeExtFunc rfc.base64
    syn keyword schemeExtFunc rfc.cookie
    syn keyword schemeExtFunc rfc.ftp
    syn keyword schemeExtFunc rfc.hmac
    syn keyword schemeExtFunc rfc.http
    syn keyword schemeExtFunc rfc.icmp
    syn keyword schemeExtFunc rfc.ip
    syn keyword schemeExtFunc rfc.json
    syn keyword schemeExtFunc rfc.md5
    syn keyword schemeExtFunc rfc.mime
    syn keyword schemeExtFunc rfc.quoted-printable
    syn keyword schemeExtFunc rfc.sha
    syn keyword schemeExtFunc rfc.sha1
    syn keyword schemeExtFunc rfc.uri
    syn keyword schemeExtFunc rfc.zlib
    syn keyword schemeExtFunc srfi-0
    syn keyword schemeExtFunc srfi-1
    syn keyword schemeExtFunc srfi-11
    syn keyword schemeExtFunc srfi-13
    syn keyword schemeExtFunc srfi-14
    syn keyword schemeExtFunc srfi-19
    syn keyword schemeExtFunc srfi-26
    syn keyword schemeExtFunc srfi-27
    syn keyword schemeExtFunc srfi-29
    syn keyword schemeExtFunc srfi-29.bundle
    syn keyword schemeExtFunc srfi-29.format
    syn keyword schemeExtFunc srfi-31
    syn keyword schemeExtFunc srfi-37
    syn keyword schemeExtFunc srfi-4
    syn keyword schemeExtFunc srfi-42
    syn keyword schemeExtFunc srfi-43
    syn keyword schemeExtFunc srfi-5
    syn keyword schemeExtFunc srfi-55
    syn keyword schemeExtFunc srfi-7
    syn keyword schemeExtFunc srfi-9
    syn keyword schemeExtFunc srfi-98
    syn keyword schemeExtFunc sxml.adaptor
    syn keyword schemeExtFunc sxml.serializer
    syn keyword schemeExtFunc sxml.ssax
    syn keyword schemeExtFunc sxml.sxpath
    syn keyword schemeExtFunc sxml.to-html
    syn keyword schemeExtFunc sxml.tools
    syn keyword schemeExtFunc sxml.tree-trans
    syn keyword schemeExtFunc text.csv
    syn keyword schemeExtFunc text.diff
    syn keyword schemeExtFunc text.gettext
    syn keyword schemeExtFunc text.html-lite
    syn keyword schemeExtFunc text.info
    syn keyword schemeExtFunc text.parse
    syn keyword schemeExtFunc text.progress
    syn keyword schemeExtFunc text.sql
    syn keyword schemeExtFunc text.tr
    syn keyword schemeExtFunc text.tree
    syn keyword schemeExtFunc util.combinations
    syn keyword schemeExtFunc util.digest
    syn keyword schemeExtFunc util.isomorph
    syn keyword schemeExtFunc util.lcs
    syn keyword schemeExtFunc util.list
    syn keyword schemeExtFunc util.match
    syn keyword schemeExtFunc util.queue
    syn keyword schemeExtFunc util.rbtree
    syn keyword schemeExtFunc util.record
    syn keyword schemeExtFunc util.relation
    syn keyword schemeExtFunc util.sparse
    syn keyword schemeExtFunc util.stream
    syn keyword schemeExtFunc util.toposort
    syn keyword schemeExtFunc util.tree
    syn keyword schemeExtFunc util.trie
    syn keyword schemeExtFunc www.cgi
    syn keyword schemeExtFunc www.cgi-test
    syn keyword schemeExtFunc www.cgi.test


    " syntax
    syn keyword schemeExtSyntax %macroexpand
    set lispwords+=%macroexpand
    syn keyword schemeExtSyntax %macroexpand-1
    set lispwords+=%macroexpand-1
    syn keyword schemeExtSyntax and-let*
    set lispwords+=and-let*
    syn keyword schemeExtSyntax current-module
    set lispwords+=current-module
    syn keyword schemeExtSyntax define-class
    set lispwords+=define-class
    syn keyword schemeExtSyntax define-constant
    set lispwords+=define-constant
    syn keyword schemeExtSyntax define-generic
    set lispwords+=define-generic
    syn keyword schemeExtSyntax define-in-module
    set lispwords+=define-in-module
    syn keyword schemeExtSyntax define-inline
    set lispwords+=define-inline
    syn keyword schemeExtSyntax define-macro
    set lispwords+=define-macro
    syn keyword schemeExtSyntax define-method
    set lispwords+=define-method
    syn keyword schemeExtSyntax define-module
    set lispwords+=define-module
    syn keyword schemeExtSyntax eval-when
    set lispwords+=eval-when
    syn keyword schemeExtSyntax export
    set lispwords+=export
    syn keyword schemeExtSyntax export-all
    set lispwords+=export-all
    syn keyword schemeExtSyntax extend
    set lispwords+=extend
    syn keyword schemeExtSyntax import
    set lispwords+=import
    syn keyword schemeExtSyntax include
    set lispwords+=include
    syn keyword schemeExtSyntax lazy
    set lispwords+=lazy
    syn keyword schemeExtSyntax receive
    set lispwords+=receive
    syn keyword schemeExtSyntax require
    set lispwords+=require
    syn keyword schemeExtSyntax select-module
    set lispwords+=select-module
    syn keyword schemeExtSyntax unless
    set lispwords+=unless
    syn keyword schemeExtSyntax when
    set lispwords+=when
    syn keyword schemeExtSyntax with-module
    set lispwords+=with-module


    " macro
    syn keyword schemeExtSyntax $
    set lispwords+=$
    syn keyword schemeExtSyntax $*
    set lispwords+=$*
    syn keyword schemeExtSyntax $<<
    set lispwords+=$<<
    syn keyword schemeExtSyntax $do
    set lispwords+=$do
    syn keyword schemeExtSyntax $do*
    set lispwords+=$do*
    syn keyword schemeExtSyntax $lazy
    set lispwords+=$lazy
    syn keyword schemeExtSyntax $many-chars
    set lispwords+=$many-chars
    syn keyword schemeExtSyntax $or
    set lispwords+=$or
    syn keyword schemeExtSyntax $satisfy
    set lispwords+=$satisfy
    syn keyword schemeExtSyntax %do-ec
    set lispwords+=%do-ec
    syn keyword schemeExtSyntax %ec-guarded-do-ec
    set lispwords+=%ec-guarded-do-ec
    syn keyword schemeExtSyntax %first-ec
    set lispwords+=%first-ec
    syn keyword schemeExtSyntax %guard-rec
    set lispwords+=%guard-rec
    syn keyword schemeExtSyntax %replace-keywords
    set lispwords+=%replace-keywords
    syn keyword schemeExtSyntax --
    set lispwords+=--
    syn keyword schemeExtSyntax ^
    set lispwords+=^
    syn keyword schemeExtSyntax ^*
    set lispwords+=^*
    syn keyword schemeExtSyntax ^-generator
    set lispwords+=^-generator
    syn keyword schemeExtSyntax ^.
    set lispwords+=^.
    syn keyword schemeExtSyntax ^_
    set lispwords+=^_
    syn keyword schemeExtSyntax ^a
    set lispwords+=^a
    syn keyword schemeExtSyntax ^b
    set lispwords+=^b
    syn keyword schemeExtSyntax ^c
    set lispwords+=^c
    syn keyword schemeExtSyntax ^d
    set lispwords+=^d
    syn keyword schemeExtSyntax ^e
    set lispwords+=^e
    syn keyword schemeExtSyntax ^f
    set lispwords+=^f
    syn keyword schemeExtSyntax ^g
    set lispwords+=^g
    syn keyword schemeExtSyntax ^h
    set lispwords+=^h
    syn keyword schemeExtSyntax ^i
    set lispwords+=^i
    syn keyword schemeExtSyntax ^j
    set lispwords+=^j
    syn keyword schemeExtSyntax ^k
    set lispwords+=^k
    syn keyword schemeExtSyntax ^l
    set lispwords+=^l
    syn keyword schemeExtSyntax ^m
    set lispwords+=^m
    syn keyword schemeExtSyntax ^n
    set lispwords+=^n
    syn keyword schemeExtSyntax ^o
    set lispwords+=^o
    syn keyword schemeExtSyntax ^p
    set lispwords+=^p
    syn keyword schemeExtSyntax ^q
    set lispwords+=^q
    syn keyword schemeExtSyntax ^r
    set lispwords+=^r
    syn keyword schemeExtSyntax ^s
    set lispwords+=^s
    syn keyword schemeExtSyntax ^t
    set lispwords+=^t
    syn keyword schemeExtSyntax ^u
    set lispwords+=^u
    syn keyword schemeExtSyntax ^v
    set lispwords+=^v
    syn keyword schemeExtSyntax ^w
    set lispwords+=^w
    syn keyword schemeExtSyntax ^x
    set lispwords+=^x
    syn keyword schemeExtSyntax ^y
    set lispwords+=^y
    syn keyword schemeExtSyntax ^z
    set lispwords+=^z
    syn keyword schemeExtSyntax add-load-path
    set lispwords+=add-load-path
    syn keyword schemeExtSyntax any?-ec
    set lispwords+=any?-ec
    syn keyword schemeExtSyntax append-ec
    set lispwords+=append-ec
    syn keyword schemeExtSyntax apropos
    set lispwords+=apropos
    syn keyword schemeExtSyntax assert
    set lispwords+=assert
    syn keyword schemeExtSyntax autoload
    set lispwords+=autoload
    syn keyword schemeExtSyntax begin0
    set lispwords+=begin0
    syn keyword schemeExtSyntax case-lambda
    set lispwords+=case-lambda
    syn keyword schemeExtSyntax check-arg
    set lispwords+=check-arg
    syn keyword schemeExtSyntax cond-expand
    set lispwords+=cond-expand
    syn keyword schemeExtSyntax cond-list
    set lispwords+=cond-list
    syn keyword schemeExtSyntax condition
    set lispwords+=condition
    syn keyword schemeExtSyntax cut
    set lispwords+=cut
    syn keyword schemeExtSyntax cute
    set lispwords+=cute
    syn keyword schemeExtSyntax debug-print
    set lispwords+=debug-print
    syn keyword schemeExtSyntax dec!
    set lispwords+=dec!
    syn keyword schemeExtSyntax declare
    set lispwords+=declare
    syn keyword schemeExtSyntax define-^x
    set lispwords+=define-^x
    syn keyword schemeExtSyntax define-cgen-literal
    set lispwords+=define-cgen-literal
    syn keyword schemeExtSyntax define-cise-expr
    set lispwords+=define-cise-expr
    syn keyword schemeExtSyntax define-cise-macro
    set lispwords+=define-cise-macro
    syn keyword schemeExtSyntax define-cise-stmt
    set lispwords+=define-cise-stmt
    syn keyword schemeExtSyntax define-cise-toplevel
    set lispwords+=define-cise-toplevel
    syn keyword schemeExtSyntax define-compiler-macro
    set lispwords+=define-compiler-macro
    syn keyword schemeExtSyntax define-condition-type
    set lispwords+=define-condition-type
    syn keyword schemeExtSyntax define-record-type
    set lispwords+=define-record-type
    syn keyword schemeExtSyntax define-values
    set lispwords+=define-values
    syn keyword schemeExtSyntax do-ec
    set lispwords+=do-ec
    syn keyword schemeExtSyntax do-ec:do
    set lispwords+=do-ec:do
    syn keyword schemeExtSyntax dolist
    set lispwords+=dolist
    syn keyword schemeExtSyntax dotimes
    set lispwords+=dotimes
    syn keyword schemeExtSyntax ec-guarded-do-ec
    set lispwords+=ec-guarded-do-ec
    syn keyword schemeExtSyntax ec-simplify
    set lispwords+=ec-simplify
    syn keyword schemeExtSyntax every?-ec
    set lispwords+=every?-ec
    syn keyword schemeExtSyntax export-if-defined
    set lispwords+=export-if-defined
    syn keyword schemeExtSyntax first-ec
    set lispwords+=first-ec
    syn keyword schemeExtSyntax fluid-let
    set lispwords+=fluid-let
    syn keyword schemeExtSyntax fold-ec
    set lispwords+=fold-ec
    syn keyword schemeExtSyntax fold3-ec
    set lispwords+=fold3-ec
    syn keyword schemeExtSyntax get-keyword*
    set lispwords+=get-keyword*
    syn keyword schemeExtSyntax get-optional
    set lispwords+=get-optional
    syn keyword schemeExtSyntax guard
    set lispwords+=guard
    syn keyword schemeExtSyntax http-cond-receiver
    set lispwords+=http-cond-receiver
    syn keyword schemeExtSyntax if-let1
    set lispwords+=if-let1
    syn keyword schemeExtSyntax inc!
    set lispwords+=inc!
    syn keyword schemeExtSyntax inline-stub
    set lispwords+=inline-stub
    syn keyword schemeExtSyntax last-ec
    set lispwords+=last-ec
    syn keyword schemeExtSyntax let*-values
    set lispwords+=let*-values
    syn keyword schemeExtSyntax let-args
    set lispwords+=let-args
    syn keyword schemeExtSyntax let-keywords
    set lispwords+=let-keywords
    syn keyword schemeExtSyntax let-keywords*
    set lispwords+=let-keywords*
    syn keyword schemeExtSyntax let-optionals*
    set lispwords+=let-optionals*
    syn keyword schemeExtSyntax let-string-start+end
    set lispwords+=let-string-start+end
    syn keyword schemeExtSyntax let-values
    set lispwords+=let-values
    syn keyword schemeExtSyntax let/cc
    set lispwords+=let/cc
    syn keyword schemeExtSyntax let1
    set lispwords+=let1
    syn keyword schemeExtSyntax list-ec
    set lispwords+=list-ec
    syn keyword schemeExtSyntax make-option-parser
    set lispwords+=make-option-parser
    syn keyword schemeExtSyntax match
    set lispwords+=match
    syn keyword schemeExtSyntax match-define
    set lispwords+=match-define
    syn keyword schemeExtSyntax match-lambda
    set lispwords+=match-lambda
    syn keyword schemeExtSyntax match-lambda*
    set lispwords+=match-lambda*
    syn keyword schemeExtSyntax match-let
    set lispwords+=match-let
    syn keyword schemeExtSyntax match-let*
    set lispwords+=match-let*
    syn keyword schemeExtSyntax match-let1
    set lispwords+=match-let1
    syn keyword schemeExtSyntax match-letrec
    set lispwords+=match-letrec
    syn keyword schemeExtSyntax max-ec
    set lispwords+=max-ec
    syn keyword schemeExtSyntax min-ec
    set lispwords+=min-ec
    syn keyword schemeExtSyntax parameterize
    set lispwords+=parameterize
    syn keyword schemeExtSyntax parse-options
    set lispwords+=parse-options
    syn keyword schemeExtSyntax pop!
    set lispwords+=pop!
    syn keyword schemeExtSyntax product-ec
    set lispwords+=product-ec
    syn keyword schemeExtSyntax program
    set lispwords+=program
    syn keyword schemeExtSyntax push!
    set lispwords+=push!
    syn keyword schemeExtSyntax rec
    set lispwords+=rec
    syn keyword schemeExtSyntax require-extension
    set lispwords+=require-extension
    syn keyword schemeExtSyntax reset
    set lispwords+=reset
    syn keyword schemeExtSyntax rlet1
    set lispwords+=rlet1
    syn keyword schemeExtSyntax rxmatch-case
    set lispwords+=rxmatch-case
    syn keyword schemeExtSyntax rxmatch-cond
    set lispwords+=rxmatch-cond
    syn keyword schemeExtSyntax rxmatch-if
    set lispwords+=rxmatch-if
    syn keyword schemeExtSyntax rxmatch-let
    set lispwords+=rxmatch-let
    syn keyword schemeExtSyntax set!-values
    set lispwords+=set!-values
    syn keyword schemeExtSyntax shift
    set lispwords+=shift
    syn keyword schemeExtSyntax srfi-42-
    set lispwords+=srfi-42-
    syn keyword schemeExtSyntax srfi-42-char-range
    set lispwords+=srfi-42-char-range
    syn keyword schemeExtSyntax srfi-42-dispatched
    set lispwords+=srfi-42-dispatched
    syn keyword schemeExtSyntax srfi-42-do
    set lispwords+=srfi-42-do
    syn keyword schemeExtSyntax srfi-42-generator-proc
    set lispwords+=srfi-42-generator-proc
    syn keyword schemeExtSyntax srfi-42-integers
    set lispwords+=srfi-42-integers
    syn keyword schemeExtSyntax srfi-42-let
    set lispwords+=srfi-42-let
    syn keyword schemeExtSyntax srfi-42-list
    set lispwords+=srfi-42-list
    syn keyword schemeExtSyntax srfi-42-parallel
    set lispwords+=srfi-42-parallel
    syn keyword schemeExtSyntax srfi-42-parallel-1
    set lispwords+=srfi-42-parallel-1
    syn keyword schemeExtSyntax srfi-42-port
    set lispwords+=srfi-42-port
    syn keyword schemeExtSyntax srfi-42-range
    set lispwords+=srfi-42-range
    syn keyword schemeExtSyntax srfi-42-real-range
    set lispwords+=srfi-42-real-range
    syn keyword schemeExtSyntax srfi-42-string
    set lispwords+=srfi-42-string
    syn keyword schemeExtSyntax srfi-42-until
    set lispwords+=srfi-42-until
    syn keyword schemeExtSyntax srfi-42-until-1
    set lispwords+=srfi-42-until-1
    syn keyword schemeExtSyntax srfi-42-vector
    set lispwords+=srfi-42-vector
    syn keyword schemeExtSyntax srfi-42-while
    set lispwords+=srfi-42-while
    syn keyword schemeExtSyntax srfi-42-while-1
    set lispwords+=srfi-42-while-1
    syn keyword schemeExtSyntax srfi-42-while-2
    set lispwords+=srfi-42-while-2
    syn keyword schemeExtSyntax ssax:make-elem-parser
    set lispwords+=ssax:make-elem-parser
    syn keyword schemeExtSyntax ssax:make-parser
    set lispwords+=ssax:make-parser
    syn keyword schemeExtSyntax ssax:make-pi-parser
    set lispwords+=ssax:make-pi-parser
    syn keyword schemeExtSyntax stream-cons
    set lispwords+=stream-cons
    syn keyword schemeExtSyntax stream-delay
    set lispwords+=stream-delay
    syn keyword schemeExtSyntax string-append-ec
    set lispwords+=string-append-ec
    syn keyword schemeExtSyntax string-ec
    set lispwords+=string-ec
    syn keyword schemeExtSyntax sum-ec
    set lispwords+=sum-ec
    syn keyword schemeExtSyntax sxml:find-name-separator
    set lispwords+=sxml:find-name-separator
    syn keyword schemeExtSyntax syntax-error
    set lispwords+=syntax-error
    syn keyword schemeExtSyntax syntax-errorf
    set lispwords+=syntax-errorf
    syn keyword schemeExtSyntax test*
    set lispwords+=test*
    syn keyword schemeExtSyntax time
    set lispwords+=time
    syn keyword schemeExtSyntax until
    set lispwords+=until
    syn keyword schemeExtSyntax unwind-protect
    set lispwords+=unwind-protect
    syn keyword schemeExtSyntax update!
    set lispwords+=update!
    syn keyword schemeExtSyntax use
    set lispwords+=use
    syn keyword schemeExtSyntax use-version
    set lispwords+=use-version
    syn keyword schemeExtSyntax values-ref
    set lispwords+=values-ref
    syn keyword schemeExtSyntax vector-ec
    set lispwords+=vector-ec
    syn keyword schemeExtSyntax vector-of-length-ec
    set lispwords+=vector-of-length-ec
    syn keyword schemeExtSyntax while
    set lispwords+=while
    syn keyword schemeExtSyntax with-builder
    set lispwords+=with-builder
    syn keyword schemeExtSyntax with-iterator
    set lispwords+=with-iterator
    syn keyword schemeExtSyntax with-signal-handlers
    set lispwords+=with-signal-handlers
    syn keyword schemeExtSyntax with-time-counter
    set lispwords+=with-time-counter
    syn keyword schemeExtSyntax xmac
    set lispwords+=xmac
    syn keyword schemeExtSyntax xmac1
    set lispwords+=xmac1


    " procedure
    syn keyword schemeExtFunc $->rope
    syn keyword schemeExtFunc $alternate
    syn keyword schemeExtFunc $between
    syn keyword schemeExtFunc $c
    syn keyword schemeExtFunc $chain-left
    syn keyword schemeExtFunc $chain-right
    syn keyword schemeExtFunc $char
    syn keyword schemeExtFunc $count
    syn keyword schemeExtFunc $end-by
    syn keyword schemeExtFunc $expect
    syn keyword schemeExtFunc $fail
    syn keyword schemeExtFunc $fold-parsers
    syn keyword schemeExtFunc $fold-parsers-right
    syn keyword schemeExtFunc $many
    syn keyword schemeExtFunc $many-till
    syn keyword schemeExtFunc $many1
    syn keyword schemeExtFunc $none-of
    syn keyword schemeExtFunc $not
    syn keyword schemeExtFunc $one-of
    syn keyword schemeExtFunc $optional
    syn keyword schemeExtFunc $repeat
    syn keyword schemeExtFunc $return
    syn keyword schemeExtFunc $s
    syn keyword schemeExtFunc $sep-by
    syn keyword schemeExtFunc $sep-end-by
    syn keyword schemeExtFunc $seq
    syn keyword schemeExtFunc $skip-many
    syn keyword schemeExtFunc $string
    syn keyword schemeExtFunc $string-ci
    syn keyword schemeExtFunc $try
    syn keyword schemeExtFunc $y
    syn keyword schemeExtFunc %add-load-path
    syn keyword schemeExtFunc %alist-delete
    syn keyword schemeExtFunc %alist-delete!
    syn keyword schemeExtFunc %autoload
    syn keyword schemeExtFunc %bignum-dump
    syn keyword schemeExtFunc %char-set-add!
    syn keyword schemeExtFunc %char-set-add-chars!
    syn keyword schemeExtFunc %char-set-add-range!
    syn keyword schemeExtFunc %char-set-complement!
    syn keyword schemeExtFunc %char-set-dump
    syn keyword schemeExtFunc %char-set-equal?
    syn keyword schemeExtFunc %char-set-predefined
    syn keyword schemeExtFunc %char-set-ranges
    syn keyword schemeExtFunc %char-set<=?
    syn keyword schemeExtFunc %check-class-binding
    syn keyword schemeExtFunc %default-signal-handler
    syn keyword schemeExtFunc %delete
    syn keyword schemeExtFunc %delete!
    syn keyword schemeExtFunc %delete-duplicates
    syn keyword schemeExtFunc %delete-duplicates!
    syn keyword schemeExtFunc %div&mod
    syn keyword schemeExtFunc %ensure-generic-function
    syn keyword schemeExtFunc %exact-integer-sqrt
    syn keyword schemeExtFunc %exit
    syn keyword schemeExtFunc %export-all
    syn keyword schemeExtFunc %extend-module
    syn keyword schemeExtFunc %format
    syn keyword schemeExtFunc %gauche-runtime-directory
    syn keyword schemeExtFunc %get-reader-ctor
    syn keyword schemeExtFunc %hash-string
    syn keyword schemeExtFunc %hash-table-iter
    syn keyword schemeExtFunc %let-keywords-rec
    syn keyword schemeExtFunc %make-sigset
    syn keyword schemeExtFunc %make-tree-map
    syn keyword schemeExtFunc %maybe-substring
    syn keyword schemeExtFunc %open-input-file
    syn keyword schemeExtFunc %open-input-file/conv
    syn keyword schemeExtFunc %open-output-file
    syn keyword schemeExtFunc %open-output-file/conv
    syn keyword schemeExtFunc %regexp-dump
    syn keyword schemeExtFunc %regexp-pattern
    syn keyword schemeExtFunc %regmatch-dump
    syn keyword schemeExtFunc %require
    syn keyword schemeExtFunc %sort
    syn keyword schemeExtFunc %sort!
    syn keyword schemeExtFunc %sparse-table-check
    syn keyword schemeExtFunc %sparse-table-dump
    syn keyword schemeExtFunc %sparse-vector-dump
    syn keyword schemeExtFunc %string-pointer-dump
    syn keyword schemeExtFunc %string-replace-body!
    syn keyword schemeExtFunc %string-split-by-char
    syn keyword schemeExtFunc %sys-escape-windows-command-line
    syn keyword schemeExtFunc %tree-map-bound
    syn keyword schemeExtFunc %tree-map-check-consistency
    syn keyword schemeExtFunc %tree-map-dump
    syn keyword schemeExtFunc %tree-map-iter
    syn keyword schemeExtFunc %uvector-ref
    syn keyword schemeExtFunc %vm-make-parameter-slot
    syn keyword schemeExtFunc %vm-parameter-ref
    syn keyword schemeExtFunc %vm-parameter-set!
    syn keyword schemeExtFunc %vm-show-stack-trace
    syn keyword schemeExtFunc %with-signal-handlers
    syn keyword schemeExtFunc *.
    syn keyword schemeExtFunc +.
    syn keyword schemeExtFunc -.
    syn keyword schemeExtFunc ->char-set
    syn keyword schemeExtFunc ->stream-char
    syn keyword schemeExtFunc .$
    syn keyword schemeExtFunc /.
    syn keyword schemeExtFunc SRV:send-reply
    syn keyword schemeExtFunc SSAX:XML->SXML
    syn keyword schemeExtFunc SXML->HTML
    syn keyword schemeExtFunc abandoned-mutex-exception?
    syn keyword schemeExtFunc absolute-path?
    syn keyword schemeExtFunc acons
    syn keyword schemeExtFunc acosh
    syn keyword schemeExtFunc add-duration
    syn keyword schemeExtFunc add-duration!
    syn keyword schemeExtFunc add-job!
    syn keyword schemeExtFunc adler32
    syn keyword schemeExtFunc alist->hash-table
    syn keyword schemeExtFunc alist->rbtree
    syn keyword schemeExtFunc alist->tree-map
    syn keyword schemeExtFunc alist-cons
    syn keyword schemeExtFunc alist-copy
    syn keyword schemeExtFunc alist-delete
    syn keyword schemeExtFunc alist-delete!
    syn keyword schemeExtFunc all-modules
    syn keyword schemeExtFunc alphanum
    syn keyword schemeExtFunc any
    syn keyword schemeExtFunc any$
    syn keyword schemeExtFunc any-in-queue
    syn keyword schemeExtFunc any-pred
    syn keyword schemeExtFunc anychar
    syn keyword schemeExtFunc append!
    syn keyword schemeExtFunc append-map
    syn keyword schemeExtFunc append-map!
    syn keyword schemeExtFunc append-reverse
    syn keyword schemeExtFunc append-reverse!
    syn keyword schemeExtFunc apply$
    syn keyword schemeExtFunc args-fold
    syn keyword schemeExtFunc arity
    syn keyword schemeExtFunc arity-at-least-value
    syn keyword schemeExtFunc arity-at-least?
    syn keyword schemeExtFunc array
    syn keyword schemeExtFunc array->list
    syn keyword schemeExtFunc array->vector
    syn keyword schemeExtFunc array-add-elements
    syn keyword schemeExtFunc array-any
    syn keyword schemeExtFunc array-concatenate
    syn keyword schemeExtFunc array-div-elements
    syn keyword schemeExtFunc array-div-left
    syn keyword schemeExtFunc array-div-right
    syn keyword schemeExtFunc array-end
    syn keyword schemeExtFunc array-equal?
    syn keyword schemeExtFunc array-every
    syn keyword schemeExtFunc array-expt
    syn keyword schemeExtFunc array-flip
    syn keyword schemeExtFunc array-flip!
    syn keyword schemeExtFunc array-for-each
    syn keyword schemeExtFunc array-for-each-index
    syn keyword schemeExtFunc array-for-each-index-by-dimension
    syn keyword schemeExtFunc array-inverse
    syn keyword schemeExtFunc array-length
    syn keyword schemeExtFunc array-mul
    syn keyword schemeExtFunc array-mul-elements
    syn keyword schemeExtFunc array-rank
    syn keyword schemeExtFunc array-rotate-90
    syn keyword schemeExtFunc array-shape
    syn keyword schemeExtFunc array-size
    syn keyword schemeExtFunc array-start
    syn keyword schemeExtFunc array-sub-elements
    syn keyword schemeExtFunc array-transpose
    syn keyword schemeExtFunc array-valid-index?
    syn keyword schemeExtFunc array?
    syn keyword schemeExtFunc as-nodeset
    syn keyword schemeExtFunc ascii->char
    syn keyword schemeExtFunc ash
    syn keyword schemeExtFunc asinh
    syn keyword schemeExtFunc assert-curr-char
    syn keyword schemeExtFunc assoc$
    syn keyword schemeExtFunc assoc-ref
    syn keyword schemeExtFunc assoc-set!
    syn keyword schemeExtFunc assq-ref
    syn keyword schemeExtFunc assq-set!
    syn keyword schemeExtFunc assq-values
    syn keyword schemeExtFunc assv-ref
    syn keyword schemeExtFunc assv-set!
    syn keyword schemeExtFunc atanh
    syn keyword schemeExtFunc atom
    syn keyword schemeExtFunc atom-ref
    syn keyword schemeExtFunc atom-swap!
    syn keyword schemeExtFunc attlist->alist
    syn keyword schemeExtFunc attlist-add
    syn keyword schemeExtFunc attlist-fold
    syn keyword schemeExtFunc attlist-null?
    syn keyword schemeExtFunc attlist-remove-top
    syn keyword schemeExtFunc base64-decode
    syn keyword schemeExtFunc base64-decode-string
    syn keyword schemeExtFunc base64-encode
    syn keyword schemeExtFunc base64-encode-string
    syn keyword schemeExtFunc bcrypt-gensalt
    syn keyword schemeExtFunc bcrypt-hashpw
    syn keyword schemeExtFunc bignum?
    syn keyword schemeExtFunc bimap-left
    syn keyword schemeExtFunc bimap-left-delete!
    syn keyword schemeExtFunc bimap-left-exists?
    syn keyword schemeExtFunc bimap-left-get
    syn keyword schemeExtFunc bimap-put!
    syn keyword schemeExtFunc bimap-right
    syn keyword schemeExtFunc bimap-right-delete!
    syn keyword schemeExtFunc bimap-right-exists?
    syn keyword schemeExtFunc bimap-right-get
    syn keyword schemeExtFunc bindtextdomain
    syn keyword schemeExtFunc bit-field
    syn keyword schemeExtFunc boolean
    syn keyword schemeExtFunc break
    syn keyword schemeExtFunc break!
    syn keyword schemeExtFunc build-path
    syn keyword schemeExtFunc build-transliterator
    syn keyword schemeExtFunc byte-ready?
    syn keyword schemeExtFunc byte-substring
    syn keyword schemeExtFunc call-with-cgi-script
    syn keyword schemeExtFunc call-with-client-socket
    syn keyword schemeExtFunc call-with-ftp-connection
    syn keyword schemeExtFunc call-with-input-conversion
    syn keyword schemeExtFunc call-with-input-process
    syn keyword schemeExtFunc call-with-input-string
    syn keyword schemeExtFunc call-with-iterators
    syn keyword schemeExtFunc call-with-output-conversion
    syn keyword schemeExtFunc call-with-output-process
    syn keyword schemeExtFunc call-with-output-string
    syn keyword schemeExtFunc call-with-process-io
    syn keyword schemeExtFunc call-with-string-io
    syn keyword schemeExtFunc call/pc
    syn keyword schemeExtFunc canonical-path
    syn keyword schemeExtFunc car+cdr
    syn keyword schemeExtFunc car-sxpath
    syn keyword schemeExtFunc cartesian-product
    syn keyword schemeExtFunc cartesian-product-for-each
    syn keyword schemeExtFunc cartesian-product-right
    syn keyword schemeExtFunc cartesian-product-right-for-each
    syn keyword schemeExtFunc ceiling->exact
    syn keyword schemeExtFunc cerr
    syn keyword schemeExtFunc ces-conversion-supported?
    syn keyword schemeExtFunc ces-convert
    syn keyword schemeExtFunc ces-equivalent?
    syn keyword schemeExtFunc ces-guess-from-string
    syn keyword schemeExtFunc ces-upper-compatible?
    syn keyword schemeExtFunc cgen-add!
    syn keyword schemeExtFunc cgen-allocate-static-datum
    syn keyword schemeExtFunc cgen-body
    syn keyword schemeExtFunc cgen-box-expr
    syn keyword schemeExtFunc cgen-decl
    syn keyword schemeExtFunc cgen-define
    syn keyword schemeExtFunc cgen-extern
    syn keyword schemeExtFunc cgen-genstub
    syn keyword schemeExtFunc cgen-include
    syn keyword schemeExtFunc cgen-init
    syn keyword schemeExtFunc cgen-literal
    syn keyword schemeExtFunc cgen-precompile
    syn keyword schemeExtFunc cgen-precompile-multi
    syn keyword schemeExtFunc cgen-pred-expr
    syn keyword schemeExtFunc cgen-return-stmt
    syn keyword schemeExtFunc cgen-safe-comment
    syn keyword schemeExtFunc cgen-safe-name
    syn keyword schemeExtFunc cgen-safe-name-friendly
    syn keyword schemeExtFunc cgen-stub-parse-form
    syn keyword schemeExtFunc cgen-stub-parser
    syn keyword schemeExtFunc cgen-type-from-name
    syn keyword schemeExtFunc cgen-unbox-expr
    syn keyword schemeExtFunc cgi-add-temporary-file
    syn keyword schemeExtFunc cgi-get-metavariable
    syn keyword schemeExtFunc cgi-get-parameter
    syn keyword schemeExtFunc cgi-header
    syn keyword schemeExtFunc cgi-main
    syn keyword schemeExtFunc cgi-parse-parameters
    syn keyword schemeExtFunc cgi-test-environment-ref
    syn keyword schemeExtFunc change-object-class
    syn keyword schemeExtFunc char->ucs
    syn keyword schemeExtFunc char-set
    syn keyword schemeExtFunc char-set->list
    syn keyword schemeExtFunc char-set->string
    syn keyword schemeExtFunc char-set-adjoin
    syn keyword schemeExtFunc char-set-adjoin!
    syn keyword schemeExtFunc char-set-any
    syn keyword schemeExtFunc char-set-complement
    syn keyword schemeExtFunc char-set-complement!
    syn keyword schemeExtFunc char-set-contains?
    syn keyword schemeExtFunc char-set-copy
    syn keyword schemeExtFunc char-set-count
    syn keyword schemeExtFunc char-set-cursor
    syn keyword schemeExtFunc char-set-cursor-next
    syn keyword schemeExtFunc char-set-delete
    syn keyword schemeExtFunc char-set-delete!
    syn keyword schemeExtFunc char-set-diff+intersection
    syn keyword schemeExtFunc char-set-diff+intersection!
    syn keyword schemeExtFunc char-set-difference
    syn keyword schemeExtFunc char-set-difference!
    syn keyword schemeExtFunc char-set-every
    syn keyword schemeExtFunc char-set-filter
    syn keyword schemeExtFunc char-set-filter!
    syn keyword schemeExtFunc char-set-fold
    syn keyword schemeExtFunc char-set-for-each
    syn keyword schemeExtFunc char-set-hash
    syn keyword schemeExtFunc char-set-intersection
    syn keyword schemeExtFunc char-set-intersection!
    syn keyword schemeExtFunc char-set-map
    syn keyword schemeExtFunc char-set-ref
    syn keyword schemeExtFunc char-set-size
    syn keyword schemeExtFunc char-set-unfold
    syn keyword schemeExtFunc char-set-unfold!
    syn keyword schemeExtFunc char-set-union
    syn keyword schemeExtFunc char-set-union!
    syn keyword schemeExtFunc char-set-xor
    syn keyword schemeExtFunc char-set-xor!
    syn keyword schemeExtFunc char-set<=
    syn keyword schemeExtFunc char-set=
    syn keyword schemeExtFunc char-set?
    syn keyword schemeExtFunc chdir
    syn keyword schemeExtFunc check-directory-tree
    syn keyword schemeExtFunc check-substring-spec
    syn keyword schemeExtFunc circular-list
    syn keyword schemeExtFunc circular-list?
    syn keyword schemeExtFunc cise-context-copy
    syn keyword schemeExtFunc cise-lookup-macro
    syn keyword schemeExtFunc cise-register-macro!
    syn keyword schemeExtFunc cise-render
    syn keyword schemeExtFunc cise-render-rec
    syn keyword schemeExtFunc cise-render-to-string
    syn keyword schemeExtFunc cise-translate
    syn keyword schemeExtFunc clamp
    syn keyword schemeExtFunc class-direct-methods
    syn keyword schemeExtFunc class-direct-slots
    syn keyword schemeExtFunc class-direct-subclasses
    syn keyword schemeExtFunc class-direct-supers
    syn keyword schemeExtFunc class-name
    syn keyword schemeExtFunc class-of
    syn keyword schemeExtFunc class-precedence-list
    syn keyword schemeExtFunc class-slot-accessor
    syn keyword schemeExtFunc class-slot-bound?
    syn keyword schemeExtFunc class-slot-definition
    syn keyword schemeExtFunc class-slot-ref
    syn keyword schemeExtFunc class-slot-set!
    syn keyword schemeExtFunc class-slots
    syn keyword schemeExtFunc closure-code
    syn keyword schemeExtFunc closure?
    syn keyword schemeExtFunc combinations
    syn keyword schemeExtFunc combinations*
    syn keyword schemeExtFunc combinations*-for-each
    syn keyword schemeExtFunc combinations-for-each
    syn keyword schemeExtFunc compare
    syn keyword schemeExtFunc complement
    syn keyword schemeExtFunc complete-sexp?
    syn keyword schemeExtFunc compose
    syn keyword schemeExtFunc concatenate
    syn keyword schemeExtFunc concatenate!
    syn keyword schemeExtFunc condition-has-type?
    syn keyword schemeExtFunc condition-ref
    syn keyword schemeExtFunc condition-type?
    syn keyword schemeExtFunc condition-variable-broadcast!
    syn keyword schemeExtFunc condition-variable-name
    syn keyword schemeExtFunc condition-variable-signal!
    syn keyword schemeExtFunc condition-variable-specific
    syn keyword schemeExtFunc condition-variable-specific-set!
    syn keyword schemeExtFunc condition-variable?
    syn keyword schemeExtFunc condition?
    syn keyword schemeExtFunc cons*
    syn keyword schemeExtFunc console-device
    syn keyword schemeExtFunc construct-cookie-string
    syn keyword schemeExtFunc construct-json
    syn keyword schemeExtFunc construct-json-string
    syn keyword schemeExtFunc copy-bit
    syn keyword schemeExtFunc copy-bit-field
    syn keyword schemeExtFunc copy-directory*
    syn keyword schemeExtFunc copy-file
    syn keyword schemeExtFunc copy-port
    syn keyword schemeExtFunc copy-time
    syn keyword schemeExtFunc cosh
    syn keyword schemeExtFunc count
    syn keyword schemeExtFunc count$
    syn keyword schemeExtFunc cout
    syn keyword schemeExtFunc crc32
    syn keyword schemeExtFunc create-directory*
    syn keyword schemeExtFunc create-directory-tree
    syn keyword schemeExtFunc current-class-of
    syn keyword schemeExtFunc current-date
    syn keyword schemeExtFunc current-directory
    syn keyword schemeExtFunc current-error-port
    syn keyword schemeExtFunc current-exception-handler
    syn keyword schemeExtFunc current-julian-day
    syn keyword schemeExtFunc current-load-history
    syn keyword schemeExtFunc current-load-next
    syn keyword schemeExtFunc current-load-path
    syn keyword schemeExtFunc current-load-port
    syn keyword schemeExtFunc current-microseconds
    syn keyword schemeExtFunc current-modified-julian-day
    syn keyword schemeExtFunc current-thread
    syn keyword schemeExtFunc current-time
    syn keyword schemeExtFunc cv-file
    syn keyword schemeExtFunc cv-string
    syn keyword schemeExtFunc date->julian-day
    syn keyword schemeExtFunc date->modified-julian-day
    syn keyword schemeExtFunc date->rfc822-date
    syn keyword schemeExtFunc date->string
    syn keyword schemeExtFunc date->time-monotonic
    syn keyword schemeExtFunc date->time-tai
    syn keyword schemeExtFunc date->time-utc
    syn keyword schemeExtFunc date-week-day
    syn keyword schemeExtFunc date-week-number
    syn keyword schemeExtFunc date-year-day
    syn keyword schemeExtFunc date?
    syn keyword schemeExtFunc dbi-connect
    syn keyword schemeExtFunc dbi-list-drivers
    syn keyword schemeExtFunc dbi-make-driver
    syn keyword schemeExtFunc dbi-parse-dsn
    syn keyword schemeExtFunc dbi-prepare-sql
    syn keyword schemeExtFunc dbm-type->class
    syn keyword schemeExtFunc dcgettext
    syn keyword schemeExtFunc debug-source-info
    syn keyword schemeExtFunc declare-bundle!
    syn keyword schemeExtFunc decode-float
    syn keyword schemeExtFunc decompose-path
    syn keyword schemeExtFunc default-endian
    syn keyword schemeExtFunc define-reader-ctor
    syn keyword schemeExtFunc define-reader-directive
    syn keyword schemeExtFunc deflate-string
    syn keyword schemeExtFunc deflating-port-full-flush
    syn keyword schemeExtFunc delete
    syn keyword schemeExtFunc delete!
    syn keyword schemeExtFunc delete$
    syn keyword schemeExtFunc delete-directory*
    syn keyword schemeExtFunc delete-duplicates
    syn keyword schemeExtFunc delete-duplicates!
    syn keyword schemeExtFunc delete-files
    syn keyword schemeExtFunc delete-keyword
    syn keyword schemeExtFunc delete-keyword!
    syn keyword schemeExtFunc delete-keywords
    syn keyword schemeExtFunc delete-keywords!
    syn keyword schemeExtFunc dequeue!
    syn keyword schemeExtFunc dequeue-all!
    syn keyword schemeExtFunc dequeue/wait!
    syn keyword schemeExtFunc determinant
    syn keyword schemeExtFunc determinant!
    syn keyword schemeExtFunc dgettext
    syn keyword schemeExtFunc diff
    syn keyword schemeExtFunc diff-report
    syn keyword schemeExtFunc digest-hexify
    syn keyword schemeExtFunc digit
    syn keyword schemeExtFunc digit->integer
    syn keyword schemeExtFunc directory-fold
    syn keyword schemeExtFunc directory-list
    syn keyword schemeExtFunc directory-list2
    syn keyword schemeExtFunc disasm
    syn keyword schemeExtFunc dispatch-union
    syn keyword schemeExtFunc dotted-list?
    syn keyword schemeExtFunc drop
    syn keyword schemeExtFunc drop*
    syn keyword schemeExtFunc drop-right
    syn keyword schemeExtFunc drop-right!
    syn keyword schemeExtFunc drop-right*
    syn keyword schemeExtFunc drop-while
    syn keyword schemeExtFunc dynamic-load
    syn keyword schemeExtFunc eager
    syn keyword schemeExtFunc ec-:vector-filter
    syn keyword schemeExtFunc eighth
    syn keyword schemeExtFunc end-of-char-set?
    syn keyword schemeExtFunc enqueue!
    syn keyword schemeExtFunc enqueue-unique!
    syn keyword schemeExtFunc enqueue/wait!
    syn keyword schemeExtFunc eof
    syn keyword schemeExtFunc eof-object
    syn keyword schemeExtFunc eq-hash
    syn keyword schemeExtFunc eqv-hash
    syn keyword schemeExtFunc error
    syn keyword schemeExtFunc errorf
    syn keyword schemeExtFunc every
    syn keyword schemeExtFunc every$
    syn keyword schemeExtFunc every-in-queue
    syn keyword schemeExtFunc every-pred
    syn keyword schemeExtFunc exit
    syn keyword schemeExtFunc exit-handler
    syn keyword schemeExtFunc expand-file-name
    syn keyword schemeExtFunc expand-path
    syn keyword schemeExtFunc extract-condition
    syn keyword schemeExtFunc f16vector
    syn keyword schemeExtFunc f16vector->list
    syn keyword schemeExtFunc f16vector->vector
    syn keyword schemeExtFunc f16vector-add
    syn keyword schemeExtFunc f16vector-add!
    syn keyword schemeExtFunc f16vector-clamp
    syn keyword schemeExtFunc f16vector-clamp!
    syn keyword schemeExtFunc f16vector-copy
    syn keyword schemeExtFunc f16vector-copy!
    syn keyword schemeExtFunc f16vector-div
    syn keyword schemeExtFunc f16vector-div!
    syn keyword schemeExtFunc f16vector-dot
    syn keyword schemeExtFunc f16vector-fill!
    syn keyword schemeExtFunc f16vector-length
    syn keyword schemeExtFunc f16vector-mul
    syn keyword schemeExtFunc f16vector-mul!
    syn keyword schemeExtFunc f16vector-range-check
    syn keyword schemeExtFunc f16vector-ref
    syn keyword schemeExtFunc f16vector-set!
    syn keyword schemeExtFunc f16vector-sub
    syn keyword schemeExtFunc f16vector-sub!
    syn keyword schemeExtFunc f16vector-swap-bytes
    syn keyword schemeExtFunc f16vector-swap-bytes!
    syn keyword schemeExtFunc f16vector?
    syn keyword schemeExtFunc f32vector
    syn keyword schemeExtFunc f32vector->list
    syn keyword schemeExtFunc f32vector->vector
    syn keyword schemeExtFunc f32vector-add
    syn keyword schemeExtFunc f32vector-add!
    syn keyword schemeExtFunc f32vector-clamp
    syn keyword schemeExtFunc f32vector-clamp!
    syn keyword schemeExtFunc f32vector-copy
    syn keyword schemeExtFunc f32vector-copy!
    syn keyword schemeExtFunc f32vector-div
    syn keyword schemeExtFunc f32vector-div!
    syn keyword schemeExtFunc f32vector-dot
    syn keyword schemeExtFunc f32vector-fill!
    syn keyword schemeExtFunc f32vector-length
    syn keyword schemeExtFunc f32vector-mul
    syn keyword schemeExtFunc f32vector-mul!
    syn keyword schemeExtFunc f32vector-range-check
    syn keyword schemeExtFunc f32vector-ref
    syn keyword schemeExtFunc f32vector-set!
    syn keyword schemeExtFunc f32vector-sub
    syn keyword schemeExtFunc f32vector-sub!
    syn keyword schemeExtFunc f32vector-swap-bytes
    syn keyword schemeExtFunc f32vector-swap-bytes!
    syn keyword schemeExtFunc f32vector?
    syn keyword schemeExtFunc f64vector
    syn keyword schemeExtFunc f64vector->list
    syn keyword schemeExtFunc f64vector->vector
    syn keyword schemeExtFunc f64vector-add
    syn keyword schemeExtFunc f64vector-add!
    syn keyword schemeExtFunc f64vector-clamp
    syn keyword schemeExtFunc f64vector-clamp!
    syn keyword schemeExtFunc f64vector-copy
    syn keyword schemeExtFunc f64vector-copy!
    syn keyword schemeExtFunc f64vector-div
    syn keyword schemeExtFunc f64vector-div!
    syn keyword schemeExtFunc f64vector-dot
    syn keyword schemeExtFunc f64vector-fill!
    syn keyword schemeExtFunc f64vector-length
    syn keyword schemeExtFunc f64vector-mul
    syn keyword schemeExtFunc f64vector-mul!
    syn keyword schemeExtFunc f64vector-range-check
    syn keyword schemeExtFunc f64vector-ref
    syn keyword schemeExtFunc f64vector-set!
    syn keyword schemeExtFunc f64vector-sub
    syn keyword schemeExtFunc f64vector-sub!
    syn keyword schemeExtFunc f64vector-swap-bytes
    syn keyword schemeExtFunc f64vector-swap-bytes!
    syn keyword schemeExtFunc f64vector?
    syn keyword schemeExtFunc fifth
    syn keyword schemeExtFunc file->list
    syn keyword schemeExtFunc file->sexp-list
    syn keyword schemeExtFunc file->string
    syn keyword schemeExtFunc file->string-list
    syn keyword schemeExtFunc file-atime
    syn keyword schemeExtFunc file-ctime
    syn keyword schemeExtFunc file-dev
    syn keyword schemeExtFunc file-device=?
    syn keyword schemeExtFunc file-eq?
    syn keyword schemeExtFunc file-equal?
    syn keyword schemeExtFunc file-eqv?
    syn keyword schemeExtFunc file-exists?
    syn keyword schemeExtFunc file-filter
    syn keyword schemeExtFunc file-gid
    syn keyword schemeExtFunc file-ino
    syn keyword schemeExtFunc file-is-directory?
    syn keyword schemeExtFunc file-is-executable?
    syn keyword schemeExtFunc file-is-readable?
    syn keyword schemeExtFunc file-is-regular?
    syn keyword schemeExtFunc file-is-symlink?
    syn keyword schemeExtFunc file-is-writable?
    syn keyword schemeExtFunc file-mode
    syn keyword schemeExtFunc file-mtime
    syn keyword schemeExtFunc file-nlink
    syn keyword schemeExtFunc file-perm
    syn keyword schemeExtFunc file-rdev
    syn keyword schemeExtFunc file-size
    syn keyword schemeExtFunc file-type
    syn keyword schemeExtFunc file-uid
    syn keyword schemeExtFunc filter
    syn keyword schemeExtFunc filter!
    syn keyword schemeExtFunc filter$
    syn keyword schemeExtFunc filter-map
    syn keyword schemeExtFunc find$
    syn keyword schemeExtFunc find-file-in-paths
    syn keyword schemeExtFunc find-gauche-package-description
    syn keyword schemeExtFunc find-in-queue
    syn keyword schemeExtFunc find-module
    syn keyword schemeExtFunc find-string-from-port?
    syn keyword schemeExtFunc find-tail
    syn keyword schemeExtFunc find-tail$
    syn keyword schemeExtFunc finite?
    syn keyword schemeExtFunc first
    syn keyword schemeExtFunc fixnum-width
    syn keyword schemeExtFunc fixnum?
    syn keyword schemeExtFunc flonum?
    syn keyword schemeExtFunc floor->exact
    syn keyword schemeExtFunc flush
    syn keyword schemeExtFunc flush-all-ports
    syn keyword schemeExtFunc fmod
    syn keyword schemeExtFunc fold-right$
    syn keyword schemeExtFunc foldts
    syn keyword schemeExtFunc for-each$
    syn keyword schemeExtFunc foreign-pointer-attribute-get
    syn keyword schemeExtFunc foreign-pointer-attribute-set
    syn keyword schemeExtFunc foreign-pointer-attributes
    syn keyword schemeExtFunc format
    syn keyword schemeExtFunc format/ss
    syn keyword schemeExtFunc fourth
    syn keyword schemeExtFunc frexp
    syn keyword schemeExtFunc ftp-chdir
    syn keyword schemeExtFunc ftp-current-directory
    syn keyword schemeExtFunc ftp-get
    syn keyword schemeExtFunc ftp-help
    syn keyword schemeExtFunc ftp-list
    syn keyword schemeExtFunc ftp-login
    syn keyword schemeExtFunc ftp-ls
    syn keyword schemeExtFunc ftp-mdtm
    syn keyword schemeExtFunc ftp-mkdir
    syn keyword schemeExtFunc ftp-mtime
    syn keyword schemeExtFunc ftp-name-list
    syn keyword schemeExtFunc ftp-noop
    syn keyword schemeExtFunc ftp-put
    syn keyword schemeExtFunc ftp-put-unique
    syn keyword schemeExtFunc ftp-quit
    syn keyword schemeExtFunc ftp-remove
    syn keyword schemeExtFunc ftp-rename
    syn keyword schemeExtFunc ftp-rmdir
    syn keyword schemeExtFunc ftp-site
    syn keyword schemeExtFunc ftp-size
    syn keyword schemeExtFunc ftp-stat
    syn keyword schemeExtFunc ftp-system
    syn keyword schemeExtFunc gauche-architecture
    syn keyword schemeExtFunc gauche-architecture-directory
    syn keyword schemeExtFunc gauche-character-encoding
    syn keyword schemeExtFunc gauche-config
    syn keyword schemeExtFunc gauche-dso-suffix
    syn keyword schemeExtFunc gauche-library-directory
    syn keyword schemeExtFunc gauche-package-build
    syn keyword schemeExtFunc gauche-package-clean
    syn keyword schemeExtFunc gauche-package-compile
    syn keyword schemeExtFunc gauche-package-compile-and-link
    syn keyword schemeExtFunc gauche-package-description-paths
    syn keyword schemeExtFunc gauche-package-ensure
    syn keyword schemeExtFunc gauche-package-link
    syn keyword schemeExtFunc gauche-site-architecture-directory
    syn keyword schemeExtFunc gauche-site-library-directory
    syn keyword schemeExtFunc gauche-thread-type
    syn keyword schemeExtFunc gauche-version
    syn keyword schemeExtFunc gc
    syn keyword schemeExtFunc gc-stat
    syn keyword schemeExtFunc gdbm-close
    syn keyword schemeExtFunc gdbm-closed?
    syn keyword schemeExtFunc gdbm-delete
    syn keyword schemeExtFunc gdbm-errno
    syn keyword schemeExtFunc gdbm-exists?
    syn keyword schemeExtFunc gdbm-fetch
    syn keyword schemeExtFunc gdbm-firstkey
    syn keyword schemeExtFunc gdbm-nextkey
    syn keyword schemeExtFunc gdbm-open
    syn keyword schemeExtFunc gdbm-reorganize
    syn keyword schemeExtFunc gdbm-setopt
    syn keyword schemeExtFunc gdbm-store
    syn keyword schemeExtFunc gdbm-strerror
    syn keyword schemeExtFunc gdbm-sync
    syn keyword schemeExtFunc gdbm-version
    syn keyword schemeExtFunc gensym
    syn keyword schemeExtFunc get-environment-variable
    syn keyword schemeExtFunc get-environment-variables
    syn keyword schemeExtFunc get-f16
    syn keyword schemeExtFunc get-f16be
    syn keyword schemeExtFunc get-f16le
    syn keyword schemeExtFunc get-f32
    syn keyword schemeExtFunc get-f32be
    syn keyword schemeExtFunc get-f32le
    syn keyword schemeExtFunc get-f64
    syn keyword schemeExtFunc get-f64be
    syn keyword schemeExtFunc get-f64le
    syn keyword schemeExtFunc get-keyword
    syn keyword schemeExtFunc get-output-byte-string
    syn keyword schemeExtFunc get-output-string
    syn keyword schemeExtFunc get-password
    syn keyword schemeExtFunc get-remaining-input-string
    syn keyword schemeExtFunc get-s16
    syn keyword schemeExtFunc get-s16be
    syn keyword schemeExtFunc get-s16le
    syn keyword schemeExtFunc get-s32
    syn keyword schemeExtFunc get-s32be
    syn keyword schemeExtFunc get-s32le
    syn keyword schemeExtFunc get-s64
    syn keyword schemeExtFunc get-s64be
    syn keyword schemeExtFunc get-s64le
    syn keyword schemeExtFunc get-s8
    syn keyword schemeExtFunc get-signal-handler
    syn keyword schemeExtFunc get-signal-handler-mask
    syn keyword schemeExtFunc get-signal-handlers
    syn keyword schemeExtFunc get-signal-pending-limit
    syn keyword schemeExtFunc get-u16
    syn keyword schemeExtFunc get-u16be
    syn keyword schemeExtFunc get-u16le
    syn keyword schemeExtFunc get-u32
    syn keyword schemeExtFunc get-u32be
    syn keyword schemeExtFunc get-u32le
    syn keyword schemeExtFunc get-u64
    syn keyword schemeExtFunc get-u64be
    syn keyword schemeExtFunc get-u64le
    syn keyword schemeExtFunc get-u8
    syn keyword schemeExtFunc getcwd
    syn keyword schemeExtFunc getenv
    syn keyword schemeExtFunc getpid
    syn keyword schemeExtFunc getter-with-setter
    syn keyword schemeExtFunc gettext
    syn keyword schemeExtFunc glob
    syn keyword schemeExtFunc glob-component->regexp
    syn keyword schemeExtFunc glob-fold
    syn keyword schemeExtFunc global-variable-bound?
    syn keyword schemeExtFunc global-variable-ref
    syn keyword schemeExtFunc greatest-fixnum
    syn keyword schemeExtFunc gzip-decode-string
    syn keyword schemeExtFunc gzip-encode-string
    syn keyword schemeExtFunc has-setter?
    syn keyword schemeExtFunc hash
    syn keyword schemeExtFunc hash-table
    syn keyword schemeExtFunc hash-table->alist
    syn keyword schemeExtFunc hash-table-clear!
    syn keyword schemeExtFunc hash-table-copy
    syn keyword schemeExtFunc hash-table-delete!
    syn keyword schemeExtFunc hash-table-exists?
    syn keyword schemeExtFunc hash-table-fold
    syn keyword schemeExtFunc hash-table-for-each
    syn keyword schemeExtFunc hash-table-get
    syn keyword schemeExtFunc hash-table-keys
    syn keyword schemeExtFunc hash-table-map
    syn keyword schemeExtFunc hash-table-num-entries
    syn keyword schemeExtFunc hash-table-pop!
    syn keyword schemeExtFunc hash-table-push!
    syn keyword schemeExtFunc hash-table-put!
    syn keyword schemeExtFunc hash-table-stat
    syn keyword schemeExtFunc hash-table-type
    syn keyword schemeExtFunc hash-table-update!
    syn keyword schemeExtFunc hash-table-values
    syn keyword schemeExtFunc hash-table?
    syn keyword schemeExtFunc hexdigit
    syn keyword schemeExtFunc hmac-digest
    syn keyword schemeExtFunc hmac-digest-string
    syn keyword schemeExtFunc home-directory
    syn keyword schemeExtFunc hook?
    syn keyword schemeExtFunc html-doctype
    syn keyword schemeExtFunc html-escape
    syn keyword schemeExtFunc html-escape-string
    syn keyword schemeExtFunc html:a
    syn keyword schemeExtFunc html:abbr
    syn keyword schemeExtFunc html:acronym
    syn keyword schemeExtFunc html:address
    syn keyword schemeExtFunc html:area
    syn keyword schemeExtFunc html:b
    syn keyword schemeExtFunc html:base
    syn keyword schemeExtFunc html:bdo
    syn keyword schemeExtFunc html:big
    syn keyword schemeExtFunc html:blockquote
    syn keyword schemeExtFunc html:body
    syn keyword schemeExtFunc html:br
    syn keyword schemeExtFunc html:button
    syn keyword schemeExtFunc html:caption
    syn keyword schemeExtFunc html:cite
    syn keyword schemeExtFunc html:code
    syn keyword schemeExtFunc html:col
    syn keyword schemeExtFunc html:colgroup
    syn keyword schemeExtFunc html:dd
    syn keyword schemeExtFunc html:del
    syn keyword schemeExtFunc html:dfn
    syn keyword schemeExtFunc html:div
    syn keyword schemeExtFunc html:dl
    syn keyword schemeExtFunc html:dt
    syn keyword schemeExtFunc html:em
    syn keyword schemeExtFunc html:fieldset
    syn keyword schemeExtFunc html:form
    syn keyword schemeExtFunc html:frame
    syn keyword schemeExtFunc html:frameset
    syn keyword schemeExtFunc html:h1
    syn keyword schemeExtFunc html:h2
    syn keyword schemeExtFunc html:h3
    syn keyword schemeExtFunc html:h4
    syn keyword schemeExtFunc html:h5
    syn keyword schemeExtFunc html:h6
    syn keyword schemeExtFunc html:head
    syn keyword schemeExtFunc html:hr
    syn keyword schemeExtFunc html:html
    syn keyword schemeExtFunc html:i
    syn keyword schemeExtFunc html:iframe
    syn keyword schemeExtFunc html:img
    syn keyword schemeExtFunc html:input
    syn keyword schemeExtFunc html:ins
    syn keyword schemeExtFunc html:kbd
    syn keyword schemeExtFunc html:label
    syn keyword schemeExtFunc html:legend
    syn keyword schemeExtFunc html:li
    syn keyword schemeExtFunc html:link
    syn keyword schemeExtFunc html:map
    syn keyword schemeExtFunc html:meta
    syn keyword schemeExtFunc html:noframes
    syn keyword schemeExtFunc html:noscript
    syn keyword schemeExtFunc html:object
    syn keyword schemeExtFunc html:ol
    syn keyword schemeExtFunc html:optgroup
    syn keyword schemeExtFunc html:option
    syn keyword schemeExtFunc html:p
    syn keyword schemeExtFunc html:param
    syn keyword schemeExtFunc html:pre
    syn keyword schemeExtFunc html:q
    syn keyword schemeExtFunc html:samp
    syn keyword schemeExtFunc html:script
    syn keyword schemeExtFunc html:select
    syn keyword schemeExtFunc html:small
    syn keyword schemeExtFunc html:span
    syn keyword schemeExtFunc html:strong
    syn keyword schemeExtFunc html:style
    syn keyword schemeExtFunc html:sub
    syn keyword schemeExtFunc html:sup
    syn keyword schemeExtFunc html:table
    syn keyword schemeExtFunc html:tbody
    syn keyword schemeExtFunc html:td
    syn keyword schemeExtFunc html:textarea
    syn keyword schemeExtFunc html:tfoot
    syn keyword schemeExtFunc html:th
    syn keyword schemeExtFunc html:thead
    syn keyword schemeExtFunc html:title
    syn keyword schemeExtFunc html:tr
    syn keyword schemeExtFunc html:tt
    syn keyword schemeExtFunc html:ul
    syn keyword schemeExtFunc html:var
    syn keyword schemeExtFunc http-blob-sender
    syn keyword schemeExtFunc http-compose-form-data
    syn keyword schemeExtFunc http-compose-query
    syn keyword schemeExtFunc http-default-auth-handler
    syn keyword schemeExtFunc http-delete
    syn keyword schemeExtFunc http-file-receiver
    syn keyword schemeExtFunc http-file-sender
    syn keyword schemeExtFunc http-get
    syn keyword schemeExtFunc http-head
    syn keyword schemeExtFunc http-multipart-sender
    syn keyword schemeExtFunc http-null-receiver
    syn keyword schemeExtFunc http-null-sender
    syn keyword schemeExtFunc http-oport-receiver
    syn keyword schemeExtFunc http-post
    syn keyword schemeExtFunc http-put
    syn keyword schemeExtFunc http-request
    syn keyword schemeExtFunc http-secure-connection-available?
    syn keyword schemeExtFunc http-string-receiver
    syn keyword schemeExtFunc http-string-sender
    syn keyword schemeExtFunc icmp-echo-ident
    syn keyword schemeExtFunc icmp-echo-sequence
    syn keyword schemeExtFunc icmp-fill-header!
    syn keyword schemeExtFunc icmp-packet-code
    syn keyword schemeExtFunc icmp-packet-type
    syn keyword schemeExtFunc icmp4-describe-packet
    syn keyword schemeExtFunc icmp4-exceeded-code->string
    syn keyword schemeExtFunc icmp4-fill-checksum!
    syn keyword schemeExtFunc icmp4-fill-echo!
    syn keyword schemeExtFunc icmp4-message-type->string
    syn keyword schemeExtFunc icmp4-parameter-code->string
    syn keyword schemeExtFunc icmp4-redirect-code->string
    syn keyword schemeExtFunc icmp4-router-code->string
    syn keyword schemeExtFunc icmp4-security-code->string
    syn keyword schemeExtFunc icmp4-unreach-code->string
    syn keyword schemeExtFunc icmp6-describe-packet
    syn keyword schemeExtFunc icmp6-exceeded-code->string
    syn keyword schemeExtFunc icmp6-fill-echo!
    syn keyword schemeExtFunc icmp6-message-type->string
    syn keyword schemeExtFunc icmp6-parameter-code->string
    syn keyword schemeExtFunc icmp6-unreach-code->string
    syn keyword schemeExtFunc identifier->symbol
    syn keyword schemeExtFunc identifier?
    syn keyword schemeExtFunc identity
    syn keyword schemeExtFunc identity-array
    syn keyword schemeExtFunc if-car-sxpath
    syn keyword schemeExtFunc if-sxpath
    syn keyword schemeExtFunc inet-address->string
    syn keyword schemeExtFunc inet-checksum
    syn keyword schemeExtFunc inet-string->address
    syn keyword schemeExtFunc inet-string->address!
    syn keyword schemeExtFunc inexact-/
    syn keyword schemeExtFunc infinite?
    syn keyword schemeExtFunc inflate-string
    syn keyword schemeExtFunc inflate-sync
    syn keyword schemeExtFunc info
    syn keyword schemeExtFunc input-serializer?
    syn keyword schemeExtFunc instance-slot-ref
    syn keyword schemeExtFunc instance-slot-set
    syn keyword schemeExtFunc integer->digit
    syn keyword schemeExtFunc integer-length
    syn keyword schemeExtFunc integer-range->char-set
    syn keyword schemeExtFunc integer-range->char-set!
    syn keyword schemeExtFunc intersperse
    syn keyword schemeExtFunc iota
    syn keyword schemeExtFunc ip-destination-address
    syn keyword schemeExtFunc ip-header-length
    syn keyword schemeExtFunc ip-protocol
    syn keyword schemeExtFunc ip-source-address
    syn keyword schemeExtFunc ip-version
    syn keyword schemeExtFunc ipv4-global-address?
    syn keyword schemeExtFunc is-a?
    syn keyword schemeExtFunc isomorphic?
    syn keyword schemeExtFunc iterator->stream
    syn keyword schemeExtFunc job-acknowledge!
    syn keyword schemeExtFunc job-acknowledge-time
    syn keyword schemeExtFunc job-finish-time
    syn keyword schemeExtFunc job-mark-killed!
    syn keyword schemeExtFunc job-result
    syn keyword schemeExtFunc job-run!
    syn keyword schemeExtFunc job-start-time
    syn keyword schemeExtFunc job-status
    syn keyword schemeExtFunc job-touch!
    syn keyword schemeExtFunc job-wait
    syn keyword schemeExtFunc job?
    syn keyword schemeExtFunc join-timeout-exception?
    syn keyword schemeExtFunc judge-file
    syn keyword schemeExtFunc julian-day->date
    syn keyword schemeExtFunc julian-day->time-monotonic
    syn keyword schemeExtFunc julian-day->time-tai
    syn keyword schemeExtFunc julian-day->time-utc
    syn keyword schemeExtFunc keyword->string
    syn keyword schemeExtFunc keyword?
    syn keyword schemeExtFunc kmp-step
    syn keyword schemeExtFunc last
    syn keyword schemeExtFunc last-pair
    syn keyword schemeExtFunc lcs
    syn keyword schemeExtFunc lcs-edit-list
    syn keyword schemeExtFunc lcs-fold
    syn keyword schemeExtFunc lcs-with-positions
    syn keyword schemeExtFunc ldexp
    syn keyword schemeExtFunc least-fixnum
    syn keyword schemeExtFunc letter
    syn keyword schemeExtFunc library-exists?
    syn keyword schemeExtFunc library-fold
    syn keyword schemeExtFunc library-for-each
    syn keyword schemeExtFunc library-has-module?
    syn keyword schemeExtFunc library-map
    syn keyword schemeExtFunc list*
    syn keyword schemeExtFunc list->char-set
    syn keyword schemeExtFunc list->char-set!
    syn keyword schemeExtFunc list->f16vector
    syn keyword schemeExtFunc list->f32vector
    syn keyword schemeExtFunc list->f64vector
    syn keyword schemeExtFunc list->peg-stream
    syn keyword schemeExtFunc list->queue
    syn keyword schemeExtFunc list->s16vector
    syn keyword schemeExtFunc list->s32vector
    syn keyword schemeExtFunc list->s64vector
    syn keyword schemeExtFunc list->s8vector
    syn keyword schemeExtFunc list->stream
    syn keyword schemeExtFunc list->sys-fdset
    syn keyword schemeExtFunc list->u16vector
    syn keyword schemeExtFunc list->u32vector
    syn keyword schemeExtFunc list->u64vector
    syn keyword schemeExtFunc list->u8vector
    syn keyword schemeExtFunc list-copy
    syn keyword schemeExtFunc list-index
    syn keyword schemeExtFunc list-tabulate
    syn keyword schemeExtFunc list=
    syn keyword schemeExtFunc load-bundle!
    syn keyword schemeExtFunc load-from-port
    syn keyword schemeExtFunc localized-template
    syn keyword schemeExtFunc log-open
    syn keyword schemeExtFunc logand
    syn keyword schemeExtFunc logbit?
    syn keyword schemeExtFunc logcount
    syn keyword schemeExtFunc logior
    syn keyword schemeExtFunc lognot
    syn keyword schemeExtFunc logtest
    syn keyword schemeExtFunc logxor
    syn keyword schemeExtFunc lower
    syn keyword schemeExtFunc lset-adjoin
    syn keyword schemeExtFunc lset-diff+intersection
    syn keyword schemeExtFunc lset-diff+intersection!
    syn keyword schemeExtFunc lset-difference
    syn keyword schemeExtFunc lset-difference!
    syn keyword schemeExtFunc lset-intersection
    syn keyword schemeExtFunc lset-intersection!
    syn keyword schemeExtFunc lset-union
    syn keyword schemeExtFunc lset-union!
    syn keyword schemeExtFunc lset-xor
    syn keyword schemeExtFunc lset-xor!
    syn keyword schemeExtFunc lset<=
    syn keyword schemeExtFunc lset=
    syn keyword schemeExtFunc macroexpand
    syn keyword schemeExtFunc macroexpand-1
    syn keyword schemeExtFunc make-array
    syn keyword schemeExtFunc make-bimap
    syn keyword schemeExtFunc make-byte-string
    syn keyword schemeExtFunc make-cgen-type
    syn keyword schemeExtFunc make-char-quotator
    syn keyword schemeExtFunc make-client-socket
    syn keyword schemeExtFunc make-compound-condition
    syn keyword schemeExtFunc make-condition
    syn keyword schemeExtFunc make-condition-type
    syn keyword schemeExtFunc make-condition-variable
    syn keyword schemeExtFunc make-csv-reader
    syn keyword schemeExtFunc make-csv-writer
    syn keyword schemeExtFunc make-date
    syn keyword schemeExtFunc make-directory*
    syn keyword schemeExtFunc make-empty-attlist
    syn keyword schemeExtFunc make-f16array
    syn keyword schemeExtFunc make-f16vector
    syn keyword schemeExtFunc make-f32array
    syn keyword schemeExtFunc make-f32vector
    syn keyword schemeExtFunc make-f64array
    syn keyword schemeExtFunc make-f64vector
    syn keyword schemeExtFunc make-gettext
    syn keyword schemeExtFunc make-glob-fs-fold
    syn keyword schemeExtFunc make-hash-table
    syn keyword schemeExtFunc make-hook
    syn keyword schemeExtFunc make-http-connection
    syn keyword schemeExtFunc make-initial-:-dispatch
    syn keyword schemeExtFunc make-job
    syn keyword schemeExtFunc make-keyword
    syn keyword schemeExtFunc make-kmp-restart-vector
    syn keyword schemeExtFunc make-list
    syn keyword schemeExtFunc make-module
    syn keyword schemeExtFunc make-mtqueue
    syn keyword schemeExtFunc make-mutex
    syn keyword schemeExtFunc make-packer
    syn keyword schemeExtFunc make-parameter
    syn keyword schemeExtFunc make-peg-parse-error
    syn keyword schemeExtFunc make-peg-stream
    syn keyword schemeExtFunc make-queue
    syn keyword schemeExtFunc make-random-source
    syn keyword schemeExtFunc make-rbtree
    syn keyword schemeExtFunc make-record-type
    syn keyword schemeExtFunc make-rtd
    syn keyword schemeExtFunc make-s16array
    syn keyword schemeExtFunc make-s16vector
    syn keyword schemeExtFunc make-s32array
    syn keyword schemeExtFunc make-s32vector
    syn keyword schemeExtFunc make-s64array
    syn keyword schemeExtFunc make-s64vector
    syn keyword schemeExtFunc make-s8array
    syn keyword schemeExtFunc make-s8vector
    syn keyword schemeExtFunc make-server-socket
    syn keyword schemeExtFunc make-server-sockets
    syn keyword schemeExtFunc make-sockaddrs
    syn keyword schemeExtFunc make-socket
    syn keyword schemeExtFunc make-sparse-table
    syn keyword schemeExtFunc make-sparse-vector
    syn keyword schemeExtFunc make-stream
    syn keyword schemeExtFunc make-string-pointer
    syn keyword schemeExtFunc make-sys-addrinfo
    syn keyword schemeExtFunc make-text-progress-bar
    syn keyword schemeExtFunc make-thread
    syn keyword schemeExtFunc make-thread-pool
    syn keyword schemeExtFunc make-time
    syn keyword schemeExtFunc make-tree-map
    syn keyword schemeExtFunc make-trie
    syn keyword schemeExtFunc make-u16array
    syn keyword schemeExtFunc make-u16vector
    syn keyword schemeExtFunc make-u32array
    syn keyword schemeExtFunc make-u32vector
    syn keyword schemeExtFunc make-u64array
    syn keyword schemeExtFunc make-u64vector
    syn keyword schemeExtFunc make-u8array
    syn keyword schemeExtFunc make-u8vector
    syn keyword schemeExtFunc make-weak-vector
    syn keyword schemeExtFunc make-xml-token
    syn keyword schemeExtFunc map!
    syn keyword schemeExtFunc map$
    syn keyword schemeExtFunc map-in-order
    syn keyword schemeExtFunc map-union
    syn keyword schemeExtFunc match:$-ref
    syn keyword schemeExtFunc match:error
    syn keyword schemeExtFunc match:every
    syn keyword schemeExtFunc md5-digest
    syn keyword schemeExtFunc md5-digest-string
    syn keyword schemeExtFunc member$
    syn keyword schemeExtFunc merge
    syn keyword schemeExtFunc merge!
    syn keyword schemeExtFunc mime-body->file
    syn keyword schemeExtFunc mime-body->string
    syn keyword schemeExtFunc mime-compose-message
    syn keyword schemeExtFunc mime-compose-message-string
    syn keyword schemeExtFunc mime-compose-parameters
    syn keyword schemeExtFunc mime-decode-text
    syn keyword schemeExtFunc mime-decode-word
    syn keyword schemeExtFunc mime-encode-text
    syn keyword schemeExtFunc mime-encode-word
    syn keyword schemeExtFunc mime-make-boundary
    syn keyword schemeExtFunc mime-parse-content-disposition
    syn keyword schemeExtFunc mime-parse-content-type
    syn keyword schemeExtFunc mime-parse-message
    syn keyword schemeExtFunc mime-parse-parameters
    syn keyword schemeExtFunc mime-parse-version
    syn keyword schemeExtFunc mime-retrieve-body
    syn keyword schemeExtFunc min&max
    syn keyword schemeExtFunc modf
    syn keyword schemeExtFunc modified-julian-day->date
    syn keyword schemeExtFunc modified-julian-day->time-monotonic
    syn keyword schemeExtFunc modified-julian-day->time-tai
    syn keyword schemeExtFunc modified-julian-day->time-utc
    syn keyword schemeExtFunc module-exports
    syn keyword schemeExtFunc module-imports
    syn keyword schemeExtFunc module-name
    syn keyword schemeExtFunc module-name->path
    syn keyword schemeExtFunc module-parents
    syn keyword schemeExtFunc module-precedence-list
    syn keyword schemeExtFunc module-table
    syn keyword schemeExtFunc module?
    syn keyword schemeExtFunc monotonic-merge
    syn keyword schemeExtFunc move-file
    syn keyword schemeExtFunc mt-random-fill-f32vector!
    syn keyword schemeExtFunc mt-random-fill-f64vector!
    syn keyword schemeExtFunc mt-random-fill-u32vector!
    syn keyword schemeExtFunc mt-random-get-state
    syn keyword schemeExtFunc mt-random-integer
    syn keyword schemeExtFunc mt-random-real
    syn keyword schemeExtFunc mt-random-real0
    syn keyword schemeExtFunc mt-random-set-seed!
    syn keyword schemeExtFunc mt-random-set-state!
    syn keyword schemeExtFunc mtqueue-max-length
    syn keyword schemeExtFunc mtqueue-room
    syn keyword schemeExtFunc mtqueue?
    syn keyword schemeExtFunc mutex-lock!
    syn keyword schemeExtFunc mutex-name
    syn keyword schemeExtFunc mutex-specific
    syn keyword schemeExtFunc mutex-specific-set!
    syn keyword schemeExtFunc mutex-state
    syn keyword schemeExtFunc mutex-unlock!
    syn keyword schemeExtFunc mutex?
    syn keyword schemeExtFunc name-compare
    syn keyword schemeExtFunc nan?
    syn keyword schemeExtFunc native-endian
    syn keyword schemeExtFunc next-token
    syn keyword schemeExtFunc next-token-of
    syn keyword schemeExtFunc ngettext
    syn keyword schemeExtFunc ninth
    syn keyword schemeExtFunc node-closure
    syn keyword schemeExtFunc node-eq?
    syn keyword schemeExtFunc node-equal?
    syn keyword schemeExtFunc node-join
    syn keyword schemeExtFunc node-or
    syn keyword schemeExtFunc node-pos
    syn keyword schemeExtFunc node-reduce
    syn keyword schemeExtFunc node-reverse
    syn keyword schemeExtFunc node-self
    syn keyword schemeExtFunc node-trace
    syn keyword schemeExtFunc nodeset?
    syn keyword schemeExtFunc not-pair?
    syn keyword schemeExtFunc ntype-names??
    syn keyword schemeExtFunc ntype-namespace-id??
    syn keyword schemeExtFunc ntype??
    syn keyword schemeExtFunc null-device
    syn keyword schemeExtFunc null-list?
    syn keyword schemeExtFunc number->stream
    syn keyword schemeExtFunc open-coding-aware-port
    syn keyword schemeExtFunc open-deflating-port
    syn keyword schemeExtFunc open-inflating-port
    syn keyword schemeExtFunc open-info-file
    syn keyword schemeExtFunc open-input-buffered-port
    syn keyword schemeExtFunc open-input-conversion-port
    syn keyword schemeExtFunc open-input-fd-port
    syn keyword schemeExtFunc open-input-limited-length-port
    syn keyword schemeExtFunc open-input-process-port
    syn keyword schemeExtFunc open-input-string
    syn keyword schemeExtFunc open-input-uvector
    syn keyword schemeExtFunc open-output-buffered-port
    syn keyword schemeExtFunc open-output-conversion-port
    syn keyword schemeExtFunc open-output-fd-port
    syn keyword schemeExtFunc open-output-process-port
    syn keyword schemeExtFunc open-output-string
    syn keyword schemeExtFunc open-output-uvector
    syn keyword schemeExtFunc option
    syn keyword schemeExtFunc option?
    syn keyword schemeExtFunc output-serializer?
    syn keyword schemeExtFunc pa$
    syn keyword schemeExtFunc pack
    syn keyword schemeExtFunc pair-fold
    syn keyword schemeExtFunc pair-fold-right
    syn keyword schemeExtFunc pair-for-each
    syn keyword schemeExtFunc parse-cookie-string
    syn keyword schemeExtFunc parse-json
    syn keyword schemeExtFunc parse-json-string
    syn keyword schemeExtFunc parser-error
    syn keyword schemeExtFunc partition
    syn keyword schemeExtFunc partition!
    syn keyword schemeExtFunc partition$
    syn keyword schemeExtFunc path->gauche-package-description
    syn keyword schemeExtFunc path->module-name
    syn keyword schemeExtFunc path-extension
    syn keyword schemeExtFunc path-sans-extension
    syn keyword schemeExtFunc path-separator
    syn keyword schemeExtFunc path-swap-extension
    syn keyword schemeExtFunc peek-byte
    syn keyword schemeExtFunc peek-next-char
    syn keyword schemeExtFunc peg-parse-port
    syn keyword schemeExtFunc peg-parse-string
    syn keyword schemeExtFunc peg-run-parser
    syn keyword schemeExtFunc peg-stream-peek!
    syn keyword schemeExtFunc peg-stream-position
    syn keyword schemeExtFunc permutations
    syn keyword schemeExtFunc permutations*
    syn keyword schemeExtFunc permutations*-for-each
    syn keyword schemeExtFunc permutations-for-each
    syn keyword schemeExtFunc port->byte-string
    syn keyword schemeExtFunc port->list
    syn keyword schemeExtFunc port->peg-stream
    syn keyword schemeExtFunc port->sexp-list
    syn keyword schemeExtFunc port->stream
    syn keyword schemeExtFunc port->string
    syn keyword schemeExtFunc port->string-list
    syn keyword schemeExtFunc port-buffering
    syn keyword schemeExtFunc port-case-fold-set!
    syn keyword schemeExtFunc port-closed?
    syn keyword schemeExtFunc port-current-line
    syn keyword schemeExtFunc port-fd-dup!
    syn keyword schemeExtFunc port-file-number
    syn keyword schemeExtFunc port-fold
    syn keyword schemeExtFunc port-fold-right
    syn keyword schemeExtFunc port-for-each
    syn keyword schemeExtFunc port-map
    syn keyword schemeExtFunc port-name
    syn keyword schemeExtFunc port-position-prefix
    syn keyword schemeExtFunc port-seek
    syn keyword schemeExtFunc port-tell
    syn keyword schemeExtFunc port-type
    syn keyword schemeExtFunc posix-access
    syn keyword schemeExtFunc posix-chmod
    syn keyword schemeExtFunc posix-ctime
    syn keyword schemeExtFunc posix-domain-name
    syn keyword schemeExtFunc posix-fork
    syn keyword schemeExtFunc posix-getlogin
    syn keyword schemeExtFunc posix-gmtime
    syn keyword schemeExtFunc posix-host-name
    syn keyword schemeExtFunc posix-localtime
    syn keyword schemeExtFunc posix-mktime
    syn keyword schemeExtFunc posix-pipe
    syn keyword schemeExtFunc posix-rename
    syn keyword schemeExtFunc posix-rmdir
    syn keyword schemeExtFunc posix-stat
    syn keyword schemeExtFunc posix-stat->vector
    syn keyword schemeExtFunc posix-strftime
    syn keyword schemeExtFunc posix-symlink
    syn keyword schemeExtFunc posix-time
    syn keyword schemeExtFunc posix-tm->vector
    syn keyword schemeExtFunc posix-uname
    syn keyword schemeExtFunc posix-unlink
    syn keyword schemeExtFunc posix-wait
    syn keyword schemeExtFunc post-order
    syn keyword schemeExtFunc power-set
    syn keyword schemeExtFunc power-set*
    syn keyword schemeExtFunc power-set*-for-each
    syn keyword schemeExtFunc power-set-binary
    syn keyword schemeExtFunc power-set-for-each
    syn keyword schemeExtFunc pp
    syn keyword schemeExtFunc pre-post-order
    syn keyword schemeExtFunc pretty-print-array
    syn keyword schemeExtFunc prim-test
    syn keyword schemeExtFunc print
    syn keyword schemeExtFunc procedure-arity-includes?
    syn keyword schemeExtFunc procedure-info
    syn keyword schemeExtFunc process-alive?
    syn keyword schemeExtFunc process-continue
    syn keyword schemeExtFunc process-error
    syn keyword schemeExtFunc process-input
    syn keyword schemeExtFunc process-kill
    syn keyword schemeExtFunc process-list
    syn keyword schemeExtFunc process-output
    syn keyword schemeExtFunc process-output->string
    syn keyword schemeExtFunc process-output->string-list
    syn keyword schemeExtFunc process-send-signal
    syn keyword schemeExtFunc process-stop
    syn keyword schemeExtFunc process-wait
    syn keyword schemeExtFunc process-wait-any
    syn keyword schemeExtFunc process?
    syn keyword schemeExtFunc profiler-get-result
    syn keyword schemeExtFunc profiler-reset
    syn keyword schemeExtFunc profiler-show
    syn keyword schemeExtFunc profiler-show-load-stats
    syn keyword schemeExtFunc profiler-start
    syn keyword schemeExtFunc profiler-stop
    syn keyword schemeExtFunc promise-kind
    syn keyword schemeExtFunc promise?
    syn keyword schemeExtFunc proper-list?
    syn keyword schemeExtFunc provide
    syn keyword schemeExtFunc provided?
    syn keyword schemeExtFunc put-f16!
    syn keyword schemeExtFunc put-f16be!
    syn keyword schemeExtFunc put-f16le!
    syn keyword schemeExtFunc put-f32!
    syn keyword schemeExtFunc put-f32be!
    syn keyword schemeExtFunc put-f32le!
    syn keyword schemeExtFunc put-f64!
    syn keyword schemeExtFunc put-f64be!
    syn keyword schemeExtFunc put-f64le!
    syn keyword schemeExtFunc put-s16!
    syn keyword schemeExtFunc put-s16be!
    syn keyword schemeExtFunc put-s16le!
    syn keyword schemeExtFunc put-s32!
    syn keyword schemeExtFunc put-s32be!
    syn keyword schemeExtFunc put-s32le!
    syn keyword schemeExtFunc put-s64!
    syn keyword schemeExtFunc put-s64be!
    syn keyword schemeExtFunc put-s64le!
    syn keyword schemeExtFunc put-s8!
    syn keyword schemeExtFunc put-u16!
    syn keyword schemeExtFunc put-u16be!
    syn keyword schemeExtFunc put-u16le!
    syn keyword schemeExtFunc put-u32!
    syn keyword schemeExtFunc put-u32be!
    syn keyword schemeExtFunc put-u32le!
    syn keyword schemeExtFunc put-u64!
    syn keyword schemeExtFunc put-u64be!
    syn keyword schemeExtFunc put-u64le!
    syn keyword schemeExtFunc put-u8!
    syn keyword schemeExtFunc queue->list
    syn keyword schemeExtFunc queue-empty?
    syn keyword schemeExtFunc queue-front
    syn keyword schemeExtFunc queue-length
    syn keyword schemeExtFunc queue-pop!
    syn keyword schemeExtFunc queue-pop/wait!
    syn keyword schemeExtFunc queue-push!
    syn keyword schemeExtFunc queue-push-unique!
    syn keyword schemeExtFunc queue-push/wait!
    syn keyword schemeExtFunc queue-rear
    syn keyword schemeExtFunc queue?
    syn keyword schemeExtFunc quoted-printable-decode
    syn keyword schemeExtFunc quoted-printable-decode-string
    syn keyword schemeExtFunc quoted-printable-encode
    syn keyword schemeExtFunc quoted-printable-encode-string
    syn keyword schemeExtFunc quotient&remainder
    syn keyword schemeExtFunc raise
    syn keyword schemeExtFunc random
    syn keyword schemeExtFunc random-integer
    syn keyword schemeExtFunc random-real
    syn keyword schemeExtFunc random-source-make-integers
    syn keyword schemeExtFunc random-source-make-reals
    syn keyword schemeExtFunc random-source-pseudo-randomize!
    syn keyword schemeExtFunc random-source-randomize!
    syn keyword schemeExtFunc random-source-state-ref
    syn keyword schemeExtFunc random-source-state-set!
    syn keyword schemeExtFunc random-source?
    syn keyword schemeExtFunc rassoc
    syn keyword schemeExtFunc rassoc-ref
    syn keyword schemeExtFunc rassq
    syn keyword schemeExtFunc rassq-ref
    syn keyword schemeExtFunc rassv
    syn keyword schemeExtFunc rassv-ref
    syn keyword schemeExtFunc rbtree->alist
    syn keyword schemeExtFunc rbtree-copy
    syn keyword schemeExtFunc rbtree-delete!
    syn keyword schemeExtFunc rbtree-empty?
    syn keyword schemeExtFunc rbtree-exists?
    syn keyword schemeExtFunc rbtree-extract-max!
    syn keyword schemeExtFunc rbtree-extract-min!
    syn keyword schemeExtFunc rbtree-fold
    syn keyword schemeExtFunc rbtree-fold-right
    syn keyword schemeExtFunc rbtree-get
    syn keyword schemeExtFunc rbtree-keys
    syn keyword schemeExtFunc rbtree-max
    syn keyword schemeExtFunc rbtree-min
    syn keyword schemeExtFunc rbtree-num-entries
    syn keyword schemeExtFunc rbtree-pop!
    syn keyword schemeExtFunc rbtree-push!
    syn keyword schemeExtFunc rbtree-put!
    syn keyword schemeExtFunc rbtree-update!
    syn keyword schemeExtFunc rbtree-values
    syn keyword schemeExtFunc rbtree?
    syn keyword schemeExtFunc read-ber-integer
    syn keyword schemeExtFunc read-binary-double
    syn keyword schemeExtFunc read-binary-float
    syn keyword schemeExtFunc read-binary-long
    syn keyword schemeExtFunc read-binary-short
    syn keyword schemeExtFunc read-binary-sint
    syn keyword schemeExtFunc read-binary-sint16
    syn keyword schemeExtFunc read-binary-sint32
    syn keyword schemeExtFunc read-binary-sint64
    syn keyword schemeExtFunc read-binary-sint8
    syn keyword schemeExtFunc read-binary-uint
    syn keyword schemeExtFunc read-binary-uint16
    syn keyword schemeExtFunc read-binary-uint32
    syn keyword schemeExtFunc read-binary-uint64
    syn keyword schemeExtFunc read-binary-uint8
    syn keyword schemeExtFunc read-binary-ulong
    syn keyword schemeExtFunc read-binary-ushort
    syn keyword schemeExtFunc read-block
    syn keyword schemeExtFunc read-block!
    syn keyword schemeExtFunc read-byte
    syn keyword schemeExtFunc read-char-set
    syn keyword schemeExtFunc read-eval-print-loop
    syn keyword schemeExtFunc read-f16
    syn keyword schemeExtFunc read-f32
    syn keyword schemeExtFunc read-f64
    syn keyword schemeExtFunc read-from-string
    syn keyword schemeExtFunc read-line
    syn keyword schemeExtFunc read-list
    syn keyword schemeExtFunc read-reference-has-value?
    syn keyword schemeExtFunc read-reference-value
    syn keyword schemeExtFunc read-reference?
    syn keyword schemeExtFunc read-s16
    syn keyword schemeExtFunc read-s32
    syn keyword schemeExtFunc read-s64
    syn keyword schemeExtFunc read-s8
    syn keyword schemeExtFunc read-sint
    syn keyword schemeExtFunc read-string
    syn keyword schemeExtFunc read-u16
    syn keyword schemeExtFunc read-u32
    syn keyword schemeExtFunc read-u64
    syn keyword schemeExtFunc read-u8
    syn keyword schemeExtFunc read-uint
    syn keyword schemeExtFunc read-with-shared-structure
    syn keyword schemeExtFunc read/ss
    syn keyword schemeExtFunc record-accessor
    syn keyword schemeExtFunc record-constructor
    syn keyword schemeExtFunc record-modifier
    syn keyword schemeExtFunc record-predicate
    syn keyword schemeExtFunc record-rtd
    syn keyword schemeExtFunc record-type-descriptor
    syn keyword schemeExtFunc record-type-fields
    syn keyword schemeExtFunc record-type-name
    syn keyword schemeExtFunc record?
    syn keyword schemeExtFunc redefine-class!
    syn keyword schemeExtFunc reduce
    syn keyword schemeExtFunc reduce$
    syn keyword schemeExtFunc reduce-right
    syn keyword schemeExtFunc reduce-right$
    syn keyword schemeExtFunc ref*
    syn keyword schemeExtFunc regexp->string
    syn keyword schemeExtFunc regexp-ast
    syn keyword schemeExtFunc regexp-case-fold?
    syn keyword schemeExtFunc regexp-compile
    syn keyword schemeExtFunc regexp-optimize
    syn keyword schemeExtFunc regexp-parse
    syn keyword schemeExtFunc regexp-quote
    syn keyword schemeExtFunc regexp-replace
    syn keyword schemeExtFunc regexp-replace*
    syn keyword schemeExtFunc regexp-replace-all
    syn keyword schemeExtFunc regexp-replace-all*
    syn keyword schemeExtFunc regexp-unparse
    syn keyword schemeExtFunc regexp?
    syn keyword schemeExtFunc regmatch?
    syn keyword schemeExtFunc relative-path?
    syn keyword schemeExtFunc relnum-compare
    syn keyword schemeExtFunc reload
    syn keyword schemeExtFunc reload-modified-modules
    syn keyword schemeExtFunc remove
    syn keyword schemeExtFunc remove!
    syn keyword schemeExtFunc remove$
    syn keyword schemeExtFunc remove-directory*
    syn keyword schemeExtFunc remove-file
    syn keyword schemeExtFunc remove-files
    syn keyword schemeExtFunc remove-from-queue!
    syn keyword schemeExtFunc remq
    syn keyword schemeExtFunc remv
    syn keyword schemeExtFunc rename-file
    syn keyword schemeExtFunc replace-range
    syn keyword schemeExtFunc report-error
    syn keyword schemeExtFunc resolve-path
    syn keyword schemeExtFunc reverse!
    syn keyword schemeExtFunc reverse-list->string
    syn keyword schemeExtFunc reverse-list->vector
    syn keyword schemeExtFunc reverse-vector->list
    syn keyword schemeExtFunc rfc822-atom
    syn keyword schemeExtFunc rfc822-date->date
    syn keyword schemeExtFunc rfc822-dot-atom
    syn keyword schemeExtFunc rfc822-field->tokens
    syn keyword schemeExtFunc rfc822-header->list
    syn keyword schemeExtFunc rfc822-header-ref
    syn keyword schemeExtFunc rfc822-invalid-header-field
    syn keyword schemeExtFunc rfc822-next-token
    syn keyword schemeExtFunc rfc822-parse-date
    syn keyword schemeExtFunc rfc822-parse-errorf
    syn keyword schemeExtFunc rfc822-quoted-string
    syn keyword schemeExtFunc rfc822-read-headers
    syn keyword schemeExtFunc rfc822-skip-cfws
    syn keyword schemeExtFunc rfc822-write-headers
    syn keyword schemeExtFunc rope->string
    syn keyword schemeExtFunc rope-finalize
    syn keyword schemeExtFunc round->exact
    syn keyword schemeExtFunc rtd-all-field-names
    syn keyword schemeExtFunc rtd-field-mutable?
    syn keyword schemeExtFunc rtd-field-names
    syn keyword schemeExtFunc rtd-name
    syn keyword schemeExtFunc rtd-parent
    syn keyword schemeExtFunc rtd?
    syn keyword schemeExtFunc run
    syn keyword schemeExtFunc run-cgi-script->header&body
    syn keyword schemeExtFunc run-cgi-script->string
    syn keyword schemeExtFunc run-cgi-script->string-list
    syn keyword schemeExtFunc run-cgi-script->sxml
    syn keyword schemeExtFunc run-process
    syn keyword schemeExtFunc rxmatch
    syn keyword schemeExtFunc rxmatch->string
    syn keyword schemeExtFunc rxmatch-after
    syn keyword schemeExtFunc rxmatch-before
    syn keyword schemeExtFunc rxmatch-end
    syn keyword schemeExtFunc rxmatch-num-matches
    syn keyword schemeExtFunc rxmatch-start
    syn keyword schemeExtFunc rxmatch-substring
    syn keyword schemeExtFunc s16vector
    syn keyword schemeExtFunc s16vector->list
    syn keyword schemeExtFunc s16vector->vector
    syn keyword schemeExtFunc s16vector-add
    syn keyword schemeExtFunc s16vector-add!
    syn keyword schemeExtFunc s16vector-and
    syn keyword schemeExtFunc s16vector-and!
    syn keyword schemeExtFunc s16vector-clamp
    syn keyword schemeExtFunc s16vector-clamp!
    syn keyword schemeExtFunc s16vector-copy
    syn keyword schemeExtFunc s16vector-copy!
    syn keyword schemeExtFunc s16vector-dot
    syn keyword schemeExtFunc s16vector-fill!
    syn keyword schemeExtFunc s16vector-ior
    syn keyword schemeExtFunc s16vector-ior!
    syn keyword schemeExtFunc s16vector-length
    syn keyword schemeExtFunc s16vector-mul
    syn keyword schemeExtFunc s16vector-mul!
    syn keyword schemeExtFunc s16vector-range-check
    syn keyword schemeExtFunc s16vector-ref
    syn keyword schemeExtFunc s16vector-set!
    syn keyword schemeExtFunc s16vector-sub
    syn keyword schemeExtFunc s16vector-sub!
    syn keyword schemeExtFunc s16vector-swap-bytes
    syn keyword schemeExtFunc s16vector-swap-bytes!
    syn keyword schemeExtFunc s16vector-xor
    syn keyword schemeExtFunc s16vector-xor!
    syn keyword schemeExtFunc s16vector?
    syn keyword schemeExtFunc s32vector
    syn keyword schemeExtFunc s32vector->list
    syn keyword schemeExtFunc s32vector->string
    syn keyword schemeExtFunc s32vector->vector
    syn keyword schemeExtFunc s32vector-add
    syn keyword schemeExtFunc s32vector-add!
    syn keyword schemeExtFunc s32vector-and
    syn keyword schemeExtFunc s32vector-and!
    syn keyword schemeExtFunc s32vector-clamp
    syn keyword schemeExtFunc s32vector-clamp!
    syn keyword schemeExtFunc s32vector-copy
    syn keyword schemeExtFunc s32vector-copy!
    syn keyword schemeExtFunc s32vector-dot
    syn keyword schemeExtFunc s32vector-fill!
    syn keyword schemeExtFunc s32vector-ior
    syn keyword schemeExtFunc s32vector-ior!
    syn keyword schemeExtFunc s32vector-length
    syn keyword schemeExtFunc s32vector-mul
    syn keyword schemeExtFunc s32vector-mul!
    syn keyword schemeExtFunc s32vector-range-check
    syn keyword schemeExtFunc s32vector-ref
    syn keyword schemeExtFunc s32vector-set!
    syn keyword schemeExtFunc s32vector-sub
    syn keyword schemeExtFunc s32vector-sub!
    syn keyword schemeExtFunc s32vector-swap-bytes
    syn keyword schemeExtFunc s32vector-swap-bytes!
    syn keyword schemeExtFunc s32vector-xor
    syn keyword schemeExtFunc s32vector-xor!
    syn keyword schemeExtFunc s32vector?
    syn keyword schemeExtFunc s64vector
    syn keyword schemeExtFunc s64vector->list
    syn keyword schemeExtFunc s64vector->vector
    syn keyword schemeExtFunc s64vector-add
    syn keyword schemeExtFunc s64vector-add!
    syn keyword schemeExtFunc s64vector-and
    syn keyword schemeExtFunc s64vector-and!
    syn keyword schemeExtFunc s64vector-clamp
    syn keyword schemeExtFunc s64vector-clamp!
    syn keyword schemeExtFunc s64vector-copy
    syn keyword schemeExtFunc s64vector-copy!
    syn keyword schemeExtFunc s64vector-dot
    syn keyword schemeExtFunc s64vector-fill!
    syn keyword schemeExtFunc s64vector-ior
    syn keyword schemeExtFunc s64vector-ior!
    syn keyword schemeExtFunc s64vector-length
    syn keyword schemeExtFunc s64vector-mul
    syn keyword schemeExtFunc s64vector-mul!
    syn keyword schemeExtFunc s64vector-range-check
    syn keyword schemeExtFunc s64vector-ref
    syn keyword schemeExtFunc s64vector-set!
    syn keyword schemeExtFunc s64vector-sub
    syn keyword schemeExtFunc s64vector-sub!
    syn keyword schemeExtFunc s64vector-swap-bytes
    syn keyword schemeExtFunc s64vector-swap-bytes!
    syn keyword schemeExtFunc s64vector-xor
    syn keyword schemeExtFunc s64vector-xor!
    syn keyword schemeExtFunc s64vector?
    syn keyword schemeExtFunc s8vector
    syn keyword schemeExtFunc s8vector->list
    syn keyword schemeExtFunc s8vector->string
    syn keyword schemeExtFunc s8vector->vector
    syn keyword schemeExtFunc s8vector-add
    syn keyword schemeExtFunc s8vector-add!
    syn keyword schemeExtFunc s8vector-and
    syn keyword schemeExtFunc s8vector-and!
    syn keyword schemeExtFunc s8vector-clamp
    syn keyword schemeExtFunc s8vector-clamp!
    syn keyword schemeExtFunc s8vector-copy
    syn keyword schemeExtFunc s8vector-copy!
    syn keyword schemeExtFunc s8vector-dot
    syn keyword schemeExtFunc s8vector-fill!
    syn keyword schemeExtFunc s8vector-ior
    syn keyword schemeExtFunc s8vector-ior!
    syn keyword schemeExtFunc s8vector-length
    syn keyword schemeExtFunc s8vector-mul
    syn keyword schemeExtFunc s8vector-mul!
    syn keyword schemeExtFunc s8vector-range-check
    syn keyword schemeExtFunc s8vector-ref
    syn keyword schemeExtFunc s8vector-set!
    syn keyword schemeExtFunc s8vector-sub
    syn keyword schemeExtFunc s8vector-sub!
    syn keyword schemeExtFunc s8vector-xor
    syn keyword schemeExtFunc s8vector-xor!
    syn keyword schemeExtFunc s8vector?
    syn keyword schemeExtFunc second
    syn keyword schemeExtFunc seconds->time
    syn keyword schemeExtFunc select-first-kid
    syn keyword schemeExtFunc select-kids
    syn keyword schemeExtFunc serializer?
    syn keyword schemeExtFunc set-random-seed!
    syn keyword schemeExtFunc set-signal-handler!
    syn keyword schemeExtFunc set-signal-pending-limit
    syn keyword schemeExtFunc setenv!
    syn keyword schemeExtFunc setter
    syn keyword schemeExtFunc seventh
    syn keyword schemeExtFunc sha1-digest
    syn keyword schemeExtFunc sha1-digest-string
    syn keyword schemeExtFunc sha224-digest
    syn keyword schemeExtFunc sha224-digest-string
    syn keyword schemeExtFunc sha256-digest
    syn keyword schemeExtFunc sha256-digest-string
    syn keyword schemeExtFunc sha384-digest
    syn keyword schemeExtFunc sha384-digest-string
    syn keyword schemeExtFunc sha512-digest
    syn keyword schemeExtFunc sha512-digest-string
    syn keyword schemeExtFunc shape
    syn keyword schemeExtFunc shape-for-each
    syn keyword schemeExtFunc share-array
    syn keyword schemeExtFunc shell-escape-string
    syn keyword schemeExtFunc simplify-path
    syn keyword schemeExtFunc sinh
    syn keyword schemeExtFunc sixth
    syn keyword schemeExtFunc skip-until
    syn keyword schemeExtFunc skip-while
    syn keyword schemeExtFunc slices
    syn keyword schemeExtFunc slot-bound-using-accessor?
    syn keyword schemeExtFunc slot-bound?
    syn keyword schemeExtFunc slot-definition-accessor
    syn keyword schemeExtFunc slot-definition-allocation
    syn keyword schemeExtFunc slot-definition-getter
    syn keyword schemeExtFunc slot-definition-name
    syn keyword schemeExtFunc slot-definition-option
    syn keyword schemeExtFunc slot-definition-options
    syn keyword schemeExtFunc slot-definition-setter
    syn keyword schemeExtFunc slot-exists?
    syn keyword schemeExtFunc slot-initialize-using-accessor!
    syn keyword schemeExtFunc slot-pop!
    syn keyword schemeExtFunc slot-push!
    syn keyword schemeExtFunc slot-ref
    syn keyword schemeExtFunc slot-ref-using-accessor
    syn keyword schemeExtFunc slot-set!
    syn keyword schemeExtFunc slot-set-using-accessor!
    syn keyword schemeExtFunc socket-accept
    syn keyword schemeExtFunc socket-address
    syn keyword schemeExtFunc socket-bind
    syn keyword schemeExtFunc socket-buildmsg
    syn keyword schemeExtFunc socket-close
    syn keyword schemeExtFunc socket-connect
    syn keyword schemeExtFunc socket-fd
    syn keyword schemeExtFunc socket-getpeername
    syn keyword schemeExtFunc socket-getsockname
    syn keyword schemeExtFunc socket-getsockopt
    syn keyword schemeExtFunc socket-input-port
    syn keyword schemeExtFunc socket-ioctl
    syn keyword schemeExtFunc socket-listen
    syn keyword schemeExtFunc socket-output-port
    syn keyword schemeExtFunc socket-recv
    syn keyword schemeExtFunc socket-recv!
    syn keyword schemeExtFunc socket-recvfrom
    syn keyword schemeExtFunc socket-recvfrom!
    syn keyword schemeExtFunc socket-send
    syn keyword schemeExtFunc socket-sendmsg
    syn keyword schemeExtFunc socket-sendto
    syn keyword schemeExtFunc socket-setsockopt
    syn keyword schemeExtFunc socket-shutdown
    syn keyword schemeExtFunc socket-status
    syn keyword schemeExtFunc sort
    syn keyword schemeExtFunc sort!
    syn keyword schemeExtFunc sort-by
    syn keyword schemeExtFunc sort-by!
    syn keyword schemeExtFunc sorted?
    syn keyword schemeExtFunc space
    syn keyword schemeExtFunc spaces
    syn keyword schemeExtFunc span
    syn keyword schemeExtFunc span!
    syn keyword schemeExtFunc sparse-table-clear!
    syn keyword schemeExtFunc sparse-table-copy
    syn keyword schemeExtFunc sparse-table-delete!
    syn keyword schemeExtFunc sparse-table-exists?
    syn keyword schemeExtFunc sparse-table-fold
    syn keyword schemeExtFunc sparse-table-for-each
    syn keyword schemeExtFunc sparse-table-keys
    syn keyword schemeExtFunc sparse-table-map
    syn keyword schemeExtFunc sparse-table-num-entries
    syn keyword schemeExtFunc sparse-table-pop!
    syn keyword schemeExtFunc sparse-table-push!
    syn keyword schemeExtFunc sparse-table-ref
    syn keyword schemeExtFunc sparse-table-set!
    syn keyword schemeExtFunc sparse-table-update!
    syn keyword schemeExtFunc sparse-table-values
    syn keyword schemeExtFunc sparse-vector-clear!
    syn keyword schemeExtFunc sparse-vector-copy
    syn keyword schemeExtFunc sparse-vector-delete!
    syn keyword schemeExtFunc sparse-vector-exists?
    syn keyword schemeExtFunc sparse-vector-fold
    syn keyword schemeExtFunc sparse-vector-for-each
    syn keyword schemeExtFunc sparse-vector-inc!
    syn keyword schemeExtFunc sparse-vector-keys
    syn keyword schemeExtFunc sparse-vector-map
    syn keyword schemeExtFunc sparse-vector-max-index-bits
    syn keyword schemeExtFunc sparse-vector-num-entries
    syn keyword schemeExtFunc sparse-vector-pop!
    syn keyword schemeExtFunc sparse-vector-push!
    syn keyword schemeExtFunc sparse-vector-ref
    syn keyword schemeExtFunc sparse-vector-set!
    syn keyword schemeExtFunc sparse-vector-update!
    syn keyword schemeExtFunc sparse-vector-values
    syn keyword schemeExtFunc split-at
    syn keyword schemeExtFunc split-at!
    syn keyword schemeExtFunc split-at*
    syn keyword schemeExtFunc split-string
    syn keyword schemeExtFunc sql-tokenize
    syn keyword schemeExtFunc srfi-42--dispatch
    syn keyword schemeExtFunc srfi-42--dispatch-ref
    syn keyword schemeExtFunc srfi-42--dispatch-set!
    syn keyword schemeExtFunc srl:display-sxml
    syn keyword schemeExtFunc srl:parameterizable
    syn keyword schemeExtFunc srl:sxml->html
    syn keyword schemeExtFunc srl:sxml->html-noindent
    syn keyword schemeExtFunc srl:sxml->string
    syn keyword schemeExtFunc srl:sxml->xml
    syn keyword schemeExtFunc srl:sxml->xml-noindent
    syn keyword schemeExtFunc ssax:assert-token
    syn keyword schemeExtFunc ssax:complete-start-tag
    syn keyword schemeExtFunc ssax:handle-parsed-entity
    syn keyword schemeExtFunc ssax:ncname-starting-char?
    syn keyword schemeExtFunc ssax:read-NCName
    syn keyword schemeExtFunc ssax:read-QName
    syn keyword schemeExtFunc ssax:read-attributes
    syn keyword schemeExtFunc ssax:read-cdata-body
    syn keyword schemeExtFunc ssax:read-char-data
    syn keyword schemeExtFunc ssax:read-char-ref
    syn keyword schemeExtFunc ssax:read-external-id
    syn keyword schemeExtFunc ssax:read-markup-token
    syn keyword schemeExtFunc ssax:read-pi-body-as-string
    syn keyword schemeExtFunc ssax:resolve-name
    syn keyword schemeExtFunc ssax:reverse-collect-str
    syn keyword schemeExtFunc ssax:reverse-collect-str-drop-ws
    syn keyword schemeExtFunc ssax:scan-Misc
    syn keyword schemeExtFunc ssax:skip-S
    syn keyword schemeExtFunc ssax:skip-internal-dtd
    syn keyword schemeExtFunc ssax:skip-pi
    syn keyword schemeExtFunc ssax:uri-string->symbol
    syn keyword schemeExtFunc ssax:warn
    syn keyword schemeExtFunc ssax:xml->sxml
    syn keyword schemeExtFunc stable-sort
    syn keyword schemeExtFunc stable-sort!
    syn keyword schemeExtFunc stable-sort-by
    syn keyword schemeExtFunc stable-sort-by!
    syn keyword schemeExtFunc standard-error-port
    syn keyword schemeExtFunc standard-input-port
    syn keyword schemeExtFunc standard-output-port
    syn keyword schemeExtFunc store-bundle!
    syn keyword schemeExtFunc stream
    syn keyword schemeExtFunc stream->list
    syn keyword schemeExtFunc stream->number
    syn keyword schemeExtFunc stream->string
    syn keyword schemeExtFunc stream->symbol
    syn keyword schemeExtFunc stream-any
    syn keyword schemeExtFunc stream-append
    syn keyword schemeExtFunc stream-break
    syn keyword schemeExtFunc stream-butlast
    syn keyword schemeExtFunc stream-butlast-n
    syn keyword schemeExtFunc stream-caaaar
    syn keyword schemeExtFunc stream-caaadr
    syn keyword schemeExtFunc stream-caaar
    syn keyword schemeExtFunc stream-caadar
    syn keyword schemeExtFunc stream-caaddr
    syn keyword schemeExtFunc stream-caadr
    syn keyword schemeExtFunc stream-caar
    syn keyword schemeExtFunc stream-cadaar
    syn keyword schemeExtFunc stream-cadadr
    syn keyword schemeExtFunc stream-cadar
    syn keyword schemeExtFunc stream-caddar
    syn keyword schemeExtFunc stream-cadddr
    syn keyword schemeExtFunc stream-caddr
    syn keyword schemeExtFunc stream-cadr
    syn keyword schemeExtFunc stream-car
    syn keyword schemeExtFunc stream-cdaaar
    syn keyword schemeExtFunc stream-cdaadr
    syn keyword schemeExtFunc stream-cdaar
    syn keyword schemeExtFunc stream-cdadar
    syn keyword schemeExtFunc stream-cdaddr
    syn keyword schemeExtFunc stream-cdadr
    syn keyword schemeExtFunc stream-cdar
    syn keyword schemeExtFunc stream-cddaar
    syn keyword schemeExtFunc stream-cddadr
    syn keyword schemeExtFunc stream-cddar
    syn keyword schemeExtFunc stream-cdddar
    syn keyword schemeExtFunc stream-cddddr
    syn keyword schemeExtFunc stream-cdddr
    syn keyword schemeExtFunc stream-cddr
    syn keyword schemeExtFunc stream-cdr
    syn keyword schemeExtFunc stream-concatenate
    syn keyword schemeExtFunc stream-cons*
    syn keyword schemeExtFunc stream-count
    syn keyword schemeExtFunc stream-delete
    syn keyword schemeExtFunc stream-delete-duplicates
    syn keyword schemeExtFunc stream-drop
    syn keyword schemeExtFunc stream-drop-safe
    syn keyword schemeExtFunc stream-drop-while
    syn keyword schemeExtFunc stream-eighth
    syn keyword schemeExtFunc stream-every
    syn keyword schemeExtFunc stream-fifth
    syn keyword schemeExtFunc stream-filter
    syn keyword schemeExtFunc stream-find
    syn keyword schemeExtFunc stream-find-tail
    syn keyword schemeExtFunc stream-first
    syn keyword schemeExtFunc stream-for-each
    syn keyword schemeExtFunc stream-format
    syn keyword schemeExtFunc stream-fourth
    syn keyword schemeExtFunc stream-grep
    syn keyword schemeExtFunc stream-index
    syn keyword schemeExtFunc stream-intersperse
    syn keyword schemeExtFunc stream-iota
    syn keyword schemeExtFunc stream-last
    syn keyword schemeExtFunc stream-last-n
    syn keyword schemeExtFunc stream-length
    syn keyword schemeExtFunc stream-length>=
    syn keyword schemeExtFunc stream-lines
    syn keyword schemeExtFunc stream-map
    syn keyword schemeExtFunc stream-member
    syn keyword schemeExtFunc stream-memq
    syn keyword schemeExtFunc stream-memv
    syn keyword schemeExtFunc stream-ninth
    syn keyword schemeExtFunc stream-null?
    syn keyword schemeExtFunc stream-pair?
    syn keyword schemeExtFunc stream-partition
    syn keyword schemeExtFunc stream-prefix=
    syn keyword schemeExtFunc stream-ref
    syn keyword schemeExtFunc stream-remove
    syn keyword schemeExtFunc stream-replace
    syn keyword schemeExtFunc stream-reverse
    syn keyword schemeExtFunc stream-second
    syn keyword schemeExtFunc stream-seventh
    syn keyword schemeExtFunc stream-sixth
    syn keyword schemeExtFunc stream-span
    syn keyword schemeExtFunc stream-split
    syn keyword schemeExtFunc stream-tabulate
    syn keyword schemeExtFunc stream-take
    syn keyword schemeExtFunc stream-take-safe
    syn keyword schemeExtFunc stream-take-while
    syn keyword schemeExtFunc stream-tenth
    syn keyword schemeExtFunc stream-third
    syn keyword schemeExtFunc stream-translate
    syn keyword schemeExtFunc stream-unfoldn
    syn keyword schemeExtFunc stream-xcons
    syn keyword schemeExtFunc stream=
    syn keyword schemeExtFunc stream?
    syn keyword schemeExtFunc string->char-set
    syn keyword schemeExtFunc string->char-set!
    syn keyword schemeExtFunc string->date
    syn keyword schemeExtFunc string->peg-stream
    syn keyword schemeExtFunc string->regexp
    syn keyword schemeExtFunc string->s32vector
    syn keyword schemeExtFunc string->s8vector
    syn keyword schemeExtFunc string->s8vector!
    syn keyword schemeExtFunc string->stream
    syn keyword schemeExtFunc string->u32vector
    syn keyword schemeExtFunc string->u8vector
    syn keyword schemeExtFunc string->u8vector!
    syn keyword schemeExtFunc string->uninterned-symbol
    syn keyword schemeExtFunc string-any
    syn keyword schemeExtFunc string-append/shared
    syn keyword schemeExtFunc string-byte-ref
    syn keyword schemeExtFunc string-byte-set!
    syn keyword schemeExtFunc string-ci<
    syn keyword schemeExtFunc string-ci<=
    syn keyword schemeExtFunc string-ci<>
    syn keyword schemeExtFunc string-ci=
    syn keyword schemeExtFunc string-ci>
    syn keyword schemeExtFunc string-ci>=
    syn keyword schemeExtFunc string-compare
    syn keyword schemeExtFunc string-compare-ci
    syn keyword schemeExtFunc string-complete->incomplete
    syn keyword schemeExtFunc string-concatenate
    syn keyword schemeExtFunc string-concatenate-reverse
    syn keyword schemeExtFunc string-concatenate-reverse/shared
    syn keyword schemeExtFunc string-concatenate/shared
    syn keyword schemeExtFunc string-contains
    syn keyword schemeExtFunc string-contains-ci
    syn keyword schemeExtFunc string-copy!
    syn keyword schemeExtFunc string-count
    syn keyword schemeExtFunc string-delete
    syn keyword schemeExtFunc string-downcase
    syn keyword schemeExtFunc string-downcase!
    syn keyword schemeExtFunc string-drop
    syn keyword schemeExtFunc string-drop-right
    syn keyword schemeExtFunc string-every
    syn keyword schemeExtFunc string-fill!
    syn keyword schemeExtFunc string-filter
    syn keyword schemeExtFunc string-find
    syn keyword schemeExtFunc string-fold
    syn keyword schemeExtFunc string-fold-right
    syn keyword schemeExtFunc string-for-each
    syn keyword schemeExtFunc string-for-each-index
    syn keyword schemeExtFunc string-hash
    syn keyword schemeExtFunc string-hash-ci
    syn keyword schemeExtFunc string-immutable?
    syn keyword schemeExtFunc string-incomplete->complete
    syn keyword schemeExtFunc string-incomplete->complete!
    syn keyword schemeExtFunc string-incomplete?
    syn keyword schemeExtFunc string-index
    syn keyword schemeExtFunc string-index-right
    syn keyword schemeExtFunc string-interpolate
    syn keyword schemeExtFunc string-join
    syn keyword schemeExtFunc string-kmp-partial-search
    syn keyword schemeExtFunc string-lower
    syn keyword schemeExtFunc string-map
    syn keyword schemeExtFunc string-map!
    syn keyword schemeExtFunc string-null?
    syn keyword schemeExtFunc string-pad
    syn keyword schemeExtFunc string-pad-right
    syn keyword schemeExtFunc string-parse-final-start+end
    syn keyword schemeExtFunc string-parse-start+end
    syn keyword schemeExtFunc string-pointer-byte-index
    syn keyword schemeExtFunc string-pointer-copy
    syn keyword schemeExtFunc string-pointer-index
    syn keyword schemeExtFunc string-pointer-next!
    syn keyword schemeExtFunc string-pointer-prev!
    syn keyword schemeExtFunc string-pointer-ref
    syn keyword schemeExtFunc string-pointer-set!
    syn keyword schemeExtFunc string-pointer-substring
    syn keyword schemeExtFunc string-pointer?
    syn keyword schemeExtFunc string-prefix-ci?
    syn keyword schemeExtFunc string-prefix-length
    syn keyword schemeExtFunc string-prefix-length-ci
    syn keyword schemeExtFunc string-prefix?
    syn keyword schemeExtFunc string-replace
    syn keyword schemeExtFunc string-reverse
    syn keyword schemeExtFunc string-reverse!
    syn keyword schemeExtFunc string-rindex
    syn keyword schemeExtFunc string-scan
    syn keyword schemeExtFunc string-size
    syn keyword schemeExtFunc string-skip
    syn keyword schemeExtFunc string-skip-right
    syn keyword schemeExtFunc string-split
    syn keyword schemeExtFunc string-suffix-ci?
    syn keyword schemeExtFunc string-suffix-length
    syn keyword schemeExtFunc string-suffix-length-ci
    syn keyword schemeExtFunc string-suffix?
    syn keyword schemeExtFunc string-tabulate
    syn keyword schemeExtFunc string-take
    syn keyword schemeExtFunc string-take-right
    syn keyword schemeExtFunc string-titlecase
    syn keyword schemeExtFunc string-titlecase!
    syn keyword schemeExtFunc string-tokenize
    syn keyword schemeExtFunc string-tr
    syn keyword schemeExtFunc string-transliterate
    syn keyword schemeExtFunc string-trim
    syn keyword schemeExtFunc string-trim-both
    syn keyword schemeExtFunc string-trim-right
    syn keyword schemeExtFunc string-unfold
    syn keyword schemeExtFunc string-unfold-right
    syn keyword schemeExtFunc string-upcase
    syn keyword schemeExtFunc string-upcase!
    syn keyword schemeExtFunc string-upper
    syn keyword schemeExtFunc string-whitespace?
    syn keyword schemeExtFunc string-xcopy!
    syn keyword schemeExtFunc string<
    syn keyword schemeExtFunc string<=
    syn keyword schemeExtFunc string<>
    syn keyword schemeExtFunc string=
    syn keyword schemeExtFunc string>
    syn keyword schemeExtFunc string>=
    syn keyword schemeExtFunc subarray
    syn keyword schemeExtFunc subr?
    syn keyword schemeExtFunc substring-spec-ok?
    syn keyword schemeExtFunc substring/shared
    syn keyword schemeExtFunc substring?
    syn keyword schemeExtFunc subtract-duration
    syn keyword schemeExtFunc subtract-duration!
    syn keyword schemeExtFunc supported-character-encoding?
    syn keyword schemeExtFunc supported-character-encodings
    syn keyword schemeExtFunc sxml:add-attr
    syn keyword schemeExtFunc sxml:add-attr!
    syn keyword schemeExtFunc sxml:add-aux
    syn keyword schemeExtFunc sxml:add-aux!
    syn keyword schemeExtFunc sxml:add-parents
    syn keyword schemeExtFunc sxml:ancestor
    syn keyword schemeExtFunc sxml:ancestor-or-self
    syn keyword schemeExtFunc sxml:attr
    syn keyword schemeExtFunc sxml:attr->html
    syn keyword schemeExtFunc sxml:attr->xml
    syn keyword schemeExtFunc sxml:attr-as-list
    syn keyword schemeExtFunc sxml:attr-list
    syn keyword schemeExtFunc sxml:attr-list-node
    syn keyword schemeExtFunc sxml:attr-list-u
    syn keyword schemeExtFunc sxml:attr-u
    syn keyword schemeExtFunc sxml:attribute
    syn keyword schemeExtFunc sxml:aux-as-list
    syn keyword schemeExtFunc sxml:aux-list
    syn keyword schemeExtFunc sxml:aux-list-node
    syn keyword schemeExtFunc sxml:aux-list-u
    syn keyword schemeExtFunc sxml:aux-node
    syn keyword schemeExtFunc sxml:aux-nodes
    syn keyword schemeExtFunc sxml:boolean
    syn keyword schemeExtFunc sxml:change-attr
    syn keyword schemeExtFunc sxml:change-attr!
    syn keyword schemeExtFunc sxml:change-attrlist
    syn keyword schemeExtFunc sxml:change-attrlist!
    syn keyword schemeExtFunc sxml:change-content
    syn keyword schemeExtFunc sxml:change-content!
    syn keyword schemeExtFunc sxml:change-name
    syn keyword schemeExtFunc sxml:change-name!
    syn keyword schemeExtFunc sxml:child
    syn keyword schemeExtFunc sxml:child-elements
    syn keyword schemeExtFunc sxml:child-nodes
    syn keyword schemeExtFunc sxml:clean
    syn keyword schemeExtFunc sxml:clean-feed
    syn keyword schemeExtFunc sxml:content
    syn keyword schemeExtFunc sxml:content-raw
    syn keyword schemeExtFunc sxml:descendant
    syn keyword schemeExtFunc sxml:descendant-or-self
    syn keyword schemeExtFunc sxml:element-name
    syn keyword schemeExtFunc sxml:element?
    syn keyword schemeExtFunc sxml:empty-element?
    syn keyword schemeExtFunc sxml:equal?
    syn keyword schemeExtFunc sxml:equality-cmp
    syn keyword schemeExtFunc sxml:error
    syn keyword schemeExtFunc sxml:filter
    syn keyword schemeExtFunc sxml:following
    syn keyword schemeExtFunc sxml:following-sibling
    syn keyword schemeExtFunc sxml:id
    syn keyword schemeExtFunc sxml:id-alist
    syn keyword schemeExtFunc sxml:invert
    syn keyword schemeExtFunc sxml:lookup
    syn keyword schemeExtFunc sxml:minimized?
    syn keyword schemeExtFunc sxml:name
    syn keyword schemeExtFunc sxml:name->ns-id
    syn keyword schemeExtFunc sxml:namespace
    syn keyword schemeExtFunc sxml:ncname
    syn keyword schemeExtFunc sxml:node-name
    syn keyword schemeExtFunc sxml:node-parent
    syn keyword schemeExtFunc sxml:node?
    syn keyword schemeExtFunc sxml:non-terminated-html-tag?
    syn keyword schemeExtFunc sxml:normalized?
    syn keyword schemeExtFunc sxml:not-equal?
    syn keyword schemeExtFunc sxml:ns-id
    syn keyword schemeExtFunc sxml:ns-id->nodes
    syn keyword schemeExtFunc sxml:ns-id->uri
    syn keyword schemeExtFunc sxml:ns-list
    syn keyword schemeExtFunc sxml:ns-prefix
    syn keyword schemeExtFunc sxml:ns-uri
    syn keyword schemeExtFunc sxml:ns-uri->id
    syn keyword schemeExtFunc sxml:ns-uri->nodes
    syn keyword schemeExtFunc sxml:num-attr
    syn keyword schemeExtFunc sxml:number
    syn keyword schemeExtFunc sxml:parent
    syn keyword schemeExtFunc sxml:preceding
    syn keyword schemeExtFunc sxml:preceding-sibling
    syn keyword schemeExtFunc sxml:relational-cmp
    syn keyword schemeExtFunc sxml:set-attr
    syn keyword schemeExtFunc sxml:set-attr!
    syn keyword schemeExtFunc sxml:shallow-minimized?
    syn keyword schemeExtFunc sxml:shallow-normalized?
    syn keyword schemeExtFunc sxml:squeeze
    syn keyword schemeExtFunc sxml:squeeze!
    syn keyword schemeExtFunc sxml:string
    syn keyword schemeExtFunc sxml:string->html
    syn keyword schemeExtFunc sxml:string->xml
    syn keyword schemeExtFunc sxml:string-value
    syn keyword schemeExtFunc sxml:sxml->html
    syn keyword schemeExtFunc sxml:sxml->xml
    syn keyword schemeExtFunc sxpath
    syn keyword schemeExtFunc symbol->stream
    syn keyword schemeExtFunc symbol-bound?
    syn keyword schemeExtFunc symbol-interned?
    syn keyword schemeExtFunc symbol-sans-prefix
    syn keyword schemeExtFunc sys-abort
    syn keyword schemeExtFunc sys-access
    syn keyword schemeExtFunc sys-alarm
    syn keyword schemeExtFunc sys-asctime
    syn keyword schemeExtFunc sys-basename
    syn keyword schemeExtFunc sys-cfgetispeed
    syn keyword schemeExtFunc sys-cfgetospeed
    syn keyword schemeExtFunc sys-cfsetispeed
    syn keyword schemeExtFunc sys-cfsetospeed
    syn keyword schemeExtFunc sys-chdir
    syn keyword schemeExtFunc sys-chmod
    syn keyword schemeExtFunc sys-chown
    syn keyword schemeExtFunc sys-close
    syn keyword schemeExtFunc sys-closelog
    syn keyword schemeExtFunc sys-crypt
    syn keyword schemeExtFunc sys-ctermid
    syn keyword schemeExtFunc sys-ctime
    syn keyword schemeExtFunc sys-difftime
    syn keyword schemeExtFunc sys-dirname
    syn keyword schemeExtFunc sys-environ
    syn keyword schemeExtFunc sys-environ->alist
    syn keyword schemeExtFunc sys-exec
    syn keyword schemeExtFunc sys-exit
    syn keyword schemeExtFunc sys-fchmod
    syn keyword schemeExtFunc sys-fcntl
    syn keyword schemeExtFunc sys-fdset
    syn keyword schemeExtFunc sys-fdset->list
    syn keyword schemeExtFunc sys-fdset-clear!
    syn keyword schemeExtFunc sys-fdset-copy!
    syn keyword schemeExtFunc sys-fdset-max-fd
    syn keyword schemeExtFunc sys-fdset-ref
    syn keyword schemeExtFunc sys-fdset-set!
    syn keyword schemeExtFunc sys-fork
    syn keyword schemeExtFunc sys-fork-and-exec
    syn keyword schemeExtFunc sys-forkpty
    syn keyword schemeExtFunc sys-forkpty-and-exec
    syn keyword schemeExtFunc sys-fstat
    syn keyword schemeExtFunc sys-ftruncate
    syn keyword schemeExtFunc sys-getcwd
    syn keyword schemeExtFunc sys-getdomainname
    syn keyword schemeExtFunc sys-getegid
    syn keyword schemeExtFunc sys-getenv
    syn keyword schemeExtFunc sys-geteuid
    syn keyword schemeExtFunc sys-getgid
    syn keyword schemeExtFunc sys-getgrgid
    syn keyword schemeExtFunc sys-getgrnam
    syn keyword schemeExtFunc sys-getgroups
    syn keyword schemeExtFunc sys-gethostbyaddr
    syn keyword schemeExtFunc sys-gethostbyname
    syn keyword schemeExtFunc sys-gethostname
    syn keyword schemeExtFunc sys-getloadavg
    syn keyword schemeExtFunc sys-getlogin
    syn keyword schemeExtFunc sys-getpgid
    syn keyword schemeExtFunc sys-getpgrp
    syn keyword schemeExtFunc sys-getpid
    syn keyword schemeExtFunc sys-getppid
    syn keyword schemeExtFunc sys-getprotobyname
    syn keyword schemeExtFunc sys-getprotobynumber
    syn keyword schemeExtFunc sys-getpwnam
    syn keyword schemeExtFunc sys-getpwuid
    syn keyword schemeExtFunc sys-getrlimit
    syn keyword schemeExtFunc sys-getservbyname
    syn keyword schemeExtFunc sys-getservbyport
    syn keyword schemeExtFunc sys-gettimeofday
    syn keyword schemeExtFunc sys-getuid
    syn keyword schemeExtFunc sys-gid->group-name
    syn keyword schemeExtFunc sys-glob
    syn keyword schemeExtFunc sys-gmtime
    syn keyword schemeExtFunc sys-group-name->gid
    syn keyword schemeExtFunc sys-htonl
    syn keyword schemeExtFunc sys-htons
    syn keyword schemeExtFunc sys-isatty
    syn keyword schemeExtFunc sys-kill
    syn keyword schemeExtFunc sys-lchown
    syn keyword schemeExtFunc sys-link
    syn keyword schemeExtFunc sys-localeconv
    syn keyword schemeExtFunc sys-localtime
    syn keyword schemeExtFunc sys-logmask
    syn keyword schemeExtFunc sys-lstat
    syn keyword schemeExtFunc sys-mkdir
    syn keyword schemeExtFunc sys-mkfifo
    syn keyword schemeExtFunc sys-mkstemp
    syn keyword schemeExtFunc sys-mktime
    syn keyword schemeExtFunc sys-nanosleep
    syn keyword schemeExtFunc sys-normalize-pathname
    syn keyword schemeExtFunc sys-ntohl
    syn keyword schemeExtFunc sys-ntohs
    syn keyword schemeExtFunc sys-openlog
    syn keyword schemeExtFunc sys-openpty
    syn keyword schemeExtFunc sys-pause
    syn keyword schemeExtFunc sys-pipe
    syn keyword schemeExtFunc sys-putenv
    syn keyword schemeExtFunc sys-random
    syn keyword schemeExtFunc sys-readdir
    syn keyword schemeExtFunc sys-readlink
    syn keyword schemeExtFunc sys-realpath
    syn keyword schemeExtFunc sys-remove
    syn keyword schemeExtFunc sys-rename
    syn keyword schemeExtFunc sys-rmdir
    syn keyword schemeExtFunc sys-select
    syn keyword schemeExtFunc sys-select!
    syn keyword schemeExtFunc sys-setenv
    syn keyword schemeExtFunc sys-setgid
    syn keyword schemeExtFunc sys-setlocale
    syn keyword schemeExtFunc sys-setlogmask
    syn keyword schemeExtFunc sys-setpgid
    syn keyword schemeExtFunc sys-setrlimit
    syn keyword schemeExtFunc sys-setsid
    syn keyword schemeExtFunc sys-setuid
    syn keyword schemeExtFunc sys-sigmask
    syn keyword schemeExtFunc sys-signal-name
    syn keyword schemeExtFunc sys-sigset
    syn keyword schemeExtFunc sys-sigset-add!
    syn keyword schemeExtFunc sys-sigset-delete!
    syn keyword schemeExtFunc sys-sigset-empty!
    syn keyword schemeExtFunc sys-sigset-fill!
    syn keyword schemeExtFunc sys-sigsuspend
    syn keyword schemeExtFunc sys-sigwait
    syn keyword schemeExtFunc sys-sleep
    syn keyword schemeExtFunc sys-srandom
    syn keyword schemeExtFunc sys-stat
    syn keyword schemeExtFunc sys-stat->atime
    syn keyword schemeExtFunc sys-stat->ctime
    syn keyword schemeExtFunc sys-stat->dev
    syn keyword schemeExtFunc sys-stat->file-type
    syn keyword schemeExtFunc sys-stat->gid
    syn keyword schemeExtFunc sys-stat->ino
    syn keyword schemeExtFunc sys-stat->mode
    syn keyword schemeExtFunc sys-stat->mtime
    syn keyword schemeExtFunc sys-stat->nlink
    syn keyword schemeExtFunc sys-stat->rdev
    syn keyword schemeExtFunc sys-stat->size
    syn keyword schemeExtFunc sys-stat->type
    syn keyword schemeExtFunc sys-stat->uid
    syn keyword schemeExtFunc sys-strerror
    syn keyword schemeExtFunc sys-strftime
    syn keyword schemeExtFunc sys-symlink
    syn keyword schemeExtFunc sys-syslog
    syn keyword schemeExtFunc sys-system
    syn keyword schemeExtFunc sys-tcdrain
    syn keyword schemeExtFunc sys-tcflow
    syn keyword schemeExtFunc sys-tcflush
    syn keyword schemeExtFunc sys-tcgetattr
    syn keyword schemeExtFunc sys-tcgetpgrp
    syn keyword schemeExtFunc sys-tcsendbreak
    syn keyword schemeExtFunc sys-tcsetattr
    syn keyword schemeExtFunc sys-tcsetpgrp
    syn keyword schemeExtFunc sys-time
    syn keyword schemeExtFunc sys-times
    syn keyword schemeExtFunc sys-tm->alist
    syn keyword schemeExtFunc sys-tmpdir
    syn keyword schemeExtFunc sys-tmpnam
    syn keyword schemeExtFunc sys-truncate
    syn keyword schemeExtFunc sys-ttyname
    syn keyword schemeExtFunc sys-uid->user-name
    syn keyword schemeExtFunc sys-umask
    syn keyword schemeExtFunc sys-uname
    syn keyword schemeExtFunc sys-unlink
    syn keyword schemeExtFunc sys-unsetenv
    syn keyword schemeExtFunc sys-user-name->uid
    syn keyword schemeExtFunc sys-utime
    syn keyword schemeExtFunc sys-wait
    syn keyword schemeExtFunc sys-wait-exit-status
    syn keyword schemeExtFunc sys-wait-exited?
    syn keyword schemeExtFunc sys-wait-signaled?
    syn keyword schemeExtFunc sys-wait-stopped?
    syn keyword schemeExtFunc sys-wait-stopsig
    syn keyword schemeExtFunc sys-wait-termsig
    syn keyword schemeExtFunc sys-waitpid
    syn keyword schemeExtFunc system
    syn keyword schemeExtFunc tab
    syn keyword schemeExtFunc tabulate-array
    syn keyword schemeExtFunc take
    syn keyword schemeExtFunc take!
    syn keyword schemeExtFunc take*
    syn keyword schemeExtFunc take-after
    syn keyword schemeExtFunc take-right
    syn keyword schemeExtFunc take-right*
    syn keyword schemeExtFunc take-until
    syn keyword schemeExtFunc take-while
    syn keyword schemeExtFunc take-while!
    syn keyword schemeExtFunc tanh
    syn keyword schemeExtFunc temporary-file-name
    syn keyword schemeExtFunc tenth
    syn keyword schemeExtFunc terminate-all!
    syn keyword schemeExtFunc terminated-thread-exception?
    syn keyword schemeExtFunc test
    syn keyword schemeExtFunc test-check
    syn keyword schemeExtFunc test-end
    syn keyword schemeExtFunc test-error
    syn keyword schemeExtFunc test-error?
    syn keyword schemeExtFunc test-module
    syn keyword schemeExtFunc test-record-file
    syn keyword schemeExtFunc test-section
    syn keyword schemeExtFunc test-start
    syn keyword schemeExtFunc textdomain
    syn keyword schemeExtFunc third
    syn keyword schemeExtFunc thread-cont!
    syn keyword schemeExtFunc thread-join!
    syn keyword schemeExtFunc thread-name
    syn keyword schemeExtFunc thread-sleep!
    syn keyword schemeExtFunc thread-specific
    syn keyword schemeExtFunc thread-specific-set!
    syn keyword schemeExtFunc thread-start!
    syn keyword schemeExtFunc thread-state
    syn keyword schemeExtFunc thread-stop!
    syn keyword schemeExtFunc thread-terminate!
    syn keyword schemeExtFunc thread-yield!
    syn keyword schemeExtFunc thread?
    syn keyword schemeExtFunc time->seconds
    syn keyword schemeExtFunc time-difference
    syn keyword schemeExtFunc time-difference!
    syn keyword schemeExtFunc time-monotonic->date
    syn keyword schemeExtFunc time-monotonic->julian-day
    syn keyword schemeExtFunc time-monotonic->modified-julian-day
    syn keyword schemeExtFunc time-monotonic->time-tai
    syn keyword schemeExtFunc time-monotonic->time-tai!
    syn keyword schemeExtFunc time-monotonic->time-utc
    syn keyword schemeExtFunc time-monotonic->time-utc!
    syn keyword schemeExtFunc time-resolution
    syn keyword schemeExtFunc time-tai->date
    syn keyword schemeExtFunc time-tai->julian-day
    syn keyword schemeExtFunc time-tai->modified-julian-day
    syn keyword schemeExtFunc time-tai->time-monotonic
    syn keyword schemeExtFunc time-tai->time-monotonic!
    syn keyword schemeExtFunc time-tai->time-utc
    syn keyword schemeExtFunc time-tai->time-utc!
    syn keyword schemeExtFunc time-utc->date
    syn keyword schemeExtFunc time-utc->julian-day
    syn keyword schemeExtFunc time-utc->modified-julian-day
    syn keyword schemeExtFunc time-utc->time-monotonic
    syn keyword schemeExtFunc time-utc->time-monotonic!
    syn keyword schemeExtFunc time-utc->time-tai
    syn keyword schemeExtFunc time-utc->time-tai!
    syn keyword schemeExtFunc time<=?
    syn keyword schemeExtFunc time<?
    syn keyword schemeExtFunc time=?
    syn keyword schemeExtFunc time>=?
    syn keyword schemeExtFunc time>?
    syn keyword schemeExtFunc time?
    syn keyword schemeExtFunc toplevel-closure?
    syn keyword schemeExtFunc topological-sort
    syn keyword schemeExtFunc touch-file
    syn keyword schemeExtFunc touch-instance!
    syn keyword schemeExtFunc tr
    syn keyword schemeExtFunc transliterate
    syn keyword schemeExtFunc tree->string
    syn keyword schemeExtFunc tree-fold
    syn keyword schemeExtFunc tree-fold-bf
    syn keyword schemeExtFunc tree-map->alist
    syn keyword schemeExtFunc tree-map-ceiling
    syn keyword schemeExtFunc tree-map-ceiling-key
    syn keyword schemeExtFunc tree-map-ceiling-value
    syn keyword schemeExtFunc tree-map-clear!
    syn keyword schemeExtFunc tree-map-copy
    syn keyword schemeExtFunc tree-map-delete!
    syn keyword schemeExtFunc tree-map-empty?
    syn keyword schemeExtFunc tree-map-exists?
    syn keyword schemeExtFunc tree-map-floor
    syn keyword schemeExtFunc tree-map-floor-key
    syn keyword schemeExtFunc tree-map-floor-value
    syn keyword schemeExtFunc tree-map-fold
    syn keyword schemeExtFunc tree-map-fold-right
    syn keyword schemeExtFunc tree-map-for-each
    syn keyword schemeExtFunc tree-map-get
    syn keyword schemeExtFunc tree-map-keys
    syn keyword schemeExtFunc tree-map-map
    syn keyword schemeExtFunc tree-map-max
    syn keyword schemeExtFunc tree-map-min
    syn keyword schemeExtFunc tree-map-num-entries
    syn keyword schemeExtFunc tree-map-pop!
    syn keyword schemeExtFunc tree-map-pop-max!
    syn keyword schemeExtFunc tree-map-pop-min!
    syn keyword schemeExtFunc tree-map-predecessor
    syn keyword schemeExtFunc tree-map-predecessor-key
    syn keyword schemeExtFunc tree-map-predecessor-value
    syn keyword schemeExtFunc tree-map-push!
    syn keyword schemeExtFunc tree-map-put!
    syn keyword schemeExtFunc tree-map-successor
    syn keyword schemeExtFunc tree-map-successor-key
    syn keyword schemeExtFunc tree-map-successor-value
    syn keyword schemeExtFunc tree-map-update!
    syn keyword schemeExtFunc tree-map-values
    syn keyword schemeExtFunc tree-map?
    syn keyword schemeExtFunc tree-walk
    syn keyword schemeExtFunc tree-walk-bf
    syn keyword schemeExtFunc trie
    syn keyword schemeExtFunc trie->hash-table
    syn keyword schemeExtFunc trie->list
    syn keyword schemeExtFunc trie-common-prefix
    syn keyword schemeExtFunc trie-common-prefix-fold
    syn keyword schemeExtFunc trie-common-prefix-for-each
    syn keyword schemeExtFunc trie-common-prefix-keys
    syn keyword schemeExtFunc trie-common-prefix-map
    syn keyword schemeExtFunc trie-common-prefix-values
    syn keyword schemeExtFunc trie-delete!
    syn keyword schemeExtFunc trie-exists?
    syn keyword schemeExtFunc trie-fold
    syn keyword schemeExtFunc trie-for-each
    syn keyword schemeExtFunc trie-get
    syn keyword schemeExtFunc trie-keys
    syn keyword schemeExtFunc trie-map
    syn keyword schemeExtFunc trie-num-entries
    syn keyword schemeExtFunc trie-put!
    syn keyword schemeExtFunc trie-update!
    syn keyword schemeExtFunc trie-values
    syn keyword schemeExtFunc trie-with-keys
    syn keyword schemeExtFunc trie?
    syn keyword schemeExtFunc truncate->exact
    syn keyword schemeExtFunc u16vector
    syn keyword schemeExtFunc u16vector->list
    syn keyword schemeExtFunc u16vector->vector
    syn keyword schemeExtFunc u16vector-add
    syn keyword schemeExtFunc u16vector-add!
    syn keyword schemeExtFunc u16vector-and
    syn keyword schemeExtFunc u16vector-and!
    syn keyword schemeExtFunc u16vector-clamp
    syn keyword schemeExtFunc u16vector-clamp!
    syn keyword schemeExtFunc u16vector-copy
    syn keyword schemeExtFunc u16vector-copy!
    syn keyword schemeExtFunc u16vector-dot
    syn keyword schemeExtFunc u16vector-fill!
    syn keyword schemeExtFunc u16vector-ior
    syn keyword schemeExtFunc u16vector-ior!
    syn keyword schemeExtFunc u16vector-length
    syn keyword schemeExtFunc u16vector-mul
    syn keyword schemeExtFunc u16vector-mul!
    syn keyword schemeExtFunc u16vector-range-check
    syn keyword schemeExtFunc u16vector-ref
    syn keyword schemeExtFunc u16vector-set!
    syn keyword schemeExtFunc u16vector-sub
    syn keyword schemeExtFunc u16vector-sub!
    syn keyword schemeExtFunc u16vector-swap-bytes
    syn keyword schemeExtFunc u16vector-swap-bytes!
    syn keyword schemeExtFunc u16vector-xor
    syn keyword schemeExtFunc u16vector-xor!
    syn keyword schemeExtFunc u16vector?
    syn keyword schemeExtFunc u32vector
    syn keyword schemeExtFunc u32vector->list
    syn keyword schemeExtFunc u32vector->string
    syn keyword schemeExtFunc u32vector->vector
    syn keyword schemeExtFunc u32vector-add
    syn keyword schemeExtFunc u32vector-add!
    syn keyword schemeExtFunc u32vector-and
    syn keyword schemeExtFunc u32vector-and!
    syn keyword schemeExtFunc u32vector-clamp
    syn keyword schemeExtFunc u32vector-clamp!
    syn keyword schemeExtFunc u32vector-copy
    syn keyword schemeExtFunc u32vector-copy!
    syn keyword schemeExtFunc u32vector-dot
    syn keyword schemeExtFunc u32vector-fill!
    syn keyword schemeExtFunc u32vector-ior
    syn keyword schemeExtFunc u32vector-ior!
    syn keyword schemeExtFunc u32vector-length
    syn keyword schemeExtFunc u32vector-mul
    syn keyword schemeExtFunc u32vector-mul!
    syn keyword schemeExtFunc u32vector-range-check
    syn keyword schemeExtFunc u32vector-ref
    syn keyword schemeExtFunc u32vector-set!
    syn keyword schemeExtFunc u32vector-sub
    syn keyword schemeExtFunc u32vector-sub!
    syn keyword schemeExtFunc u32vector-swap-bytes
    syn keyword schemeExtFunc u32vector-swap-bytes!
    syn keyword schemeExtFunc u32vector-xor
    syn keyword schemeExtFunc u32vector-xor!
    syn keyword schemeExtFunc u32vector?
    syn keyword schemeExtFunc u64vector
    syn keyword schemeExtFunc u64vector->list
    syn keyword schemeExtFunc u64vector->vector
    syn keyword schemeExtFunc u64vector-add
    syn keyword schemeExtFunc u64vector-add!
    syn keyword schemeExtFunc u64vector-and
    syn keyword schemeExtFunc u64vector-and!
    syn keyword schemeExtFunc u64vector-clamp
    syn keyword schemeExtFunc u64vector-clamp!
    syn keyword schemeExtFunc u64vector-copy
    syn keyword schemeExtFunc u64vector-copy!
    syn keyword schemeExtFunc u64vector-dot
    syn keyword schemeExtFunc u64vector-fill!
    syn keyword schemeExtFunc u64vector-ior
    syn keyword schemeExtFunc u64vector-ior!
    syn keyword schemeExtFunc u64vector-length
    syn keyword schemeExtFunc u64vector-mul
    syn keyword schemeExtFunc u64vector-mul!
    syn keyword schemeExtFunc u64vector-range-check
    syn keyword schemeExtFunc u64vector-ref
    syn keyword schemeExtFunc u64vector-set!
    syn keyword schemeExtFunc u64vector-sub
    syn keyword schemeExtFunc u64vector-sub!
    syn keyword schemeExtFunc u64vector-swap-bytes
    syn keyword schemeExtFunc u64vector-swap-bytes!
    syn keyword schemeExtFunc u64vector-xor
    syn keyword schemeExtFunc u64vector-xor!
    syn keyword schemeExtFunc u64vector?
    syn keyword schemeExtFunc u8vector
    syn keyword schemeExtFunc u8vector->list
    syn keyword schemeExtFunc u8vector->string
    syn keyword schemeExtFunc u8vector->vector
    syn keyword schemeExtFunc u8vector-add
    syn keyword schemeExtFunc u8vector-add!
    syn keyword schemeExtFunc u8vector-and
    syn keyword schemeExtFunc u8vector-and!
    syn keyword schemeExtFunc u8vector-clamp
    syn keyword schemeExtFunc u8vector-clamp!
    syn keyword schemeExtFunc u8vector-copy
    syn keyword schemeExtFunc u8vector-copy!
    syn keyword schemeExtFunc u8vector-dot
    syn keyword schemeExtFunc u8vector-fill!
    syn keyword schemeExtFunc u8vector-ior
    syn keyword schemeExtFunc u8vector-ior!
    syn keyword schemeExtFunc u8vector-length
    syn keyword schemeExtFunc u8vector-mul
    syn keyword schemeExtFunc u8vector-mul!
    syn keyword schemeExtFunc u8vector-range-check
    syn keyword schemeExtFunc u8vector-ref
    syn keyword schemeExtFunc u8vector-set!
    syn keyword schemeExtFunc u8vector-sub
    syn keyword schemeExtFunc u8vector-sub!
    syn keyword schemeExtFunc u8vector-xor
    syn keyword schemeExtFunc u8vector-xor!
    syn keyword schemeExtFunc u8vector?
    syn keyword schemeExtFunc ucs->char
    syn keyword schemeExtFunc ucs-range->char-set
    syn keyword schemeExtFunc ucs-range->char-set!
    syn keyword schemeExtFunc ucscode->char
    syn keyword schemeExtFunc uncaught-exception-reason
    syn keyword schemeExtFunc uncaught-exception?
    syn keyword schemeExtFunc undefined
    syn keyword schemeExtFunc undefined?
    syn keyword schemeExtFunc unfold
    syn keyword schemeExtFunc unfold-right
    syn keyword schemeExtFunc unpack
    syn keyword schemeExtFunc unpack-skip
    syn keyword schemeExtFunc unwrap-syntax
    syn keyword schemeExtFunc unzip1
    syn keyword schemeExtFunc unzip2
    syn keyword schemeExtFunc unzip3
    syn keyword schemeExtFunc unzip4
    syn keyword schemeExtFunc unzip5
    syn keyword schemeExtFunc upper
    syn keyword schemeExtFunc uri-compose
    syn keyword schemeExtFunc uri-decode
    syn keyword schemeExtFunc uri-decode-string
    syn keyword schemeExtFunc uri-decompose-authority
    syn keyword schemeExtFunc uri-decompose-hierarchical
    syn keyword schemeExtFunc uri-encode
    syn keyword schemeExtFunc uri-encode-string
    syn keyword schemeExtFunc uri-parse
    syn keyword schemeExtFunc uri-scheme&specific
    syn keyword schemeExtFunc uvector-alias
    syn keyword schemeExtFunc uvector-immutable?
    syn keyword schemeExtFunc uvector-length
    syn keyword schemeExtFunc uvector-size
    syn keyword schemeExtFunc uvector-swap-bytes
    syn keyword schemeExtFunc uvector-swap-bytes!
    syn keyword schemeExtFunc vector->f16vector
    syn keyword schemeExtFunc vector->f32vector
    syn keyword schemeExtFunc vector->f64vector
    syn keyword schemeExtFunc vector->posix-tm
    syn keyword schemeExtFunc vector->s16vector
    syn keyword schemeExtFunc vector->s32vector
    syn keyword schemeExtFunc vector->s64vector
    syn keyword schemeExtFunc vector->s8vector
    syn keyword schemeExtFunc vector->u16vector
    syn keyword schemeExtFunc vector->u32vector
    syn keyword schemeExtFunc vector->u64vector
    syn keyword schemeExtFunc vector->u8vector
    syn keyword schemeExtFunc vector-any
    syn keyword schemeExtFunc vector-append
    syn keyword schemeExtFunc vector-binary-search
    syn keyword schemeExtFunc vector-concatenate
    syn keyword schemeExtFunc vector-copy
    syn keyword schemeExtFunc vector-copy!
    syn keyword schemeExtFunc vector-count
    syn keyword schemeExtFunc vector-empty?
    syn keyword schemeExtFunc vector-every
    syn keyword schemeExtFunc vector-fold
    syn keyword schemeExtFunc vector-fold-right
    syn keyword schemeExtFunc vector-for-each
    syn keyword schemeExtFunc vector-index
    syn keyword schemeExtFunc vector-index-right
    syn keyword schemeExtFunc vector-map
    syn keyword schemeExtFunc vector-map!
    syn keyword schemeExtFunc vector-reverse!
    syn keyword schemeExtFunc vector-reverse-copy
    syn keyword schemeExtFunc vector-reverse-copy!
    syn keyword schemeExtFunc vector-skip
    syn keyword schemeExtFunc vector-skip-right
    syn keyword schemeExtFunc vector-swap!
    syn keyword schemeExtFunc vector-unfold
    syn keyword schemeExtFunc vector-unfold-right
    syn keyword schemeExtFunc vector=
    syn keyword schemeExtFunc version
    syn keyword schemeExtFunc version-compare
    syn keyword schemeExtFunc version<=?
    syn keyword schemeExtFunc version<?
    syn keyword schemeExtFunc version=?
    syn keyword schemeExtFunc version>=?
    syn keyword schemeExtFunc version>?
    syn keyword schemeExtFunc vm-build-insn
    syn keyword schemeExtFunc vm-dump
    syn keyword schemeExtFunc vm-find-insn-info
    syn keyword schemeExtFunc vm-get-stack-trace
    syn keyword schemeExtFunc vm-get-stack-trace-lite
    syn keyword schemeExtFunc vm-set-default-exception-handler
    syn keyword schemeExtFunc wait-all
    syn keyword schemeExtFunc warn
    syn keyword schemeExtFunc weak-vector-length
    syn keyword schemeExtFunc weak-vector-ref
    syn keyword schemeExtFunc weak-vector-set!
    syn keyword schemeExtFunc with-error-handler
    syn keyword schemeExtFunc with-error-to-port
    syn keyword schemeExtFunc with-exception-handler
    syn keyword schemeExtFunc with-input-conversion
    syn keyword schemeExtFunc with-input-from-port
    syn keyword schemeExtFunc with-input-from-process
    syn keyword schemeExtFunc with-input-from-string
    syn keyword schemeExtFunc with-locking-mutex
    syn keyword schemeExtFunc with-output-conversion
    syn keyword schemeExtFunc with-output-to-port
    syn keyword schemeExtFunc with-output-to-process
    syn keyword schemeExtFunc with-output-to-string
    syn keyword schemeExtFunc with-port-locking
    syn keyword schemeExtFunc with-ports
    syn keyword schemeExtFunc with-string-io
    syn keyword schemeExtFunc without-echoing
    syn keyword schemeExtFunc wrap-with-input-conversion
    syn keyword schemeExtFunc wrap-with-output-conversion
    syn keyword schemeExtFunc write*
    syn keyword schemeExtFunc write-ber-integer
    syn keyword schemeExtFunc write-binary-double
    syn keyword schemeExtFunc write-binary-float
    syn keyword schemeExtFunc write-binary-long
    syn keyword schemeExtFunc write-binary-short
    syn keyword schemeExtFunc write-binary-sint
    syn keyword schemeExtFunc write-binary-sint16
    syn keyword schemeExtFunc write-binary-sint32
    syn keyword schemeExtFunc write-binary-sint64
    syn keyword schemeExtFunc write-binary-sint8
    syn keyword schemeExtFunc write-binary-uint
    syn keyword schemeExtFunc write-binary-uint16
    syn keyword schemeExtFunc write-binary-uint32
    syn keyword schemeExtFunc write-binary-uint64
    syn keyword schemeExtFunc write-binary-uint8
    syn keyword schemeExtFunc write-binary-ulong
    syn keyword schemeExtFunc write-binary-ushort
    syn keyword schemeExtFunc write-block
    syn keyword schemeExtFunc write-byte
    syn keyword schemeExtFunc write-f16
    syn keyword schemeExtFunc write-f32
    syn keyword schemeExtFunc write-f64
    syn keyword schemeExtFunc write-limited
    syn keyword schemeExtFunc write-s16
    syn keyword schemeExtFunc write-s32
    syn keyword schemeExtFunc write-s64
    syn keyword schemeExtFunc write-s8
    syn keyword schemeExtFunc write-sint
    syn keyword schemeExtFunc write-stream
    syn keyword schemeExtFunc write-to-string
    syn keyword schemeExtFunc write-u16
    syn keyword schemeExtFunc write-u32
    syn keyword schemeExtFunc write-u64
    syn keyword schemeExtFunc write-u8
    syn keyword schemeExtFunc write-uint
    syn keyword schemeExtFunc write-with-shared-structure
    syn keyword schemeExtFunc write/ss
    syn keyword schemeExtFunc xcons
    syn keyword schemeExtFunc xml-token-head
    syn keyword schemeExtFunc xml-token-kind
    syn keyword schemeExtFunc xml-token?
    syn keyword schemeExtFunc xsubstring
    syn keyword schemeExtFunc zip
    syn keyword schemeExtFunc zlib-version
    syn keyword schemeExtFunc zstream-adler32
    syn keyword schemeExtFunc zstream-data-type
    syn keyword schemeExtFunc zstream-dictionary-adler32
    syn keyword schemeExtFunc zstream-params-set!
    syn keyword schemeExtFunc zstream-total-in
    syn keyword schemeExtFunc zstream-total-out
    syn keyword schemeExtFunc ~


    " method
    syn keyword schemeExtFunc add-hook!
    syn keyword schemeExtFunc add-method!
    syn keyword schemeExtFunc allocate-instance
    syn keyword schemeExtFunc apply-generic
    syn keyword schemeExtFunc apply-method
    syn keyword schemeExtFunc apply-methods
    syn keyword schemeExtFunc array-add-elements!
    syn keyword schemeExtFunc array-div-elements!
    syn keyword schemeExtFunc array-map
    syn keyword schemeExtFunc array-map!
    syn keyword schemeExtFunc array-mul-elements!
    syn keyword schemeExtFunc array-ref
    syn keyword schemeExtFunc array-retabulate!
    syn keyword schemeExtFunc array-set!
    syn keyword schemeExtFunc array-sub-elements!
    syn keyword schemeExtFunc call-with-builder
    syn keyword schemeExtFunc call-with-iterator
    syn keyword schemeExtFunc cgen-c-name
    syn keyword schemeExtFunc cgen-cexpr
    syn keyword schemeExtFunc cgen-emit
    syn keyword schemeExtFunc cgen-emit-body
    syn keyword schemeExtFunc cgen-emit-c
    syn keyword schemeExtFunc cgen-emit-decl
    syn keyword schemeExtFunc cgen-emit-h
    syn keyword schemeExtFunc cgen-emit-init
    syn keyword schemeExtFunc cgen-emit-static-data
    syn keyword schemeExtFunc cgen-emit-xtrn
    syn keyword schemeExtFunc cgen-literal-static?
    syn keyword schemeExtFunc cgen-make-literal
    syn keyword schemeExtFunc cgen-unit-c-file
    syn keyword schemeExtFunc cgen-unit-h-file
    syn keyword schemeExtFunc cgen-unit-init-name
    syn keyword schemeExtFunc cgen-unit-toplevel-nodes
    syn keyword schemeExtFunc change-class
    syn keyword schemeExtFunc class-redefinition
    syn keyword schemeExtFunc coerce-to
    syn keyword schemeExtFunc compute-applicable-methods
    syn keyword schemeExtFunc compute-cpl
    syn keyword schemeExtFunc compute-get-n-set
    syn keyword schemeExtFunc compute-slot-accessor
    syn keyword schemeExtFunc compute-slots
    syn keyword schemeExtFunc copy-queue
    syn keyword schemeExtFunc d
    syn keyword schemeExtFunc date-day
    syn keyword schemeExtFunc date-hour
    syn keyword schemeExtFunc date-minute
    syn keyword schemeExtFunc date-month
    syn keyword schemeExtFunc date-nanosecond
    syn keyword schemeExtFunc date-second
    syn keyword schemeExtFunc date-year
    syn keyword schemeExtFunc date-zone-offset
    syn keyword schemeExtFunc dbi-close
    syn keyword schemeExtFunc dbi-do
    syn keyword schemeExtFunc dbi-escape-sql
    syn keyword schemeExtFunc dbi-execute
    syn keyword schemeExtFunc dbi-execute-query
    syn keyword schemeExtFunc dbi-execute-using-connection
    syn keyword schemeExtFunc dbi-get-value
    syn keyword schemeExtFunc dbi-make-connection
    syn keyword schemeExtFunc dbi-make-query
    syn keyword schemeExtFunc dbi-open?
    syn keyword schemeExtFunc dbi-prepare
    syn keyword schemeExtFunc dbm-close
    syn keyword schemeExtFunc dbm-closed?
    syn keyword schemeExtFunc dbm-db-copy
    syn keyword schemeExtFunc dbm-db-exists?
    syn keyword schemeExtFunc dbm-db-move
    syn keyword schemeExtFunc dbm-db-remove
    syn keyword schemeExtFunc dbm-db-rename
    syn keyword schemeExtFunc dbm-delete!
    syn keyword schemeExtFunc dbm-exists?
    syn keyword schemeExtFunc dbm-fold
    syn keyword schemeExtFunc dbm-for-each
    syn keyword schemeExtFunc dbm-get
    syn keyword schemeExtFunc dbm-map
    syn keyword schemeExtFunc dbm-open
    syn keyword schemeExtFunc dbm-put!
    syn keyword schemeExtFunc delete-hook!
    syn keyword schemeExtFunc delete-method!
    syn keyword schemeExtFunc describe
    syn keyword schemeExtFunc dict-delete!
    syn keyword schemeExtFunc dict-exists?
    syn keyword schemeExtFunc dict-fold
    syn keyword schemeExtFunc dict-fold-right
    syn keyword schemeExtFunc dict-for-each
    syn keyword schemeExtFunc dict-get
    syn keyword schemeExtFunc dict-keys
    syn keyword schemeExtFunc dict-map
    syn keyword schemeExtFunc dict-put!
    syn keyword schemeExtFunc dict-values
    syn keyword schemeExtFunc digest
    syn keyword schemeExtFunc digest-final!
    syn keyword schemeExtFunc digest-string
    syn keyword schemeExtFunc digest-update!
    syn keyword schemeExtFunc direction-of
    syn keyword schemeExtFunc file-atime<=?
    syn keyword schemeExtFunc file-atime<?
    syn keyword schemeExtFunc file-atime=?
    syn keyword schemeExtFunc file-atime>=?
    syn keyword schemeExtFunc file-atime>?
    syn keyword schemeExtFunc file-ctime<=?
    syn keyword schemeExtFunc file-ctime<?
    syn keyword schemeExtFunc file-ctime=?
    syn keyword schemeExtFunc file-ctime>=?
    syn keyword schemeExtFunc file-ctime>?
    syn keyword schemeExtFunc file-mtime<=?
    syn keyword schemeExtFunc file-mtime<?
    syn keyword schemeExtFunc file-mtime=?
    syn keyword schemeExtFunc file-mtime>=?
    syn keyword schemeExtFunc file-mtime>?
    syn keyword schemeExtFunc filter-to
    syn keyword schemeExtFunc find
    syn keyword schemeExtFunc find-index
    syn keyword schemeExtFunc find-max
    syn keyword schemeExtFunc find-min
    syn keyword schemeExtFunc find-min&max
    syn keyword schemeExtFunc find-with-index
    syn keyword schemeExtFunc fold
    syn keyword schemeExtFunc fold$
    syn keyword schemeExtFunc fold-right
    syn keyword schemeExtFunc fold-with-index
    syn keyword schemeExtFunc fold2
    syn keyword schemeExtFunc fold2$
    syn keyword schemeExtFunc fold3
    syn keyword schemeExtFunc fold3$
    syn keyword schemeExtFunc for-each-with-index
    syn keyword schemeExtFunc ftp-passive?
    syn keyword schemeExtFunc ftp-transfer-type
    syn keyword schemeExtFunc gdbm-file-of
    syn keyword schemeExtFunc get-serializable-slots
    syn keyword schemeExtFunc group-collection
    syn keyword schemeExtFunc group-sequence
    syn keyword schemeExtFunc hmac-final!
    syn keyword schemeExtFunc hmac-update!
    syn keyword schemeExtFunc hook->list
    syn keyword schemeExtFunc hook-empty?
    syn keyword schemeExtFunc info-get-node
    syn keyword schemeExtFunc info-parse-menu
    syn keyword schemeExtFunc initialize
    syn keyword schemeExtFunc instance-of
    syn keyword schemeExtFunc instance-pool->list
    syn keyword schemeExtFunc instance-pool-find
    syn keyword schemeExtFunc instance-pool-fold
    syn keyword schemeExtFunc instance-pool-for-each
    syn keyword schemeExtFunc instance-pool-map
    syn keyword schemeExtFunc instance-pool-of
    syn keyword schemeExtFunc instance-pool-remove!
    syn keyword schemeExtFunc instance-pool:->list
    syn keyword schemeExtFunc instance-pool:add
    syn keyword schemeExtFunc instance-pool:compute-pools
    syn keyword schemeExtFunc instance-pool:create-pool
    syn keyword schemeExtFunc instance-pool:find
    syn keyword schemeExtFunc instance-pool:fold
    syn keyword schemeExtFunc instance-pool:for-each
    syn keyword schemeExtFunc instance-pool:map
    syn keyword schemeExtFunc instance-pool:remove!
    syn keyword schemeExtFunc instance-pools-of
    syn keyword schemeExtFunc lazy-size-of
    syn keyword schemeExtFunc listener-read-handler
    syn keyword schemeExtFunc listener-show-prompt
    syn keyword schemeExtFunc log-format
    syn keyword schemeExtFunc make
    syn keyword schemeExtFunc map-accum
    syn keyword schemeExtFunc map-to
    syn keyword schemeExtFunc map-to-with-index
    syn keyword schemeExtFunc map-with-index
    syn keyword schemeExtFunc method-more-specific?
    syn keyword schemeExtFunc modifier
    syn keyword schemeExtFunc object-*
    syn keyword schemeExtFunc object-+
    syn keyword schemeExtFunc object--
    syn keyword schemeExtFunc object-/
    syn keyword schemeExtFunc object-apply
    syn keyword schemeExtFunc object-compare
    syn keyword schemeExtFunc object-equal?
    syn keyword schemeExtFunc object-hash
    syn keyword schemeExtFunc object-isomorphic?
    syn keyword schemeExtFunc option-names
    syn keyword schemeExtFunc option-optional-arg?
    syn keyword schemeExtFunc option-processor
    syn keyword schemeExtFunc option-required-arg?
    syn keyword schemeExtFunc parameter-observer-add!
    syn keyword schemeExtFunc parameter-observer-delete!
    syn keyword schemeExtFunc parameter-post-observers
    syn keyword schemeExtFunc parameter-pre-observers
    syn keyword schemeExtFunc partition-to
    syn keyword schemeExtFunc permute
    syn keyword schemeExtFunc permute!
    syn keyword schemeExtFunc permute-to
    syn keyword schemeExtFunc port-of
    syn keyword schemeExtFunc process-command
    syn keyword schemeExtFunc process-exit-status
    syn keyword schemeExtFunc process-pid
    syn keyword schemeExtFunc pseudo-rtd
    syn keyword schemeExtFunc read-from-file-with-serializer
    syn keyword schemeExtFunc read-from-serializer
    syn keyword schemeExtFunc read-from-string-with-serializer
    syn keyword schemeExtFunc ref
    syn keyword schemeExtFunc referencer
    syn keyword schemeExtFunc relation-accessor
    syn keyword schemeExtFunc relation-coercer
    syn keyword schemeExtFunc relation-column-getter
    syn keyword schemeExtFunc relation-column-getters
    syn keyword schemeExtFunc relation-column-name?
    syn keyword schemeExtFunc relation-column-names
    syn keyword schemeExtFunc relation-column-setter
    syn keyword schemeExtFunc relation-column-setters
    syn keyword schemeExtFunc relation-deletable?
    syn keyword schemeExtFunc relation-delete!
    syn keyword schemeExtFunc relation-fold
    syn keyword schemeExtFunc relation-insert!
    syn keyword schemeExtFunc relation-insertable?
    syn keyword schemeExtFunc relation-modifier
    syn keyword schemeExtFunc relation-ref
    syn keyword schemeExtFunc relation-rows
    syn keyword schemeExtFunc relation-set!
    syn keyword schemeExtFunc remove-hook!
    syn keyword schemeExtFunc remove-to
    syn keyword schemeExtFunc reset-hook!
    syn keyword schemeExtFunc rtd-accessor
    syn keyword schemeExtFunc rtd-constructor
    syn keyword schemeExtFunc rtd-mutator
    syn keyword schemeExtFunc rtd-predicate
    syn keyword schemeExtFunc run-hook
    syn keyword schemeExtFunc selector-add!
    syn keyword schemeExtFunc selector-delete!
    syn keyword schemeExtFunc selector-select
    syn keyword schemeExtFunc set-time-nanosecond!
    syn keyword schemeExtFunc set-time-second!
    syn keyword schemeExtFunc set-time-type!
    syn keyword schemeExtFunc shape-valid-index?
    syn keyword schemeExtFunc shuffle
    syn keyword schemeExtFunc shuffle!
    syn keyword schemeExtFunc shuffle-to
    syn keyword schemeExtFunc size-of
    syn keyword schemeExtFunc slot-bound-using-class?
    syn keyword schemeExtFunc slot-exists-using-class?
    syn keyword schemeExtFunc slot-missing
    syn keyword schemeExtFunc slot-ref-using-class
    syn keyword schemeExtFunc slot-set-using-class!
    syn keyword schemeExtFunc slot-unbound
    syn keyword schemeExtFunc sockaddr-addr
    syn keyword schemeExtFunc sockaddr-family
    syn keyword schemeExtFunc sockaddr-name
    syn keyword schemeExtFunc sockaddr-port
    syn keyword schemeExtFunc sort-applicable-methods
    syn keyword schemeExtFunc subseq
    syn keyword schemeExtFunc time-counter-get-current-time
    syn keyword schemeExtFunc time-counter-get-delta
    syn keyword schemeExtFunc time-counter-reset!
    syn keyword schemeExtFunc time-counter-start!
    syn keyword schemeExtFunc time-counter-stop!
    syn keyword schemeExtFunc time-counter-value
    syn keyword schemeExtFunc time-nanosecond
    syn keyword schemeExtFunc time-second
    syn keyword schemeExtFunc time-type
    syn keyword schemeExtFunc update-direct-method!
    syn keyword schemeExtFunc update-direct-subclass!
    syn keyword schemeExtFunc write-gauche-package-description
    syn keyword schemeExtFunc write-object
    syn keyword schemeExtFunc write-to-file-with-serializer
    syn keyword schemeExtFunc write-to-serializer
    syn keyword schemeExtFunc write-to-string-with-serializer
    syn keyword schemeExtFunc write-tree
    syn keyword schemeExtFunc x->integer
    syn keyword schemeExtFunc x->number
    syn keyword schemeExtFunc x->string


    " class
    syn keyword schemeExtFunc &condition
    syn keyword schemeExtFunc &error
    syn keyword schemeExtFunc &i/o-closed-error
    syn keyword schemeExtFunc &i/o-error
    syn keyword schemeExtFunc &i/o-port-error
    syn keyword schemeExtFunc &i/o-read-error
    syn keyword schemeExtFunc &i/o-write-error
    syn keyword schemeExtFunc &message
    syn keyword schemeExtFunc &read-error
    syn keyword schemeExtFunc &serious
    syn keyword schemeExtFunc <abandoned-mutex-exception-meta>
    syn keyword schemeExtFunc <abandoned-mutex-exception>
    syn keyword schemeExtFunc <accessor-method>
    syn keyword schemeExtFunc <arity-at-least>
    syn keyword schemeExtFunc <array-meta>
    syn keyword schemeExtFunc <array>
    syn keyword schemeExtFunc <autoload-meta>
    syn keyword schemeExtFunc <autoload>
    syn keyword schemeExtFunc <bimap>
    syn keyword schemeExtFunc <boolean-meta>
    syn keyword schemeExtFunc <boolean>
    syn keyword schemeExtFunc <buffered-input-port>
    syn keyword schemeExtFunc <buffered-output-port>
    syn keyword schemeExtFunc <cgen-literal>
    syn keyword schemeExtFunc <cgen-node>
    syn keyword schemeExtFunc <cgen-stub-error>
    syn keyword schemeExtFunc <cgen-stub-unit>
    syn keyword schemeExtFunc <cgen-type>
    syn keyword schemeExtFunc <cgen-unit>
    syn keyword schemeExtFunc <cgi-content-type-error>
    syn keyword schemeExtFunc <cgi-error>
    syn keyword schemeExtFunc <cgi-request-method-error>
    syn keyword schemeExtFunc <cgi-request-size-error>
    syn keyword schemeExtFunc <char-meta>
    syn keyword schemeExtFunc <char-set-meta>
    syn keyword schemeExtFunc <char-set>
    syn keyword schemeExtFunc <char>
    syn keyword schemeExtFunc <class>
    syn keyword schemeExtFunc <coding-aware-port>
    syn keyword schemeExtFunc <collection>
    syn keyword schemeExtFunc <compiled-code>
    syn keyword schemeExtFunc <complex-meta>
    syn keyword schemeExtFunc <complex>
    syn keyword schemeExtFunc <compound-condition>
    syn keyword schemeExtFunc <condition-meta>
    syn keyword schemeExtFunc <condition>
    syn keyword schemeExtFunc <csv>
    syn keyword schemeExtFunc <date>
    syn keyword schemeExtFunc <dbi-connection>
    syn keyword schemeExtFunc <dbi-driver>
    syn keyword schemeExtFunc <dbi-error>
    syn keyword schemeExtFunc <dbi-exception>
    syn keyword schemeExtFunc <dbi-nonexistent-driver-error>
    syn keyword schemeExtFunc <dbi-parameter-error>
    syn keyword schemeExtFunc <dbi-query>
    syn keyword schemeExtFunc <dbi-result-set>
    syn keyword schemeExtFunc <dbi-unsupported-error>
    syn keyword schemeExtFunc <dbm-meta>
    syn keyword schemeExtFunc <dbm>
    syn keyword schemeExtFunc <deflating-port>
    syn keyword schemeExtFunc <dictionary>
    syn keyword schemeExtFunc <eof-object>
    syn keyword schemeExtFunc <error>
    syn keyword schemeExtFunc <exception>
    syn keyword schemeExtFunc <f16array>
    syn keyword schemeExtFunc <f16vector-meta>
    syn keyword schemeExtFunc <f16vector>
    syn keyword schemeExtFunc <f32array>
    syn keyword schemeExtFunc <f32vector-meta>
    syn keyword schemeExtFunc <f32vector>
    syn keyword schemeExtFunc <f64array>
    syn keyword schemeExtFunc <f64vector-meta>
    syn keyword schemeExtFunc <f64vector>
    syn keyword schemeExtFunc <foreign-pointer>
    syn keyword schemeExtFunc <fsdbm>
    syn keyword schemeExtFunc <ftp-connection>
    syn keyword schemeExtFunc <ftp-error>
    syn keyword schemeExtFunc <gauche-package-description>
    syn keyword schemeExtFunc <gdbm>
    syn keyword schemeExtFunc <generic>
    syn keyword schemeExtFunc <gloc-meta>
    syn keyword schemeExtFunc <gloc>
    syn keyword schemeExtFunc <hash-table-meta>
    syn keyword schemeExtFunc <hash-table>
    syn keyword schemeExtFunc <hmac>
    syn keyword schemeExtFunc <hook>
    syn keyword schemeExtFunc <http-error>
    syn keyword schemeExtFunc <identifier>
    syn keyword schemeExtFunc <inflating-port>
    syn keyword schemeExtFunc <info-file>
    syn keyword schemeExtFunc <info-node>
    syn keyword schemeExtFunc <instance-pool-meta>
    syn keyword schemeExtFunc <instance-pool-mixin>
    syn keyword schemeExtFunc <integer-meta>
    syn keyword schemeExtFunc <integer>
    syn keyword schemeExtFunc <io-closed-error>
    syn keyword schemeExtFunc <io-error>
    syn keyword schemeExtFunc <io-read-error>
    syn keyword schemeExtFunc <io-unit-error>
    syn keyword schemeExtFunc <io-write-error>
    syn keyword schemeExtFunc <join-timeout-exception-meta>
    syn keyword schemeExtFunc <join-timeout-exception>
    syn keyword schemeExtFunc <json-construct-error>
    syn keyword schemeExtFunc <json-parse-error>
    syn keyword schemeExtFunc <keyword-meta>
    syn keyword schemeExtFunc <keyword>
    syn keyword schemeExtFunc <list-meta>
    syn keyword schemeExtFunc <list>
    syn keyword schemeExtFunc <listener>
    syn keyword schemeExtFunc <log-drain>
    syn keyword schemeExtFunc <macro-meta>
    syn keyword schemeExtFunc <macro>
    syn keyword schemeExtFunc <md5>
    syn keyword schemeExtFunc <mersenne-twister>
    syn keyword schemeExtFunc <message-condition>
    syn keyword schemeExtFunc <message-digest-algorithm-meta>
    syn keyword schemeExtFunc <message-digest-algorithm>
    syn keyword schemeExtFunc <method>
    syn keyword schemeExtFunc <mime-part>
    syn keyword schemeExtFunc <module-meta>
    syn keyword schemeExtFunc <module>
    syn keyword schemeExtFunc <mtqueue>
    syn keyword schemeExtFunc <next-method>
    syn keyword schemeExtFunc <null-meta>
    syn keyword schemeExtFunc <null>
    syn keyword schemeExtFunc <number-meta>
    syn keyword schemeExtFunc <number>
    syn keyword schemeExtFunc <object-set-relation>
    syn keyword schemeExtFunc <object>
    syn keyword schemeExtFunc <ordered-dictionary>
    syn keyword schemeExtFunc <pair-meta>
    syn keyword schemeExtFunc <pair>
    syn keyword schemeExtFunc <parameter>
    syn keyword schemeExtFunc <parse-error>
    syn keyword schemeExtFunc <parseopt-error>
    syn keyword schemeExtFunc <port-error>
    syn keyword schemeExtFunc <port>
    syn keyword schemeExtFunc <procedure>
    syn keyword schemeExtFunc <process-abnormal-exit>
    syn keyword schemeExtFunc <process-time-counter>
    syn keyword schemeExtFunc <process>
    syn keyword schemeExtFunc <promise-meta>
    syn keyword schemeExtFunc <promise>
    syn keyword schemeExtFunc <propagate-meta>
    syn keyword schemeExtFunc <propagate-mixin>
    syn keyword schemeExtFunc <pseudo-record-meta>
    syn keyword schemeExtFunc <queue>
    syn keyword schemeExtFunc <rational-meta>
    syn keyword schemeExtFunc <rational>
    syn keyword schemeExtFunc <rbtree>
    syn keyword schemeExtFunc <read-context>
    syn keyword schemeExtFunc <read-error>
    syn keyword schemeExtFunc <read-reference>
    syn keyword schemeExtFunc <real-meta>
    syn keyword schemeExtFunc <real-time-counter>
    syn keyword schemeExtFunc <real>
    syn keyword schemeExtFunc <record-meta>
    syn keyword schemeExtFunc <record>
    syn keyword schemeExtFunc <regexp-invalid-ast>
    syn keyword schemeExtFunc <regexp-meta>
    syn keyword schemeExtFunc <regexp>
    syn keyword schemeExtFunc <regmatch-meta>
    syn keyword schemeExtFunc <regmatch>
    syn keyword schemeExtFunc <relation>
    syn keyword schemeExtFunc <rfc822-parse-error>
    syn keyword schemeExtFunc <s16array>
    syn keyword schemeExtFunc <s16vector-meta>
    syn keyword schemeExtFunc <s16vector>
    syn keyword schemeExtFunc <s32array>
    syn keyword schemeExtFunc <s32vector-meta>
    syn keyword schemeExtFunc <s32vector>
    syn keyword schemeExtFunc <s64array>
    syn keyword schemeExtFunc <s64vector-meta>
    syn keyword schemeExtFunc <s64vector>
    syn keyword schemeExtFunc <s8array>
    syn keyword schemeExtFunc <s8vector-meta>
    syn keyword schemeExtFunc <s8vector>
    syn keyword schemeExtFunc <selector>
    syn keyword schemeExtFunc <sequence>
    syn keyword schemeExtFunc <serializer>
    syn keyword schemeExtFunc <serious-compound-condition>
    syn keyword schemeExtFunc <serious-condition>
    syn keyword schemeExtFunc <sha1>
    syn keyword schemeExtFunc <sha224>
    syn keyword schemeExtFunc <sha256>
    syn keyword schemeExtFunc <sha384>
    syn keyword schemeExtFunc <sha512>
    syn keyword schemeExtFunc <simple-relation>
    syn keyword schemeExtFunc <singleton-meta>
    syn keyword schemeExtFunc <singleton-mixin>
    syn keyword schemeExtFunc <slot-accessor>
    syn keyword schemeExtFunc <sockaddr-in>
    syn keyword schemeExtFunc <sockaddr-un>
    syn keyword schemeExtFunc <sockaddr>
    syn keyword schemeExtFunc <socket>
    syn keyword schemeExtFunc <sparse-f16vector>
    syn keyword schemeExtFunc <sparse-f32vector>
    syn keyword schemeExtFunc <sparse-f64vector>
    syn keyword schemeExtFunc <sparse-s16vector>
    syn keyword schemeExtFunc <sparse-s32vector>
    syn keyword schemeExtFunc <sparse-s64vector>
    syn keyword schemeExtFunc <sparse-s8vector>
    syn keyword schemeExtFunc <sparse-table>
    syn keyword schemeExtFunc <sparse-u16vector>
    syn keyword schemeExtFunc <sparse-u32vector>
    syn keyword schemeExtFunc <sparse-u64vector>
    syn keyword schemeExtFunc <sparse-u8vector>
    syn keyword schemeExtFunc <sparse-vector-base>
    syn keyword schemeExtFunc <sparse-vector>
    syn keyword schemeExtFunc <sql-parse-error>
    syn keyword schemeExtFunc <string-meta>
    syn keyword schemeExtFunc <string-pointer-meta>
    syn keyword schemeExtFunc <string-pointer>
    syn keyword schemeExtFunc <string>
    syn keyword schemeExtFunc <symbol-meta>
    syn keyword schemeExtFunc <symbol>
    syn keyword schemeExtFunc <syntactic-closure>
    syn keyword schemeExtFunc <syntax-meta>
    syn keyword schemeExtFunc <syntax-pattern-meta>
    syn keyword schemeExtFunc <syntax-pattern>
    syn keyword schemeExtFunc <syntax-rules-meta>
    syn keyword schemeExtFunc <syntax-rules>
    syn keyword schemeExtFunc <syntax>
    syn keyword schemeExtFunc <sys-fdset>
    syn keyword schemeExtFunc <sys-flock>
    syn keyword schemeExtFunc <sys-group>
    syn keyword schemeExtFunc <sys-hostent>
    syn keyword schemeExtFunc <sys-passwd>
    syn keyword schemeExtFunc <sys-protoent>
    syn keyword schemeExtFunc <sys-servent>
    syn keyword schemeExtFunc <sys-sigset>
    syn keyword schemeExtFunc <sys-stat>
    syn keyword schemeExtFunc <sys-termios>
    syn keyword schemeExtFunc <sys-tm>
    syn keyword schemeExtFunc <system-error>
    syn keyword schemeExtFunc <system-time-counter>
    syn keyword schemeExtFunc <terminated-thread-exception-meta>
    syn keyword schemeExtFunc <terminated-thread-exception>
    syn keyword schemeExtFunc <thread-exception-meta>
    syn keyword schemeExtFunc <thread-exception>
    syn keyword schemeExtFunc <thread-meta>
    syn keyword schemeExtFunc <thread-pool>
    syn keyword schemeExtFunc <thread>
    syn keyword schemeExtFunc <time-counter>
    syn keyword schemeExtFunc <time>
    syn keyword schemeExtFunc <top>
    syn keyword schemeExtFunc <tree-map-meta>
    syn keyword schemeExtFunc <tree-map>
    syn keyword schemeExtFunc <trie>
    syn keyword schemeExtFunc <u16array>
    syn keyword schemeExtFunc <u16vector-meta>
    syn keyword schemeExtFunc <u16vector>
    syn keyword schemeExtFunc <u32array>
    syn keyword schemeExtFunc <u32vector-meta>
    syn keyword schemeExtFunc <u32vector>
    syn keyword schemeExtFunc <u64array>
    syn keyword schemeExtFunc <u64vector-meta>
    syn keyword schemeExtFunc <u64vector>
    syn keyword schemeExtFunc <u8array>
    syn keyword schemeExtFunc <u8vector-meta>
    syn keyword schemeExtFunc <u8vector>
    syn keyword schemeExtFunc <uncaught-exception-meta>
    syn keyword schemeExtFunc <uncaught-exception>
    syn keyword schemeExtFunc <undefined-object>
    syn keyword schemeExtFunc <unhandled-signal-error>
    syn keyword schemeExtFunc <unknown>
    syn keyword schemeExtFunc <user-time-counter>
    syn keyword schemeExtFunc <uvector-meta>
    syn keyword schemeExtFunc <uvector>
    syn keyword schemeExtFunc <validator-meta>
    syn keyword schemeExtFunc <validator-mixin>
    syn keyword schemeExtFunc <vector-meta>
    syn keyword schemeExtFunc <vector>
    syn keyword schemeExtFunc <virtual-input-port>
    syn keyword schemeExtFunc <virtual-output-port>
    syn keyword schemeExtFunc <vm-insn-info>
    syn keyword schemeExtFunc <weak-hash-table-meta>
    syn keyword schemeExtFunc <weak-hash-table>
    syn keyword schemeExtFunc <weak-vector-meta>
    syn keyword schemeExtFunc <weak-vector>
    syn keyword schemeExtFunc <zlib-data-error>
    syn keyword schemeExtFunc <zlib-error>
    syn keyword schemeExtFunc <zlib-memory-error>
    syn keyword schemeExtFunc <zlib-need-dict-error>
    syn keyword schemeExtFunc <zlib-stream-error>
    syn keyword schemeExtFunc <zlib-version-error>
    syn keyword schemeExtFunc job


    " char-set
    syn keyword schemeExtFunc *rfc2396-unreserved-char-set*
    syn keyword schemeExtFunc *rfc3986-unreserved-char-set*
    syn keyword schemeExtFunc *rfc822-atext-chars*
    syn keyword schemeExtFunc char-set:ascii
    syn keyword schemeExtFunc char-set:blank
    syn keyword schemeExtFunc char-set:digit
    syn keyword schemeExtFunc char-set:empty
    syn keyword schemeExtFunc char-set:full
    syn keyword schemeExtFunc char-set:graphic
    syn keyword schemeExtFunc char-set:hex-digit
    syn keyword schemeExtFunc char-set:iso-control
    syn keyword schemeExtFunc char-set:letter
    syn keyword schemeExtFunc char-set:letter+digit
    syn keyword schemeExtFunc char-set:lower-case
    syn keyword schemeExtFunc char-set:printing
    syn keyword schemeExtFunc char-set:punctuation
    syn keyword schemeExtFunc char-set:symbol
    syn keyword schemeExtFunc char-set:title-case
    syn keyword schemeExtFunc char-set:upper-case
    syn keyword schemeExtFunc char-set:whitespace


    " parameter
    syn keyword schemeExtFunc cgen-cpp-condition
    syn keyword schemeExtFunc cgen-current-unit
    syn keyword schemeExtFunc cgi-metavariables
    syn keyword schemeExtFunc cgi-output-character-encoding
    syn keyword schemeExtFunc cgi-temporary-files
    syn keyword schemeExtFunc cise-context
    syn keyword schemeExtFunc cise-emit-source-line
    syn keyword schemeExtFunc current-country
    syn keyword schemeExtFunc current-language
    syn keyword schemeExtFunc current-locale-details
    syn keyword schemeExtFunc debug-print-width
    syn keyword schemeExtFunc dry-run
    syn keyword schemeExtFunc http-user-agent
    syn keyword schemeExtFunc log-default-drain
    syn keyword schemeExtFunc module-reload-rules
    syn keyword schemeExtFunc reload-verbose
    syn keyword schemeExtFunc ssax:warn-handler
    syn keyword schemeExtFunc temporary-directory
    syn keyword schemeExtFunc verbose-run



    " meddlesome
    set ts=8 sts=2 sw=2 et nocindent lisp
endif


" Synchronization and the wrapping up...

syn sync match matchPlace grouphere NONE "^[^ \t]"
" ... i.e. synchronize on a line that starts at the left margin

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_scheme_syntax_inits")
  if version < 508
    let did_scheme_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink schemeSyntax		Statement
  HiLink schemeFunc		Function

  HiLink schemeString		String
  HiLink schemeChar		Character
  HiLink schemeNumber		Number
  HiLink schemeBoolean		Boolean

  HiLink schemeDelimiter	Delimiter
  HiLink schemeConstant		Constant

  HiLink schemeComment		Comment
  HiLink schemeMultilineComment	Comment
  HiLink schemeError		Error

  HiLink schemeExtSyntax	Type
  HiLink schemeExtFunc		PreProc

  HiLink schemeRegexp		schemeString
  HiLink schemeSrfi62Comment	schemeComment
  HiLink schemeSharpBang	Special
  HiLink schemeInclude		Include
  HiLink schemeInterpolation	Debug

  delcommand HiLink
endif

let b:current_syntax = "scheme"
