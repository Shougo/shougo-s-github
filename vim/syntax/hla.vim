
"
" Vim syntax file
" Language:  HLA
"
" ~/.vim/syntax/hla.vim
"
" written by:      Jeremiah Mahler <jmmahler@gmail.com>
" created on:      10 Oct 2009
" last modified:   20 Nov 2009
"
" A Vim syntax definition for the HLA programming language.
"  http://en.wikipedia.org/wiki/High_Level_Assembly
"
" -- Jeremiah Mahler  <jmmahler@gmail.com>  Fri, 20 Nov 2009 18:29:26 -0800
"
"   * Lots more keywords added with help from Boyd Trolinger <jboydt@foobt.net>.
"  
" 

"runtime syntax/c.vim
"unlet b:current_syntax

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


syn keyword hlaRegister  ax bx cx dx ex si di bp sp ss es ds cs fs gs ip al ah
syn keyword hlaRegister  bl bh ch cl dh dl eh el eax ebx ebp ecx edi edx esi esp
syn keyword hlaRegister  dx:ax edx:eax

syn keyword hlaType  boolean byte char dword int int128 int16 int32 int64 int8
syn keyword hlaType  lword qword string tbyte uns128 uns16 uns32 uns64 uns8 word

syn keyword hlaConstant  nl

syn keyword hlaBoolean  true false

" {{{ hlaDirective
syn keyword hlaDirective  aaa aad aam adc add and arpl bound bsf bsr bswap bt
syn keyword hlaDirective  btc btr bts call cbw cdq clc cld cli clts cmc cmp
syn keyword hlaDirective  cmps cmpsb cmpsd cmpsw cmpxchg cwd cwde daa das dec
syn keyword hlaDirective  div emms enter f2xm1 fabs fadd faddp fbld fbstp fchs
syn keyword hlaDirective  fclex fcmovb fcmovbe fcmove fcmovnb fcmovnbe fcmovne
syn keyword hlaDirective  fcmovnu fcmovu fcom fcomi fcomip fcomp fcompp fcos
syn keyword hlaDirective  fdecstp fdiv fdivp fdivr fdivrp femms ffree fiadd
syn keyword hlaDirective  ficom ficomp fidiv fidivr fild fimul fincstp finit
syn keyword hlaDirective  fist fistp fisub fisubr fld fld1 fldcw fldenv fldl2e
syn keyword hlaDirective  fldl2t fldlg2 fldln2 fldpi fldz fmul fmulp fnclex
syn keyword hlaDirective  fninit fnop fnsave fnstcw fnstenv fnstsw fpatan
syn keyword hlaDirective  fprem1 fptan frndint frstor fsave fscale fsin fsincos
syn keyword hlaDirective  fsqrt fst fstcw fstenv fstp fstsw fsub fsubp fsubr
syn keyword hlaDirective  fsubrp ftst fucom fucomi fucomip fucomp fucompp fwait
syn keyword hlaDirective  fxch fxtract fyl2xp1 hlt idiv imul in inc ins insb
syn keyword hlaDirective  insd insw into invd invlpg iret iretd iretw ja jae jb
syn keyword hlaDirective  jbe jc jcxz je jecxz jg jge jl jle jmp jna jnae jnb
syn keyword hlaDirective  jnbe jnc jne jng jnge jnl jnle jno jnp jns jnz jo jp
syn keyword hlaDirective  jpe jpo js jz lahf lar lds lea leave les lfs lgdt lgs
syn keyword hlaDirective  lidt lldt lmsw lock lods lodsb lodsd lodsw loop loope
syn keyword hlaDirective  loopne loopnz loopz lsl lss ltr mov movd movq movs
syn keyword hlaDirective  malloc free stralloc strfree
syn keyword hlaDirective  movsb movsd movsw movsx movzx mul neg nop not or out
syn keyword hlaDirective  outs outsb outsd outsw packssdw packsswb packuswb
syn keyword hlaDirective  paddb paddd paddsb paddsw paddusb paddusw paddw pand
syn keyword hlaDirective  pandn pavgusb pcmpeqb pcmpeqd pcmpeqw pcmpgtb pcmpgtd
syn keyword hlaDirective  pcmpgtw pf2id pfacc pfadd pfcmpeq pfcmpge pfcmpgt
syn keyword hlaDirective  pfmax pfmin pfmul pfrcp pfrcpit1 pfrcpit2 pfrsqit1
syn keyword hlaDirective  pfrsqrt pfsub pfsubr pi2fd pmaddwd pmulhrw pmulhw
syn keyword hlaDirective  pmullw pop popa popad popaw popf popfd popfw por
syn keyword hlaDirective  prefetch prefetchw pslld psllq psllw psrad psraw
syn keyword hlaDirective  psrld psrlq psrlw psubb psubd psubsb psubsw psubusb
syn keyword hlaDirective  psubusw psubw punpckhbw punpckhdq punpckhwd punpcklbw
syn keyword hlaDirective  punpckldq punpcklwd push pusha pushad pushaw pushf
syn keyword hlaDirective  pushfd pushfw pxor rcl rcr rep repe repne repnz repz
syn keyword hlaDirective  ret rol ror sahf sal sar sbb scas scasb scasd scasw
syn keyword hlaDirective  seta setae setb setbe setc sete setg setge setl setle
syn keyword hlaDirective  setna setnae setnb setnbe setnc setne setng setnge
syn keyword hlaDirective  setnl setnle setno setnp setns setnz seto setp setpo
syn keyword hlaDirective  sets setz sgdt shl shld shr shrd sidt sldt smsw stc
syn keyword hlaDirective  std sti stos stosb stosd stosw str sub test verr verw
" }}}

