" Vim syntax file
" Language:     GNU as (AT&T) assembler for X86
" Maintainer:   Rene Koecher <shirk@bitspin.org>
" Last Change:  2009 Dec 29
" Version:      0.8
" Remark:       Intel compatible instructions only (for now)

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

setlocal iskeyword +=%,.,-,_
setlocal isident   +=%,.,-,_

syn case ignore

" directives
syn keyword gasDirective	.abort .ABORT .align .balignw .balignl
syn keyword gasDirective	.cfi_startproc .cfi_sections .cfi_endproc .cfi_personality
syn keyword gasDirective	.cfi_lsda .cfi_def_cfa .cfi_def_cfa_register .cfi_def_cfa_offset
syn keyword gasDirective	.cfi_adjust_cfa_offset .cfi_offset .cfi_rel_offset .cfi_register
syn keyword gasDirective	.cfi_restore .cfi_undefined .cfi_same_value .cfi_remember_state
syn keyword gasDirective	.cfi_return_column .cfi_signal_frame .cfi_window_save .cfi_escape
syn keyword gasDirective	.cfi_val_encoded_addr .data .def .desc .dim .eject
syn keyword gasDirective	.else .elseif .endef .endif .equ .equiv .eqv .err
syn keyword gasDirective	.error .exitm .extern .fail .file .fill .global .globl
syn keyword gasDirective	.gnu_attribute .hidden .ident .if .incbin .include .internal
syn keyword gasDirective	.irp .irpc .lcomm .lflags .line .linkonce .list .ln .loc .loc_mark_labels
syn keyword gasDirective	.local .mri .nolist .octa .org .p2alignw .p2alignl
syn keyword gasDirective	.popsection .previous .print .protected .psize .purgem .pushsection .quad
syn keyword gasDirective	.reloc .rept .sbttl .scl .section .set .single .size .skip .sleb128
syn keyword gasDirective	.space .stabd .stabn .stabs .struct .subsection
syn keyword gasDirective	.symver .tag .text .title .type .uleb128 .val .version
syn keyword gasDirective	.vtable_entry .vtable_inherit .warning .weak .weakref

syn keyword gasDirectiveStore	.byte .hword .word .int .long .double .short .float
syn keyword gasDirectiveStore	.string .string8 .string16 .ascii .asciz .comm

syn keyword gasDirectiveMacro	.altmacro .macro .noaltmacro .end .func .endfunc

" i*86 directives
syn keyword gasDirectiveX86	.att_syntax .intel_syntax .att_mnemonic .intel_mnemonic .lcomm

" i*86 register set
syn keyword gasRegisterX86	%rax %rbx %rcx %rdx %rdi %rsi %rsp %rbp
syn keyword gasRegisterX86	%eax %ebx %ecx %edx %ax %bx %cx %dx %ah %al %bh %bl %ch %cl %dh %dl
syn keyword gasRegisterX86	%edi %esi %esp %ebp %di %si %sp %bp %sph %spl %bph %bpl
syn keyword gasRegisterX86	%cs %ds %es %fs %gs %ss %ip %eip %rip %eflags
syn match   gasRegisterX86	/\<%r\([8-9]\|1[0-5]\)[lwd]\?\>/

" i*86 special registers
syn match gasRegisterX86Cr	/\<%cr[0-8]\>/
syn match gasRegisterX86Dr	/\<%dr[0-8]\>/
syn match gasRegisterX86Tr	/\<%tr[0-8]\>/
syn match gasRegisterX86Fp	/\<%sp\(([0-7])\)\?\>/
syn match gasRegisterX86MMX	/\<%x\?mm[0-7]\>/

" symbols and labels

syn match   gasLabel		/[-_$.A-Za-z0-9]\+\s*:/
syn match   gasSymbol		/\<[^; \t()]\+\>/
syn match   gasSymbolRef	/\$[-_$.A-Za-z][-_$.A-Za-z0-9]*\>/
syn match   gasSpecial		/\<[$.]\>/

" constants
syn region  gasString		start=/"/  end=/"/ skip=/\\"/
syn match   gasCharacter	/'\(?\|\\?\)/
syn match   gasDecimalNumber	/\$\?-\?\d\+/
syn match   gasBinaryNumber	/\$\?-\?0b[01]\+/
syn match   gasOctalNumber	/\$\?-\?0\d\+/
syn match   gasHexNumber	/\$\?-\?0x\x\+/
" -- TODO: gasFloatNumber

" local label needs to be matched *after* numerics
syn match   gasLocalLabel	/\d\{1,2\}[:fb]/

