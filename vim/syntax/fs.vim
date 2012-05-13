" Vim syntax file
" Language:     F#
" Filenames:    *.fs *.fsi *.fsx
" Maintainers:  Choy Rim <choy.rim@gmail.com>
" Last Change:  2008 Feb 09 - Copied from ocaml syntax

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax") && b:current_syntax == "fs"
  finish
endif

" F# is case sensitive.
syn case match

" Scripting directives
syn match    fsScript "^#\<\(quit\|labels\|warnings\|directory\|cd\|load\|use\|install_printer\|remove_printer\|require\|thread\|trace\|untrace\|untrace_all\|print_depth\|print_length\)\>"

" lowercase identifier - the standard way to match
syn match    fsLCIdentifier /\<\(\l\|_\)\(\w\|'\)*\>/

syn match    fsKeyChar    "|"

" Errors
syn match    fsBraceErr   "}"
syn match    fsBrackErr   "\]"
syn match    fsParenErr   ")"
syn match    fsArrErr     "|]"

syn match    fsCommentErr "\*)"

syn match    fsCountErr   "\<downto\>"
syn match    fsCountErr   "\<to\>"

if !exists("fs_revised")
  syn match    fsDoErr      "\<do\>"
endif

syn match    fsDoneErr    "\<done\>"
syn match    fsThenErr    "\<then\>"

" Error-highlighting of "end" without synchronization:
" as keyword or as error (default)
if exists("fs_noend_error")
  syn match    fsKeyword    "\<end\>"
else
  syn match    fsEndErr     "\<end\>"
endif

" Some convenient clusters
syn cluster  fsAllErrs contains=fsBraceErr,fsBrackErr,fsParenErr,fsCommentErr,fsCountErr,fsDoErr,fsDoneErr,fsEndErr,fsThenErr

syn cluster  fsAENoParen contains=fsBraceErr,fsBrackErr,fsCommentErr,fsCountErr,fsDoErr,fsDoneErr,fsEndErr,fsThenErr

syn cluster  fsContained contains=fsTodo,fsPreDef,fsModParam,fsModParam1,fsPreMPRestr,fsMPRestr,fsMPRestr1,fsMPRestr2,fsMPRestr3,fsModRHS,fsFuncWith,fsFuncStruct,fsModTypeRestr,fsModTRWith,fsWith,fsWithRest,fsModType,fsFullMod


" Enclosing delimiters
syn region   fsEncl transparent matchgroup=fsKeyword start="(" matchgroup=fsKeyword end=")" contains=ALLBUT,@fsContained,fsParenErr
syn region   fsEncl transparent matchgroup=fsKeyword start="{" matchgroup=fsKeyword end="}"  contains=ALLBUT,@fsContained,fsBraceErr
syn region   fsEncl transparent matchgroup=fsKeyword start="\[" matchgroup=fsKeyword end="\]" contains=ALLBUT,@fsContained,fsBrackErr
syn region   fsEncl transparent matchgroup=fsKeyword start="\[|" matchgroup=fsKeyword end="|\]" contains=ALLBUT,@fsContained,fsArrErr


" Comments
syn keyword  fsTodo contained TODO FIXME XXX NOTE
syn region   fsComment start="(\*" end="\*)" contains=fsComment,@fsCommentHook,fsTodo,@Spell
" C# style comments
syn match    fsComment "//.*$" contains=@fsCommentHook,fsTodo,@Spell
" xml documentation comments
syn cluster xmlRegionHook	add=fsXmlCommentLeader
syn cluster xmlCdataHook	add=fsXmlCommentLeader
syn cluster xmlStartTagHook	add=fsXmlCommentLeader
syn keyword fsXmlTag		contained Libraries Packages Types Excluded ExcludedTypeName ExcludedLibraryName
syn keyword fsXmlTag		contained ExcludedBucketName TypeExcluded Type TypeKind TypeSignature AssemblyInfo
syn keyword fsXmlTag		contained AssemblyName AssemblyPublicKey AssemblyVersion AssemblyCulture Base
syn keyword fsXmlTag		contained BaseTypeName Interfaces Interface InterfaceName Attributes Attribute
syn keyword fsXmlTag		contained AttributeName Members Member MemberSignature MemberType MemberValue
syn keyword fsXmlTag		contained ReturnValue ReturnType Parameters Parameter MemberOfPackage
syn keyword fsXmlTag		contained ThreadingSafetyStatement Docs devdoc example overload remarks returns summary
syn keyword fsXmlTag		contained threadsafe value internalonly nodoc exception param permission platnote
syn keyword fsXmlTag		contained seealso b c i pre sub sup block code note paramref see subscript superscript
syn keyword fsXmlTag		contained list listheader item term description altcompliant altmember

syn cluster xmlTagHook add=fsXmlTag

syn match   fsXmlCommentLeader	+\/\/\/+    contained
syn match   fsXmlComment	+\/\/\/.*$+ contains=fsXmlCommentLeader,@fsXml
syntax include @fsXml <sfile>:p:h/xml.vim



" Objects
syn region   fsEnd matchgroup=fsObject start="\<object\>" matchgroup=fsObject end="\<end\>" contains=ALLBUT,@fsContained,fsEndErr


" Blocks
if !exists("fs_revised")
  syn region   fsEnd matchgroup=fsKeyword start="\<begin\>" matchgroup=fsKeyword end="\<end\>" contains=ALLBUT,@fsContained,fsEndErr
endif


" "for"
syn region   fsNone matchgroup=fsKeyword start="\<for\>" matchgroup=fsKeyword end="\<\(to\|downto\)\>" contains=ALLBUT,@fsContained,fsCountErr


" "do"
if !exists("fs_revised")
  syn region   fsDo matchgroup=fsKeyword start="\<do\>" matchgroup=fsKeyword end="\<done\>" contains=ALLBUT,@fsContained,fsDoneErr
endif

" "if"
syn region   fsNone matchgroup=fsKeyword start="\<if\>" matchgroup=fsKeyword end="\<then\>" contains=ALLBUT,@fsContained,fsThenErr


"" Modules

" "struct"
syn region   fsStruct matchgroup=fsModule start="\<struct\>" matchgroup=fsModule end="\<end\>" contains=ALLBUT,@fsContained,fsEndErr

" "sig"
syn region   fsSig matchgroup=fsModule start="\<sig\>" matchgroup=fsModule end="\<end\>" contains=ALLBUT,@fsContained,fsEndErr,fsModule
syn region   fsModSpec matchgroup=fsKeyword start="\<module\>" matchgroup=fsModule end="\<\u\(\w\|'\)*\>" contained contains=@fsAllErrs,fsComment skipwhite skipempty nextgroup=fsModTRWith,fsMPRestr

" "open"
syn region   fsNone matchgroup=fsKeyword start="\<open\>" matchgroup=fsModule end="\<\u\(\w\|'\)*\(\.\u\(\w\|'\)*\)*\>" contains=@fsAllErrs,fsComment

" "include"
syn match    fsKeyword "\<include\>" skipwhite skipempty nextgroup=fsModParam,fsFullMod

" "module" - somewhat complicated stuff ;-)
syn region   fsModule matchgroup=fsKeyword start="\<module\>" matchgroup=fsModule end="\<\u\(\w\|'\)*\>" contains=@fsAllErrs,fsComment skipwhite skipempty nextgroup=fsPreDef
syn region   fsPreDef start="."me=e-1 matchgroup=fsKeyword end="\l\|="me=e-1 contained contains=@fsAllErrs,fsComment,fsModParam,fsModTypeRestr,fsModTRWith nextgroup=fsModPreRHS
syn region   fsModParam start="([^*]" end=")" contained contains=@fsAENoParen,fsModParam1
syn match    fsModParam1 "\<\u\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=fsPreMPRestr

syn region   fsPreMPRestr start="."me=e-1 end=")"me=e-1 contained contains=@fsAllErrs,fsComment,fsMPRestr,fsModTypeRestr

syn region   fsMPRestr start=":" end="."me=e-1 contained contains=@fsComment skipwhite skipempty nextgroup=fsMPRestr1,fsMPRestr2,fsMPRestr3
syn region   fsMPRestr1 matchgroup=fsModule start="\ssig\s\=" matchgroup=fsModule end="\<end\>" contained contains=ALLBUT,@fsContained,fsEndErr,fsModule
syn region   fsMPRestr2 start="\sfunctor\(\s\|(\)\="me=e-1 matchgroup=fsKeyword end="->" contained contains=@fsAllErrs,fsComment,fsModParam skipwhite skipempty nextgroup=fsFuncWith,fsMPRestr2
syn match    fsMPRestr3 "\w\(\w\|'\)*\(\.\w\(\w\|'\)*\)*" contained
syn match    fsModPreRHS "=" contained skipwhite skipempty nextgroup=fsModParam,fsFullMod
syn region   fsModRHS start="." end=".\w\|([^*]"me=e-2 contained contains=fsComment skipwhite skipempty nextgroup=fsModParam,fsFullMod
syn match    fsFullMod "\<\u\(\w\|'\)*\(\.\u\(\w\|'\)*\)*" contained skipwhite skipempty nextgroup=fsFuncWith

syn region   fsFuncWith start="([^*]"me=e-1 end=")" contained contains=fsComment,fsWith,fsFuncStruct skipwhite skipempty nextgroup=fsFuncWith
syn region   fsFuncStruct matchgroup=fsModule start="[^a-zA-Z]struct\>"hs=s+1 matchgroup=fsModule end="\<end\>" contains=ALLBUT,@fsContained,fsEndErr

syn match    fsModTypeRestr "\<\w\(\w\|'\)*\(\.\w\(\w\|'\)*\)*\>" contained
syn region   fsModTRWith start=":\s*("hs=s+1 end=")" contained contains=@fsAENoParen,fsWith
syn match    fsWith "\<\(\u\(\w\|'\)*\.\)*\w\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=fsWithRest
syn region   fsWithRest start="[^)]" end=")"me=e-1 contained contains=ALLBUT,@fsContained

" "module type"
syn region   fsKeyword start="\<module\>\s*\<type\>" matchgroup=fsModule end="\<\w\(\w\|'\)*\>" contains=fsComment skipwhite skipempty nextgroup=fsMTDef
syn match    fsMTDef "=\s*\w\(\w\|'\)*\>"hs=s+1,me=s

syn keyword  fsKeyword  and as assert class
syn keyword  fsKeyword  constraint else
syn keyword  fsKeyword  exception external fun

syn keyword  fsKeyword  in inherit initializer
syn keyword  fsKeyword  land lazy let match
syn keyword  fsKeyword  method mutable new of
syn keyword  fsKeyword  parser private raise rec
syn keyword  fsKeyword  try type
syn keyword  fsKeyword  val virtual when while with

if exists("fs_revised")
  syn keyword  fsKeyword  do value
  syn keyword  fsBoolean  True False
else
  syn keyword  fsKeyword  function
  syn keyword  fsBoolean  true false
  syn match    fsKeyChar  "!"
endif

" F# keywords
syn keyword fsKeyword    abstract and as assert begin class default delegate do done downcast downto else end
syn keyword fsKeyword    enum exception extern false finally for fun function if in inherit interface land lazy let 
syn keyword fsKeyword    match member  module mutable namespace new null of open or override rec sig static struct then to true try
syn keyword fsKeyword    type val when inline upcast while with void
syn keyword fsKeyword    asr land lor lsl lsr lxor mod
syn keyword fsKeyword    async atomic break checked component const constraint 
syn keyword fsKeyword    constructor continue decimal eager event
syn keyword fsKeyword    external fixed functor include method mixin object 
syn keyword fsKeyword    process property protected public pure readonly return sealed  
syn keyword fsKeyword    virtual volatile

syn keyword fsModifier			abstract const extern internal override private protected public readonly sealed static virtual volatile
" constant
syn keyword fsConstant			false null true
" exception

syn keyword  fsType     array bool char exn float format format4
syn keyword  fsType     int int32 int64 lazy_t list nativeint option
syn keyword  fsType     string unit

syn keyword  fsOperator asr lor lsl lsr lxor mod not

syn match    fsConstructor  "(\s*)"
syn match    fsConstructor  "\[\s*\]"
syn match    fsConstructor  "\[|\s*>|]"
syn match    fsConstructor  "\[<\s*>\]"
syn match    fsConstructor  "\u\(\w\|'\)*\>"

" Polymorphic variants
syn match    fsConstructor  "`\w\(\w\|'\)*\>"

" Module prefix
syn match    fsModPath      "\u\(\w\|'\)*\."he=e-1

syn match    fsCharacter    "'\\\d\d\d'\|'\\[\'ntbr]'\|'.'"
syn match    fsCharErr      "'\\\d\d'\|'\\\d'"
syn match    fsCharErr      "'\\[^\'ntbr]'"
syn region   fsString       start=+"+ skip=+\\\\\|\\"+ end=+"+
" verbatim
syn region  fsVerbatimString	start=+@"+ end=+"+ skip=+""+ contains=fsVerbatimSpec,@Spell
syn match   fsVerbatimSpec	+@"+he=s+1 contained

syn match    fsFunDef       "->"
syn match    fsRefAssign    ":="
syn match    fsTopStop      ";;"
syn match    fsOperator     "\^"
syn match    fsOperator     "::"

syn match    fsOperator     "&&"
syn match    fsOperator     "<"
syn match    fsOperator     ">"
" F# operators
syn match    fsOperator     "|>"
syn match    fsOperator     ":>"
syn match    fsOperator     "&&&"
syn match    fsOperator     "|||"
syn match    fsOperator     "\.\."

syn match    fsAnyVar       "\<_\>"
syn match    fsKeyChar      "|[^\]]"me=e-1
syn match    fsKeyChar      ";"
syn match    fsKeyChar      "\~"
syn match    fsKeyChar      "?"
syn match    fsKeyChar      "\*"
syn match    fsKeyChar      "="

if exists("fs_revised")
  syn match    fsErr        "<-"
else
  syn match    fsOperator   "<-"
endif

syn match    fsNumber        "\<-\=\d\+[l|L]\?\>"
syn match    fsNumber        "\<-\=0[x|X]\x\+[l|L]\?\>"
syn match    fsNumber        "\<-\=0[o|O]\o\+[l|L]\?\>"
syn match    fsNumber        "\<-\=0[b|B][01]\+[l|L]\?\>"
syn match    fsFloat         "\<-\=\d\+\.\d*\([eE][-+]\=\d\+\)\=[fl]\=\>"

" Labels
syn match    fsLabel        "\~\(\l\|_\)\(\w\|'\)*"lc=1
syn match    fsLabel        "?\(\l\|_\)\(\w\|'\)*"lc=1
syn region   fsLabel transparent matchgroup=fsLabel start="?(\(\l\|_\)\(\w\|'\)*"lc=2 end=")"me=e-1 contains=ALLBUT,@fsContained,fsParenErr


" Synchronization
syn sync minlines=50
syn sync maxlines=500

if !exists("fs_revised")
  syn sync match fsDoSync      grouphere  fsDo      "\<do\>"
  syn sync match fsDoSync      groupthere fsDo      "\<done\>"
endif

if exists("fs_revised")
  syn sync match fsEndSync     grouphere  fsEnd     "\<\(object\)\>"
else
  syn sync match fsEndSync     grouphere  fsEnd     "\<\(begin\|object\)\>"
endif

syn sync match fsEndSync     groupthere fsEnd     "\<end\>"
syn sync match fsStructSync  grouphere  fsStruct  "\<struct\>"
syn sync match fsStructSync  groupthere fsStruct  "\<end\>"
syn sync match fsSigSync     grouphere  fsSig     "\<sig\>"
syn sync match fsSigSync     groupthere fsSig     "\<end\>"

" preprocessor directives
syn region	fsPreCondit
    \ start="^\s*#\s*\(define\|undef\|if\|elif\|else\|endif\|line\|error\|warning\|light\)"
    \ skip="\\$" end="$" contains=fsComment keepend
syn region	fsRegion matchgroup=fsPreCondit start="^\s*#\s*region.*$"
    \ end="^\s*#\s*endregion" transparent fold contains=TOP

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_fs_syntax_inits")
  if version < 508
    let did_fs_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink fsBraceErr	   Error
  HiLink fsBrackErr	   Error
  HiLink fsParenErr	   Error
  HiLink fsArrErr	   Error

  HiLink fsCommentErr   Error

  HiLink fsCountErr	   Error
  HiLink fsDoErr	   Error
  HiLink fsDoneErr	   Error
  HiLink fsEndErr	   Error
  HiLink fsThenErr	   Error

  HiLink fsCharErr	   Error

  HiLink fsErr	   Error

  HiLink fsComment	   Comment
  " xml markup
  HiLink fsXmlCommentLeader Comment
  HiLink fsXmlComment       Comment
  HiLink fsXmlTag           Statement
  HiLink xmlRegion          Comment

  HiLink fsModPath	   Include
  HiLink fsObject	   Include
  HiLink fsModule	   Include
  HiLink fsModParam1    Include
  HiLink fsModType	   Include
  HiLink fsMPRestr3	   Include
  HiLink fsFullMod	   Include
  HiLink fsModTypeRestr Include
  HiLink fsWith	   Include
  HiLink fsMTDef	   Include

  HiLink fsScript	   Include

  HiLink fsConstructor  Constant

  HiLink fsModPreRHS    Keyword
  HiLink fsMPRestr2	   Keyword
  HiLink fsKeyword	   Keyword
  HiLink fsFunDef	   Keyword
  HiLink fsRefAssign    Keyword
  HiLink fsKeyChar	   Keyword
  HiLink fsAnyVar	   Keyword
  HiLink fsTopStop	   Keyword
  HiLink fsOperator	   Keyword

  HiLink fsBoolean	   Boolean
  HiLink fsCharacter    Character
  HiLink fsNumber	   Number
  HiLink fsFloat	   Float
  HiLink fsString	   String
  HiLink fsVerbatimString  String
  HiLink fsVerbatimSpec    SpecialChar

  HiLink fsLabel	   Identifier

  HiLink fsType	   Type

  HiLink fsTodo	   Todo

  HiLink fsEncl	   Keyword


  HiLink fsPreCondit      PreCondit
  HiLink fsModifier		StorageClass
  HiLink fsConstant		Constant

  delcommand HiLink
endif

let b:current_syntax = "fs"

" vim: ts=8