" {{{ hlaConditional
syn keyword hlaConditional  aaa aad aam aas abstract adc add addpd addps addsd
syn keyword hlaConditional  addss addsubpd addsubps align and andnpd andnps
syn keyword hlaConditional  andpd andps anyexception arpl begin bound break
syn keyword hlaConditional  breakif bsf bsr bswap bt btc btr bts call case cbw
syn keyword hlaConditional  cdq class clc cld clflush cli clts cmc cmova cmovae
syn keyword hlaConditional  cmovb cmovbe cmovc cmove cmovg cmovge cmovl cmovle
syn keyword hlaConditional  cmovna cmovnae cmovnb cmovnbe cmovnc cmovne cmovng
syn keyword hlaConditional  cmovnge cmovnl cmovnle cmovno cmovnp cmovns cmovnz
syn keyword hlaConditional  cmovo cmovp cmovpe cmovpo cmovs cmovz cmp cmpeqpd
syn keyword hlaConditional  cmpeqps cmpeqsd cmpeqss cmplepd cmpleps cmplesd
syn keyword hlaConditional  cmpless cmpltpd cmpltps cmpltsd cmpltss cmpneqpd
syn keyword hlaConditional  cmpneqps cmpneqsd cmpneqss cmpnlepd cmpnleps
syn keyword hlaConditional  cmpnlesd cmpnless cmpnltpd cmpnltps cmpnltsd
syn keyword hlaConditional  cmpnltss cmpordpd cmpordps cmpordsd cmpordss cmppd
syn keyword hlaConditional  cmpps cmpsb cmpsd cmpss cmpsw cmpunordpd cmpunordps
syn keyword hlaConditional  cmpunordsd cmpunordss cmpxchg cmpxchg8b comisd
syn keyword hlaConditional  comiss const continue continueif cpuid cr0 cr1 cr2
syn keyword hlaConditional  cr3 cr4 cr5 cr6 cr7 cseg cset cvtdq2pd cvtdq2ps
syn keyword hlaConditional  cvtpd2dq cvtpd2pi cvtpd2ps cvtpi2pd cvtpi2ps
syn keyword hlaConditional  cvtps2dq cvtps2pd cvtps2pi cvtsd2si cvtsd2ss
syn keyword hlaConditional  cvtsi2sd cvtsi2ss cvtss2sd cvtss2si cvttpd2dq
syn keyword hlaConditional  cvttpd2pi cvttps2dq cvttps2pi cvttsd2si cvttss2si
syn keyword hlaConditional  cwd cwde daa das dec default div divpd divps divsd
syn keyword hlaConditional  divss do downto dr0 dr1 dr2 dr3 dr4 dr5 dr6 dr7
syn keyword hlaConditional  dseg dup else elseif emms end endclass endconst
syn keyword hlaConditional  endfor endif endlabel endproc endreadonly endrecord
syn keyword hlaConditional  endstatic endstorage endswitch endtry endtype
syn keyword hlaConditional  endunion endval endvar endwhile enter enum eseg
syn keyword hlaConditional  exception exit exitif external f2xm1 fabs fadd
syn keyword hlaConditional  faddp fbld fbstp fchs fclex fcmova fcmovae fcmovb
syn keyword hlaConditional  fcmovbe fcmove fcmovna fcmovnae fcmovnb fcmovnbe
syn keyword hlaConditional  fcmovne fcmovnu fcmovu fcom fcomi fcomip fcomp
syn keyword hlaConditional  fcompp fcos fdecstp fdiv fdivp fdivr fdivrp felse
syn keyword hlaConditional  ffree fiadd ficom ficomp fidiv fidivr fild fimul
syn keyword hlaConditional  fincstp finit fist fistp fisttp fisub fisubr fld
syn keyword hlaConditional  fld1 fldcw fldenv fldl2e fldl2t fldlg2 fldln2 fldpi
syn keyword hlaConditional  fldz fmul fmulp fnclex fninit fnop fnsave fnstcw
syn keyword hlaConditional  fnstenv fnstsw for foreach forever forward fpatan
syn keyword hlaConditional  fprem fprem1 fptan frndint frstor fsave fscale fseg
syn keyword hlaConditional  fsin fsincos fsqrt fst fstcw fstenv fstp fstsw fsub
syn keyword hlaConditional  fsubp fsubr fsubrp ftst fucom fucomi fucomip fucomp
syn keyword hlaConditional  fucompp fwait fxam fxch fxrstor fxsave fxtract
syn keyword hlaConditional  fyl2x fyl2xp1 gseg haddpd haddps hlt hsubpd hsubps
syn keyword hlaConditional  idiv if imod imul in inc inherits insb insd insw
syn keyword hlaConditional  intmul into invd invlpg iret iretd iterator ja jae
syn keyword hlaConditional  jb jbe jc jcxz je jecxz jf jg jge jl jle jmp jna
syn keyword hlaConditional  jnae jnb jnbe jnc jne jng jnge jnl jnle jno jnp jns
syn keyword hlaConditional  jnz jo jp jpe jpo js jt jz label lahf lar lazy
syn keyword hlaConditional  lddqu ldmxcsr lds lea leave les lfence lfs lgdt lgs
syn keyword hlaConditional  lidt lldt lmsw lock.adc lock.add lock.and lock.btc
syn keyword hlaConditional  lock.btr lock.bts lock.cmpxchg lock.dec lock.inc
syn keyword hlaConditional  lock.neg lock.not lock.or lock.sbb lock.sub
syn keyword hlaConditional  lock.xadd lock.xchg lock.xor lodsb lodsd lodsw loop
syn keyword hlaConditional  loope loopne loopnz loopz lsl lss ltreg maskmovdqu
syn keyword hlaConditional  maskmovq maxpd maxps maxsd maxss method mfence
syn keyword hlaConditional  minpd minps minsd minss mm0 mm1 mm2 mm3 mm4 mm5 mm6
syn keyword hlaConditional  mm7 mod monitor mov movapd movaps movd movddup
syn keyword hlaConditional  movdq2q movdqa movdqu movhlps movhpd movhps movlhps
syn keyword hlaConditional  movlpd movlps movmskpd movmskps movntdq movnti
syn keyword hlaConditional  movntpd movntps movntq movq movq2dq movsb movsd
syn keyword hlaConditional  movshdup movsldup movss movsw movsx movupd movups
syn keyword hlaConditional  movzx mul mulpd mulps mulsd mulss mwait name
syn keyword hlaConditional  namespace neg nop not null or orpd orps out outsb
syn keyword hlaConditional  outsd outsw overloads override overrides packssdw
syn keyword hlaConditional  packsswb packuswb paddb paddd paddq paddsb paddsw
syn keyword hlaConditional  paddusb paddusw paddw pand pandn pause pavgb pavgw
syn keyword hlaConditional  pcmpeqb pcmpeqd pcmpeqw pcmpgtb pcmpgtd pcmpgtw
syn keyword hlaConditional  pextrw pinsrw pmaddwd pmaxsw pmaxub pminsw pminub
syn keyword hlaConditional  pmovmskb pmulhuw pmulhw pmullw pmuludq pointer pop
syn keyword hlaConditional  popa popad popf popfd por prefetchnta prefetcht0
syn keyword hlaConditional  prefetcht1 prefetcht2 proc procedure program psadbw
syn keyword hlaConditional  pshufd pshufhw pshuflw pshufw pslld pslldq psllq
syn keyword hlaConditional  psllw psrad psraw psrld psrldq psrlq psrlw psubb
syn keyword hlaConditional  psubd psubq psubsb psubsw psubusb psubusw psubw
syn keyword hlaConditional  punpckhbw punpckhdq punpckhqdq punpckhwd punpcklbw
syn keyword hlaConditional  punpckldq punpcklqdq punpcklwd push pusha pushad
syn keyword hlaConditional  pushd pushf pushfd pushw pxor raise rcl rcpps rcpss
syn keyword hlaConditional  rcr rdmsr rdpmc rdtsc readonly real128 real32
syn keyword hlaConditional  real64 real80 record regex rep.insb rep.insd
syn keyword hlaConditional  rep.insw rep.movsb rep.movsd rep.movsw rep.outsb
syn keyword hlaConditional  rep.outsd rep.outsw rep.stosb rep.stosd rep.stosw
syn keyword hlaConditional  repe.cmpsb repe.cmpsd repe.cmpsw repe.scasb
syn keyword hlaConditional  repe.scasd repe.scasw repeat repne.cmpsb
syn keyword hlaConditional  repne.cmpsd repne.cmpsw repne.scasb repne.scasd
syn keyword hlaConditional  repne.scasw repnz.cmpsb repnz.cmpsd repnz.cmpsw
syn keyword hlaConditional  repnz.scasb repnz.scasd repnz.scasw repz.cmpsb
syn keyword hlaConditional  repz.cmpsd repz.cmpsw repz.scasb repz.scasd
syn keyword hlaConditional  repz.scasw result ret returns rol ror rsm rsqrtps
syn keyword hlaConditional  rsqrtss sahf sal sar sbb scasb scasd scasw segment
syn keyword hlaConditional  seta setae setb setbe setc sete setg setge setl
syn keyword hlaConditional  setle setna setnae setnb setnbe setnc setne setng
syn keyword hlaConditional  setnge setnl setnle setno setnp setns setnz seto
syn keyword hlaConditional  setp setpe setpo sets setz sfence sgdt shl shld shr
syn keyword hlaConditional  shrd shufpd shufps sidt sldt smsw sqrtpd sqrtps
syn keyword hlaConditional  sqrtsd sqrtss sseg st0 st1 st2 st3 st4 st5 st6 st7
syn keyword hlaConditional  static stc std sti stmxcsr storage stosb stosd
syn keyword hlaConditional  stosw streg sub subpd subps subsd subss switch
syn keyword hlaConditional  sysenter sysexit test text then this thunk to try
syn keyword hlaConditional  type ucomisd ucomiss ud2 union unit unpckhpd
syn keyword hlaConditional  unpckhps unpcklpd unpcklps unprotected until val
syn keyword hlaConditional  valres var verr verw vmt wait wbinvd wchar welse
syn keyword hlaConditional  while wrmsr wstring xadd xchg xlat xmm0 xmm1 xmm2
" }}}