" comments etc.
syn match   gasOperator		/[+-/*=|&~<>]\|<=\|>=\|<>/
syn region  gasComment		start=/\/\*/ end=/\*\//
syn region  gasCommentSingle    start=/#/ end=/$/

" finally: Opcodes
"
"-- Section: Willamette MMX instructions (SSE2 SIMD Integer Instructions)
syn keyword gasOpcode_SSE2		movd movdb movdw movdl movdq
syn keyword gasOpcode_SSE2		movdqa
syn keyword gasOpcode_SSE2		movdqu
syn keyword gasOpcode_SSE2		movdq2q
syn keyword gasOpcode_X64_SSE2		movq
syn keyword gasOpcode_SSE2		movq2dq
syn keyword gasOpcode_SSE2		packsswb packsswbb packsswbw packsswbl packsswbq
syn keyword gasOpcode_SSE2		packssdw packssdwb packssdww packssdwl packssdwq
syn keyword gasOpcode_SSE2		packuswb packuswbb packuswbw packuswbl packuswbq
syn keyword gasOpcode_SSE2		paddb paddbb paddbw paddbl paddbq
syn keyword gasOpcode_SSE2		paddw paddwb paddww paddwl paddwq
syn keyword gasOpcode_SSE2		paddd padddb padddw padddl padddq
syn keyword gasOpcode_SSE2		paddq paddqb paddqw paddql paddqq
syn keyword gasOpcode_SSE2		paddsb paddsbb paddsbw paddsbl paddsbq
syn keyword gasOpcode_SSE2		paddsw paddswb paddsww paddswl paddswq
syn keyword gasOpcode_SSE2		paddusb paddusbb paddusbw paddusbl paddusbq
syn keyword gasOpcode_SSE2		paddusw padduswb paddusww padduswl padduswq
syn keyword gasOpcode_SSE2		pand pandb pandw pandl pandq
syn keyword gasOpcode_SSE2		pandn pandnb pandnw pandnl pandnq
syn keyword gasOpcode_SSE2		pavgb pavgbb pavgbw pavgbl pavgbq
syn keyword gasOpcode_SSE2		pavgw pavgwb pavgww pavgwl pavgwq
syn keyword gasOpcode_SSE2		pcmpeqb pcmpeqbb pcmpeqbw pcmpeqbl pcmpeqbq
syn keyword gasOpcode_SSE2		pcmpeqw pcmpeqwb pcmpeqww pcmpeqwl pcmpeqwq
syn keyword gasOpcode_SSE2		pcmpeqd pcmpeqdb pcmpeqdw pcmpeqdl pcmpeqdq
syn keyword gasOpcode_SSE2		pcmpgtb pcmpgtbb pcmpgtbw pcmpgtbl pcmpgtbq
syn keyword gasOpcode_SSE2		pcmpgtw pcmpgtwb pcmpgtww pcmpgtwl pcmpgtwq
syn keyword gasOpcode_SSE2		pcmpgtd pcmpgtdb pcmpgtdw pcmpgtdl pcmpgtdq
syn keyword gasOpcode_SSE2		pextrw pextrwb pextrww pextrwl pextrwq
syn keyword gasOpcode_SSE2		pinsrw pinsrwb pinsrww pinsrwl pinsrwq
syn keyword gasOpcode_SSE2		pmaddwd pmaddwdb pmaddwdw pmaddwdl pmaddwdq
syn keyword gasOpcode_SSE2		pmaxsw pmaxswb pmaxsww pmaxswl pmaxswq
syn keyword gasOpcode_SSE2		pmaxub pmaxubb pmaxubw pmaxubl pmaxubq
syn keyword gasOpcode_SSE2		pminsw pminswb pminsww pminswl pminswq
syn keyword gasOpcode_SSE2		pminub pminubb pminubw pminubl pminubq
syn keyword gasOpcode_SSE2		pmovmskb
syn keyword gasOpcode_SSE2		pmulhuw pmulhuwb pmulhuww pmulhuwl pmulhuwq
syn keyword gasOpcode_SSE2		pmulhw pmulhwb pmulhww pmulhwl pmulhwq
syn keyword gasOpcode_SSE2		pmullw pmullwb pmullww pmullwl pmullwq
syn keyword gasOpcode_SSE2		pmuludq pmuludqb pmuludqw pmuludql pmuludqq
syn keyword gasOpcode_SSE2		por porb porw porl porq
syn keyword gasOpcode_SSE2		psadbw psadbwb psadbww psadbwl psadbwq
syn keyword gasOpcode_Base		pshufd pshufdb pshufdw pshufdl pshufdq
syn keyword gasOpcode_Base		pshufhw pshufhwb pshufhww pshufhwl pshufhwq
syn keyword gasOpcode_Base		pshuflw pshuflwb pshuflww pshuflwl pshuflwq
syn keyword gasOpcode_SSE2		pslldq pslldqb pslldqw pslldql pslldqq
syn keyword gasOpcode_SSE2		psllw psllwb psllww psllwl psllwq
syn keyword gasOpcode_SSE2		pslld pslldb pslldw pslldl pslldq
syn keyword gasOpcode_SSE2		psllq psllqb psllqw psllql psllqq
syn keyword gasOpcode_SSE2		psraw psrawb psraww psrawl psrawq
syn keyword gasOpcode_SSE2		psrad psradb psradw psradl psradq
syn keyword gasOpcode_SSE2		psrldq psrldqb psrldqw psrldql psrldqq
syn keyword gasOpcode_SSE2		psrlw psrlwb psrlww psrlwl psrlwq
syn keyword gasOpcode_SSE2		psrld psrldb psrldw psrldl psrldq
syn keyword gasOpcode_SSE2		psrlq psrlqb psrlqw psrlql psrlqq
syn keyword gasOpcode_SSE2		psubb psubbb psubbw psubbl psubbq
syn keyword gasOpcode_SSE2		psubw psubwb psubww psubwl psubwq
syn keyword gasOpcode_SSE2		psubd psubdb psubdw psubdl psubdq
syn keyword gasOpcode_SSE2		psubq psubqb psubqw psubql psubqq
syn keyword gasOpcode_SSE2		psubsb psubsbb psubsbw psubsbl psubsbq
syn keyword gasOpcode_SSE2		psubsw psubswb psubsww psubswl psubswq
syn keyword gasOpcode_SSE2		psubusb psubusbb psubusbw psubusbl psubusbq
syn keyword gasOpcode_SSE2		psubusw psubuswb psubusww psubuswl psubuswq
syn keyword gasOpcode_SSE2		punpckhbw punpckhbwb punpckhbww punpckhbwl punpckhbwq
syn keyword gasOpcode_SSE2		punpckhwd punpckhwdb punpckhwdw punpckhwdl punpckhwdq
syn keyword gasOpcode_SSE2		punpckhdq punpckhdqb punpckhdqw punpckhdql punpckhdqq
syn keyword gasOpcode_SSE2		punpckhqdq punpckhqdqb punpckhqdqw punpckhqdql punpckhqdqq
syn keyword gasOpcode_SSE2		punpcklbw punpcklbwb punpcklbww punpcklbwl punpcklbwq
syn keyword gasOpcode_SSE2		punpcklwd punpcklwdb punpcklwdw punpcklwdl punpcklwdq
syn keyword gasOpcode_SSE2		punpckldq punpckldqb punpckldqw punpckldql punpckldqq
syn keyword gasOpcode_SSE2		punpcklqdq punpcklqdqb punpcklqdqw punpcklqdql punpcklqdqq
syn keyword gasOpcode_SSE2		pxor pxorb pxorw pxorl pxorq

"-- Section: Nehalem New Instructions (SSE4.2)
syn keyword gasOpcode_X64_SSE42		crc32
syn keyword gasOpcode_SSE42		pcmpestri pcmpestrib pcmpestriw pcmpestril pcmpestriq
syn keyword gasOpcode_SSE42		pcmpestrm pcmpestrmb pcmpestrmw pcmpestrml pcmpestrmq
syn keyword gasOpcode_SSE42		pcmpistri pcmpistrib pcmpistriw pcmpistril pcmpistriq
syn keyword gasOpcode_SSE42		pcmpistrm pcmpistrmb pcmpistrmw pcmpistrml pcmpistrmq
syn keyword gasOpcode_SSE42		pcmpgtq pcmpgtqb pcmpgtqw pcmpgtql pcmpgtqq
syn keyword gasOpcode_NEHALEM_Base	popcnt

"-- Section: Intel new instructions in ???
syn keyword gasOpcode_NEHALEM_Base	movbe movbeb movbew movbel movbeq

"-- Section: AMD XOP, FMA4 and CVT16 instructions (SSE5)
syn keyword gasOpcode_AMD_SSE5		vcvtph2ps vcvtph2psb vcvtph2psw vcvtph2psl vcvtph2psq
syn keyword gasOpcode_AMD_SSE5		vcvtps2ph vcvtps2phb vcvtps2phw vcvtps2phl vcvtps2phq
syn keyword gasOpcode_AMD_SSE5		vfmaddpd vfmaddpdb vfmaddpdw vfmaddpdl vfmaddpdq
syn keyword gasOpcode_AMD_SSE5		vfmaddps vfmaddpsb vfmaddpsw vfmaddpsl vfmaddpsq
syn keyword gasOpcode_AMD_SSE5		vfmaddsd vfmaddsdb vfmaddsdw vfmaddsdl vfmaddsdq
syn keyword gasOpcode_AMD_SSE5		vfmaddss vfmaddssb vfmaddssw vfmaddssl vfmaddssq
syn keyword gasOpcode_AMD_SSE5		vfmaddsubpd vfmaddsubpdb vfmaddsubpdw vfmaddsubpdl vfmaddsubpdq
syn keyword gasOpcode_AMD_SSE5		vfmaddsubps vfmaddsubpsb vfmaddsubpsw vfmaddsubpsl vfmaddsubpsq
syn keyword gasOpcode_AMD_SSE5		vfmsubaddpd vfmsubaddpdb vfmsubaddpdw vfmsubaddpdl vfmsubaddpdq
syn keyword gasOpcode_AMD_SSE5		vfmsubaddps vfmsubaddpsb vfmsubaddpsw vfmsubaddpsl vfmsubaddpsq
syn keyword gasOpcode_AMD_SSE5		vfmsubpd vfmsubpdb vfmsubpdw vfmsubpdl vfmsubpdq
syn keyword gasOpcode_AMD_SSE5		vfmsubps vfmsubpsb vfmsubpsw vfmsubpsl vfmsubpsq
syn keyword gasOpcode_AMD_SSE5		vfmsubsd vfmsubsdb vfmsubsdw vfmsubsdl vfmsubsdq
syn keyword gasOpcode_AMD_SSE5		vfmsubss vfmsubssb vfmsubssw vfmsubssl vfmsubssq
syn keyword gasOpcode_AMD_SSE5		vfnmaddpd vfnmaddpdb vfnmaddpdw vfnmaddpdl vfnmaddpdq
syn keyword gasOpcode_AMD_SSE5		vfnmaddps vfnmaddpsb vfnmaddpsw vfnmaddpsl vfnmaddpsq
syn keyword gasOpcode_AMD_SSE5		vfnmaddsd vfnmaddsdb vfnmaddsdw vfnmaddsdl vfnmaddsdq
syn keyword gasOpcode_AMD_SSE5		vfnmaddss vfnmaddssb vfnmaddssw vfnmaddssl vfnmaddssq
syn keyword gasOpcode_AMD_SSE5		vfnmsubpd vfnmsubpdb vfnmsubpdw vfnmsubpdl vfnmsubpdq
syn keyword gasOpcode_AMD_SSE5		vfnmsubps vfnmsubpsb vfnmsubpsw vfnmsubpsl vfnmsubpsq
syn keyword gasOpcode_AMD_SSE5		vfnmsubsd vfnmsubsdb vfnmsubsdw vfnmsubsdl vfnmsubsdq
syn keyword gasOpcode_AMD_SSE5		vfnmsubss vfnmsubssb vfnmsubssw vfnmsubssl vfnmsubssq
syn keyword gasOpcode_AMD_SSE5		vfrczpd vfrczpdb vfrczpdw vfrczpdl vfrczpdq
syn keyword gasOpcode_AMD_SSE5		vfrczps vfrczpsb vfrczpsw vfrczpsl vfrczpsq
syn keyword gasOpcode_AMD_SSE5		vfrczsd vfrczsdb vfrczsdw vfrczsdl vfrczsdq
syn keyword gasOpcode_AMD_SSE5		vfrczss vfrczssb vfrczssw vfrczssl vfrczssq
syn keyword gasOpcode_AMD_SSE5		vpcmov vpcmovb vpcmovw vpcmovl vpcmovq
syn keyword gasOpcode_AMD_SSE5		vpcomb vpcombb vpcombw vpcombl vpcombq
syn keyword gasOpcode_AMD_SSE5		vpcomd vpcomdb vpcomdw vpcomdl vpcomdq
syn keyword gasOpcode_AMD_SSE5		vpcomq vpcomqb vpcomqw vpcomql vpcomqq
syn keyword gasOpcode_AMD_SSE5		vpcomub vpcomubb vpcomubw vpcomubl vpcomubq
syn keyword gasOpcode_AMD_SSE5		vpcomud vpcomudb vpcomudw vpcomudl vpcomudq
syn keyword gasOpcode_AMD_SSE5		vpcomuq vpcomuqb vpcomuqw vpcomuql vpcomuqq
syn keyword gasOpcode_AMD_SSE5		vpcomuw vpcomuwb vpcomuww vpcomuwl vpcomuwq
syn keyword gasOpcode_AMD_SSE5		vpcomw vpcomwb vpcomww vpcomwl vpcomwq
syn keyword gasOpcode_AMD_SSE5		vphaddbd vphaddbdb vphaddbdw vphaddbdl vphaddbdq
syn keyword gasOpcode_AMD_SSE5		vphaddbq vphaddbqb vphaddbqw vphaddbql vphaddbqq
syn keyword gasOpcode_AMD_SSE5		vphaddbw vphaddbwb vphaddbww vphaddbwl vphaddbwq
syn keyword gasOpcode_AMD_SSE5		vphadddq vphadddqb vphadddqw vphadddql vphadddqq
syn keyword gasOpcode_AMD_SSE5		vphaddubd vphaddubdb vphaddubdw vphaddubdl vphaddubdq
syn keyword gasOpcode_AMD_SSE5		vphaddubq vphaddubqb vphaddubqw vphaddubql vphaddubqq
syn keyword gasOpcode_AMD_SSE5		vphaddubwd vphaddubwdb vphaddubwdw vphaddubwdl vphaddubwdq
syn keyword gasOpcode_AMD_SSE5		vphaddudq vphaddudqb vphaddudqw vphaddudql vphaddudqq
syn keyword gasOpcode_AMD_SSE5		vphadduwd vphadduwdb vphadduwdw vphadduwdl vphadduwdq
syn keyword gasOpcode_AMD_SSE5		vphadduwq vphadduwqb vphadduwqw vphadduwql vphadduwqq
syn keyword gasOpcode_AMD_SSE5		vphaddwd vphaddwdb vphaddwdw vphaddwdl vphaddwdq
syn keyword gasOpcode_AMD_SSE5		vphaddwq vphaddwqb vphaddwqw vphaddwql vphaddwqq
syn keyword gasOpcode_AMD_SSE5		vphsubbw vphsubbwb vphsubbww vphsubbwl vphsubbwq
syn keyword gasOpcode_AMD_SSE5		vphsubdq vphsubdqb vphsubdqw vphsubdql vphsubdqq
syn keyword gasOpcode_AMD_SSE5		vphsubwd vphsubwdb vphsubwdw vphsubwdl vphsubwdq
syn keyword gasOpcode_AMD_SSE5		vpmacsdd vpmacsddb vpmacsddw vpmacsddl vpmacsddq
syn keyword gasOpcode_AMD_SSE5		vpmacsdqh vpmacsdqhb vpmacsdqhw vpmacsdqhl vpmacsdqhq
syn keyword gasOpcode_AMD_SSE5		vpmacsdql vpmacsdqlb vpmacsdqlw vpmacsdqll vpmacsdqlq
syn keyword gasOpcode_AMD_SSE5		vpmacssdd vpmacssddb vpmacssddw vpmacssddl vpmacssddq
syn keyword gasOpcode_AMD_SSE5		vpmacssdqh vpmacssdqhb vpmacssdqhw vpmacssdqhl vpmacssdqhq
syn keyword gasOpcode_AMD_SSE5		vpmacssdql vpmacssdqlb vpmacssdqlw vpmacssdqll vpmacssdqlq
syn keyword gasOpcode_AMD_SSE5		vpmacsswd vpmacsswdb vpmacsswdw vpmacsswdl vpmacsswdq
syn keyword gasOpcode_AMD_SSE5		vpmacssww vpmacsswwb vpmacsswww vpmacsswwl vpmacsswwq
syn keyword gasOpcode_AMD_SSE5		vpmacswd vpmacswdb vpmacswdw vpmacswdl vpmacswdq
syn keyword gasOpcode_AMD_SSE5		vpmacsww vpmacswwb vpmacswww vpmacswwl vpmacswwq
syn keyword gasOpcode_AMD_SSE5		vpmadcsswd vpmadcsswdb vpmadcsswdw vpmadcsswdl vpmadcsswdq
syn keyword gasOpcode_AMD_SSE5		vpmadcswd vpmadcswdb vpmadcswdw vpmadcswdl vpmadcswdq
syn keyword gasOpcode_AMD_SSE5		vpperm vppermb vppermw vpperml vppermq
syn keyword gasOpcode_AMD_SSE5		vprotb vprotbb vprotbw vprotbl vprotbq
syn keyword gasOpcode_AMD_SSE5		vprotd vprotdb vprotdw vprotdl vprotdq
syn keyword gasOpcode_AMD_SSE5		vprotq vprotqb vprotqw vprotql vprotqq
syn keyword gasOpcode_AMD_SSE5		vprotw vprotwb vprotww vprotwl vprotwq
syn keyword gasOpcode_AMD_SSE5		vpshab vpshabb vpshabw vpshabl vpshabq
syn keyword gasOpcode_AMD_SSE5		vpshad vpshadb vpshadw vpshadl vpshadq
syn keyword gasOpcode_AMD_SSE5		vpshaq vpshaqb vpshaqw vpshaql vpshaqq
syn keyword gasOpcode_AMD_SSE5		vpshaw vpshawb vpshaww vpshawl vpshawq
syn keyword gasOpcode_AMD_SSE5		vpshlb vpshlbb vpshlbw vpshlbl vpshlbq
syn keyword gasOpcode_AMD_SSE5		vpshld vpshldb vpshldw vpshldl vpshldq
syn keyword gasOpcode_AMD_SSE5		vpshlq vpshlqb vpshlqw vpshlql vpshlqq
syn keyword gasOpcode_AMD_SSE5		vpshlw vpshlwb vpshlww vpshlwl vpshlwq

"-- Section: Generic memory operations
syn keyword gasOpcode_KATMAI_Base	prefetchnta prefetchntab prefetchntaw prefetchntal prefetchntaq
syn keyword gasOpcode_KATMAI_Base	prefetcht0 prefetcht0b prefetcht0w prefetcht0l prefetcht0q
syn keyword gasOpcode_KATMAI_Base	prefetcht1 prefetcht1b prefetcht1w prefetcht1l prefetcht1q
syn keyword gasOpcode_KATMAI_Base	prefetcht2 prefetcht2b prefetcht2w prefetcht2l prefetcht2q
syn keyword gasOpcode_KATMAI_Base	sfence

"-- Section: Tejas New Instructions (SSSE3)
syn keyword gasOpcode_Base		pabsb pabsbb pabsbw pabsbl pabsbq
syn keyword gasOpcode_Base		pabsw pabswb pabsww pabswl pabswq
syn keyword gasOpcode_Base		pabsd pabsdb pabsdw pabsdl pabsdq
syn keyword gasOpcode_Base		palignr palignrb palignrw palignrl palignrq
syn keyword gasOpcode_Base		phaddw phaddwb phaddww phaddwl phaddwq
syn keyword gasOpcode_Base		phaddd phadddb phadddw phadddl phadddq
syn keyword gasOpcode_Base		phaddsw phaddswb phaddsww phaddswl phaddswq
syn keyword gasOpcode_Base		phsubw phsubwb phsubww phsubwl phsubwq
syn keyword gasOpcode_Base		phsubd phsubdb phsubdw phsubdl phsubdq
syn keyword gasOpcode_Base		phsubsw phsubswb phsubsww phsubswl phsubswq
syn keyword gasOpcode_Base		pmaddubsw pmaddubswb pmaddubsww pmaddubswl pmaddubswq
syn keyword gasOpcode_Base		pmulhrsw pmulhrswb pmulhrsww pmulhrswl pmulhrswq
syn keyword gasOpcode_Base		pshufb pshufbb pshufbw pshufbl pshufbq
syn keyword gasOpcode_Base		psignb psignbb psignbw psignbl psignbq
syn keyword gasOpcode_Base		psignw psignwb psignww psignwl psignwq
syn keyword gasOpcode_Base		psignd psigndb psigndw psigndl psigndq

"-- Section: Intel Fused Multiply-Add instructions (FMA)
syn keyword gasOpcode_FUTURE_FMA	vfmadd132ps vfmadd132psb vfmadd132psw vfmadd132psl vfmadd132psq
syn keyword gasOpcode_FUTURE_FMA	vfmadd132pd vfmadd132pdb vfmadd132pdw vfmadd132pdl vfmadd132pdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd312ps vfmadd312psb vfmadd312psw vfmadd312psl vfmadd312psq
syn keyword gasOpcode_FUTURE_FMA	vfmadd312pd vfmadd312pdb vfmadd312pdw vfmadd312pdl vfmadd312pdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd213ps vfmadd213psb vfmadd213psw vfmadd213psl vfmadd213psq
syn keyword gasOpcode_FUTURE_FMA	vfmadd213pd vfmadd213pdb vfmadd213pdw vfmadd213pdl vfmadd213pdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd123ps vfmadd123psb vfmadd123psw vfmadd123psl vfmadd123psq
syn keyword gasOpcode_FUTURE_FMA	vfmadd123pd vfmadd123pdb vfmadd123pdw vfmadd123pdl vfmadd123pdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd231ps vfmadd231psb vfmadd231psw vfmadd231psl vfmadd231psq
syn keyword gasOpcode_FUTURE_FMA	vfmadd231pd vfmadd231pdb vfmadd231pdw vfmadd231pdl vfmadd231pdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd321ps vfmadd321psb vfmadd321psw vfmadd321psl vfmadd321psq
syn keyword gasOpcode_FUTURE_FMA	vfmadd321pd vfmadd321pdb vfmadd321pdw vfmadd321pdl vfmadd321pdq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub132ps vfmaddsub132psb vfmaddsub132psw vfmaddsub132psl vfmaddsub132psq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub132pd vfmaddsub132pdb vfmaddsub132pdw vfmaddsub132pdl vfmaddsub132pdq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub312ps vfmaddsub312psb vfmaddsub312psw vfmaddsub312psl vfmaddsub312psq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub312pd vfmaddsub312pdb vfmaddsub312pdw vfmaddsub312pdl vfmaddsub312pdq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub213ps vfmaddsub213psb vfmaddsub213psw vfmaddsub213psl vfmaddsub213psq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub213pd vfmaddsub213pdb vfmaddsub213pdw vfmaddsub213pdl vfmaddsub213pdq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub123ps vfmaddsub123psb vfmaddsub123psw vfmaddsub123psl vfmaddsub123psq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub123pd vfmaddsub123pdb vfmaddsub123pdw vfmaddsub123pdl vfmaddsub123pdq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub231ps vfmaddsub231psb vfmaddsub231psw vfmaddsub231psl vfmaddsub231psq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub231pd vfmaddsub231pdb vfmaddsub231pdw vfmaddsub231pdl vfmaddsub231pdq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub321ps vfmaddsub321psb vfmaddsub321psw vfmaddsub321psl vfmaddsub321psq
syn keyword gasOpcode_FUTURE_FMA	vfmaddsub321pd vfmaddsub321pdb vfmaddsub321pdw vfmaddsub321pdl vfmaddsub321pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub132ps vfmsub132psb vfmsub132psw vfmsub132psl vfmsub132psq
syn keyword gasOpcode_FUTURE_FMA	vfmsub132pd vfmsub132pdb vfmsub132pdw vfmsub132pdl vfmsub132pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub312ps vfmsub312psb vfmsub312psw vfmsub312psl vfmsub312psq
syn keyword gasOpcode_FUTURE_FMA	vfmsub312pd vfmsub312pdb vfmsub312pdw vfmsub312pdl vfmsub312pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub213ps vfmsub213psb vfmsub213psw vfmsub213psl vfmsub213psq
syn keyword gasOpcode_FUTURE_FMA	vfmsub213pd vfmsub213pdb vfmsub213pdw vfmsub213pdl vfmsub213pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub123ps vfmsub123psb vfmsub123psw vfmsub123psl vfmsub123psq
syn keyword gasOpcode_FUTURE_FMA	vfmsub123pd vfmsub123pdb vfmsub123pdw vfmsub123pdl vfmsub123pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub231ps vfmsub231psb vfmsub231psw vfmsub231psl vfmsub231psq
syn keyword gasOpcode_FUTURE_FMA	vfmsub231pd vfmsub231pdb vfmsub231pdw vfmsub231pdl vfmsub231pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub321ps vfmsub321psb vfmsub321psw vfmsub321psl vfmsub321psq
syn keyword gasOpcode_FUTURE_FMA	vfmsub321pd vfmsub321pdb vfmsub321pdw vfmsub321pdl vfmsub321pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd132ps vfmsubadd132psb vfmsubadd132psw vfmsubadd132psl vfmsubadd132psq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd132pd vfmsubadd132pdb vfmsubadd132pdw vfmsubadd132pdl vfmsubadd132pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd312ps vfmsubadd312psb vfmsubadd312psw vfmsubadd312psl vfmsubadd312psq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd312pd vfmsubadd312pdb vfmsubadd312pdw vfmsubadd312pdl vfmsubadd312pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd213ps vfmsubadd213psb vfmsubadd213psw vfmsubadd213psl vfmsubadd213psq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd213pd vfmsubadd213pdb vfmsubadd213pdw vfmsubadd213pdl vfmsubadd213pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd123ps vfmsubadd123psb vfmsubadd123psw vfmsubadd123psl vfmsubadd123psq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd123pd vfmsubadd123pdb vfmsubadd123pdw vfmsubadd123pdl vfmsubadd123pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd231ps vfmsubadd231psb vfmsubadd231psw vfmsubadd231psl vfmsubadd231psq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd231pd vfmsubadd231pdb vfmsubadd231pdw vfmsubadd231pdl vfmsubadd231pdq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd321ps vfmsubadd321psb vfmsubadd321psw vfmsubadd321psl vfmsubadd321psq
syn keyword gasOpcode_FUTURE_FMA	vfmsubadd321pd vfmsubadd321pdb vfmsubadd321pdw vfmsubadd321pdl vfmsubadd321pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd132ps vfnmadd132psb vfnmadd132psw vfnmadd132psl vfnmadd132psq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd132pd vfnmadd132pdb vfnmadd132pdw vfnmadd132pdl vfnmadd132pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd312ps vfnmadd312psb vfnmadd312psw vfnmadd312psl vfnmadd312psq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd312pd vfnmadd312pdb vfnmadd312pdw vfnmadd312pdl vfnmadd312pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd213ps vfnmadd213psb vfnmadd213psw vfnmadd213psl vfnmadd213psq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd213pd vfnmadd213pdb vfnmadd213pdw vfnmadd213pdl vfnmadd213pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd123ps vfnmadd123psb vfnmadd123psw vfnmadd123psl vfnmadd123psq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd123pd vfnmadd123pdb vfnmadd123pdw vfnmadd123pdl vfnmadd123pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd231ps vfnmadd231psb vfnmadd231psw vfnmadd231psl vfnmadd231psq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd231pd vfnmadd231pdb vfnmadd231pdw vfnmadd231pdl vfnmadd231pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd321ps vfnmadd321psb vfnmadd321psw vfnmadd321psl vfnmadd321psq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd321pd vfnmadd321pdb vfnmadd321pdw vfnmadd321pdl vfnmadd321pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub132ps vfnmsub132psb vfnmsub132psw vfnmsub132psl vfnmsub132psq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub132pd vfnmsub132pdb vfnmsub132pdw vfnmsub132pdl vfnmsub132pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub312ps vfnmsub312psb vfnmsub312psw vfnmsub312psl vfnmsub312psq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub312pd vfnmsub312pdb vfnmsub312pdw vfnmsub312pdl vfnmsub312pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub213ps vfnmsub213psb vfnmsub213psw vfnmsub213psl vfnmsub213psq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub213pd vfnmsub213pdb vfnmsub213pdw vfnmsub213pdl vfnmsub213pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub123ps vfnmsub123psb vfnmsub123psw vfnmsub123psl vfnmsub123psq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub123pd vfnmsub123pdb vfnmsub123pdw vfnmsub123pdl vfnmsub123pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub231ps vfnmsub231psb vfnmsub231psw vfnmsub231psl vfnmsub231psq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub231pd vfnmsub231pdb vfnmsub231pdw vfnmsub231pdl vfnmsub231pdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub321ps vfnmsub321psb vfnmsub321psw vfnmsub321psl vfnmsub321psq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub321pd vfnmsub321pdb vfnmsub321pdw vfnmsub321pdl vfnmsub321pdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd132ss vfmadd132ssb vfmadd132ssw vfmadd132ssl vfmadd132ssq
syn keyword gasOpcode_FUTURE_FMA	vfmadd132sd vfmadd132sdb vfmadd132sdw vfmadd132sdl vfmadd132sdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd312ss vfmadd312ssb vfmadd312ssw vfmadd312ssl vfmadd312ssq
syn keyword gasOpcode_FUTURE_FMA	vfmadd312sd vfmadd312sdb vfmadd312sdw vfmadd312sdl vfmadd312sdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd213ss vfmadd213ssb vfmadd213ssw vfmadd213ssl vfmadd213ssq
syn keyword gasOpcode_FUTURE_FMA	vfmadd213sd vfmadd213sdb vfmadd213sdw vfmadd213sdl vfmadd213sdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd123ss vfmadd123ssb vfmadd123ssw vfmadd123ssl vfmadd123ssq
syn keyword gasOpcode_FUTURE_FMA	vfmadd123sd vfmadd123sdb vfmadd123sdw vfmadd123sdl vfmadd123sdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd231ss vfmadd231ssb vfmadd231ssw vfmadd231ssl vfmadd231ssq
syn keyword gasOpcode_FUTURE_FMA	vfmadd231sd vfmadd231sdb vfmadd231sdw vfmadd231sdl vfmadd231sdq
syn keyword gasOpcode_FUTURE_FMA	vfmadd321ss vfmadd321ssb vfmadd321ssw vfmadd321ssl vfmadd321ssq
syn keyword gasOpcode_FUTURE_FMA	vfmadd321sd vfmadd321sdb vfmadd321sdw vfmadd321sdl vfmadd321sdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub132ss vfmsub132ssb vfmsub132ssw vfmsub132ssl vfmsub132ssq
syn keyword gasOpcode_FUTURE_FMA	vfmsub132sd vfmsub132sdb vfmsub132sdw vfmsub132sdl vfmsub132sdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub312ss vfmsub312ssb vfmsub312ssw vfmsub312ssl vfmsub312ssq
syn keyword gasOpcode_FUTURE_FMA	vfmsub312sd vfmsub312sdb vfmsub312sdw vfmsub312sdl vfmsub312sdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub213ss vfmsub213ssb vfmsub213ssw vfmsub213ssl vfmsub213ssq
syn keyword gasOpcode_FUTURE_FMA	vfmsub213sd vfmsub213sdb vfmsub213sdw vfmsub213sdl vfmsub213sdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub123ss vfmsub123ssb vfmsub123ssw vfmsub123ssl vfmsub123ssq
syn keyword gasOpcode_FUTURE_FMA	vfmsub123sd vfmsub123sdb vfmsub123sdw vfmsub123sdl vfmsub123sdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub231ss vfmsub231ssb vfmsub231ssw vfmsub231ssl vfmsub231ssq
syn keyword gasOpcode_FUTURE_FMA	vfmsub231sd vfmsub231sdb vfmsub231sdw vfmsub231sdl vfmsub231sdq
syn keyword gasOpcode_FUTURE_FMA	vfmsub321ss vfmsub321ssb vfmsub321ssw vfmsub321ssl vfmsub321ssq
syn keyword gasOpcode_FUTURE_FMA	vfmsub321sd vfmsub321sdb vfmsub321sdw vfmsub321sdl vfmsub321sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd132ss vfnmadd132ssb vfnmadd132ssw vfnmadd132ssl vfnmadd132ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd132sd vfnmadd132sdb vfnmadd132sdw vfnmadd132sdl vfnmadd132sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd312ss vfnmadd312ssb vfnmadd312ssw vfnmadd312ssl vfnmadd312ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd312sd vfnmadd312sdb vfnmadd312sdw vfnmadd312sdl vfnmadd312sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd213ss vfnmadd213ssb vfnmadd213ssw vfnmadd213ssl vfnmadd213ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd213sd vfnmadd213sdb vfnmadd213sdw vfnmadd213sdl vfnmadd213sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd123ss vfnmadd123ssb vfnmadd123ssw vfnmadd123ssl vfnmadd123ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd123sd vfnmadd123sdb vfnmadd123sdw vfnmadd123sdl vfnmadd123sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd231ss vfnmadd231ssb vfnmadd231ssw vfnmadd231ssl vfnmadd231ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd231sd vfnmadd231sdb vfnmadd231sdw vfnmadd231sdl vfnmadd231sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd321ss vfnmadd321ssb vfnmadd321ssw vfnmadd321ssl vfnmadd321ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmadd321sd vfnmadd321sdb vfnmadd321sdw vfnmadd321sdl vfnmadd321sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub132ss vfnmsub132ssb vfnmsub132ssw vfnmsub132ssl vfnmsub132ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub132sd vfnmsub132sdb vfnmsub132sdw vfnmsub132sdl vfnmsub132sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub312ss vfnmsub312ssb vfnmsub312ssw vfnmsub312ssl vfnmsub312ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub312sd vfnmsub312sdb vfnmsub312sdw vfnmsub312sdl vfnmsub312sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub213ss vfnmsub213ssb vfnmsub213ssw vfnmsub213ssl vfnmsub213ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub213sd vfnmsub213sdb vfnmsub213sdw vfnmsub213sdl vfnmsub213sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub123ss vfnmsub123ssb vfnmsub123ssw vfnmsub123ssl vfnmsub123ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub123sd vfnmsub123sdb vfnmsub123sdw vfnmsub123sdl vfnmsub123sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub231ss vfnmsub231ssb vfnmsub231ssw vfnmsub231ssl vfnmsub231ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub231sd vfnmsub231sdb vfnmsub231sdw vfnmsub231sdl vfnmsub231sdq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub321ss vfnmsub321ssb vfnmsub321ssw vfnmsub321ssl vfnmsub321ssq
syn keyword gasOpcode_FUTURE_FMA	vfnmsub321sd vfnmsub321sdb vfnmsub321sdw vfnmsub321sdl vfnmsub321sdq

"-- Section: Willamette SSE2 Cacheability Instructions
syn keyword gasOpcode_SSE2		maskmovdqu
syn keyword gasOpcode_SSE2		clflush clflushb clflushw clflushl clflushq
syn keyword gasOpcode_SSE2		movntdq movntdqb movntdqw movntdql movntdqq
syn keyword gasOpcode_X64_Base		movnti movntib movntiw movntil movntiq
syn keyword gasOpcode_SSE2		movntpd movntpdb movntpdw movntpdl movntpdq
syn keyword gasOpcode_SSE2		lfence
syn keyword gasOpcode_SSE2		mfence

"-- Section: Systematic names for the hinting nop instructions
syn keyword gasOpcode_X64_Base		hint_nop0
syn keyword gasOpcode_X64_Base		hint_nop1
syn keyword gasOpcode_X64_Base		hint_nop2
syn keyword gasOpcode_X64_Base		hint_nop3
syn keyword gasOpcode_X64_Base		hint_nop4
syn keyword gasOpcode_X64_Base		hint_nop5
syn keyword gasOpcode_X64_Base		hint_nop6
syn keyword gasOpcode_X64_Base		hint_nop7
syn keyword gasOpcode_X64_Base		hint_nop8
syn keyword gasOpcode_X64_Base		hint_nop9
syn keyword gasOpcode_X64_Base		hint_nop10
syn keyword gasOpcode_X64_Base		hint_nop11
syn keyword gasOpcode_X64_Base		hint_nop12
syn keyword gasOpcode_X64_Base		hint_nop13
syn keyword gasOpcode_X64_Base		hint_nop14
syn keyword gasOpcode_X64_Base		hint_nop15
syn keyword gasOpcode_X64_Base		hint_nop16
syn keyword gasOpcode_X64_Base		hint_nop17
syn keyword gasOpcode_X64_Base		hint_nop18
syn keyword gasOpcode_X64_Base		hint_nop19
syn keyword gasOpcode_X64_Base		hint_nop20
syn keyword gasOpcode_X64_Base		hint_nop21
syn keyword gasOpcode_X64_Base		hint_nop22
syn keyword gasOpcode_X64_Base		hint_nop23
syn keyword gasOpcode_X64_Base		hint_nop24
syn keyword gasOpcode_X64_Base		hint_nop25
syn keyword gasOpcode_X64_Base		hint_nop26
syn keyword gasOpcode_X64_Base		hint_nop27
syn keyword gasOpcode_X64_Base		hint_nop28
syn keyword gasOpcode_X64_Base		hint_nop29
syn keyword gasOpcode_X64_Base		hint_nop30
syn keyword gasOpcode_X64_Base		hint_nop31
syn keyword gasOpcode_X64_Base		hint_nop32
syn keyword gasOpcode_X64_Base		hint_nop33
syn keyword gasOpcode_X64_Base		hint_nop34
syn keyword gasOpcode_X64_Base		hint_nop35
syn keyword gasOpcode_X64_Base		hint_nop36
syn keyword gasOpcode_X64_Base		hint_nop37
syn keyword gasOpcode_X64_Base		hint_nop38
syn keyword gasOpcode_X64_Base		hint_nop39
syn keyword gasOpcode_X64_Base		hint_nop40
syn keyword gasOpcode_X64_Base		hint_nop41
syn keyword gasOpcode_X64_Base		hint_nop42
syn keyword gasOpcode_X64_Base		hint_nop43
syn keyword gasOpcode_X64_Base		hint_nop44
syn keyword gasOpcode_X64_Base		hint_nop45
syn keyword gasOpcode_X64_Base		hint_nop46
syn keyword gasOpcode_X64_Base		hint_nop47
syn keyword gasOpcode_X64_Base		hint_nop48
syn keyword gasOpcode_X64_Base		hint_nop49
syn keyword gasOpcode_X64_Base		hint_nop50
syn keyword gasOpcode_X64_Base		hint_nop51
syn keyword gasOpcode_X64_Base		hint_nop52
syn keyword gasOpcode_X64_Base		hint_nop53
syn keyword gasOpcode_X64_Base		hint_nop54
syn keyword gasOpcode_X64_Base		hint_nop55
syn keyword gasOpcode_X64_Base		hint_nop56
syn keyword gasOpcode_X64_Base		hint_nop57
syn keyword gasOpcode_X64_Base		hint_nop58
syn keyword gasOpcode_X64_Base		hint_nop59
syn keyword gasOpcode_X64_Base		hint_nop60
syn keyword gasOpcode_X64_Base		hint_nop61
syn keyword gasOpcode_X64_Base		hint_nop62

"-- Section: Geode (Cyrix) 3DNow! additions
syn keyword gasOpcode_PENT_3DNOW	pfrcpv pfrcpvb pfrcpvw pfrcpvl pfrcpvq
syn keyword gasOpcode_PENT_3DNOW	pfrsqrtv pfrsqrtvb pfrsqrtvw pfrsqrtvl pfrsqrtvq

"-- Section: XSAVE group (AVX and extended state)
syn keyword gasOpcode_NEHALEM_Base	xgetbv
syn keyword gasOpcode_NEHALEM_Base	xsetbv
syn keyword gasOpcode_NEHALEM_Base	xsave xsaveb xsavew xsavel xsaveq
syn keyword gasOpcode_NEHALEM_Base	xrstor xrstorb xrstorw xrstorl xrstorq

"-- Section: Conventional instructions
syn keyword gasOpcode_8086_Base		aaa
syn keyword gasOpcode_8086_Base		aad aadb aadw aadl aadq
syn keyword gasOpcode_8086_Base		aam aamb aamw aaml aamq
syn keyword gasOpcode_8086_Base		aas
syn keyword gasOpcode_386_Base		adc adcb adcw adcl adcq
syn keyword gasOpcode_386_Base		add addb addw addl addq
syn keyword gasOpcode_386_Base		and andb andw andl andq
syn keyword gasOpcode_286_Base		arpl
syn keyword gasOpcode_PENT_Base		bb0_reset
syn keyword gasOpcode_PENT_Base		bb1_reset
syn keyword gasOpcode_386_Base		bound boundb boundw boundl boundq
syn keyword gasOpcode_X64_Base		bsf
syn keyword gasOpcode_X64_Base		bsr
syn keyword gasOpcode_X64_Base		bswap
syn keyword gasOpcode_X64_Base		bt btb btw btl btq
syn keyword gasOpcode_X64_Base		btc btcb btcw btcl btcq
syn keyword gasOpcode_X64_Base		btr btrb btrw btrl btrq
syn keyword gasOpcode_X64_Base		bts btsb btsw btsl btsq
syn keyword gasOpcode_X64_Base		call callb callw calll callq
syn keyword gasOpcode_8086_Base		cbw
syn keyword gasOpcode_386_Base		cdq
syn keyword gasOpcode_X64_Base		cdqe
syn keyword gasOpcode_8086_Base		clc
syn keyword gasOpcode_8086_Base		cld
syn keyword gasOpcode_X64_Base		clgi
syn keyword gasOpcode_8086_Base		cli
syn keyword gasOpcode_286_Base		clts
syn keyword gasOpcode_8086_Base		cmc
syn keyword gasOpcode_386_Base		cmp cmpb cmpw cmpl cmpq
syn keyword gasOpcode_8086_Base		cmpsb
syn keyword gasOpcode_386_Base		cmpsd
syn keyword gasOpcode_X64_Base		cmpsq
syn keyword gasOpcode_8086_Base		cmpsw
syn keyword gasOpcode_X64_Base		cmpxchg
syn keyword gasOpcode_486_Base		cmpxchg486
syn keyword gasOpcode_PENT_Base		cmpxchg8b cmpxchg8bb cmpxchg8bw cmpxchg8bl cmpxchg8bq
syn keyword gasOpcode_X64_Base		cmpxchg16b cmpxchg16bb cmpxchg16bw cmpxchg16bl cmpxchg16bq
syn keyword gasOpcode_PENT_Base		cpuid
syn keyword gasOpcode_PENT_Base		cpu_read
syn keyword gasOpcode_PENT_Base		cpu_write
syn keyword gasOpcode_X64_Base		cqo
syn keyword gasOpcode_8086_Base		cwd
syn keyword gasOpcode_386_Base		cwde
syn keyword gasOpcode_8086_Base		daa
syn keyword gasOpcode_8086_Base		das
syn keyword gasOpcode_X64_Base		dec
syn keyword gasOpcode_X64_Base		div
syn keyword gasOpcode_P6_Base		dmint
syn keyword gasOpcode_PENT_MMX		emms
syn keyword gasOpcode_186_Base		enter enterb enterw enterl enterq
syn keyword gasOpcode_8086_Base		equ
syn keyword gasOpcode_8086_Base		f2xm1
syn keyword gasOpcode_8086_Base		fabs
syn keyword gasOpcode_8086_Base		fadd
syn keyword gasOpcode_8086_Base		faddp
syn keyword gasOpcode_8086_Base		fbld fbldb fbldw fbldl fbldq
syn keyword gasOpcode_8086_Base		fbstp fbstpb fbstpw fbstpl fbstpq
syn keyword gasOpcode_8086_Base		fchs
syn keyword gasOpcode_8086_Base		fclex
syn keyword gasOpcode_P6_Base		fcmovb
syn keyword gasOpcode_P6_Base		fcmovbe
syn keyword gasOpcode_P6_Base		fcmove
syn keyword gasOpcode_P6_Base		fcmovnb
syn keyword gasOpcode_P6_Base		fcmovnbe
syn keyword gasOpcode_P6_Base		fcmovne
syn keyword gasOpcode_P6_Base		fcmovnu
syn keyword gasOpcode_P6_Base		fcmovu
syn keyword gasOpcode_8086_Base		fcom
syn keyword gasOpcode_P6_Base		fcomi
syn keyword gasOpcode_P6_Base		fcomip
syn keyword gasOpcode_8086_Base		fcomp
syn keyword gasOpcode_8086_Base		fcompp
syn keyword gasOpcode_386_Base		fcos
syn keyword gasOpcode_8086_Base		fdecstp
syn keyword gasOpcode_8086_Base		fdisi
syn keyword gasOpcode_8086_Base		fdiv
syn keyword gasOpcode_8086_Base		fdivp
syn keyword gasOpcode_8086_Base		fdivr
syn keyword gasOpcode_8086_Base		fdivrp
syn keyword gasOpcode_PENT_3DNOW	femms
syn keyword gasOpcode_8086_Base		feni
syn keyword gasOpcode_8086_Base		ffree
syn keyword gasOpcode_286_Base		ffreep
syn keyword gasOpcode_8086_Base		fiadd fiaddb fiaddw fiaddl fiaddq
syn keyword gasOpcode_8086_Base		ficom ficomb ficomw ficoml ficomq
syn keyword gasOpcode_8086_Base		ficomp ficompb ficompw ficompl ficompq
syn keyword gasOpcode_8086_Base		fidiv fidivb fidivw fidivl fidivq
syn keyword gasOpcode_8086_Base		fidivr fidivrb fidivrw fidivrl fidivrq
syn keyword gasOpcode_8086_Base		fild fildb fildw fildl fildq
syn keyword gasOpcode_8086_Base		fimul fimulb fimulw fimull fimulq
syn keyword gasOpcode_8086_Base		fincstp
syn keyword gasOpcode_8086_Base		finit
syn keyword gasOpcode_8086_Base		fist fistb fistw fistl fistq
syn keyword gasOpcode_8086_Base		fistp fistpb fistpw fistpl fistpq
syn keyword gasOpcode_PRESCOTT_Base	fisttp fisttpb fisttpw fisttpl fisttpq
syn keyword gasOpcode_8086_Base		fisub fisubb fisubw fisubl fisubq
syn keyword gasOpcode_8086_Base		fisubr fisubrb fisubrw fisubrl fisubrq
syn keyword gasOpcode_8086_Base		fld
syn keyword gasOpcode_8086_Base		fld1
syn keyword gasOpcode_8086_Base		fldcw fldcwb fldcww fldcwl fldcwq
syn keyword gasOpcode_8086_Base		fldenv fldenvb fldenvw fldenvl fldenvq
syn keyword gasOpcode_8086_Base		fldl2e
syn keyword gasOpcode_8086_Base		fldl2t
syn keyword gasOpcode_8086_Base		fldlg2
syn keyword gasOpcode_8086_Base		fldln2
syn keyword gasOpcode_8086_Base		fldpi
syn keyword gasOpcode_8086_Base		fldz
syn keyword gasOpcode_8086_Base		fmul
syn keyword gasOpcode_8086_Base		fmulp
syn keyword gasOpcode_8086_Base		fnclex
syn keyword gasOpcode_8086_Base		fndisi
syn keyword gasOpcode_8086_Base		fneni
syn keyword gasOpcode_8086_Base		fninit
syn keyword gasOpcode_8086_Base		fnop
syn keyword gasOpcode_8086_Base		fnsave fnsaveb fnsavew fnsavel fnsaveq
syn keyword gasOpcode_8086_Base		fnstcw fnstcwb fnstcww fnstcwl fnstcwq
syn keyword gasOpcode_8086_Base		fnstenv fnstenvb fnstenvw fnstenvl fnstenvq
syn keyword gasOpcode_286_Base		fnstsw
syn keyword gasOpcode_8086_Base		fpatan
syn keyword gasOpcode_8086_Base		fprem
syn keyword gasOpcode_386_Base		fprem1
syn keyword gasOpcode_8086_Base		fptan
syn keyword gasOpcode_8086_Base		frndint
syn keyword gasOpcode_8086_Base		frstor frstorb frstorw frstorl frstorq
syn keyword gasOpcode_8086_Base		fsave fsaveb fsavew fsavel fsaveq
syn keyword gasOpcode_8086_Base		fscale
syn keyword gasOpcode_286_Base		fsetpm
syn keyword gasOpcode_386_Base		fsin
syn keyword gasOpcode_386_Base		fsincos
syn keyword gasOpcode_8086_Base		fsqrt
syn keyword gasOpcode_8086_Base		fst
syn keyword gasOpcode_8086_Base		fstcw fstcwb fstcww fstcwl fstcwq
syn keyword gasOpcode_8086_Base		fstenv fstenvb fstenvw fstenvl fstenvq
syn keyword gasOpcode_8086_Base		fstp
syn keyword gasOpcode_286_Base		fstsw
syn keyword gasOpcode_8086_Base		fsub
syn keyword gasOpcode_8086_Base		fsubp
syn keyword gasOpcode_8086_Base		fsubr
syn keyword gasOpcode_8086_Base		fsubrp
syn keyword gasOpcode_8086_Base		ftst
syn keyword gasOpcode_386_Base		fucom
syn keyword gasOpcode_P6_Base		fucomi
syn keyword gasOpcode_P6_Base		fucomip
syn keyword gasOpcode_386_Base		fucomp
syn keyword gasOpcode_386_Base		fucompp
syn keyword gasOpcode_8086_Base		fxam
syn keyword gasOpcode_8086_Base		fxch
syn keyword gasOpcode_8086_Base		fxtract
syn keyword gasOpcode_8086_Base		fyl2x
syn keyword gasOpcode_8086_Base		fyl2xp1
syn keyword gasOpcode_8086_Base		hlt
syn keyword gasOpcode_386_Base		ibts
syn keyword gasOpcode_386_Base		icebp
syn keyword gasOpcode_X64_Base		idiv
syn keyword gasOpcode_X64_Base		imul imulb imulw imull imulq
syn keyword gasOpcode_386_Base		in
syn keyword gasOpcode_X64_Base		inc incb incw incl incq
syn keyword gasOpcode_Base		incbin
syn keyword gasOpcode_186_Base		insb
syn keyword gasOpcode_386_Base		insd
syn keyword gasOpcode_186_Base		insw
syn keyword gasOpcode_8086_Base		int intb intw intl intq
syn keyword gasOpcode_386_Base		int01
syn keyword gasOpcode_386_Base		int1
syn keyword gasOpcode_8086_Base		int03
syn keyword gasOpcode_8086_Base		int3
syn keyword gasOpcode_8086_Base		into
syn keyword gasOpcode_486_Base		invd
syn keyword gasOpcode_486_Base		invlpg invlpgb invlpgw invlpgl invlpgq
syn keyword gasOpcode_X86_64_Base	invlpga
syn keyword gasOpcode_8086_Base		iret
syn keyword gasOpcode_386_Base		iretd
syn keyword gasOpcode_X64_Base		iretq
syn keyword gasOpcode_8086_Base		iretw
syn keyword gasOpcode_8086_Base		jcxz jcxzb jcxzw jcxzl jcxzq
syn keyword gasOpcode_386_Base		jecxz jecxzb jecxzw jecxzl jecxzq
syn keyword gasOpcode_X64_Base		jrcxz jrcxzb jrcxzw jrcxzl jrcxzq
syn keyword gasOpcode_X64_Base		jmp jmpb jmpw jmpl jmpq
syn keyword gasOpcode_IA64_Base		jmpe
syn keyword gasOpcode_8086_Base		lahf
syn keyword gasOpcode_X64_Base		lar
syn keyword gasOpcode_386_Base		lds ldsb ldsw ldsl ldsq
syn keyword gasOpcode_X64_Base		lea leab leaw leal leaq
syn keyword gasOpcode_186_Base		leave
syn keyword gasOpcode_386_Base		les lesb lesw lesl lesq
syn keyword gasOpcode_X64_Base		lfence
syn keyword gasOpcode_386_Base		lfs lfsb lfsw lfsl lfsq
syn keyword gasOpcode_286_Base		lgdt lgdtb lgdtw lgdtl lgdtq
syn keyword gasOpcode_386_Base		lgs lgsb lgsw lgsl lgsq
syn keyword gasOpcode_286_Base		lidt lidtb lidtw lidtl lidtq
syn keyword gasOpcode_286_Base		lldt
syn keyword gasOpcode_286_Base		lmsw
syn keyword gasOpcode_386_Base		loadall
syn keyword gasOpcode_286_Base		loadall286
syn keyword gasOpcode_8086_Base		lodsb
syn keyword gasOpcode_386_Base		lodsd
syn keyword gasOpcode_X64_Base		lodsq
syn keyword gasOpcode_8086_Base		lodsw
syn keyword gasOpcode_X64_Base		loop loopb loopw loopl loopq
syn keyword gasOpcode_X64_Base		loope loopeb loopew loopel loopeq
syn keyword gasOpcode_X64_Base		loopne loopneb loopnew loopnel loopneq
syn keyword gasOpcode_X64_Base		loopnz loopnzb loopnzw loopnzl loopnzq
syn keyword gasOpcode_X64_Base		loopz loopzb loopzw loopzl loopzq
syn keyword gasOpcode_X64_Base		lsl
syn keyword gasOpcode_386_Base		lss lssb lssw lssl lssq
syn keyword gasOpcode_286_Base		ltr
syn keyword gasOpcode_X64_Base		mfence
syn keyword gasOpcode_PRESCOTT_Base	monitor
syn keyword gasOpcode_386_Base		mov movb movw movl movq
syn keyword gasOpcode_X64_SSE		movd
syn keyword gasOpcode_X64_MMX		movq
syn keyword gasOpcode_8086_Base		movsb
syn keyword gasOpcode_386_Base		movsd
syn keyword gasOpcode_X64_Base		movsq
syn keyword gasOpcode_8086_Base		movsw
syn keyword gasOpcode_X64_Base		movsx
syn keyword gasOpcode_X64_Base		movsxd
syn keyword gasOpcode_X64_Base		movsx
syn keyword gasOpcode_X64_Base		movzx
syn keyword gasOpcode_X64_Base		mul
syn keyword gasOpcode_PRESCOTT_Base	mwait
syn keyword gasOpcode_X64_Base		neg
syn keyword gasOpcode_X64_Base		nop
syn keyword gasOpcode_X64_Base		not
syn keyword gasOpcode_386_Base		or orb orw orl orq
syn keyword gasOpcode_386_Base		out
syn keyword gasOpcode_186_Base		outsb
syn keyword gasOpcode_386_Base		outsd
syn keyword gasOpcode_186_Base		outsw
syn keyword gasOpcode_PENT_MMX		packssdw packssdwb packssdww packssdwl packssdwq
syn keyword gasOpcode_PENT_MMX		packsswb packsswbb packsswbw packsswbl packsswbq
syn keyword gasOpcode_PENT_MMX		packuswb packuswbb packuswbw packuswbl packuswbq
syn keyword gasOpcode_PENT_MMX		paddb paddbb paddbw paddbl paddbq
syn keyword gasOpcode_PENT_MMX		paddd padddb padddw padddl padddq
syn keyword gasOpcode_PENT_MMX		paddsb paddsbb paddsbw paddsbl paddsbq
syn keyword gasOpcode_PENT_MMX		paddsiw paddsiwb paddsiww paddsiwl paddsiwq
syn keyword gasOpcode_PENT_MMX		paddsw paddswb paddsww paddswl paddswq
syn keyword gasOpcode_PENT_MMX		paddusb paddusbb paddusbw paddusbl paddusbq
syn keyword gasOpcode_PENT_MMX		paddusw padduswb paddusww padduswl padduswq
syn keyword gasOpcode_PENT_MMX		paddw paddwb paddww paddwl paddwq
syn keyword gasOpcode_PENT_MMX		pand pandb pandw pandl pandq
syn keyword gasOpcode_PENT_MMX		pandn pandnb pandnw pandnl pandnq
syn keyword gasOpcode_8086_Base		pause
syn keyword gasOpcode_PENT_MMX		paveb pavebb pavebw pavebl pavebq
syn keyword gasOpcode_PENT_3DNOW	pavgusb pavgusbb pavgusbw pavgusbl pavgusbq
syn keyword gasOpcode_PENT_MMX		pcmpeqb pcmpeqbb pcmpeqbw pcmpeqbl pcmpeqbq
syn keyword gasOpcode_PENT_MMX		pcmpeqd pcmpeqdb pcmpeqdw pcmpeqdl pcmpeqdq
syn keyword gasOpcode_PENT_MMX		pcmpeqw pcmpeqwb pcmpeqww pcmpeqwl pcmpeqwq
syn keyword gasOpcode_PENT_MMX		pcmpgtb pcmpgtbb pcmpgtbw pcmpgtbl pcmpgtbq
syn keyword gasOpcode_PENT_MMX		pcmpgtd pcmpgtdb pcmpgtdw pcmpgtdl pcmpgtdq
syn keyword gasOpcode_PENT_MMX		pcmpgtw pcmpgtwb pcmpgtww pcmpgtwl pcmpgtwq
syn keyword gasOpcode_PENT_MMX		pdistib pdistibb pdistibw pdistibl pdistibq
syn keyword gasOpcode_PENT_3DNOW	pf2id pf2idb pf2idw pf2idl pf2idq
syn keyword gasOpcode_PENT_3DNOW	pfacc pfaccb pfaccw pfaccl pfaccq
syn keyword gasOpcode_PENT_3DNOW	pfadd pfaddb pfaddw pfaddl pfaddq
syn keyword gasOpcode_PENT_3DNOW	pfcmpeq pfcmpeqb pfcmpeqw pfcmpeql pfcmpeqq
syn keyword gasOpcode_PENT_3DNOW	pfcmpge pfcmpgeb pfcmpgew pfcmpgel pfcmpgeq
syn keyword gasOpcode_PENT_3DNOW	pfcmpgt pfcmpgtb pfcmpgtw pfcmpgtl pfcmpgtq
syn keyword gasOpcode_PENT_3DNOW	pfmax pfmaxb pfmaxw pfmaxl pfmaxq
syn keyword gasOpcode_PENT_3DNOW	pfmin pfminb pfminw pfminl pfminq
syn keyword gasOpcode_PENT_3DNOW	pfmul pfmulb pfmulw pfmull pfmulq
syn keyword gasOpcode_PENT_3DNOW	pfrcp pfrcpb pfrcpw pfrcpl pfrcpq
syn keyword gasOpcode_PENT_3DNOW	pfrcpit1 pfrcpit1b pfrcpit1w pfrcpit1l pfrcpit1q
syn keyword gasOpcode_PENT_3DNOW	pfrcpit2 pfrcpit2b pfrcpit2w pfrcpit2l pfrcpit2q
syn keyword gasOpcode_PENT_3DNOW	pfrsqit1 pfrsqit1b pfrsqit1w pfrsqit1l pfrsqit1q
syn keyword gasOpcode_PENT_3DNOW	pfrsqrt pfrsqrtb pfrsqrtw pfrsqrtl pfrsqrtq
syn keyword gasOpcode_PENT_3DNOW	pfsub pfsubb pfsubw pfsubl pfsubq
syn keyword gasOpcode_PENT_3DNOW	pfsubr pfsubrb pfsubrw pfsubrl pfsubrq
syn keyword gasOpcode_PENT_3DNOW	pi2fd pi2fdb pi2fdw pi2fdl pi2fdq
syn keyword gasOpcode_PENT_MMX		pmachriw pmachriwb pmachriww pmachriwl pmachriwq
syn keyword gasOpcode_PENT_MMX		pmaddwd pmaddwdb pmaddwdw pmaddwdl pmaddwdq
syn keyword gasOpcode_PENT_MMX		pmagw pmagwb pmagww pmagwl pmagwq
syn keyword gasOpcode_PENT_MMX		pmulhriw pmulhriwb pmulhriww pmulhriwl pmulhriwq
syn keyword gasOpcode_PENT_3DNOW	pmulhrwa pmulhrwab pmulhrwaw pmulhrwal pmulhrwaq
syn keyword gasOpcode_PENT_MMX		pmulhrwc pmulhrwcb pmulhrwcw pmulhrwcl pmulhrwcq
syn keyword gasOpcode_PENT_MMX		pmulhw pmulhwb pmulhww pmulhwl pmulhwq
syn keyword gasOpcode_PENT_MMX		pmullw pmullwb pmullww pmullwl pmullwq
syn keyword gasOpcode_PENT_MMX		pmvgezb pmvgezbb pmvgezbw pmvgezbl pmvgezbq
syn keyword gasOpcode_PENT_MMX		pmvlzb pmvlzbb pmvlzbw pmvlzbl pmvlzbq
syn keyword gasOpcode_PENT_MMX		pmvnzb pmvnzbb pmvnzbw pmvnzbl pmvnzbq
syn keyword gasOpcode_PENT_MMX		pmvzb pmvzbb pmvzbw pmvzbl pmvzbq
syn keyword gasOpcode_386_Base		pop
syn keyword gasOpcode_186_Base		popa
syn keyword gasOpcode_386_Base		popad
syn keyword gasOpcode_186_Base		popaw
syn keyword gasOpcode_8086_Base		popf
syn keyword gasOpcode_386_Base		popfd popfl
syn keyword gasOpcode_X64_Base		popfq
syn keyword gasOpcode_8086_Base		popfw
syn keyword gasOpcode_PENT_MMX		por porb porw porl porq
syn keyword gasOpcode_PENT_3DNOW	prefetch prefetchb prefetchw prefetchl prefetchq
syn keyword gasOpcode_PENT_3DNOW	prefetchw prefetchwb prefetchww prefetchwl prefetchwq
syn keyword gasOpcode_PENT_MMX		pslld pslldb pslldw pslldl pslldq
syn keyword gasOpcode_PENT_MMX		psllq psllqb psllqw psllql psllqq
syn keyword gasOpcode_PENT_MMX		psllw psllwb psllww psllwl psllwq
syn keyword gasOpcode_PENT_MMX		psrad psradb psradw psradl psradq
syn keyword gasOpcode_PENT_MMX		psraw psrawb psraww psrawl psrawq
syn keyword gasOpcode_PENT_MMX		psrld psrldb psrldw psrldl psrldq
syn keyword gasOpcode_PENT_MMX		psrlq psrlqb psrlqw psrlql psrlqq
syn keyword gasOpcode_PENT_MMX		psrlw psrlwb psrlww psrlwl psrlwq
syn keyword gasOpcode_PENT_MMX		psubb psubbb psubbw psubbl psubbq
syn keyword gasOpcode_PENT_MMX		psubd psubdb psubdw psubdl psubdq
syn keyword gasOpcode_PENT_MMX		psubsb psubsbb psubsbw psubsbl psubsbq
syn keyword gasOpcode_PENT_MMX		psubsiw psubsiwb psubsiww psubsiwl psubsiwq
syn keyword gasOpcode_PENT_MMX		psubsw psubswb psubsww psubswl psubswq
syn keyword gasOpcode_PENT_MMX		psubusb psubusbb psubusbw psubusbl psubusbq
syn keyword gasOpcode_PENT_MMX		psubusw psubuswb psubusww psubuswl psubuswq
syn keyword gasOpcode_PENT_MMX		psubw psubwb psubww psubwl psubwq
syn keyword gasOpcode_PENT_MMX		punpckhbw punpckhbwb punpckhbww punpckhbwl punpckhbwq
syn keyword gasOpcode_PENT_MMX		punpckhdq punpckhdqb punpckhdqw punpckhdql punpckhdqq
syn keyword gasOpcode_PENT_MMX		punpckhwd punpckhwdb punpckhwdw punpckhwdl punpckhwdq
syn keyword gasOpcode_PENT_MMX		punpcklbw punpcklbwb punpcklbww punpcklbwl punpcklbwq
syn keyword gasOpcode_PENT_MMX		punpckldq punpckldqb punpckldqw punpckldql punpckldqq
syn keyword gasOpcode_PENT_MMX		punpcklwd punpcklwdb punpcklwdw punpcklwdl punpcklwdq
syn keyword gasOpcode_X64_Base		push pushb pushw pushl pushq
syn keyword gasOpcode_186_Base		pusha
syn keyword gasOpcode_386_Base		pushad
syn keyword gasOpcode_186_Base		pushaw
syn keyword gasOpcode_8086_Base		pushf
syn keyword gasOpcode_386_Base		pushfd
syn keyword gasOpcode_X64_Base		pushfq
syn keyword gasOpcode_8086_Base		pushfw
syn keyword gasOpcode_PENT_MMX		pxor pxorb pxorw pxorl pxorq
syn keyword gasOpcode_X64_Base		rcl rclb rclw rcll rclq
syn keyword gasOpcode_X64_Base		rcr rcrb rcrw rcrl rcrq
syn keyword gasOpcode_P6_Base		rdshr
syn keyword gasOpcode_PENT_Base		rdmsr
syn keyword gasOpcode_P6_Base		rdpmc
syn keyword gasOpcode_PENT_Base		rdtsc
syn keyword gasOpcode_X86_64_Base		rdtscp
syn keyword gasOpcode_8086_Base		ret retb retw retl retq
syn keyword gasOpcode_8086_Base		retf retfb retfw retfl retfq
syn keyword gasOpcode_8086_Base		retn retnb retnw retnl retnq
syn keyword gasOpcode_X64_Base		rol rolb rolw roll rolq
syn keyword gasOpcode_X64_Base		ror rorb rorw rorl rorq
syn keyword gasOpcode_P6_Base		rdm
syn keyword gasOpcode_486_Base		rsdc rsdcb rsdcw rsdcl rsdcq
syn keyword gasOpcode_486_Base		rsldt rsldtb rsldtw rsldtl rsldtq
syn keyword gasOpcode_PENTM_Base		rsm
syn keyword gasOpcode_486_Base		rsts rstsb rstsw rstsl rstsq
syn keyword gasOpcode_8086_Base		sahf
syn keyword gasOpcode_X64_Base		sal salb salw sall salq
syn keyword gasOpcode_8086_Base		salc
syn keyword gasOpcode_X64_Base		sar sarb sarw sarl sarq
syn keyword gasOpcode_386_Base		sbb sbbb sbbw sbbl sbbq
syn keyword gasOpcode_8086_Base		scasb
syn keyword gasOpcode_386_Base		scasd
syn keyword gasOpcode_X64_Base		scasq
syn keyword gasOpcode_8086_Base		scasw
syn keyword gasOpcode_X64_Base		sfence
syn keyword gasOpcode_286_Base		sgdt sgdtb sgdtw sgdtl sgdtq
syn keyword gasOpcode_X64_Base		shl shlb shlw shll shlq
syn keyword gasOpcode_X64_Base		shld
syn keyword gasOpcode_X64_Base		shr shrb shrw shrl shrq
syn keyword gasOpcode_X64_Base		shrd
syn keyword gasOpcode_286_Base		sidt sidtb sidtw sidtl sidtq
syn keyword gasOpcode_X64_Base		sldt
syn keyword gasOpcode_X64_Base		skinit
syn keyword gasOpcode_386_Base		smi
syn keyword gasOpcode_P6_Base		smint
syn keyword gasOpcode_486_Base		smintold
syn keyword gasOpcode_386_Base		smsw
syn keyword gasOpcode_8086_Base		stc
syn keyword gasOpcode_8086_Base		std
syn keyword gasOpcode_X64_Base		stgi
syn keyword gasOpcode_8086_Base		sti
syn keyword gasOpcode_8086_Base		stosb
syn keyword gasOpcode_386_Base		stosd stosl
syn keyword gasOpcode_X64_Base		stosq
syn keyword gasOpcode_8086_Base		stosw
syn keyword gasOpcode_X64_Base		str
syn keyword gasOpcode_386_Base		sub subb subw subl subq
syn keyword gasOpcode_486_Base		svdc svdcb svdcw svdcl svdcq
syn keyword gasOpcode_486_Base		svldt svldtb svldtw svldtl svldtq
syn keyword gasOpcode_486_Base		svts svtsb svtsw svtsl svtsq
syn keyword gasOpcode_X64_Base		swapgs
syn keyword gasOpcode_P6_Base		syscall
syn keyword gasOpcode_P6_Base		sysenter
syn keyword gasOpcode_P6_Base		sysexit
syn keyword gasOpcode_P6_Base		sysret
syn keyword gasOpcode_386_Base		test testb testw testl testq
syn keyword gasOpcode_186_Base		ud0
syn keyword gasOpcode_186_Base		ud1
syn keyword gasOpcode_186_Base		ud2b
syn keyword gasOpcode_186_Base		ud2
syn keyword gasOpcode_186_Base		ud2a
syn keyword gasOpcode_386_Base		umov
syn keyword gasOpcode_286_Base		verr
syn keyword gasOpcode_286_Base		verw
syn keyword gasOpcode_8086_Base		fwait
syn keyword gasOpcode_486_Base		wbinvd
syn keyword gasOpcode_P6_Base		wrshr
syn keyword gasOpcode_PENT_Base		wrmsr
syn keyword gasOpcode_X64_Base		xadd
syn keyword gasOpcode_386_Base		xbts
syn keyword gasOpcode_X64_Base		xchg
syn keyword gasOpcode_8086_Base		xlatb
syn keyword gasOpcode_8086_Base		xlat
syn keyword gasOpcode_386_Base		xor xorb xorw xorl xorq
syn keyword gasOpcode_X64_Base		cmovcc
syn match   gasOpcode_8086_Base		/\<j\(e\|ne\|a\|ae\|b\|be\|nbe\|g\|ge\|ng\|nge\|l\|le\|\|z\|nz\|c\|nc\|d\|nd\|o\|no\|p\|np\|s\|ns\)[bwlq]\?\>/
syn match   gasOpcode_386_Base		/\<set\(e\|ne\|a\|ae\|b\|be\|nbe\|g\|ge\|ng\|nge\|l\|le\|\|z\|nz\|c\|nc\|d\|nd\|o\|no\|p\|np\|s\|ns\)[bwlq]\?\>/

"-- Section: VIA (Centaur) security instructions
syn keyword gasOpcode_PENT_Base		xstore
syn keyword gasOpcode_PENT_Base		xcryptecb
syn keyword gasOpcode_PENT_Base		xcryptcbc
syn keyword gasOpcode_PENT_Base		xcryptctr
syn keyword gasOpcode_PENT_Base		xcryptcfb
syn keyword gasOpcode_PENT_Base		xcryptofb
syn keyword gasOpcode_PENT_Base		montmul
syn keyword gasOpcode_PENT_Base		xsha1
syn keyword gasOpcode_PENT_Base		xsha256

"-- Section: Intel AVX Carry-Less Multiplication instructions (CLMUL)
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpclmullqlqdq vpclmullqlqdqb vpclmullqlqdqw vpclmullqlqdql vpclmullqlqdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpclmulhqlqdq vpclmulhqlqdqb vpclmulhqlqdqw vpclmulhqlqdql vpclmulhqlqdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpclmullqhqdq vpclmullqhqdqb vpclmullqhqdqw vpclmullqhqdql vpclmullqhqdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpclmulhqhqdq vpclmulhqhqdqb vpclmulhqhqdqw vpclmulhqhqdql vpclmulhqhqdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpclmulqdq vpclmulqdqb vpclmulqdqw vpclmulqdql vpclmulqdqq

"-- Section: AMD SSE5 instructions
syn keyword gasOpcode_AMD_SSE5		fmaddps fmaddpsb fmaddpsw fmaddpsl fmaddpsq
syn keyword gasOpcode_AMD_SSE5		fmaddpd fmaddpdb fmaddpdw fmaddpdl fmaddpdq
syn keyword gasOpcode_AMD_SSE5		fmaddss fmaddssb fmaddssw fmaddssl fmaddssq
syn keyword gasOpcode_AMD_SSE5		fmaddsd fmaddsdb fmaddsdw fmaddsdl fmaddsdq
syn keyword gasOpcode_AMD_SSE5		fmsubps fmsubpsb fmsubpsw fmsubpsl fmsubpsq
syn keyword gasOpcode_AMD_SSE5		fmsubpd fmsubpdb fmsubpdw fmsubpdl fmsubpdq
syn keyword gasOpcode_AMD_SSE5		fmsubss fmsubssb fmsubssw fmsubssl fmsubssq
syn keyword gasOpcode_AMD_SSE5		fmsubsd fmsubsdb fmsubsdw fmsubsdl fmsubsdq
syn keyword gasOpcode_AMD_SSE5		fnmaddps fnmaddpsb fnmaddpsw fnmaddpsl fnmaddpsq
syn keyword gasOpcode_AMD_SSE5		fnmaddpd fnmaddpdb fnmaddpdw fnmaddpdl fnmaddpdq
syn keyword gasOpcode_AMD_SSE5		fnmaddss fnmaddssb fnmaddssw fnmaddssl fnmaddssq
syn keyword gasOpcode_AMD_SSE5		fnmaddsd fnmaddsdb fnmaddsdw fnmaddsdl fnmaddsdq
syn keyword gasOpcode_AMD_SSE5		fnmsubps fnmsubpsb fnmsubpsw fnmsubpsl fnmsubpsq
syn keyword gasOpcode_AMD_SSE5		fnmsubpd fnmsubpdb fnmsubpdw fnmsubpdl fnmsubpdq
syn keyword gasOpcode_AMD_SSE5		fnmsubss fnmsubssb fnmsubssw fnmsubssl fnmsubssq
syn keyword gasOpcode_AMD_SSE5		fnmsubsd fnmsubsdb fnmsubsdw fnmsubsdl fnmsubsdq
syn keyword gasOpcode_AMD_SSE5		comeqps comeqpsb comeqpsw comeqpsl comeqpsq
syn keyword gasOpcode_AMD_SSE5		comltps comltpsb comltpsw comltpsl comltpsq
syn keyword gasOpcode_AMD_SSE5		comleps comlepsb comlepsw comlepsl comlepsq
syn keyword gasOpcode_AMD_SSE5		comunordps comunordpsb comunordpsw comunordpsl comunordpsq
syn keyword gasOpcode_AMD_SSE5		comuneqps comuneqpsb comuneqpsw comuneqpsl comuneqpsq
syn keyword gasOpcode_AMD_SSE5		comunltps comunltpsb comunltpsw comunltpsl comunltpsq
syn keyword gasOpcode_AMD_SSE5		comunleps comunlepsb comunlepsw comunlepsl comunlepsq
syn keyword gasOpcode_AMD_SSE5		comordps comordpsb comordpsw comordpsl comordpsq
syn keyword gasOpcode_AMD_SSE5		comueqps comueqpsb comueqpsw comueqpsl comueqpsq
syn keyword gasOpcode_AMD_SSE5		comultps comultpsb comultpsw comultpsl comultpsq
syn keyword gasOpcode_AMD_SSE5		comuleps comulepsb comulepsw comulepsl comulepsq
syn keyword gasOpcode_AMD_SSE5		comfalseps comfalsepsb comfalsepsw comfalsepsl comfalsepsq
syn keyword gasOpcode_AMD_SSE5		comneqps comneqpsb comneqpsw comneqpsl comneqpsq
syn keyword gasOpcode_AMD_SSE5		comnltps comnltpsb comnltpsw comnltpsl comnltpsq
syn keyword gasOpcode_AMD_SSE5		comnleps comnlepsb comnlepsw comnlepsl comnlepsq
syn keyword gasOpcode_AMD_SSE5		comtrueps comtruepsb comtruepsw comtruepsl comtruepsq
syn keyword gasOpcode_AMD_SSE5		comps compsb compsw compsl compsq
syn keyword gasOpcode_AMD_SSE5		comeqpd comeqpdb comeqpdw comeqpdl comeqpdq
syn keyword gasOpcode_AMD_SSE5		comltpd comltpdb comltpdw comltpdl comltpdq
syn keyword gasOpcode_AMD_SSE5		comlepd comlepdb comlepdw comlepdl comlepdq
syn keyword gasOpcode_AMD_SSE5		comunordpd comunordpdb comunordpdw comunordpdl comunordpdq
syn keyword gasOpcode_AMD_SSE5		comuneqpd comuneqpdb comuneqpdw comuneqpdl comuneqpdq
syn keyword gasOpcode_AMD_SSE5		comunltpd comunltpdb comunltpdw comunltpdl comunltpdq
syn keyword gasOpcode_AMD_SSE5		comunlepd comunlepdb comunlepdw comunlepdl comunlepdq
syn keyword gasOpcode_AMD_SSE5		comordpd comordpdb comordpdw comordpdl comordpdq
syn keyword gasOpcode_AMD_SSE5		comueqpd comueqpdb comueqpdw comueqpdl comueqpdq
syn keyword gasOpcode_AMD_SSE5		comultpd comultpdb comultpdw comultpdl comultpdq
syn keyword gasOpcode_AMD_SSE5		comulepd comulepdb comulepdw comulepdl comulepdq
syn keyword gasOpcode_AMD_SSE5		comfalsepd comfalsepdb comfalsepdw comfalsepdl comfalsepdq
syn keyword gasOpcode_AMD_SSE5		comneqpd comneqpdb comneqpdw comneqpdl comneqpdq
syn keyword gasOpcode_AMD_SSE5		comnltpd comnltpdb comnltpdw comnltpdl comnltpdq
syn keyword gasOpcode_AMD_SSE5		comnlepd comnlepdb comnlepdw comnlepdl comnlepdq
syn keyword gasOpcode_AMD_SSE5		comtruepd comtruepdb comtruepdw comtruepdl comtruepdq
syn keyword gasOpcode_AMD_SSE5		compd compdb compdw compdl compdq
syn keyword gasOpcode_AMD_SSE5		comeqss comeqssb comeqssw comeqssl comeqssq
syn keyword gasOpcode_AMD_SSE5		comltss comltssb comltssw comltssl comltssq
syn keyword gasOpcode_AMD_SSE5		comless comlessb comlessw comlessl comlessq
syn keyword gasOpcode_AMD_SSE5		comunordss comunordssb comunordssw comunordssl comunordssq
syn keyword gasOpcode_AMD_SSE5		comuneqss comuneqssb comuneqssw comuneqssl comuneqssq
syn keyword gasOpcode_AMD_SSE5		comunltss comunltssb comunltssw comunltssl comunltssq
syn keyword gasOpcode_AMD_SSE5		comunless comunlessb comunlessw comunlessl comunlessq
syn keyword gasOpcode_AMD_SSE5		comordss comordssb comordssw comordssl comordssq
syn keyword gasOpcode_AMD_SSE5		comueqss comueqssb comueqssw comueqssl comueqssq
syn keyword gasOpcode_AMD_SSE5		comultss comultssb comultssw comultssl comultssq
syn keyword gasOpcode_AMD_SSE5		comuless comulessb comulessw comulessl comulessq
syn keyword gasOpcode_AMD_SSE5		comfalsess comfalsessb comfalsessw comfalsessl comfalsessq
syn keyword gasOpcode_AMD_SSE5		comneqss comneqssb comneqssw comneqssl comneqssq
syn keyword gasOpcode_AMD_SSE5		comnltss comnltssb comnltssw comnltssl comnltssq
syn keyword gasOpcode_AMD_SSE5		comnless comnlessb comnlessw comnlessl comnlessq
syn keyword gasOpcode_AMD_SSE5		comtruess comtruessb comtruessw comtruessl comtruessq
syn keyword gasOpcode_AMD_SSE5		comss comssb comssw comssl comssq
syn keyword gasOpcode_AMD_SSE5		comeqsd comeqsdb comeqsdw comeqsdl comeqsdq
syn keyword gasOpcode_AMD_SSE5		comltsd comltsdb comltsdw comltsdl comltsdq
syn keyword gasOpcode_AMD_SSE5		comlesd comlesdb comlesdw comlesdl comlesdq
syn keyword gasOpcode_AMD_SSE5		comunordsd comunordsdb comunordsdw comunordsdl comunordsdq
syn keyword gasOpcode_AMD_SSE5		comuneqsd comuneqsdb comuneqsdw comuneqsdl comuneqsdq
syn keyword gasOpcode_AMD_SSE5		comunltsd comunltsdb comunltsdw comunltsdl comunltsdq
syn keyword gasOpcode_AMD_SSE5		comunlesd comunlesdb comunlesdw comunlesdl comunlesdq
syn keyword gasOpcode_AMD_SSE5		comordsd comordsdb comordsdw comordsdl comordsdq
syn keyword gasOpcode_AMD_SSE5		comueqsd comueqsdb comueqsdw comueqsdl comueqsdq
syn keyword gasOpcode_AMD_SSE5		comultsd comultsdb comultsdw comultsdl comultsdq
syn keyword gasOpcode_AMD_SSE5		comulesd comulesdb comulesdw comulesdl comulesdq
syn keyword gasOpcode_AMD_SSE5		comfalsesd comfalsesdb comfalsesdw comfalsesdl comfalsesdq
syn keyword gasOpcode_AMD_SSE5		comneqsd comneqsdb comneqsdw comneqsdl comneqsdq
syn keyword gasOpcode_AMD_SSE5		comnltsd comnltsdb comnltsdw comnltsdl comnltsdq
syn keyword gasOpcode_AMD_SSE5		comnlesd comnlesdb comnlesdw comnlesdl comnlesdq
syn keyword gasOpcode_AMD_SSE5		comtruesd comtruesdb comtruesdw comtruesdl comtruesdq
syn keyword gasOpcode_AMD_SSE5		comsd comsdb comsdw comsdl comsdq
syn keyword gasOpcode_AMD_SSE5		pcomltb pcomltbb pcomltbw pcomltbl pcomltbq
syn keyword gasOpcode_AMD_SSE5		pcomleb pcomlebb pcomlebw pcomlebl pcomlebq
syn keyword gasOpcode_AMD_SSE5		pcomgtb pcomgtbb pcomgtbw pcomgtbl pcomgtbq
syn keyword gasOpcode_AMD_SSE5		pcomgeb pcomgebb pcomgebw pcomgebl pcomgebq
syn keyword gasOpcode_AMD_SSE5		pcomeqb pcomeqbb pcomeqbw pcomeqbl pcomeqbq
syn keyword gasOpcode_AMD_SSE5		pcomneqb pcomneqbb pcomneqbw pcomneqbl pcomneqbq
syn keyword gasOpcode_AMD_SSE5		pcomfalseb pcomfalsebb pcomfalsebw pcomfalsebl pcomfalsebq
syn keyword gasOpcode_AMD_SSE5		pcomtrueb pcomtruebb pcomtruebw pcomtruebl pcomtruebq
syn keyword gasOpcode_AMD_SSE5		pcomb pcombb pcombw pcombl pcombq
syn keyword gasOpcode_AMD_SSE5		pcomltw pcomltwb pcomltww pcomltwl pcomltwq
syn keyword gasOpcode_AMD_SSE5		pcomlew pcomlewb pcomleww pcomlewl pcomlewq
syn keyword gasOpcode_AMD_SSE5		pcomgtw pcomgtwb pcomgtww pcomgtwl pcomgtwq
syn keyword gasOpcode_AMD_SSE5		pcomgew pcomgewb pcomgeww pcomgewl pcomgewq
syn keyword gasOpcode_AMD_SSE5		pcomeqw pcomeqwb pcomeqww pcomeqwl pcomeqwq
syn keyword gasOpcode_AMD_SSE5		pcomneqw pcomneqwb pcomneqww pcomneqwl pcomneqwq
syn keyword gasOpcode_AMD_SSE5		pcomfalsew pcomfalsewb pcomfalseww pcomfalsewl pcomfalsewq
syn keyword gasOpcode_AMD_SSE5		pcomtruew pcomtruewb pcomtrueww pcomtruewl pcomtruewq
syn keyword gasOpcode_AMD_SSE5		pcomw pcomwb pcomww pcomwl pcomwq
syn keyword gasOpcode_AMD_SSE5		pcomltd pcomltdb pcomltdw pcomltdl pcomltdq
syn keyword gasOpcode_AMD_SSE5		pcomled pcomledb pcomledw pcomledl pcomledq
syn keyword gasOpcode_AMD_SSE5		pcomgtd pcomgtdb pcomgtdw pcomgtdl pcomgtdq
syn keyword gasOpcode_AMD_SSE5		pcomged pcomgedb pcomgedw pcomgedl pcomgedq
syn keyword gasOpcode_AMD_SSE5		pcomeqd pcomeqdb pcomeqdw pcomeqdl pcomeqdq
syn keyword gasOpcode_AMD_SSE5		pcomneqd pcomneqdb pcomneqdw pcomneqdl pcomneqdq
syn keyword gasOpcode_AMD_SSE5		pcomfalsed pcomfalsedb pcomfalsedw pcomfalsedl pcomfalsedq
syn keyword gasOpcode_AMD_SSE5		pcomtrued pcomtruedb pcomtruedw pcomtruedl pcomtruedq
syn keyword gasOpcode_AMD_SSE5		pcomd pcomdb pcomdw pcomdl pcomdq
syn keyword gasOpcode_AMD_SSE5		pcomltq pcomltqb pcomltqw pcomltql pcomltqq
syn keyword gasOpcode_AMD_SSE5		pcomleq pcomleqb pcomleqw pcomleql pcomleqq
syn keyword gasOpcode_AMD_SSE5		pcomgtq pcomgtqb pcomgtqw pcomgtql pcomgtqq
syn keyword gasOpcode_AMD_SSE5		pcomgeq pcomgeqb pcomgeqw pcomgeql pcomgeqq
syn keyword gasOpcode_AMD_SSE5		pcomeqq pcomeqqb pcomeqqw pcomeqql pcomeqqq
syn keyword gasOpcode_AMD_SSE5		pcomneqq pcomneqqb pcomneqqw pcomneqql pcomneqqq
syn keyword gasOpcode_AMD_SSE5		pcomfalseq pcomfalseqb pcomfalseqw pcomfalseql pcomfalseqq
syn keyword gasOpcode_AMD_SSE5		pcomtrueq pcomtrueqb pcomtrueqw pcomtrueql pcomtrueqq
syn keyword gasOpcode_AMD_SSE5		pcomq pcomqb pcomqw pcomql pcomqq
syn keyword gasOpcode_AMD_SSE5		pcomltub pcomltubb pcomltubw pcomltubl pcomltubq
syn keyword gasOpcode_AMD_SSE5		pcomleub pcomleubb pcomleubw pcomleubl pcomleubq
syn keyword gasOpcode_AMD_SSE5		pcomgtub pcomgtubb pcomgtubw pcomgtubl pcomgtubq
syn keyword gasOpcode_AMD_SSE5		pcomgeub pcomgeubb pcomgeubw pcomgeubl pcomgeubq
syn keyword gasOpcode_AMD_SSE5		pcomequb pcomequbb pcomequbw pcomequbl pcomequbq
syn keyword gasOpcode_AMD_SSE5		pcomnequb pcomnequbb pcomnequbw pcomnequbl pcomnequbq
syn keyword gasOpcode_AMD_SSE5		pcomfalseub pcomfalseubb pcomfalseubw pcomfalseubl pcomfalseubq
syn keyword gasOpcode_AMD_SSE5		pcomtrueub pcomtrueubb pcomtrueubw pcomtrueubl pcomtrueubq
syn keyword gasOpcode_AMD_SSE5		pcomub pcomubb pcomubw pcomubl pcomubq
syn keyword gasOpcode_AMD_SSE5		pcomltuw pcomltuwb pcomltuww pcomltuwl pcomltuwq
syn keyword gasOpcode_AMD_SSE5		pcomleuw pcomleuwb pcomleuww pcomleuwl pcomleuwq
syn keyword gasOpcode_AMD_SSE5		pcomgtuw pcomgtuwb pcomgtuww pcomgtuwl pcomgtuwq
syn keyword gasOpcode_AMD_SSE5		pcomgeuw pcomgeuwb pcomgeuww pcomgeuwl pcomgeuwq
syn keyword gasOpcode_AMD_SSE5		pcomequw pcomequwb pcomequww pcomequwl pcomequwq
syn keyword gasOpcode_AMD_SSE5		pcomnequw pcomnequwb pcomnequww pcomnequwl pcomnequwq
syn keyword gasOpcode_AMD_SSE5		pcomfalseuw pcomfalseuwb pcomfalseuww pcomfalseuwl pcomfalseuwq
syn keyword gasOpcode_AMD_SSE5		pcomtrueuw pcomtrueuwb pcomtrueuww pcomtrueuwl pcomtrueuwq
syn keyword gasOpcode_AMD_SSE5		pcomuw pcomuwb pcomuww pcomuwl pcomuwq
syn keyword gasOpcode_AMD_SSE5		pcomltud pcomltudb pcomltudw pcomltudl pcomltudq
syn keyword gasOpcode_AMD_SSE5		pcomleud pcomleudb pcomleudw pcomleudl pcomleudq
syn keyword gasOpcode_AMD_SSE5		pcomgtud pcomgtudb pcomgtudw pcomgtudl pcomgtudq
syn keyword gasOpcode_AMD_SSE5		pcomgeud pcomgeudb pcomgeudw pcomgeudl pcomgeudq
syn keyword gasOpcode_AMD_SSE5		pcomequd pcomequdb pcomequdw pcomequdl pcomequdq
syn keyword gasOpcode_AMD_SSE5		pcomnequd pcomnequdb pcomnequdw pcomnequdl pcomnequdq
syn keyword gasOpcode_AMD_SSE5		pcomfalseud pcomfalseudb pcomfalseudw pcomfalseudl pcomfalseudq
syn keyword gasOpcode_AMD_SSE5		pcomtrueud pcomtrueudb pcomtrueudw pcomtrueudl pcomtrueudq
syn keyword gasOpcode_AMD_SSE5		pcomud pcomudb pcomudw pcomudl pcomudq
syn keyword gasOpcode_AMD_SSE5		pcomltuq pcomltuqb pcomltuqw pcomltuql pcomltuqq
syn keyword gasOpcode_AMD_SSE5		pcomleuq pcomleuqb pcomleuqw pcomleuql pcomleuqq
syn keyword gasOpcode_AMD_SSE5		pcomgtuq pcomgtuqb pcomgtuqw pcomgtuql pcomgtuqq
syn keyword gasOpcode_AMD_SSE5		pcomgeuq pcomgeuqb pcomgeuqw pcomgeuql pcomgeuqq
syn keyword gasOpcode_AMD_SSE5		pcomequq pcomequqb pcomequqw pcomequql pcomequqq
syn keyword gasOpcode_AMD_SSE5		pcomnequq pcomnequqb pcomnequqw pcomnequql pcomnequqq
syn keyword gasOpcode_AMD_SSE5		pcomfalseuq pcomfalseuqb pcomfalseuqw pcomfalseuql pcomfalseuqq
syn keyword gasOpcode_AMD_SSE5		pcomtrueuq pcomtrueuqb pcomtrueuqw pcomtrueuql pcomtrueuqq
syn keyword gasOpcode_AMD_SSE5		pcomuq pcomuqb pcomuqw pcomuql pcomuqq
syn keyword gasOpcode_AMD_SSE5		permps permpsb permpsw permpsl permpsq
syn keyword gasOpcode_AMD_SSE5		permpd permpdb permpdw permpdl permpdq
syn keyword gasOpcode_AMD_SSE5		pcmov pcmovb pcmovw pcmovl pcmovq
syn keyword gasOpcode_AMD_SSE5		pperm ppermb ppermw pperml ppermq
syn keyword gasOpcode_AMD_SSE5		pmacssww pmacsswwb pmacsswww pmacsswwl pmacsswwq
syn keyword gasOpcode_AMD_SSE5		pmacsww pmacswwb pmacswww pmacswwl pmacswwq
syn keyword gasOpcode_AMD_SSE5		pmacsswd pmacsswdb pmacsswdw pmacsswdl pmacsswdq
syn keyword gasOpcode_AMD_SSE5		pmacswd pmacswdb pmacswdw pmacswdl pmacswdq
syn keyword gasOpcode_AMD_SSE5		pmacssdd pmacssddb pmacssddw pmacssddl pmacssddq
syn keyword gasOpcode_AMD_SSE5		pmacsdd pmacsddb pmacsddw pmacsddl pmacsddq
syn keyword gasOpcode_AMD_SSE5		pmacssdql pmacssdqlb pmacssdqlw pmacssdqll pmacssdqlq
syn keyword gasOpcode_AMD_SSE5		pmacsdql pmacsdqlb pmacsdqlw pmacsdqll pmacsdqlq
syn keyword gasOpcode_AMD_SSE5		pmacssdqh pmacssdqhb pmacssdqhw pmacssdqhl pmacssdqhq
syn keyword gasOpcode_AMD_SSE5		pmacsdqh pmacsdqhb pmacsdqhw pmacsdqhl pmacsdqhq
syn keyword gasOpcode_AMD_SSE5		pmadcsswd pmadcsswdb pmadcsswdw pmadcsswdl pmadcsswdq
syn keyword gasOpcode_AMD_SSE5		pmadcswd pmadcswdb pmadcswdw pmadcswdl pmadcswdq
syn keyword gasOpcode_AMD_SSE5		protb protbb protbw protbl protbq
syn keyword gasOpcode_AMD_SSE5		protw protwb protww protwl protwq
syn keyword gasOpcode_AMD_SSE5		protd protdb protdw protdl protdq
syn keyword gasOpcode_AMD_SSE5		protq protqb protqw protql protqq
syn keyword gasOpcode_AMD_SSE5		pshlb pshlbb pshlbw pshlbl pshlbq
syn keyword gasOpcode_AMD_SSE5		pshlw pshlwb pshlww pshlwl pshlwq
syn keyword gasOpcode_AMD_SSE5		pshld pshldb pshldw pshldl pshldq
syn keyword gasOpcode_AMD_SSE5		pshlq pshlqb pshlqw pshlql pshlqq
syn keyword gasOpcode_AMD_SSE5		pshab pshabb pshabw pshabl pshabq
syn keyword gasOpcode_AMD_SSE5		pshaw pshawb pshaww pshawl pshawq
syn keyword gasOpcode_AMD_SSE5		pshad pshadb pshadw pshadl pshadq
syn keyword gasOpcode_AMD_SSE5		pshaq pshaqb pshaqw pshaql pshaqq
syn keyword gasOpcode_AMD_SSE5		frczps frczpsb frczpsw frczpsl frczpsq
syn keyword gasOpcode_AMD_SSE5		frczpd frczpdb frczpdw frczpdl frczpdq
syn keyword gasOpcode_AMD_SSE5		frczss frczssb frczssw frczssl frczssq
syn keyword gasOpcode_AMD_SSE5		frczsd frczsdb frczsdw frczsdl frczsdq
syn keyword gasOpcode_AMD_SSE5		cvtph2ps cvtph2psb cvtph2psw cvtph2psl cvtph2psq
syn keyword gasOpcode_AMD_SSE5		cvtps2ph cvtps2phb cvtps2phw cvtps2phl cvtps2phq
syn keyword gasOpcode_AMD_SSE5		phaddbw phaddbwb phaddbww phaddbwl phaddbwq
syn keyword gasOpcode_AMD_SSE5		phaddbd phaddbdb phaddbdw phaddbdl phaddbdq
syn keyword gasOpcode_AMD_SSE5		phaddbq phaddbqb phaddbqw phaddbql phaddbqq
syn keyword gasOpcode_AMD_SSE5		phaddwd phaddwdb phaddwdw phaddwdl phaddwdq
syn keyword gasOpcode_AMD_SSE5		phaddwq phaddwqb phaddwqw phaddwql phaddwqq
syn keyword gasOpcode_AMD_SSE5		phadddq phadddqb phadddqw phadddql phadddqq
syn keyword gasOpcode_AMD_SSE5		phaddubw phaddubwb phaddubww phaddubwl phaddubwq
syn keyword gasOpcode_AMD_SSE5		phaddubd phaddubdb phaddubdw phaddubdl phaddubdq
syn keyword gasOpcode_AMD_SSE5		phaddubq phaddubqb phaddubqw phaddubql phaddubqq
syn keyword gasOpcode_AMD_SSE5		phadduwd phadduwdb phadduwdw phadduwdl phadduwdq
syn keyword gasOpcode_AMD_SSE5		phadduwq phadduwqb phadduwqw phadduwql phadduwqq
syn keyword gasOpcode_AMD_SSE5		phaddudq phaddudqb phaddudqw phaddudql phaddudqq
syn keyword gasOpcode_AMD_SSE5		phsubbw phsubbwb phsubbww phsubbwl phsubbwq
syn keyword gasOpcode_AMD_SSE5		phsubwd phsubwdb phsubwdw phsubwdl phsubwdq
syn keyword gasOpcode_AMD_SSE5		phsubdq phsubdqb phsubdqw phsubdql phsubdqq
syn keyword gasOpcode_AMD_SSE5		protb protbb protbw protbl protbq
syn keyword gasOpcode_AMD_SSE5		protw protwb protww protwl protwq
syn keyword gasOpcode_AMD_SSE5		protd protdb protdw protdl protdq
syn keyword gasOpcode_AMD_SSE5		protq protqb protqw protql protqq
syn keyword gasOpcode_AMD_SSE5		roundps roundpsb roundpsw roundpsl roundpsq
syn keyword gasOpcode_AMD_SSE5		roundpd roundpdb roundpdw roundpdl roundpdq
syn keyword gasOpcode_AMD_SSE5		roundss roundssb roundssw roundssl roundssq
syn keyword gasOpcode_AMD_SSE5		roundsd roundsdb roundsdw roundsdl roundsdq

"-- Section: Introduced in Deschutes but necessary for SSE support
syn keyword gasOpcode_P6_SSE		fxrstor fxrstorb fxrstorw fxrstorl fxrstorq
syn keyword gasOpcode_P6_SSE		fxsave fxsaveb fxsavew fxsavel fxsaveq

"-- Section: Prescott New Instructions (SSE3)
syn keyword gasOpcode_PRESCOTT_SSE3	addsubpd addsubpdb addsubpdw addsubpdl addsubpdq
syn keyword gasOpcode_PRESCOTT_SSE3	addsubps addsubpsb addsubpsw addsubpsl addsubpsq
syn keyword gasOpcode_PRESCOTT_SSE3	haddpd haddpdb haddpdw haddpdl haddpdq
syn keyword gasOpcode_PRESCOTT_SSE3	haddps haddpsb haddpsw haddpsl haddpsq
syn keyword gasOpcode_PRESCOTT_SSE3	hsubpd hsubpdb hsubpdw hsubpdl hsubpdq
syn keyword gasOpcode_PRESCOTT_SSE3	hsubps hsubpsb hsubpsw hsubpsl hsubpsq
syn keyword gasOpcode_PRESCOTT_SSE3	lddqu lddqub lddquw lddqul lddquq
syn keyword gasOpcode_PRESCOTT_SSE3	movddup movddupb movddupw movddupl movddupq
syn keyword gasOpcode_PRESCOTT_SSE3	movshdup movshdupb movshdupw movshdupl movshdupq
syn keyword gasOpcode_PRESCOTT_SSE3	movsldup movsldupb movsldupw movsldupl movsldupq

"-- Section: Intel AES instructions
syn keyword gasOpcode_SSE		aesenc aesencb aesencw aesencl aesencq
syn keyword gasOpcode_SSE		aesenclast aesenclastb aesenclastw aesenclastl aesenclastq
syn keyword gasOpcode_SSE		aesdec aesdecb aesdecw aesdecl aesdecq
syn keyword gasOpcode_SSE		aesdeclast aesdeclastb aesdeclastw aesdeclastl aesdeclastq
syn keyword gasOpcode_SSE		aesimc aesimcb aesimcw aesimcl aesimcq
syn keyword gasOpcode_SSE		aeskeygenassist aeskeygenassistb aeskeygenassistw aeskeygenassistl aeskeygenassistq

"-- Section: Willamette Streaming SIMD instructions (SSE2)
syn keyword gasOpcode_SSE2		addpd addpdb addpdw addpdl addpdq
syn keyword gasOpcode_SSE2		addsd addsdb addsdw addsdl addsdq
syn keyword gasOpcode_SSE2		andnpd andnpdb andnpdw andnpdl andnpdq
syn keyword gasOpcode_SSE2		andpd andpdb andpdw andpdl andpdq
syn keyword gasOpcode_SSE2		cmpeqpd cmpeqpdb cmpeqpdw cmpeqpdl cmpeqpdq
syn keyword gasOpcode_SSE2		cmpeqsd cmpeqsdb cmpeqsdw cmpeqsdl cmpeqsdq
syn keyword gasOpcode_SSE2		cmplepd cmplepdb cmplepdw cmplepdl cmplepdq
syn keyword gasOpcode_SSE2		cmplesd cmplesdb cmplesdw cmplesdl cmplesdq
syn keyword gasOpcode_SSE2		cmpltpd cmpltpdb cmpltpdw cmpltpdl cmpltpdq
syn keyword gasOpcode_SSE2		cmpltsd cmpltsdb cmpltsdw cmpltsdl cmpltsdq
syn keyword gasOpcode_SSE2		cmpneqpd cmpneqpdb cmpneqpdw cmpneqpdl cmpneqpdq
syn keyword gasOpcode_SSE2		cmpneqsd cmpneqsdb cmpneqsdw cmpneqsdl cmpneqsdq
syn keyword gasOpcode_SSE2		cmpnlepd cmpnlepdb cmpnlepdw cmpnlepdl cmpnlepdq
syn keyword gasOpcode_SSE2		cmpnlesd cmpnlesdb cmpnlesdw cmpnlesdl cmpnlesdq
syn keyword gasOpcode_SSE2		cmpnltpd cmpnltpdb cmpnltpdw cmpnltpdl cmpnltpdq
syn keyword gasOpcode_SSE2		cmpnltsd cmpnltsdb cmpnltsdw cmpnltsdl cmpnltsdq
syn keyword gasOpcode_SSE2		cmpordpd cmpordpdb cmpordpdw cmpordpdl cmpordpdq
syn keyword gasOpcode_SSE2		cmpordsd cmpordsdb cmpordsdw cmpordsdl cmpordsdq
syn keyword gasOpcode_SSE2		cmpunordpd cmpunordpdb cmpunordpdw cmpunordpdl cmpunordpdq
syn keyword gasOpcode_SSE2		cmpunordsd cmpunordsdb cmpunordsdw cmpunordsdl cmpunordsdq
syn keyword gasOpcode_Base		cmppd cmppdb cmppdw cmppdl cmppdq
syn keyword gasOpcode_SSE2		cmpsd cmpsdb cmpsdw cmpsdl cmpsdq
syn keyword gasOpcode_SSE2		comisd comisdb comisdw comisdl comisdq
syn keyword gasOpcode_SSE2		cvtdq2pd cvtdq2pdb cvtdq2pdw cvtdq2pdl cvtdq2pdq
syn keyword gasOpcode_SSE2		cvtdq2ps cvtdq2psb cvtdq2psw cvtdq2psl cvtdq2psq
syn keyword gasOpcode_SSE2		cvtpd2dq cvtpd2dqb cvtpd2dqw cvtpd2dql cvtpd2dqq
syn keyword gasOpcode_SSE2		cvtpd2pi cvtpd2pib cvtpd2piw cvtpd2pil cvtpd2piq
syn keyword gasOpcode_SSE2		cvtpd2ps cvtpd2psb cvtpd2psw cvtpd2psl cvtpd2psq
syn keyword gasOpcode_SSE2		cvtpi2pd cvtpi2pdb cvtpi2pdw cvtpi2pdl cvtpi2pdq
syn keyword gasOpcode_SSE2		cvtps2dq cvtps2dqb cvtps2dqw cvtps2dql cvtps2dqq
syn keyword gasOpcode_SSE2		cvtps2pd cvtps2pdb cvtps2pdw cvtps2pdl cvtps2pdq
syn keyword gasOpcode_X64_SSE2		cvtsd2si cvtsd2sib cvtsd2siw cvtsd2sil cvtsd2siq
syn keyword gasOpcode_SSE2		cvtsd2ss cvtsd2ssb cvtsd2ssw cvtsd2ssl cvtsd2ssq
syn keyword gasOpcode_X64_SSE2		cvtsi2sd
syn keyword gasOpcode_SSE2		cvtss2sd cvtss2sdb cvtss2sdw cvtss2sdl cvtss2sdq
syn keyword gasOpcode_SSE2		cvttpd2pi cvttpd2pib cvttpd2piw cvttpd2pil cvttpd2piq
syn keyword gasOpcode_SSE2		cvttpd2dq cvttpd2dqb cvttpd2dqw cvttpd2dql cvttpd2dqq
syn keyword gasOpcode_SSE2		cvttps2dq cvttps2dqb cvttps2dqw cvttps2dql cvttps2dqq
syn keyword gasOpcode_X64_SSE2		cvttsd2si cvttsd2sib cvttsd2siw cvttsd2sil cvttsd2siq
syn keyword gasOpcode_SSE2		divpd divpdb divpdw divpdl divpdq
syn keyword gasOpcode_SSE2		divsd divsdb divsdw divsdl divsdq
syn keyword gasOpcode_SSE2		maxpd maxpdb maxpdw maxpdl maxpdq
syn keyword gasOpcode_SSE2		maxsd maxsdb maxsdw maxsdl maxsdq
syn keyword gasOpcode_SSE2		minpd minpdb minpdw minpdl minpdq
syn keyword gasOpcode_SSE2		minsd minsdb minsdw minsdl minsdq
syn keyword gasOpcode_SSE2		movapd movapdb movapdw movapdl movapdq
syn keyword gasOpcode_SSE2		movhpd movhpdb movhpdw movhpdl movhpdq
syn keyword gasOpcode_SSE2		movlpd movlpdb movlpdw movlpdl movlpdq
syn keyword gasOpcode_X64_SSE2		movmskpd
syn keyword gasOpcode_SSE2		movsd movsdb movsdw movsdl movsdq
syn keyword gasOpcode_SSE2		movupd movupdb movupdw movupdl movupdq
syn keyword gasOpcode_SSE2		mulpd mulpdb mulpdw mulpdl mulpdq
syn keyword gasOpcode_SSE2		mulsd mulsdb mulsdw mulsdl mulsdq
syn keyword gasOpcode_SSE2		orpd orpdb orpdw orpdl orpdq
syn keyword gasOpcode_SSE2		shufpd shufpdb shufpdw shufpdl shufpdq
syn keyword gasOpcode_SSE2		sqrtpd sqrtpdb sqrtpdw sqrtpdl sqrtpdq
syn keyword gasOpcode_SSE2		sqrtsd sqrtsdb sqrtsdw sqrtsdl sqrtsdq
syn keyword gasOpcode_SSE2		subpd subpdb subpdw subpdl subpdq
syn keyword gasOpcode_SSE2		subsd subsdb subsdw subsdl subsdq
syn keyword gasOpcode_SSE2		ucomisd ucomisdb ucomisdw ucomisdl ucomisdq
syn keyword gasOpcode_SSE2		unpckhpd unpckhpdb unpckhpdw unpckhpdl unpckhpdq
syn keyword gasOpcode_SSE2		unpcklpd unpcklpdb unpcklpdw unpcklpdl unpcklpdq
syn keyword gasOpcode_SSE2		xorpd xorpdb xorpdw xorpdl xorpdq

"-- Section: Intel Carry-Less Multiplication instructions (CLMUL)
syn keyword gasOpcode_SSE		pclmullqlqdq pclmullqlqdqb pclmullqlqdqw pclmullqlqdql pclmullqlqdqq
syn keyword gasOpcode_SSE		pclmulhqlqdq pclmulhqlqdqb pclmulhqlqdqw pclmulhqlqdql pclmulhqlqdqq
syn keyword gasOpcode_SSE		pclmullqhqdq pclmullqhqdqb pclmullqhqdqw pclmullqhqdql pclmullqhqdqq
syn keyword gasOpcode_SSE		pclmulhqhqdq pclmulhqhqdqb pclmulhqhqdqw pclmulhqhqdql pclmulhqhqdqq
syn keyword gasOpcode_SSE		pclmulqdq pclmulqdqb pclmulqdqw pclmulqdql pclmulqdqq

"-- Section: New MMX instructions introduced in Katmai
syn keyword gasOpcode_KATMAI_MMX	maskmovq
syn keyword gasOpcode_KATMAI_MMX	movntq movntqb movntqw movntql movntqq
syn keyword gasOpcode_KATMAI_MMX	pavgb pavgbb pavgbw pavgbl pavgbq
syn keyword gasOpcode_KATMAI_MMX	pavgw pavgwb pavgww pavgwl pavgwq
syn keyword gasOpcode_KATMAI_MMX	pextrw pextrwb pextrww pextrwl pextrwq
syn keyword gasOpcode_KATMAI_MMX	pinsrw pinsrwb pinsrww pinsrwl pinsrwq
syn keyword gasOpcode_KATMAI_MMX	pmaxsw pmaxswb pmaxsww pmaxswl pmaxswq
syn keyword gasOpcode_KATMAI_MMX	pmaxub pmaxubb pmaxubw pmaxubl pmaxubq
syn keyword gasOpcode_KATMAI_MMX	pminsw pminswb pminsww pminswl pminswq
syn keyword gasOpcode_KATMAI_MMX	pminub pminubb pminubw pminubl pminubq
syn keyword gasOpcode_KATMAI_MMX	pmovmskb
syn keyword gasOpcode_KATMAI_MMX	pmulhuw pmulhuwb pmulhuww pmulhuwl pmulhuwq
syn keyword gasOpcode_KATMAI_MMX	psadbw psadbwb psadbww psadbwl psadbwq
syn keyword gasOpcode_KATMAI_MMX2	pshufw pshufwb pshufww pshufwl pshufwq

"-- Section: Intel SMX
syn keyword gasOpcode_KATMAI_Base	getsec

"-- Section: Katmai Streaming SIMD instructions (SSE -- a.k.a. KNI, XMM, MMX2)
syn keyword gasOpcode_KATMAI_SSE	addps addpsb addpsw addpsl addpsq
syn keyword gasOpcode_KATMAI_SSE	addss addssb addssw addssl addssq
syn keyword gasOpcode_KATMAI_SSE	andnps andnpsb andnpsw andnpsl andnpsq
syn keyword gasOpcode_KATMAI_SSE	andps andpsb andpsw andpsl andpsq
syn keyword gasOpcode_KATMAI_SSE	cmpeqps cmpeqpsb cmpeqpsw cmpeqpsl cmpeqpsq
syn keyword gasOpcode_KATMAI_SSE	cmpeqss cmpeqssb cmpeqssw cmpeqssl cmpeqssq
syn keyword gasOpcode_KATMAI_SSE	cmpleps cmplepsb cmplepsw cmplepsl cmplepsq
syn keyword gasOpcode_KATMAI_SSE	cmpless cmplessb cmplessw cmplessl cmplessq
syn keyword gasOpcode_KATMAI_SSE	cmpltps cmpltpsb cmpltpsw cmpltpsl cmpltpsq
syn keyword gasOpcode_KATMAI_SSE	cmpltss cmpltssb cmpltssw cmpltssl cmpltssq
syn keyword gasOpcode_KATMAI_SSE	cmpneqps cmpneqpsb cmpneqpsw cmpneqpsl cmpneqpsq
syn keyword gasOpcode_KATMAI_SSE	cmpneqss cmpneqssb cmpneqssw cmpneqssl cmpneqssq
syn keyword gasOpcode_KATMAI_SSE	cmpnleps cmpnlepsb cmpnlepsw cmpnlepsl cmpnlepsq
syn keyword gasOpcode_KATMAI_SSE	cmpnless cmpnlessb cmpnlessw cmpnlessl cmpnlessq
syn keyword gasOpcode_KATMAI_SSE	cmpnltps cmpnltpsb cmpnltpsw cmpnltpsl cmpnltpsq
syn keyword gasOpcode_KATMAI_SSE	cmpnltss cmpnltssb cmpnltssw cmpnltssl cmpnltssq
syn keyword gasOpcode_KATMAI_SSE	cmpordps cmpordpsb cmpordpsw cmpordpsl cmpordpsq
syn keyword gasOpcode_KATMAI_SSE	cmpordss cmpordssb cmpordssw cmpordssl cmpordssq
syn keyword gasOpcode_KATMAI_SSE	cmpunordps cmpunordpsb cmpunordpsw cmpunordpsl cmpunordpsq
syn keyword gasOpcode_KATMAI_SSE	cmpunordss cmpunordssb cmpunordssw cmpunordssl cmpunordssq
syn keyword gasOpcode_KATMAI_SSE	cmpps cmppsb cmppsw cmppsl cmppsq
syn keyword gasOpcode_KATMAI_SSE	cmpss cmpssb cmpssw cmpssl cmpssq
syn keyword gasOpcode_KATMAI_SSE	comiss comissb comissw comissl comissq
syn keyword gasOpcode_KATMAI_SSE	cvtpi2ps cvtpi2psb cvtpi2psw cvtpi2psl cvtpi2psq
syn keyword gasOpcode_KATMAI_SSE	cvtps2pi cvtps2pib cvtps2piw cvtps2pil cvtps2piq
syn keyword gasOpcode_X64_SSE		cvtsi2ss
syn keyword gasOpcode_X64_SSE		cvtss2si cvtss2sib cvtss2siw cvtss2sil cvtss2siq
syn keyword gasOpcode_KATMAI_SSE	cvttps2pi cvttps2pib cvttps2piw cvttps2pil cvttps2piq
syn keyword gasOpcode_X64_SSE		cvttss2si cvttss2sib cvttss2siw cvttss2sil cvttss2siq
syn keyword gasOpcode_KATMAI_SSE	divps divpsb divpsw divpsl divpsq
syn keyword gasOpcode_KATMAI_SSE	divss divssb divssw divssl divssq
syn keyword gasOpcode_KATMAI_SSE	ldmxcsr ldmxcsrb ldmxcsrw ldmxcsrl ldmxcsrq
syn keyword gasOpcode_KATMAI_SSE	maxps maxpsb maxpsw maxpsl maxpsq
syn keyword gasOpcode_KATMAI_SSE	maxss maxssb maxssw maxssl maxssq
syn keyword gasOpcode_KATMAI_SSE	minps minpsb minpsw minpsl minpsq
syn keyword gasOpcode_KATMAI_SSE	minss minssb minssw minssl minssq
syn keyword gasOpcode_KATMAI_SSE	movaps
syn keyword gasOpcode_KATMAI_SSE	movhps movhpsb movhpsw movhpsl movhpsq
syn keyword gasOpcode_KATMAI_SSE	movlhps
syn keyword gasOpcode_KATMAI_SSE	movlps movlpsb movlpsw movlpsl movlpsq
syn keyword gasOpcode_KATMAI_SSE	movhlps
syn keyword gasOpcode_X64_SSE		movmskps
syn keyword gasOpcode_KATMAI_SSE	movntps movntpsb movntpsw movntpsl movntpsq
syn keyword gasOpcode_KATMAI_SSE	movss
syn keyword gasOpcode_KATMAI_SSE	movups
syn keyword gasOpcode_KATMAI_SSE	mulps mulpsb mulpsw mulpsl mulpsq
syn keyword gasOpcode_KATMAI_SSE	mulss mulssb mulssw mulssl mulssq
syn keyword gasOpcode_KATMAI_SSE	orps orpsb orpsw orpsl orpsq
syn keyword gasOpcode_KATMAI_SSE	rcpps rcppsb rcppsw rcppsl rcppsq
syn keyword gasOpcode_KATMAI_SSE	rcpss rcpssb rcpssw rcpssl rcpssq
syn keyword gasOpcode_KATMAI_SSE	rsqrtps rsqrtpsb rsqrtpsw rsqrtpsl rsqrtpsq
syn keyword gasOpcode_KATMAI_SSE	rsqrtss rsqrtssb rsqrtssw rsqrtssl rsqrtssq
syn keyword gasOpcode_KATMAI_SSE	shufps shufpsb shufpsw shufpsl shufpsq
syn keyword gasOpcode_KATMAI_SSE	sqrtps sqrtpsb sqrtpsw sqrtpsl sqrtpsq
syn keyword gasOpcode_KATMAI_SSE	sqrtss sqrtssb sqrtssw sqrtssl sqrtssq
syn keyword gasOpcode_KATMAI_SSE	stmxcsr stmxcsrb stmxcsrw stmxcsrl stmxcsrq
syn keyword gasOpcode_KATMAI_SSE	subps subpsb subpsw subpsl subpsq
syn keyword gasOpcode_KATMAI_SSE	subss subssb subssw subssl subssq
syn keyword gasOpcode_KATMAI_SSE	ucomiss ucomissb ucomissw ucomissl ucomissq
syn keyword gasOpcode_KATMAI_SSE	unpckhps unpckhpsb unpckhpsw unpckhpsl unpckhpsq
syn keyword gasOpcode_KATMAI_SSE	unpcklps unpcklpsb unpcklpsw unpcklpsl unpcklpsq
syn keyword gasOpcode_KATMAI_SSE	xorps xorpsb xorpsw xorpsl xorpsq

"-- Section: Extended Page Tables VMX instructions
syn keyword gasOpcode_VMX		invept inveptb inveptw inveptl inveptq
syn keyword gasOpcode_VMX		invvpid invvpidb invvpidw invvpidl invvpidq

"-- Section: VMX Instructions
syn keyword gasOpcode_VMX		vmcall
syn keyword gasOpcode_VMX		vmclear vmclearb vmclearw vmclearl vmclearq
syn keyword gasOpcode_VMX		vmlaunch
syn keyword gasOpcode_X64_VMX		vmload
syn keyword gasOpcode_X64_VMX		vmmcall
syn keyword gasOpcode_VMX		vmptrld vmptrldb vmptrldw vmptrldl vmptrldq
syn keyword gasOpcode_VMX		vmptrst vmptrstb vmptrstw vmptrstl vmptrstq
syn keyword gasOpcode_X64_VMX		vmread
syn keyword gasOpcode_VMX		vmresume
syn keyword gasOpcode_X64_VMX		vmrun
syn keyword gasOpcode_X64_VMX		vmsave
syn keyword gasOpcode_X64_VMX		vmwrite
syn keyword gasOpcode_VMX		vmxoff
syn keyword gasOpcode_VMX		vmxon vmxonb vmxonw vmxonl vmxonq

"-- Section: Intel AVX AES instructions
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaesenc vaesencb vaesencw vaesencl vaesencq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaesenclast vaesenclastb vaesenclastw vaesenclastl vaesenclastq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaesdec vaesdecb vaesdecw vaesdecl vaesdecq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaesdeclast vaesdeclastb vaesdeclastw vaesdeclastl vaesdeclastq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaesimc vaesimcb vaesimcw vaesimcl vaesimcq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaeskeygenassist vaeskeygenassistb vaeskeygenassistw vaeskeygenassistl vaeskeygenassistq

"-- Section: New instructions in Barcelona
syn keyword gasOpcode_X64_Base		lzcnt

"-- Section: Intel AVX instructions
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaddpd vaddpdb vaddpdw vaddpdl vaddpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaddps vaddpsb vaddpsw vaddpsl vaddpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaddsd vaddsdb vaddsdw vaddsdl vaddsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaddss vaddssb vaddssw vaddssl vaddssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaddsubpd vaddsubpdb vaddsubpdw vaddsubpdl vaddsubpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vaddsubps vaddsubpsb vaddsubpsw vaddsubpsl vaddsubpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vandpd vandpdb vandpdw vandpdl vandpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vandps vandpsb vandpsw vandpsl vandpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vandnpd vandnpdb vandnpdw vandnpdl vandnpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vandnps vandnpsb vandnpsw vandnpsl vandnpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vblendpd vblendpdb vblendpdw vblendpdl vblendpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vblendps vblendpsb vblendpsw vblendpsl vblendpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vblendvpd vblendvpdb vblendvpdw vblendvpdl vblendvpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vblendvps vblendvpsb vblendvpsw vblendvpsl vblendvpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vblendvpd vblendvpdb vblendvpdw vblendvpdl vblendvpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vbroadcastss vbroadcastssb vbroadcastssw vbroadcastssl vbroadcastssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vbroadcastsd vbroadcastsdb vbroadcastsdw vbroadcastsdl vbroadcastsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vbroadcastf128 vbroadcastf128b vbroadcastf128w vbroadcastf128l vbroadcastf128q
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeqpd vcmpeqpdb vcmpeqpdw vcmpeqpdl vcmpeqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpltpd vcmpltpdb vcmpltpdw vcmpltpdl vcmpltpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmplepd vcmplepdb vcmplepdw vcmplepdl vcmplepdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunordpd vcmpunordpdb vcmpunordpdw vcmpunordpdl vcmpunordpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneqpd vcmpneqpdb vcmpneqpdw vcmpneqpdl vcmpneqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnltpd vcmpnltpdb vcmpnltpdw vcmpnltpdl vcmpnltpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnlepd vcmpnlepdb vcmpnlepdw vcmpnlepdl vcmpnlepdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpordpd vcmpordpdb vcmpordpdw vcmpordpdl vcmpordpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_uqpd vcmpeq_uqpdb vcmpeq_uqpdw vcmpeq_uqpdl vcmpeq_uqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngepd vcmpngepdb vcmpngepdw vcmpngepdl vcmpngepdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngtpd vcmpngtpdb vcmpngtpdw vcmpngtpdl vcmpngtpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalsepd vcmpfalsepdb vcmpfalsepdw vcmpfalsepdl vcmpfalsepdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_oqpd vcmpneq_oqpdb vcmpneq_oqpdw vcmpneq_oqpdl vcmpneq_oqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgepd vcmpgepdb vcmpgepdw vcmpgepdl vcmpgepdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgtpd vcmpgtpdb vcmpgtpdw vcmpgtpdl vcmpgtpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptruepd vcmptruepdb vcmptruepdw vcmptruepdl vcmptruepdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_ospd vcmpeq_ospdb vcmpeq_ospdw vcmpeq_ospdl vcmpeq_ospdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmplt_oqpd vcmplt_oqpdb vcmplt_oqpdw vcmplt_oqpdl vcmplt_oqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmple_oqpd vcmple_oqpdb vcmple_oqpdw vcmple_oqpdl vcmple_oqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunord_spd vcmpunord_spdb vcmpunord_spdw vcmpunord_spdl vcmpunord_spdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_uspd vcmpneq_uspdb vcmpneq_uspdw vcmpneq_uspdl vcmpneq_uspdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnlt_uqpd vcmpnlt_uqpdb vcmpnlt_uqpdw vcmpnlt_uqpdl vcmpnlt_uqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnle_uqpd vcmpnle_uqpdb vcmpnle_uqpdw vcmpnle_uqpdl vcmpnle_uqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpord_spd vcmpord_spdb vcmpord_spdw vcmpord_spdl vcmpord_spdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_uspd vcmpeq_uspdb vcmpeq_uspdw vcmpeq_uspdl vcmpeq_uspdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnge_uqpd vcmpnge_uqpdb vcmpnge_uqpdw vcmpnge_uqpdl vcmpnge_uqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngt_uqpd vcmpngt_uqpdb vcmpngt_uqpdw vcmpngt_uqpdl vcmpngt_uqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalse_ospd vcmpfalse_ospdb vcmpfalse_ospdw vcmpfalse_ospdl vcmpfalse_ospdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_ospd vcmpneq_ospdb vcmpneq_ospdw vcmpneq_ospdl vcmpneq_ospdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpge_oqpd vcmpge_oqpdb vcmpge_oqpdw vcmpge_oqpdl vcmpge_oqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgt_oqpd vcmpgt_oqpdb vcmpgt_oqpdw vcmpgt_oqpdl vcmpgt_oqpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptrue_uspd vcmptrue_uspdb vcmptrue_uspdw vcmptrue_uspdl vcmptrue_uspdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmppd vcmppdb vcmppdw vcmppdl vcmppdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeqps vcmpeqpsb vcmpeqpsw vcmpeqpsl vcmpeqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpltps vcmpltpsb vcmpltpsw vcmpltpsl vcmpltpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpleps vcmplepsb vcmplepsw vcmplepsl vcmplepsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunordps vcmpunordpsb vcmpunordpsw vcmpunordpsl vcmpunordpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneqps vcmpneqpsb vcmpneqpsw vcmpneqpsl vcmpneqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnltps vcmpnltpsb vcmpnltpsw vcmpnltpsl vcmpnltpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnleps vcmpnlepsb vcmpnlepsw vcmpnlepsl vcmpnlepsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpordps vcmpordpsb vcmpordpsw vcmpordpsl vcmpordpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_uqps vcmpeq_uqpsb vcmpeq_uqpsw vcmpeq_uqpsl vcmpeq_uqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngeps vcmpngepsb vcmpngepsw vcmpngepsl vcmpngepsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngtps vcmpngtpsb vcmpngtpsw vcmpngtpsl vcmpngtpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalseps vcmpfalsepsb vcmpfalsepsw vcmpfalsepsl vcmpfalsepsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_oqps vcmpneq_oqpsb vcmpneq_oqpsw vcmpneq_oqpsl vcmpneq_oqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgeps vcmpgepsb vcmpgepsw vcmpgepsl vcmpgepsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgtps vcmpgtpsb vcmpgtpsw vcmpgtpsl vcmpgtpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptrueps vcmptruepsb vcmptruepsw vcmptruepsl vcmptruepsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_osps vcmpeq_ospsb vcmpeq_ospsw vcmpeq_ospsl vcmpeq_ospsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmplt_oqps vcmplt_oqpsb vcmplt_oqpsw vcmplt_oqpsl vcmplt_oqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmple_oqps vcmple_oqpsb vcmple_oqpsw vcmple_oqpsl vcmple_oqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunord_sps vcmpunord_spsb vcmpunord_spsw vcmpunord_spsl vcmpunord_spsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_usps vcmpneq_uspsb vcmpneq_uspsw vcmpneq_uspsl vcmpneq_uspsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnlt_uqps vcmpnlt_uqpsb vcmpnlt_uqpsw vcmpnlt_uqpsl vcmpnlt_uqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnle_uqps vcmpnle_uqpsb vcmpnle_uqpsw vcmpnle_uqpsl vcmpnle_uqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpord_sps vcmpord_spsb vcmpord_spsw vcmpord_spsl vcmpord_spsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_usps vcmpeq_uspsb vcmpeq_uspsw vcmpeq_uspsl vcmpeq_uspsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnge_uqps vcmpnge_uqpsb vcmpnge_uqpsw vcmpnge_uqpsl vcmpnge_uqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngt_uqps vcmpngt_uqpsb vcmpngt_uqpsw vcmpngt_uqpsl vcmpngt_uqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalse_osps vcmpfalse_ospsb vcmpfalse_ospsw vcmpfalse_ospsl vcmpfalse_ospsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_osps vcmpneq_ospsb vcmpneq_ospsw vcmpneq_ospsl vcmpneq_ospsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpge_oqps vcmpge_oqpsb vcmpge_oqpsw vcmpge_oqpsl vcmpge_oqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgt_oqps vcmpgt_oqpsb vcmpgt_oqpsw vcmpgt_oqpsl vcmpgt_oqpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptrue_usps vcmptrue_uspsb vcmptrue_uspsw vcmptrue_uspsl vcmptrue_uspsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpps vcmppsb vcmppsw vcmppsl vcmppsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeqsd vcmpeqsdb vcmpeqsdw vcmpeqsdl vcmpeqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpltsd vcmpltsdb vcmpltsdw vcmpltsdl vcmpltsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmplesd vcmplesdb vcmplesdw vcmplesdl vcmplesdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunordsd vcmpunordsdb vcmpunordsdw vcmpunordsdl vcmpunordsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneqsd vcmpneqsdb vcmpneqsdw vcmpneqsdl vcmpneqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnltsd vcmpnltsdb vcmpnltsdw vcmpnltsdl vcmpnltsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnlesd vcmpnlesdb vcmpnlesdw vcmpnlesdl vcmpnlesdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpordsd vcmpordsdb vcmpordsdw vcmpordsdl vcmpordsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_uqsd vcmpeq_uqsdb vcmpeq_uqsdw vcmpeq_uqsdl vcmpeq_uqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngesd vcmpngesdb vcmpngesdw vcmpngesdl vcmpngesdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngtsd vcmpngtsdb vcmpngtsdw vcmpngtsdl vcmpngtsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalsesd vcmpfalsesdb vcmpfalsesdw vcmpfalsesdl vcmpfalsesdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_oqsd vcmpneq_oqsdb vcmpneq_oqsdw vcmpneq_oqsdl vcmpneq_oqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgesd vcmpgesdb vcmpgesdw vcmpgesdl vcmpgesdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgtsd vcmpgtsdb vcmpgtsdw vcmpgtsdl vcmpgtsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptruesd vcmptruesdb vcmptruesdw vcmptruesdl vcmptruesdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_ossd vcmpeq_ossdb vcmpeq_ossdw vcmpeq_ossdl vcmpeq_ossdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmplt_oqsd vcmplt_oqsdb vcmplt_oqsdw vcmplt_oqsdl vcmplt_oqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmple_oqsd vcmple_oqsdb vcmple_oqsdw vcmple_oqsdl vcmple_oqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunord_ssd vcmpunord_ssdb vcmpunord_ssdw vcmpunord_ssdl vcmpunord_ssdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_ussd vcmpneq_ussdb vcmpneq_ussdw vcmpneq_ussdl vcmpneq_ussdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnlt_uqsd vcmpnlt_uqsdb vcmpnlt_uqsdw vcmpnlt_uqsdl vcmpnlt_uqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnle_uqsd vcmpnle_uqsdb vcmpnle_uqsdw vcmpnle_uqsdl vcmpnle_uqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpord_ssd vcmpord_ssdb vcmpord_ssdw vcmpord_ssdl vcmpord_ssdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_ussd vcmpeq_ussdb vcmpeq_ussdw vcmpeq_ussdl vcmpeq_ussdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnge_uqsd vcmpnge_uqsdb vcmpnge_uqsdw vcmpnge_uqsdl vcmpnge_uqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngt_uqsd vcmpngt_uqsdb vcmpngt_uqsdw vcmpngt_uqsdl vcmpngt_uqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalse_ossd vcmpfalse_ossdb vcmpfalse_ossdw vcmpfalse_ossdl vcmpfalse_ossdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_ossd vcmpneq_ossdb vcmpneq_ossdw vcmpneq_ossdl vcmpneq_ossdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpge_oqsd vcmpge_oqsdb vcmpge_oqsdw vcmpge_oqsdl vcmpge_oqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgt_oqsd vcmpgt_oqsdb vcmpgt_oqsdw vcmpgt_oqsdl vcmpgt_oqsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptrue_ussd vcmptrue_ussdb vcmptrue_ussdw vcmptrue_ussdl vcmptrue_ussdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpsd vcmpsdb vcmpsdw vcmpsdl vcmpsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeqss vcmpeqssb vcmpeqssw vcmpeqssl vcmpeqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpltss vcmpltssb vcmpltssw vcmpltssl vcmpltssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpless vcmplessb vcmplessw vcmplessl vcmplessq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunordss vcmpunordssb vcmpunordssw vcmpunordssl vcmpunordssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneqss vcmpneqssb vcmpneqssw vcmpneqssl vcmpneqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnltss vcmpnltssb vcmpnltssw vcmpnltssl vcmpnltssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnless vcmpnlessb vcmpnlessw vcmpnlessl vcmpnlessq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpordss vcmpordssb vcmpordssw vcmpordssl vcmpordssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_uqss vcmpeq_uqssb vcmpeq_uqssw vcmpeq_uqssl vcmpeq_uqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngess vcmpngessb vcmpngessw vcmpngessl vcmpngessq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngtss vcmpngtssb vcmpngtssw vcmpngtssl vcmpngtssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalsess vcmpfalsessb vcmpfalsessw vcmpfalsessl vcmpfalsessq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_oqss vcmpneq_oqssb vcmpneq_oqssw vcmpneq_oqssl vcmpneq_oqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgess vcmpgessb vcmpgessw vcmpgessl vcmpgessq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgtss vcmpgtssb vcmpgtssw vcmpgtssl vcmpgtssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptruess vcmptruessb vcmptruessw vcmptruessl vcmptruessq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_osss vcmpeq_osssb vcmpeq_osssw vcmpeq_osssl vcmpeq_osssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmplt_oqss vcmplt_oqssb vcmplt_oqssw vcmplt_oqssl vcmplt_oqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmple_oqss vcmple_oqssb vcmple_oqssw vcmple_oqssl vcmple_oqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpunord_sss vcmpunord_sssb vcmpunord_sssw vcmpunord_sssl vcmpunord_sssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_usss vcmpneq_usssb vcmpneq_usssw vcmpneq_usssl vcmpneq_usssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnlt_uqss vcmpnlt_uqssb vcmpnlt_uqssw vcmpnlt_uqssl vcmpnlt_uqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnle_uqss vcmpnle_uqssb vcmpnle_uqssw vcmpnle_uqssl vcmpnle_uqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpord_sss vcmpord_sssb vcmpord_sssw vcmpord_sssl vcmpord_sssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpeq_usss vcmpeq_usssb vcmpeq_usssw vcmpeq_usssl vcmpeq_usssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpnge_uqss vcmpnge_uqssb vcmpnge_uqssw vcmpnge_uqssl vcmpnge_uqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpngt_uqss vcmpngt_uqssb vcmpngt_uqssw vcmpngt_uqssl vcmpngt_uqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpfalse_osss vcmpfalse_osssb vcmpfalse_osssw vcmpfalse_osssl vcmpfalse_osssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpneq_osss vcmpneq_osssb vcmpneq_osssw vcmpneq_osssl vcmpneq_osssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpge_oqss vcmpge_oqssb vcmpge_oqssw vcmpge_oqssl vcmpge_oqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpgt_oqss vcmpgt_oqssb vcmpgt_oqssw vcmpgt_oqssl vcmpgt_oqssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmptrue_usss vcmptrue_usssb vcmptrue_usssw vcmptrue_usssl vcmptrue_usssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcmpss vcmpssb vcmpssw vcmpssl vcmpssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcomisd vcomisdb vcomisdw vcomisdl vcomisdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcomiss vcomissb vcomissw vcomissl vcomissq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtdq2pd vcvtdq2pdb vcvtdq2pdw vcvtdq2pdl vcvtdq2pdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtdq2ps vcvtdq2psb vcvtdq2psw vcvtdq2psl vcvtdq2psq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtpd2dq vcvtpd2dqb vcvtpd2dqw vcvtpd2dql vcvtpd2dqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtpd2ps vcvtpd2psb vcvtpd2psw vcvtpd2psl vcvtpd2psq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtps2dq vcvtps2dqb vcvtps2dqw vcvtps2dql vcvtps2dqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtps2pd vcvtps2pdb vcvtps2pdw vcvtps2pdl vcvtps2pdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtsd2si vcvtsd2sib vcvtsd2siw vcvtsd2sil vcvtsd2siq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtsd2ss vcvtsd2ssb vcvtsd2ssw vcvtsd2ssl vcvtsd2ssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtsi2sd
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtsi2ss
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtss2sd vcvtss2sdb vcvtss2sdw vcvtss2sdl vcvtss2sdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvtss2si vcvtss2sib vcvtss2siw vcvtss2sil vcvtss2siq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvttpd2dq vcvttpd2dqb vcvttpd2dqw vcvttpd2dql vcvttpd2dqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvttps2dq vcvttps2dqb vcvttps2dqw vcvttps2dql vcvttps2dqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvttsd2si vcvttsd2sib vcvttsd2siw vcvttsd2sil vcvttsd2siq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vcvttss2si vcvttss2sib vcvttss2siw vcvttss2sil vcvttss2siq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vdivpd vdivpdb vdivpdw vdivpdl vdivpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vdivps vdivpsb vdivpsw vdivpsl vdivpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vdivsd vdivsdb vdivsdw vdivsdl vdivsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vdivss vdivssb vdivssw vdivssl vdivssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vdppd vdppdb vdppdw vdppdl vdppdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vdpps vdppsb vdppsw vdppsl vdppsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vextractf128 vextractf128b vextractf128w vextractf128l vextractf128q
syn keyword gasOpcode_SANDYBRIDGE_AVX	vextractps vextractpsb vextractpsw vextractpsl vextractpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vhaddpd vhaddpdb vhaddpdw vhaddpdl vhaddpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vhaddps vhaddpsb vhaddpsw vhaddpsl vhaddpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vhsubpd vhsubpdb vhsubpdw vhsubpdl vhsubpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vhsubps vhsubpsb vhsubpsw vhsubpsl vhsubpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vinsertf128 vinsertf128b vinsertf128w vinsertf128l vinsertf128q
syn keyword gasOpcode_SANDYBRIDGE_AVX	vinsertps vinsertpsb vinsertpsw vinsertpsl vinsertpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vlddqu vlddqub vlddquw vlddqul vlddquq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vldqqu vldqqub vldqquw vldqqul vldqquq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vlddqu vlddqub vlddquw vlddqul vlddquq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vldmxcsr vldmxcsrb vldmxcsrw vldmxcsrl vldmxcsrq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmaskmovdqu
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmaskmovps vmaskmovpsb vmaskmovpsw vmaskmovpsl vmaskmovpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmaskmovpd vmaskmovpdb vmaskmovpdw vmaskmovpdl vmaskmovpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmaxpd vmaxpdb vmaxpdw vmaxpdl vmaxpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmaxps vmaxpsb vmaxpsw vmaxpsl vmaxpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmaxsd vmaxsdb vmaxsdw vmaxsdl vmaxsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmaxss vmaxssb vmaxssw vmaxssl vmaxssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vminpd vminpdb vminpdw vminpdl vminpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vminps vminpsb vminpsw vminpsl vminpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vminsd vminsdb vminsdw vminsdl vminsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vminss vminssb vminssw vminssl vminssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovapd vmovapdb vmovapdw vmovapdl vmovapdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovaps vmovapsb vmovapsw vmovapsl vmovapsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovq vmovqb vmovqw vmovql vmovqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovd
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovd
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovddup vmovddupb vmovddupw vmovddupl vmovddupq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovdqa vmovdqab vmovdqaw vmovdqal vmovdqaq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovqqa vmovqqab vmovqqaw vmovqqal vmovqqaq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovdqa vmovdqab vmovdqaw vmovdqal vmovdqaq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovdqu vmovdqub vmovdquw vmovdqul vmovdquq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovqqu vmovqqub vmovqquw vmovqqul vmovqquq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovdqu vmovdqub vmovdquw vmovdqul vmovdquq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovhlps
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovhpd vmovhpdb vmovhpdw vmovhpdl vmovhpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovhps vmovhpsb vmovhpsw vmovhpsl vmovhpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovlhps
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovlpd vmovlpdb vmovlpdw vmovlpdl vmovlpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovlps vmovlpsb vmovlpsw vmovlpsl vmovlpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovmskpd vmovmskpdb vmovmskpdw vmovmskpdl vmovmskpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovmskps vmovmskpsb vmovmskpsw vmovmskpsl vmovmskpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovntdq vmovntdqb vmovntdqw vmovntdql vmovntdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovntqq vmovntqqb vmovntqqw vmovntqql vmovntqqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovntdq vmovntdqb vmovntdqw vmovntdql vmovntdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovntdqa vmovntdqab vmovntdqaw vmovntdqal vmovntdqaq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovntpd vmovntpdb vmovntpdw vmovntpdl vmovntpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovntps vmovntpsb vmovntpsw vmovntpsl vmovntpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovsd vmovsdb vmovsdw vmovsdl vmovsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovshdup vmovshdupb vmovshdupw vmovshdupl vmovshdupq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovsldup vmovsldupb vmovsldupw vmovsldupl vmovsldupq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovss vmovssb vmovssw vmovssl vmovssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovupd vmovupdb vmovupdw vmovupdl vmovupdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmovups vmovupsb vmovupsw vmovupsl vmovupsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmpsadbw vmpsadbwb vmpsadbww vmpsadbwl vmpsadbwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmulpd vmulpdb vmulpdw vmulpdl vmulpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmulps vmulpsb vmulpsw vmulpsl vmulpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmulsd vmulsdb vmulsdw vmulsdl vmulsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vmulss vmulssb vmulssw vmulssl vmulssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vorpd vorpdb vorpdw vorpdl vorpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vorps vorpsb vorpsw vorpsl vorpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpabsb vpabsbb vpabsbw vpabsbl vpabsbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpabsw vpabswb vpabsww vpabswl vpabswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpabsd vpabsdb vpabsdw vpabsdl vpabsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpacksswb vpacksswbb vpacksswbw vpacksswbl vpacksswbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpackssdw vpackssdwb vpackssdww vpackssdwl vpackssdwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpackuswb vpackuswbb vpackuswbw vpackuswbl vpackuswbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpackusdw vpackusdwb vpackusdww vpackusdwl vpackusdwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddb vpaddbb vpaddbw vpaddbl vpaddbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddw vpaddwb vpaddww vpaddwl vpaddwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddd vpadddb vpadddw vpadddl vpadddq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddq vpaddqb vpaddqw vpaddql vpaddqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddsb vpaddsbb vpaddsbw vpaddsbl vpaddsbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddsw vpaddswb vpaddsww vpaddswl vpaddswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddusb vpaddusbb vpaddusbw vpaddusbl vpaddusbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpaddusw vpadduswb vpaddusww vpadduswl vpadduswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpalignr vpalignrb vpalignrw vpalignrl vpalignrq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpand vpandb vpandw vpandl vpandq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpandn vpandnb vpandnw vpandnl vpandnq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpavgb vpavgbb vpavgbw vpavgbl vpavgbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpavgw vpavgwb vpavgww vpavgwl vpavgwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpblendvb vpblendvbb vpblendvbw vpblendvbl vpblendvbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpblendw vpblendwb vpblendww vpblendwl vpblendwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpestri vpcmpestrib vpcmpestriw vpcmpestril vpcmpestriq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpestrm vpcmpestrmb vpcmpestrmw vpcmpestrml vpcmpestrmq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpistri vpcmpistrib vpcmpistriw vpcmpistril vpcmpistriq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpistrm vpcmpistrmb vpcmpistrmw vpcmpistrml vpcmpistrmq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpeqb vpcmpeqbb vpcmpeqbw vpcmpeqbl vpcmpeqbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpeqw vpcmpeqwb vpcmpeqww vpcmpeqwl vpcmpeqwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpeqd vpcmpeqdb vpcmpeqdw vpcmpeqdl vpcmpeqdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpeqq vpcmpeqqb vpcmpeqqw vpcmpeqql vpcmpeqqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpgtb vpcmpgtbb vpcmpgtbw vpcmpgtbl vpcmpgtbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpgtw vpcmpgtwb vpcmpgtww vpcmpgtwl vpcmpgtwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpgtd vpcmpgtdb vpcmpgtdw vpcmpgtdl vpcmpgtdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpcmpgtq vpcmpgtqb vpcmpgtqw vpcmpgtql vpcmpgtqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermilpd vpermilpdb vpermilpdw vpermilpdl vpermilpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermiltd2pd vpermiltd2pdb vpermiltd2pdw vpermiltd2pdl vpermiltd2pdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermilmo2pd vpermilmo2pdb vpermilmo2pdw vpermilmo2pdl vpermilmo2pdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermilmz2pd vpermilmz2pdb vpermilmz2pdw vpermilmz2pdl vpermilmz2pdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermil2pd vpermil2pdb vpermil2pdw vpermil2pdl vpermil2pdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermilps vpermilpsb vpermilpsw vpermilpsl vpermilpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermiltd2ps vpermiltd2psb vpermiltd2psw vpermiltd2psl vpermiltd2psq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermilmo2ps vpermilmo2psb vpermilmo2psw vpermilmo2psl vpermilmo2psq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermilmz2ps vpermilmz2psb vpermilmz2psw vpermilmz2psl vpermilmz2psq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpermil2ps vpermil2psb vpermil2psw vpermil2psl vpermil2psq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vperm2f128 vperm2f128b vperm2f128w vperm2f128l vperm2f128q
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpextrb vpextrbb vpextrbw vpextrbl vpextrbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpextrw vpextrwb vpextrww vpextrwl vpextrwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpextrd vpextrdb vpextrdw vpextrdl vpextrdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpextrq vpextrqb vpextrqw vpextrql vpextrqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vphaddw vphaddwb vphaddww vphaddwl vphaddwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vphaddd vphadddb vphadddw vphadddl vphadddq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vphaddsw vphaddswb vphaddsww vphaddswl vphaddswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vphminposuw vphminposuwb vphminposuww vphminposuwl vphminposuwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vphsubw vphsubwb vphsubww vphsubwl vphsubwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vphsubd vphsubdb vphsubdw vphsubdl vphsubdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vphsubsw vphsubswb vphsubsww vphsubswl vphsubswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpinsrb vpinsrbb vpinsrbw vpinsrbl vpinsrbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpinsrw vpinsrwb vpinsrww vpinsrwl vpinsrwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpinsrd vpinsrdb vpinsrdw vpinsrdl vpinsrdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpinsrq vpinsrqb vpinsrqw vpinsrql vpinsrqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaddwd vpmaddwdb vpmaddwdw vpmaddwdl vpmaddwdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaddubsw vpmaddubswb vpmaddubsww vpmaddubswl vpmaddubswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaxsb vpmaxsbb vpmaxsbw vpmaxsbl vpmaxsbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaxsw vpmaxswb vpmaxsww vpmaxswl vpmaxswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaxsd vpmaxsdb vpmaxsdw vpmaxsdl vpmaxsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaxub vpmaxubb vpmaxubw vpmaxubl vpmaxubq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaxuw vpmaxuwb vpmaxuww vpmaxuwl vpmaxuwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmaxud vpmaxudb vpmaxudw vpmaxudl vpmaxudq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpminsb vpminsbb vpminsbw vpminsbl vpminsbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpminsw vpminswb vpminsww vpminswl vpminswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpminsd vpminsdb vpminsdw vpminsdl vpminsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpminub vpminubb vpminubw vpminubl vpminubq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpminuw vpminuwb vpminuww vpminuwl vpminuwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpminud vpminudb vpminudw vpminudl vpminudq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovmskb
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovsxbw vpmovsxbwb vpmovsxbww vpmovsxbwl vpmovsxbwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovsxbd vpmovsxbdb vpmovsxbdw vpmovsxbdl vpmovsxbdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovsxbq vpmovsxbqb vpmovsxbqw vpmovsxbql vpmovsxbqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovsxwd vpmovsxwdb vpmovsxwdw vpmovsxwdl vpmovsxwdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovsxwq vpmovsxwqb vpmovsxwqw vpmovsxwql vpmovsxwqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovsxdq vpmovsxdqb vpmovsxdqw vpmovsxdql vpmovsxdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovzxbw vpmovzxbwb vpmovzxbww vpmovzxbwl vpmovzxbwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovzxbd vpmovzxbdb vpmovzxbdw vpmovzxbdl vpmovzxbdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovzxbq vpmovzxbqb vpmovzxbqw vpmovzxbql vpmovzxbqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovzxwd vpmovzxwdb vpmovzxwdw vpmovzxwdl vpmovzxwdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovzxwq vpmovzxwqb vpmovzxwqw vpmovzxwql vpmovzxwqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmovzxdq vpmovzxdqb vpmovzxdqw vpmovzxdql vpmovzxdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmulhuw vpmulhuwb vpmulhuww vpmulhuwl vpmulhuwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmulhrsw vpmulhrswb vpmulhrsww vpmulhrswl vpmulhrswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmulhw vpmulhwb vpmulhww vpmulhwl vpmulhwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmullw vpmullwb vpmullww vpmullwl vpmullwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmulld vpmulldb vpmulldw vpmulldl vpmulldq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmuludq vpmuludqb vpmuludqw vpmuludql vpmuludqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpmuldq vpmuldqb vpmuldqw vpmuldql vpmuldqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpor vporb vporw vporl vporq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsadbw vpsadbwb vpsadbww vpsadbwl vpsadbwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpshufb vpshufbb vpshufbw vpshufbl vpshufbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpshufd vpshufdb vpshufdw vpshufdl vpshufdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpshufhw vpshufhwb vpshufhww vpshufhwl vpshufhwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpshuflw vpshuflwb vpshuflww vpshuflwl vpshuflwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsignb vpsignbb vpsignbw vpsignbl vpsignbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsignw vpsignwb vpsignww vpsignwl vpsignwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsignd vpsigndb vpsigndw vpsigndl vpsigndq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpslldq vpslldqb vpslldqw vpslldql vpslldqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsrldq vpsrldqb vpsrldqw vpsrldql vpsrldqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsllw vpsllwb vpsllww vpsllwl vpsllwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpslld vpslldb vpslldw vpslldl vpslldq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsllq vpsllqb vpsllqw vpsllql vpsllqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsraw vpsrawb vpsraww vpsrawl vpsrawq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsrad vpsradb vpsradw vpsradl vpsradq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsrlw vpsrlwb vpsrlww vpsrlwl vpsrlwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsrld vpsrldb vpsrldw vpsrldl vpsrldq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsrlq vpsrlqb vpsrlqw vpsrlql vpsrlqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vptest vptestb vptestw vptestl vptestq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubb vpsubbb vpsubbw vpsubbl vpsubbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubw vpsubwb vpsubww vpsubwl vpsubwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubd vpsubdb vpsubdw vpsubdl vpsubdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubq vpsubqb vpsubqw vpsubql vpsubqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubsb vpsubsbb vpsubsbw vpsubsbl vpsubsbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubsw vpsubswb vpsubsww vpsubswl vpsubswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubusb vpsubusbb vpsubusbw vpsubusbl vpsubusbq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpsubusw vpsubuswb vpsubusww vpsubuswl vpsubuswq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpckhbw vpunpckhbwb vpunpckhbww vpunpckhbwl vpunpckhbwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpckhwd vpunpckhwdb vpunpckhwdw vpunpckhwdl vpunpckhwdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpckhdq vpunpckhdqb vpunpckhdqw vpunpckhdql vpunpckhdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpckhqdq vpunpckhqdqb vpunpckhqdqw vpunpckhqdql vpunpckhqdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpcklbw vpunpcklbwb vpunpcklbww vpunpcklbwl vpunpcklbwq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpcklwd vpunpcklwdb vpunpcklwdw vpunpcklwdl vpunpcklwdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpckldq vpunpckldqb vpunpckldqw vpunpckldql vpunpckldqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpunpcklqdq vpunpcklqdqb vpunpcklqdqw vpunpcklqdql vpunpcklqdqq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vpxor vpxorb vpxorw vpxorl vpxorq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vrcpps vrcppsb vrcppsw vrcppsl vrcppsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vrcpss vrcpssb vrcpssw vrcpssl vrcpssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vrsqrtps vrsqrtpsb vrsqrtpsw vrsqrtpsl vrsqrtpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vrsqrtss vrsqrtssb vrsqrtssw vrsqrtssl vrsqrtssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vroundpd vroundpdb vroundpdw vroundpdl vroundpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vroundps vroundpsb vroundpsw vroundpsl vroundpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vroundsd vroundsdb vroundsdw vroundsdl vroundsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vroundss vroundssb vroundssw vroundssl vroundssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vshufpd vshufpdb vshufpdw vshufpdl vshufpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vshufps vshufpsb vshufpsw vshufpsl vshufpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsqrtpd vsqrtpdb vsqrtpdw vsqrtpdl vsqrtpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsqrtps vsqrtpsb vsqrtpsw vsqrtpsl vsqrtpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsqrtsd vsqrtsdb vsqrtsdw vsqrtsdl vsqrtsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsqrtss vsqrtssb vsqrtssw vsqrtssl vsqrtssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vstmxcsr vstmxcsrb vstmxcsrw vstmxcsrl vstmxcsrq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsubpd vsubpdb vsubpdw vsubpdl vsubpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsubps vsubpsb vsubpsw vsubpsl vsubpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsubsd vsubsdb vsubsdw vsubsdl vsubsdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vsubss vsubssb vsubssw vsubssl vsubssq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vtestps vtestpsb vtestpsw vtestpsl vtestpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vtestpd vtestpdb vtestpdw vtestpdl vtestpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vucomisd vucomisdb vucomisdw vucomisdl vucomisdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vucomiss vucomissb vucomissw vucomissl vucomissq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vunpckhpd vunpckhpdb vunpckhpdw vunpckhpdl vunpckhpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vunpckhps vunpckhpsb vunpckhpsw vunpckhpsl vunpckhpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vunpcklpd vunpcklpdb vunpcklpdw vunpcklpdl vunpcklpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vunpcklps vunpcklpsb vunpcklpsw vunpcklpsl vunpcklpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vxorpd vxorpdb vxorpdw vxorpdl vxorpdq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vxorps vxorpsb vxorpsw vxorpsl vxorpsq
syn keyword gasOpcode_SANDYBRIDGE_AVX	vzeroall
syn keyword gasOpcode_SANDYBRIDGE_AVX	vzeroupper

"-- Section: AMD Enhanced 3DNow! (Athlon) instructions
syn keyword gasOpcode_PENT_3DNOW	pf2iw pf2iwb pf2iww pf2iwl pf2iwq
syn keyword gasOpcode_PENT_3DNOW	pfnacc pfnaccb pfnaccw pfnaccl pfnaccq
syn keyword gasOpcode_PENT_3DNOW	pfpnacc pfpnaccb pfpnaccw pfpnaccl pfpnaccq
syn keyword gasOpcode_PENT_3DNOW	pi2fw pi2fwb pi2fww pi2fwl pi2fwq
syn keyword gasOpcode_PENT_3DNOW	pswapd pswapdb pswapdw pswapdl pswapdq

"-- Section: Penryn New Instructions (SSE4.1)
syn keyword gasOpcode_SSE41		blendpd blendpdb blendpdw blendpdl blendpdq
syn keyword gasOpcode_SSE41		blendps blendpsb blendpsw blendpsl blendpsq
syn keyword gasOpcode_SSE41		blendvpd blendvpdb blendvpdw blendvpdl blendvpdq
syn keyword gasOpcode_SSE41		blendvps blendvpsb blendvpsw blendvpsl blendvpsq
syn keyword gasOpcode_SSE41		dppd dppdb dppdw dppdl dppdq
syn keyword gasOpcode_SSE41		dpps dppsb dppsw dppsl dppsq
syn keyword gasOpcode_X64_SSE41		extractps extractpsb extractpsw extractpsl extractpsq
syn keyword gasOpcode_SSE41		insertps insertpsb insertpsw insertpsl insertpsq
syn keyword gasOpcode_SSE41		movntdqa movntdqab movntdqaw movntdqal movntdqaq
syn keyword gasOpcode_SSE41		mpsadbw mpsadbwb mpsadbww mpsadbwl mpsadbwq
syn keyword gasOpcode_SSE41		packusdw packusdwb packusdww packusdwl packusdwq
syn keyword gasOpcode_SSE41		pblendvb pblendvbb pblendvbw pblendvbl pblendvbq
syn keyword gasOpcode_SSE41		pblendw pblendwb pblendww pblendwl pblendwq
syn keyword gasOpcode_SSE41		pcmpeqq pcmpeqqb pcmpeqqw pcmpeqql pcmpeqqq
syn keyword gasOpcode_X64_SSE41		pextrb pextrbb pextrbw pextrbl pextrbq
syn keyword gasOpcode_SSE41		pextrd pextrdb pextrdw pextrdl pextrdq
syn keyword gasOpcode_X64_SSE41		pextrq pextrqb pextrqw pextrql pextrqq
syn keyword gasOpcode_X64_SSE41		pextrw pextrwb pextrww pextrwl pextrwq
syn keyword gasOpcode_SSE41		phminposuw phminposuwb phminposuww phminposuwl phminposuwq
syn keyword gasOpcode_SSE41		pinsrb pinsrbb pinsrbw pinsrbl pinsrbq
syn keyword gasOpcode_SSE41		pinsrd pinsrdb pinsrdw pinsrdl pinsrdq
syn keyword gasOpcode_X64_SSE41		pinsrq pinsrqb pinsrqw pinsrql pinsrqq
syn keyword gasOpcode_SSE41		pmaxsb pmaxsbb pmaxsbw pmaxsbl pmaxsbq
syn keyword gasOpcode_SSE41		pmaxsd pmaxsdb pmaxsdw pmaxsdl pmaxsdq
syn keyword gasOpcode_SSE41		pmaxud pmaxudb pmaxudw pmaxudl pmaxudq
syn keyword gasOpcode_SSE41		pmaxuw pmaxuwb pmaxuww pmaxuwl pmaxuwq
syn keyword gasOpcode_SSE41		pminsb pminsbb pminsbw pminsbl pminsbq
syn keyword gasOpcode_SSE41		pminsd pminsdb pminsdw pminsdl pminsdq
syn keyword gasOpcode_SSE41		pminud pminudb pminudw pminudl pminudq
syn keyword gasOpcode_SSE41		pminuw pminuwb pminuww pminuwl pminuwq
syn keyword gasOpcode_SSE41		pmovsxbw pmovsxbwb pmovsxbww pmovsxbwl pmovsxbwq
syn keyword gasOpcode_SSE41		pmovsxbd pmovsxbdb pmovsxbdw pmovsxbdl pmovsxbdq
syn keyword gasOpcode_SSE41		pmovsxbq pmovsxbqb pmovsxbqw pmovsxbql pmovsxbqq
syn keyword gasOpcode_SSE41		pmovsxwd pmovsxwdb pmovsxwdw pmovsxwdl pmovsxwdq
syn keyword gasOpcode_SSE41		pmovsxwq pmovsxwqb pmovsxwqw pmovsxwql pmovsxwqq
syn keyword gasOpcode_SSE41		pmovsxdq pmovsxdqb pmovsxdqw pmovsxdql pmovsxdqq
syn keyword gasOpcode_SSE41		pmovzxbw pmovzxbwb pmovzxbww pmovzxbwl pmovzxbwq
syn keyword gasOpcode_SSE41		pmovzxbd pmovzxbdb pmovzxbdw pmovzxbdl pmovzxbdq
syn keyword gasOpcode_SSE41		pmovzxbq pmovzxbqb pmovzxbqw pmovzxbql pmovzxbqq
syn keyword gasOpcode_SSE41		pmovzxwd pmovzxwdb pmovzxwdw pmovzxwdl pmovzxwdq
syn keyword gasOpcode_SSE41		pmovzxwq pmovzxwqb pmovzxwqw pmovzxwql pmovzxwqq
syn keyword gasOpcode_SSE41		pmovzxdq pmovzxdqb pmovzxdqw pmovzxdql pmovzxdqq
syn keyword gasOpcode_SSE41		pmuldq pmuldqb pmuldqw pmuldql pmuldqq
syn keyword gasOpcode_SSE41		pmulld pmulldb pmulldw pmulldl pmulldq
syn keyword gasOpcode_SSE41		ptest ptestb ptestw ptestl ptestq
syn keyword gasOpcode_SSE41		roundpd roundpdb roundpdw roundpdl roundpdq
syn keyword gasOpcode_SSE41		roundps roundpsb roundpsw roundpsl roundpsq
syn keyword gasOpcode_SSE41		roundsd roundsdb roundsdw roundsdl roundsdq
syn keyword gasOpcode_SSE41		roundss roundssb roundssw roundssl roundssq

"-- Section: AMD SSE4A
syn keyword gasOpcode_AMD_SSE4A		extrq
syn keyword gasOpcode_AMD_SSE4A		insertq
syn keyword gasOpcode_AMD_SSE4A		movntsd movntsdb movntsdw movntsdl movntsdq
syn keyword gasOpcode_AMD_SSE4A		movntss movntssb movntssw movntssl movntssq


" links
hi def link gasDirectiveX86	gasDirective
hi def link gasRegisterX86	gasRegister
hi def link gasRegisterX86Cr	gasRegister
hi def link gasRegisterX86Dr	gasRegister
hi def link gasRegisterX86MMX	gasRegister

" link to defaults
hi def link gasDirective	Preproc
hi def link gasDirectiveStore	Type
hi def link gasDirectiveMacro	Macro
hi def link gasRegister		Identifier
hi def link gasString		String
hi def link gasCharacter	Character
hi def link gasBinaryNumber	Constant
hi def link gasOctalNumber	Constant
hi def link gasHexNumber	Constant
hi def link gasDecimalNumber	Constant
hi def link gasSymbol		Function
hi def link gasSymbolRef	Special
hi def link gasSpecial		Special
hi def link gasLabel		Function
hi def link gasLocalLabel	Label
hi def link gasOperator		Operator
hi def link gasOpcode		Keyword
hi def link gasComment		Comment
hi def link gasCommentSingle	Comment

"-- initial mapping => Keyword
func! s:MapOpcode (group, cpu, ext)
	let himap = 'Keyword'

	if exists('g:gasDisableOpcodes')
		if index(split(g:gasDisableOpcodes), a:cpu) != -1
			let himap = 'Error'
		endif
		if index(split(g:gasDisableOpcodes), a:ext) != -1
			let himap = 'Error'
		endif
	endif

	if exists('b:gasDisableOpcodes')
		if index(split(b:gasDisableOpcodes), a:cpu) != -1
			let himap = 'Error'
		endif
		if index(split(b:gasDisableOpcodes), a:ext) != -1
			let himap = 'Error'
		endif
	endif

	exe 'hi link '.a:group.' '.himap
endf

call <SID>MapOpcode('gasOpcode_186_Base'       , '186'        , 'base')
call <SID>MapOpcode('gasOpcode_286_Base'       , '286'        , 'base')
call <SID>MapOpcode('gasOpcode_3862_Base'      , '3862'       , 'base')
call <SID>MapOpcode('gasOpcode_386_Base'       , '386'        , 'base')
call <SID>MapOpcode('gasOpcode_486_Base'       , '486'        , 'base')
call <SID>MapOpcode('gasOpcode_8086_Base'      , '8086'       , 'base')
call <SID>MapOpcode('gasOpcode_AMD_SSE4A'      , 'amd'        , 'sse4a')
call <SID>MapOpcode('gasOpcode_AMD_SSE5'       , 'amd'        , 'sse5')
call <SID>MapOpcode('gasOpcode_FUTURE_FMA'     , 'future'     , 'fma')
call <SID>MapOpcode('gasOpcode_IA64_Base'      , 'ia64'       , 'base')
call <SID>MapOpcode('gasOpcode_KATMAI_Base'    , 'katmai'     , 'base')
call <SID>MapOpcode('gasOpcode_KATMAI_MMX'     , 'katmai'     , 'mmx')
call <SID>MapOpcode('gasOpcode_KATMAI_MMX2'    , 'katmai'     , 'mmx2')
call <SID>MapOpcode('gasOpcode_KATMAI_SSE'     , 'katmai'     , 'sse')
call <SID>MapOpcode('gasOpcode_NEHALEM_Base'   , 'nehalem'    , 'base')
call <SID>MapOpcode('gasOpcode_P6_Base'        , 'p6'         , 'base')
call <SID>MapOpcode('gasOpcode_P6_SSE'         , 'p6'         , 'sse')
call <SID>MapOpcode('gasOpcode_PENTM_Base'     , 'pentium_m'  , 'base')
call <SID>MapOpcode('gasOpcode_PENT_3DNOW'     , 'pentium'    , '3dnow')
call <SID>MapOpcode('gasOpcode_PENT_Base'      , 'pentium'    , 'base')
call <SID>MapOpcode('gasOpcode_PENT_MMX'       , 'pentium'    , 'mmx')
call <SID>MapOpcode('gasOpcode_PRESCOTT_Base'  , 'prescott'   , 'base')
call <SID>MapOpcode('gasOpcode_PRESCOTT_SSE3'  , 'prescott'   , 'sse3')
call <SID>MapOpcode('gasOpcode_SANDYBRIDGE_AVX', 'sandybridge', 'avx')
call <SID>MapOpcode('gasOpcode_X642_Base'      , 'x642'       , 'base')
call <SID>MapOpcode('gasOpcode_X64_Base'       , 'x64'        , 'base')
call <SID>MapOpcode('gasOpcode_X64_MMX'        , 'x64'        , 'mmx')
call <SID>MapOpcode('gasOpcode_X64_SSE'        , 'x64'        , 'sse')
call <SID>MapOpcode('gasOpcode_X64_SSE2'       , 'x64'        , 'sse2')
call <SID>MapOpcode('gasOpcode_X64_SSE41'      , 'x64'        , 'sse4.1')
call <SID>MapOpcode('gasOpcode_X64_SSE42'      , 'x64'        , 'sse4.2')
call <SID>MapOpcode('gasOpcode_X64_VMX'        , 'x64'        , 'vmx')
call <SID>MapOpcode('gasOpcode_X86_64_Base'    , 'x64'        , 'base')

" support CPP preprocessor tags
syn case match

syn include @cPP syntax/c.vim
syn match   cPPLineCont "\\$" contained

syn region  cPPPreProc start=/^\s*#\s*\(if\|else\|endif\|define\|include\)/ end=/$/ contains=@cPP,cPPLineCont


" finishing touches
let b:current_syntax = "gas"

syn sync ccomment
syn sync linebreaks=1

" vim: ts=8 sw=8 :

