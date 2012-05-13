" Vim syntax file
" Language:     Go
" Maintainer:   David Daub <david.daub@googlemail.com>
" Last Change:  2009 Nov 15
" Version:      0.1
"
" Early version. Took some (ok, most) stuff from existing syntax files like
" c.vim or d.vim.
"
"
" Todo:
" - very much

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif


" A bunch of useful Go keywords
syn keyword  goStatement select
syn keyword  goStatement defer
syn keyword  goStatement fallthrough range type
syn keyword  goStatement return

syn keyword     goClause         import package
syn keyword     goConditional    if else switch
syn keyword     goBranch         goto break continue
syn keyword     goLabel          case default
syn keyword     goRepeat         for
syn keyword     goType           struct const interface func
syn keyword     goType           var map
syn keyword     goType           uint8 uint16 uint32 uint64
syn keyword     goType           int8 int16 int32 int64
syn keyword     goType           float32 float64
syn keyword     goType           float32 float64
syn keyword     goType           byte
syn keyword     goType           uint int float uintptr string

syn keyword     goConcurrent     chan go

syn keyword     goValue          nil
syn keyword     goBoolean        true false

syn keyword     goConstant       iota

" Builtin functions
syn keyword     goBif            len make new close closed cap map

" According to the language specification it is not garanteed to stay in the
" language. See http://golang.org/doc/go_spec.html#Bootstrapping
syn keyword     goBif            print println panic panicln

" Commants
syn keyword     goTodo           contained TODO FIXME XXX
syn match       goLineComment    "\/\/.*" contains=@Spell,goTodo
syn match       goCommentSkip    "^[ \t]*\*\($\|[ \t]\+\)"
syn region      goComment        start="/\*"  end="\*/" contains=@Spell,goTodo

" Numerals
syn case ignore
"integer number, or floating point number without a dot and with "f".
syn match       goNumbers        display transparent "\<\d\|\.\d" contains=goNumber,goFloat,goOctError,goOct
syn match       goNumbersCom     display contained transparent "\<\d\|\.\d" contains=goNumber,goFloat,goOct
syn match       goNumber         display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"

" hex number
syn match       goNumber         display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"

" oct number
syn match       goOct            display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=goOctZero
syn match       goOctZero        display contained "\<0"

syn match       goFloat          display contained "\d\+\.\d*\(e[-+]\=\d\+\)\="
syn match       goFloat          display contained "\d\+e[-+]\=\d\=\>"
syn match       goFloat          display "\(\.[0-9_]\+\)\(e[-+]\=[0-9_]\+\)\=[fl]\=i\=\>"

" Literals
syn region      goString         start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell

syn match       goSpecial        display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match       goCharacter      "L\='[^\\]'"
syn match       goCharacter      "L'[^']*'" contains=goSpecial


hi def link goStatement     Statement
hi def link goClause        Preproc
hi def link goConditional   Conditional
hi def link goBranch        Conditional
hi def link goLabel         Label
hi def link goRepeat        Repeat
hi def link goType          Type
hi def link goConcurrent    Statement
hi def link goValue         Constant
hi def link goBoolean       Boolean
hi def link goConstant      Constant
hi def link goBif           Function
hi def link goTodo          Todo
hi def link goLineComment   goComment
hi def link goComment       Comment
hi def link goNumbers       Number
hi def link goNumbersCom    Number
hi def link goNumber        Number
hi def link goFloat         Float
hi def link goOct           Number
hi def link goOctZero       Number
hi def link goString        String
hi def link goSpecial       Special
hi def link goCharacter     Character


let b:current_syntax = "go"