syn match hlaStatement "stdout\.put"
syn match hlaStatement "stdin\.get"
syn match hlaStatement "stdin\.putu8size"
syn match hlaStatement "stdin\.a_gets"
syn match hlaStatement "stdin\.flushInput"

" {{{ hlaMacro
syn match hlaMacro "\#append"
syn match hlaMacro "\#asm"
syn match hlaMacro "\#closeread"
syn match hlaMacro "\#closewrite"
syn match hlaMacro "\#else"
syn match hlaMacro "\#elseif"
syn match hlaMacro "\#emit"
syn match hlaMacro "\#endasm"
syn match hlaMacro "\#endfor"
syn match hlaMacro "\#endif"
syn match hlaMacro "\#endmacro"
syn match hlaMacro "\#endmatch"
syn match hlaMacro "\#endregex"
syn match hlaMacro "\#endstring"
syn match hlaMacro "\#endtext"
syn match hlaMacro "\#endwhile"
syn match hlaMacro "\#error"
syn match hlaMacro "\#for"
syn match hlaMacro "\#id"
syn match hlaMacro "\#if"
syn match hlaMacro "\#include"
syn match hlaMacro "\#includeonce"
syn match hlaMacro "\#keyword"
syn match hlaMacro "\#linker"
syn match hlaMacro "\#macro"
syn match hlaMacro "\#match"
syn match hlaMacro "\#openread"
syn match hlaMacro "\#openwrite"
syn match hlaMacro "\#print"
syn match hlaMacro "\#regex"
syn match hlaMacro "\#return"
syn match hlaMacro "\#rw"
syn match hlaMacro "\#string"
syn match hlaMacro "\#system"
syn match hlaMacro "\#terminator"
syn match hlaMacro "\#text"
syn match hlaMacro "\#while"
syn match hlaMacro "\#write"
"}}}

" {{{ hlaOther
syn match hlaOther "@a"
syn match hlaOther "@abs"
syn match hlaOther "@abstract"
syn match hlaOther "@ae"
syn match hlaOther "@align"
syn match hlaOther "@alignstack"
syn match hlaOther "@arb"
syn match hlaOther "@arity"
syn match hlaOther "@at"
syn match hlaOther "@b"
syn match hlaOther "@baseptype"
syn match hlaOther "@basereg"
syn match hlaOther "@basetype"
syn match hlaOther "@be"
syn match hlaOther "@boolean"
syn match hlaOther "@bound"
syn match hlaOther "@byte"
syn match hlaOther "@c"
syn match hlaOther "@cdecl"
syn match hlaOther "@ceil"
syn match hlaOther "@char"
syn match hlaOther "@class"
syn match hlaOther "@cos"
syn match hlaOther "@cset"
syn match hlaOther "@curdir"
syn match hlaOther "@curlex"
syn match hlaOther "@curobject"
syn match hlaOther "@curoffset"
syn match hlaOther "@date"
syn match hlaOther "@debughla"
syn match hlaOther "@defined"
syn match hlaOther "@delete"
syn match hlaOther "@dim"
syn match hlaOther "@display"
syn match hlaOther "@dword"
syn match hlaOther "@e"
syn match hlaOther "@elements"
syn match hlaOther "@elementsize"
syn match hlaOther "@enter"
syn match hlaOther "@enumsize"
syn match hlaOther "@env"
syn match hlaOther "@eos"
syn match hlaOther "@eval"
syn match hlaOther "@exactlynchar"
syn match hlaOther "@exactlyncset"
syn match hlaOther "@exactlynichar"
syn match hlaOther "@exactlyntomchar"
syn match hlaOther "@exactlyntomcset"
syn match hlaOther "@exactlyntomichar"
syn match hlaOther "@exceptions"
syn match hlaOther "@exp"
syn match hlaOther "@external"
syn match hlaOther "@extract"
syn match hlaOther "@fast"
syn match hlaOther "@filename"
syn match hlaOther "@firstnchar"
syn match hlaOther "@firstncset"
syn match hlaOther "@firstnichar"
syn match hlaOther "@floor"
syn match hlaOther "@forward"
syn match hlaOther "@fpureg"
syn match hlaOther "@frame"
syn match hlaOther "@g"
syn match hlaOther "@ge"
syn match hlaOther "@global"
syn match hlaOther "@here"
syn match hlaOther "@index"
syn match hlaOther "@insert"
syn match hlaOther "@int128"
syn match hlaOther "@int16"
syn match hlaOther "@int32"
syn match hlaOther "@int64"
syn match hlaOther "@int8"
syn match hlaOther "@into"
syn match hlaOther "@isalpha"
syn match hlaOther "@isalphanum"
syn match hlaOther "@isclass"
syn match hlaOther "@isconst"
syn match hlaOther "@isdigit"
syn match hlaOther "@IsExternal"
syn match hlaOther "@isfreg"
syn match hlaOther "@islower"
syn match hlaOther "@ismem"
syn match hlaOther "@isreg"
syn match hlaOther "@isreg16"
syn match hlaOther "@isreg32"
syn match hlaOther "@isreg8"
syn match hlaOther "@isspace"
syn match hlaOther "@istype"
syn match hlaOther "@isupper"
syn match hlaOther "@isxdigit"
syn match hlaOther "@l"
syn match hlaOther "@label"
syn match hlaOther "@lastobject"
syn match hlaOther "@le"
syn match hlaOther "@leave"
syn match hlaOther "@length"
syn match hlaOther "@lex"
syn match hlaOther "@linenumber"
syn match hlaOther "@localoffset"
syn match hlaOther "@localsyms"
syn match hlaOther "@log"
syn match hlaOther "@log10"
syn match hlaOther "@lowercase"
syn match hlaOther "@lword"
syn match hlaOther "@match"
syn match hlaOther "@match2"
syn match hlaOther "@matchchar"
syn match hlaOther "@matchcset"
syn match hlaOther "@matchichar"
syn match hlaOther "@matchid"
syn match hlaOther "@matchintconst"
syn match hlaOther "@matchistr"
syn match hlaOther "@matchiword"
syn match hlaOther "@matchnumericconst"
syn match hlaOther "@matchrealconst"
syn match hlaOther "@matchstr"
syn match hlaOther "@matchstrconst"
syn match hlaOther "@matchtoistr"
syn match hlaOther "@matchtostr"
syn match hlaOther "@matchword"
syn match hlaOther "@max"
syn match hlaOther "@min"
syn match hlaOther "@mmxreg"
syn match hlaOther "@na"
syn match hlaOther "@nae"
syn match hlaOther "@name"
syn match hlaOther "@nb"
syn match hlaOther "@nbe"
syn match hlaOther "@nc"
syn match hlaOther "@ne"
syn match hlaOther "@ng"
syn match hlaOther "@nge"
syn match hlaOther "@nl"
syn match hlaOther "@nle"
syn match hlaOther "@no"
syn match hlaOther "@noalignstack"
syn match hlaOther "@nodisplay"
syn match hlaOther "@noenter"
syn match hlaOther "@noframe"
syn match hlaOther "@noleave"
syn match hlaOther "@norlesschar"
syn match hlaOther "@norlesscset"
syn match hlaOther "@norlessichar"
syn match hlaOther "@normorechar"
syn match hlaOther "@normorecset"
syn match hlaOther "@normoreichar"
syn match hlaOther "@nostackalign"
syn match hlaOther "@nostorage"
syn match hlaOther "@np"
syn match hlaOther "@ns"
syn match hlaOther "@ntomchar"
syn match hlaOther "@ntomcset"
syn match hlaOther "@ntomichar"
syn match hlaOther "@nz"
syn match hlaOther "@o"
syn match hlaOther "@odd"
syn match hlaOther "@offset"
syn match hlaOther "@onechar"
syn match hlaOther "@onecset"
syn match hlaOther "@oneichar"
syn match hlaOther "@oneormorechar"
syn match hlaOther "@oneormorecset"
syn match hlaOther "@oneormoreichar"
syn match hlaOther "@oneormorews"
syn match hlaOther "@optstrings"
syn match hlaOther "@p"
syn match hlaOther "@parmoffset"
syn match hlaOther "@parms"
syn match hlaOther "@pascal"
syn match hlaOther "@pclass"
syn match hlaOther "@pe"
syn match hlaOther "@peekchar"
syn match hlaOther "@peekcset"
syn match hlaOther "@peekichar"
syn match hlaOther "@peekistr"
syn match hlaOther "@peekstr"
syn match hlaOther "@peekws"
syn match hlaOther "@po"
syn match hlaOther "@pointer"
syn match hlaOther "@pos"
syn match hlaOther "@ptype"
syn match hlaOther "@qword"
syn match hlaOther "@random"
syn match hlaOther "@randomize"
syn match hlaOther "@read"
syn match hlaOther "@real128"
syn match hlaOther "@real32"
syn match hlaOther "@real64"
syn match hlaOther "@real80"
syn match hlaOther "@reg"
syn match hlaOther "@reg16"
syn match hlaOther "@reg32"
syn match hlaOther "@reg8"
syn match hlaOther "@regex"
syn match hlaOther "@returns"
syn match hlaOther "@rindex"
syn match hlaOther "@s"
syn match hlaOther "@section"
syn match hlaOther "@sin"
syn match hlaOther "@size"
syn match hlaOther "@sort"
syn match hlaOther "@sqrt"
syn match hlaOther "@stackalign"
syn match hlaOther "@staticname"
syn match hlaOther "@stdcall"
syn match hlaOther "@strbrk"
syn match hlaOther "@string"
syn match hlaOther "@strset"
syn match hlaOther "@strspan"
syn match hlaOther "@substr"
syn match hlaOther "@system"
syn match hlaOther "@tab"
syn match hlaOther "@tan"
syn match hlaOther "@tbyte"
syn match hlaOther "@text"
syn match hlaOther "@thread"
syn match hlaOther "@time"
syn match hlaOther "@tokenize"
syn match hlaOther "@tostring"
syn match hlaOther "@trace"
syn match hlaOther "@trim"
syn match hlaOther "@type"
syn match hlaOther "@typename"
syn match hlaOther "@uns128"
syn match hlaOther "@uns16"
syn match hlaOther "@uns32"
syn match hlaOther "@uns64"
syn match hlaOther "@uns8"
syn match hlaOther "@uppercase"
syn match hlaOther "@uptochar"
syn match hlaOther "@uptocset"
syn match hlaOther "@uptoichar"
syn match hlaOther "@uptoistr"
syn match hlaOther "@uptostr"
syn match hlaOther "@use"
syn match hlaOther "@volatile"
syn match hlaOther "@wchar"
syn match hlaOther "@word"
syn match hlaOther "@ws"
syn match hlaOther "@wsoreos"
syn match hlaOther "@wstheneos"
syn match hlaOther "@wstring"
syn match hlaOther "@xmmreg"
syn match hlaOther "@z"
syn match hlaOther "@zeroormorechar"
syn match hlaOther "@zeroormorecset"
syn match hlaOther "@zeroormoreichar"
syn match hlaOther "@zeroormorews"
" }}}

syn keyword hlaTodo  TODO FIXME XXX contained

"syn match hlaNumbers display transparent "\<\d\|\.\d" contains=hlaNumber,hlaHexNumber,hlaBinNumber
" TODO - how to match a '%' sign for binary?
"syn match  hlaBinNumber '%[0-1]\+'
syn match  hlaHexNumber  "$[0-9a-fA-F]\+"
syn match  hlaNumber  "\<[0-9]\+[0-9]*\>"

syn match  hlaComment  "//.*" contains=hlaTodo
syn region hlaComment  start="/\*" end="\*/" contains=hlaTodo

syn region hlaString start='"' end='"'
syn region hlaString start='\'' end='\''


"highlight link hlaRegister Special
highlight link hlaRegister Constant
highlight link hlaType Type
highlight link hlaComment Comment
highlight link hlaString Constant
highlight link hlaNumber Constant
highlight link hlaHexNumber Constant
highlight link hlaConstant Constant
highlight link hlaDirective Statement
highlight link hlaOther PreProc
highlight link hlaStatement Statement
highlight link hlaMacro Macro
highlight link hlaInclude Include
highlight link hlaConditional Conditional
highlight link hlaRepeat Repeat
highlight link hlaTodo Todo
highlight link hlaBoolean Boolean

let b:current_syntax = "hla"

" vim:foldmethod=marker
