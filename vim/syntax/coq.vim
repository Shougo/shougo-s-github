" Vim syntax file
" Language:     Coq
" Filenames:    *.v
" Maintainer:  Vincent Aravantinos <vincent.aravantinos@gmail.com>
" Last Change: 2008 Dec 02 - Added the Program and Obligation constructions (in Coq v8.2) - with Serge Leblanc.
"              2008 Jan 30 - Applied the improvments for all constructions, added 'with' and 'where' for
"                            fixpoints and inductives, fixed some hard long standing bugs.
"              2008 Jan 27 - Changed the way things are coloured, improved the efficiency of colouring.
"              2008 Jan 25 - Added Ltac, added Notations, bugfixes.
"              2007 Dec 1 - Added Record's.
"              2007 Nov 28 - Added things to reuse (in other plugins) the knowledge that we are inside a proof.
"              2007 Nov 19 - Fixed bug with comments.
"              2007 Nov 17 - Various minor bugfixes.
"              2007 Nov 8 - Added keywords.
"              2007 Nov 8 - Fixed some ill-highlighting in the type of declarations.
"              2007 Nov 8 - Fixed pb with keywords ("\<...\>" had been forgotten) 
"                           (thanks to Vasileios Koutavas)
"              2007 Nov 8 - Definition...Defined now works as expected, 
"                           fixed a bug with tactics that were not recognized,
"                           fixed other bugs
"              2007 Nov 7 - Complete refactoring, (much) more accurate highlighting. Much bigger file...
"              2007 Nov 7 - Added tactic colouration, added other keywords (thanks to Tom Harke)
"              2007 Nov 6 - Added "Defined" keyword (thanks to Serge Leblanc)
"              2007 Nov 5 - Initial version.
" License:     public domain
" TODO: mark bad constructions (eg. Section ended but not opened)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
 syntax clear
elseif exists("b:current_syntax") && b:current_syntax == "coq"
 finish
endif

" Coq is case sensitive.
syn case match

syn cluster coqVernac contains=coqRequire,coqCheck,coqEval,coqNotation,coqTacNotation,coqDecl,coqThm,coqLtacDecl,coqDef,coqFix,coqInd,coqRec,coqShow

" Various
syn match   coqError             "\S\+"
syn match   coqVernacPunctuation ":=\|\.\|:"
syn match   coqIdent             contained "[_[:alpha:]][_'[:alnum:]]*"
syn keyword coqTopLevel          Declare Module Type Canonical Structure Cd Coercion Derive Drop Existential
"...
syn keyword coqVernacCmd         Functional Scheme Back Combined
syn keyword coqFeedback          Show About Print

" Terms
syn cluster coqTerm            contains=coqKwd,coqTermPunctuation,coqKwdMatch,coqKwdLet,coqKwdParen
syn region coqKwdMatch         contained contains=@coqTerm matchgroup=coqKwd start="\<match\>" end="\<with\>"
syn region coqKwdLet           contained contains=@coqTerm matchgroup=coqKwd start="\<let\>"   end=":="
syn region coqKwdParen         contained contains=@coqTerm matchgroup=coqTermPunctuation start="(" end=")" keepend extend
syn keyword coqKwd             contained else end exists2 fix forall fun if in struct then
syn match   coqKwd             contained "\<where\>"
syn match   coqKwd             contained "\<exists!\?"
syn match   coqKwd             contained "|\|/\\\|\\/\|<->\|\~\|->\|=>\|{\|}\|&\|+\|-\|*\|=\|>\|<\|<="
syn match coqTermPunctuation   contained ":=\|:>\|:\|;\|,\|||\|\[\|\]\|@\|?\|\<_\>"

" Various
syn region coqRequire contains=coqString matchgroup=coqVernacCmd start="\<Require\>\%(\_s\+\%(Export\|Import\)\>\)\?" matchgroup=coqVernacPunctuation end="\.\_s"
syn region coqRequire matchgroup=coqVernacCmd start="\<Import\>" matchgroup=coqVernacPunctuation end="\.\_s"
syn region coqRequire matchgroup=coqVernacCmd start="\<Export\>" matchgroup=coqVernacPunctuation end="\.\_s"
syn region coqCheck   contains=@coqTerm matchgroup=coqVernacCmd start="\<Check\>" matchgroup=coqVernacPunctuation end="\.\_s"
syn region coqOpaque  matchgroup=coqVernacCmd start="\<\%(Opaque\|Transparent\)\>" matchgroup=coqVernacPunctuation end="\.\_s"
syn region coqShow       matchgroup=coqVernacCmd start="\<Show\_s\+\%(\%(Implicits\|Script\|Tree\|Proof\|Conjectures\|Intros\?\|Existentials\)\>\)\?" end="\.\_s"

" Sections
syn region coqSection contains=coqSection,@coqVernac matchgroup=coqVernacCmd start="\<Section\_s*\z(\S\+\)\_s*\.\_s" end="\<End\_s\+\z1\_s*\.\_s"

" Obligations
syn region coqObligation contains=coqIdent   matchgroup=coqVernacCmd start="\<\%(\%(\%(Admit\_s\+\)\?Obligations\)\|\%(Obligation\_s\+\d\+\)\|\%(Next\_s\+Obligation\)\|Preterm\)\%(\_s\+of\)\?\>" end="\.\_s"
syn region coqObligation contains=coqOblOf   matchgroup=coqVernacCmd start="\<Solve\_s\+Obligations\>" end="\.\_s" keepend
syn region coqOblOf      contains=coqIdent,coqOblUsing matchgroup=coqVernacCmd start="\<of\>" end="\.\_s" keepend
syn region coqObligation contains=coqOblUsing   matchgroup=coqVernacCmd start="\<Solve\_s\+All\_s\+Obligations\>" end="\.\_s" keepend
syn region coqOblUsing   contains=coqLtac   matchgroup=coqVernacCmd start="\<using\>" end="\.\_s"
syn region coqObligation contains=coqOblExpr matchgroup=coqVernacCmd start="\<Obligations\_s\+Tactic\>" end="\.\_s" keepend
syn region coqOblExpr    contains=coqLtac   matchgroup=coqVernacPunctuation start=":=" end="\.\_s"

" Scopes
syn region coqBind    contains=coqScope matchgroup=coqVernacCmd start="\<Bind\|Delimit\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqArgsScope contains=coqScope matchgroup=coqVernacCmd start="\<Arguments\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqOpen    contains=coqScope matchgroup=coqVernacCmd start="\<Open\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqClose   contains=coqScope,coqLocalScope matchgroup=coqVernacCmd start="\<Close\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqScope   contained matchgroup=coqVernacCmd start="\<Scope\>" end="\.\_s"
syn region coqLocalScope contained contains=coqScope matchgroup=coqVernacCmd start="\<Local\>" end="\.\_s"

" Hints
syn region coqHint contains=coqHintOption start="\<Hint\>" end="\.\_s" keepend
syn region coqHintOption start="\<\%(Resolve\|Immediate\|Constructors\|Unfold\|Extern\)\>" end="\.\_s"

" Add
syn region coqAdd       contains=coqAddOption,coqAddOption2 matchgroup=coqVernacCmd start="\<Add\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqAddOption         contained contains=coqAddPrintingOption matchgroup=coqVernacCmd start="\<Printing\>" end="\.\_s"
syn region coqAddPrintingOption contained matchgroup=coqVernacCmd start="\<\%(Let\|If\)\>" end="\.\_s"
syn region coqAddOption         contained contains=coqAddLegacyOption matchgroup=coqVernacCmd start="\<Legacy\>" end="\.\_s"
syn region coqAddLegacyOption   contained contains=coqAddRingOption,coqAddSemiRingOption matchgroup=coqVernacCmd start="\<Abstract\>" end="\.\_s"
syn region coqAddRingOption     contained matchgroup=coqVernacCmd start="\<Ring\>" end="\.\_s"
syn region coqAddSemiRingOption contained contains=coqAddRingOption matchgroup=coqVernacCmd start="\<Semi\>" end="\.\_s"
syn region coqAddLegacyOption   contained matchgroup=coqVernacCmd start="\<Field\>" end="\.\_s"
syn region coqAddOption         contained matchgroup=coqVernacCmd start="\<Field\>" end="\.\_s"
syn region coqAddOption         contained matchgroup=coqVernacCmd start="\<Relation\>" end="\.\_s"
syn region coqAddOption         contained matchgroup=coqVernacCmd start="\<Ring\>" end="\.\_s"
syn region coqAddOption         contained matchgroup=coqVernacCmd start="\<Setoid\>" end="\.\_s"
syn region coqAddOption         contained matchgroup=coqVernacCmd start="\<Morphism\>" end="\.\_s"
syn region coqAddOption         contained contains=coqAddOption2 matchgroup=coqVernacCmd start="\<Rec\>" end="\.\_s"
syn region coqAddOption2        contained contains=coqString matchgroup=coqVernacCmd start="\<LoadPath\>" end="\.\_s"
syn region coqAddOption2        contained contains=coqAddMLPath matchgroup=coqVernacCmd start="\<ML\>" end="\.\_s"
syn region coqAddMLPath         contained contains=coqString matchgroup=coqVernacCmd start="\<Path\>" end="\.\_s"

" Set
syn region coqSet       contains=coqSetOption matchgroup=coqVernacCmd start="\<Set\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqSetOption           contained contains=coqSetPrintingOption matchgroup=coqVernacCmd start="\<Printing\>" end="\.\_s"
syn region coqSetPrintingOption   contained matchgroup=coqVernacCmd start="\<\%(Coercions\|All\|Implicit\|Matching\|Notations\|Synth\|Universes\|Wildcard\)\>" end="\.\_s"
syn region coqSetPrintingOption   contained matchgroup=coqVernacCmd start="\<\%(Width\|Depth\)\>" end="\.\_s"
syn region coqSetPrintingOption   contained matchgroup=coqVernacCmd start="\<Coercion\>" end="\.\_s"
syn region coqSetOption           contained matchgroup=coqVernacCmd start="\<\%(Silent\|Virtual\_s\+Machine\)\>" end="\.\_s"
syn region coqSetOption           contained matchgroup=coqVernacCmd start="\<Undo\>" end="\.\_s"
syn region coqSetOption           contained matchgroup=coqVernacCmd start="\<Hyps\>" end="\.\_s"
syn region coqSetHypsOtion        contained matchgroup=coqVernacCmd start="\<Limit\>" end="\.\_s"
syn region coqSetOption           contained contains=coqContextOption matchgroup=coqVernacCmd start="\<\%(Contextual\|Strict\)\>" end="\.\_s"
syn region coqContextOption       contained matchgroup=coqVernacCmd start="\<Implicit\>" end="\.\_s"
syn region coqSetOption           contained contains=coqExtractOption matchgroup=coqVernacCmd start="\<Extraction\>" end="\.\_s"
syn region coqExtractOption       contained matchgroup=coqVernacCmd start="\<\%(AutoInline\|Optimize\)\>" end="\.\_s"
syn region coqSetOption           contained contains=coqSetFirstorderOption matchgroup=coqVernacCmd start="\<Firstorder\>" end="\.\_s"
syn region coqSetFirstorderOption contained matchgroup=coqVernacCmd start="\<Depth\>" end="\.\_s"
syn region coqSetOption           contained contains=coqImplicitOption matchgroup=coqVernacCmd start="\<Implicit\>" end="\.\_s"
syn region coqImplicitOption      contained matchgroup=coqVernacCmd start="\<Arguments\>" end="\.\_s"
syn region coqSetOption           contained contains=coqLtacOption matchgroup=coqVernacCmd start="\<Ltac\>" end="\.\_s"
syn region coqLtacOption          contained matchgroup=coqVernacCmd start="\<Debug\>" end="\.\_s"
syn region coqSetOption           contained contains=coqLtacOption matchgroup=coqVernacCmd start="\<Transparent\_s\+Obligations\>" end="\.\_s"

" Unset
syn region coqUnset       contains=coqUnsetOption matchgroup=coqVernacCmd start="\<Unset\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqUnsetOption           contained contains=coqUnsetPrintingOption matchgroup=coqVernacCmd start="\<Printing\>" end="\.\_s"
syn region coqUnsetPrintingOption   contained matchgroup=coqVernacCmd start="\<\%(Coercions\?\|All\|Implicit\|Matching\|Notations\|Synth\|Universes\|Wildcard\|Width\|Depth\)\>" end="\.\_s"
syn region coqUnsetOption           contained matchgroup=coqVernacCmd start="\<\%(Silent\|Virtual\_s\+Machine\)\>" end="\.\_s"
syn region coqUnsetOption           contained matchgroup=coqVernacCmd start="\<Undo\>" end="\.\_s"
syn region coqUnsetOption           contained matchgroup=coqVernacCmd start="\<Hyps\>" end="\.\_s"
syn region coqUnsetHypsOtion        contained matchgroup=coqVernacCmd start="\<Limit\>" end="\.\_s"
syn region coqUnsetOption           contained contains=coqContextOption matchgroup=coqVernacCmd start="\<\%(Contextual\|Strict\)\>" end="\.\_s"
syn region coqContextOption         contained matchgroup=coqVernacCmd start="\<Implicit\>" end="\.\_s"
syn region coqUnsetOption           contained contains=coqExtractOption matchgroup=coqVernacCmd start="\<Extraction\>" end="\.\_s"
syn region coqExtractOption         contained matchgroup=coqVernacCmd start="\<\%(AutoInline\|Optimize\)\>" end="\.\_s"
syn region coqUnsetOption           contained contains=coqUnsetFirstorderOption matchgroup=coqVernacCmd start="\<Firstorder\>" end="\.\_s"
syn region coqUnsetFirstorderOption contained matchgroup=coqVernacCmd start="\<Depth\>" end="\.\_s"
syn region coqUnsetOption           contained contains=coqImplicitOption matchgroup=coqVernacCmd start="\<Implicit\>" end="\.\_s"
syn region coqImplicitOption        contained matchgroup=coqVernacCmd start="\<Arguments\>" end="\.\_s"
syn region coqUnsetOption           contained contains=coqLtacOption matchgroup=coqVernacCmd start="\<Ltac\>" end="\.\_s"
syn region coqLtacOption            contained matchgroup=coqVernacCmd start="\<Debug\>" end="\.\_s"

" Eval
syn region coqEval      contains=coqEvalTac matchgroup=coqVernacCmd start="\<Eval\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqEvalTac   contained contains=coqEvalIn matchgroup=coqTactic start="\<\%(\%(vm_\)\?compute\|red\|hnf\|simpl\|fold\)\>" end="\.\_s" keepend
syn region coqEvalTac   contained contains=coqEvalFlag,coqEvalIn matchgroup=coqTactic start="\<\%(cbv\|lazy\)\>" end="\.\_s"
syn keyword coqEvalFlag contained beta delta iota zeta
syn region coqEvalFlag  contained start="-\?\[" end="\]"
syn region coqEvalTac   contained contains=@coqTerm,coqEvalIn matchgroup=coqTactic start="\<\%(unfold\|pattern\)\>" end="\.\_s"
syn region coqEvalIn    contained contains=@coqTerm matchgroup=coqVernacCmd start="in" matchgroup=coqVernacPunctuation end="\.\_s"

" Notations
syn region coqNotation     contains=coqNotationDef start="\%(\%(\%(\<Reserved\>\_s*\)\?\<Notation\>\)\|\<Infix\>\)\(\_s*\<Local\>\)\?" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqNotationDef       contained contains=coqNotationString,coqNotationTerm matchgroup=coqVernacCmd start="\%(\%(\%(\<Reserved\>\_s*\)\?\<Notation\>\)\|\<Infix\>\)\(\_s*\<Local\>\)\?" end="\.\_s"
syn region coqNotationTerm      contained contains=coqNotationExpr matchgroup=coqVernacPunctuation start=":=" end="\.\_s"
syn region coqNotationExpr      contained contains=@coqTerm,coqNotationEndExpr matchgroup=coqTermPunctuation start="(" end="\.\_s"
syn region coqNotationEndExpr   contained contains=coqNotationFormat,coqNotationScope matchgroup=coqTermPunctuation start=")" end="\.\_s"
syn region coqNotationExpr      contained contains=@coqTerm,coqNotationFormat,coqNotationScope start="[^[:blank:](]" matchgroup=NONE end="\.\_s"
syn region coqNotationFormat    contained contains=coqNotationKwd,coqString,coqNotationEndFormat matchgroup=coqVernacPunctuation start="(" end="\.\_s"
syn region coqNotationEndFormat contained contains=coqNotationScope matchgroup=coqVernacPunctuation start=")" end="\.\_s"
syn region coqNotationScope     contained matchgroup=coqVernacPunctuation start=":" end="\.\_s"

syn match   coqNotationKwd contained "at \(next \)\?level"
syn match   coqNotationKwd contained "\(no\|left\|right\) associativity"
syn match   coqNotationKwd contained "only parsing"
syn match   coqNotationKwd contained "(\|,\|)\|:"
syn keyword coqNotationKwd contained ident global bigint format

syn region coqNotationString contained start=+"+ skip=+""+ end=+"+ extend

" Tactic notations
syn region coqTacNotation     contains=coqTacNotationDef start="\<Tactic\_s\+Notation\>" end="\.\_s" keepend
syn region coqTacNotationDef  contained contains=coqNotationString,coqTacNotationKwd,coqTacNotationTerm matchgroup=coqVernacCmd start="Tactic\_s\+Notation" end="\.\_s"
syn region coqTacNotationTerm contained contains=coqString,coqTactic,coqTacticKwd,coqLtac,coqProofPunctuation matchgroup=coqVernacPunctuation start=":=" end="\.\_s"

syn keyword coqTacNotationKwd contained ident simple_intropattern hyp reference constr integer int_or_var tactic
syn match   coqTacNotationKwd contained "at level"

" Declarations 
syn region coqDecl       contains=coqIdent,coqDeclTerm,coqDeclBinder matchgroup=coqVernacCmd start="\<\%(Axiom\|Conjecture\|Hypothes[ie]s\|Parameters\?\|Variables\?\)\>" matchgroup=coqVernacCmd end="\.\_s" keepend
syn region coqDeclBinder contained contains=coqIdent,coqDeclTerm matchgroup=coqVernacPunctuation start="(" end=")" keepend
syn region coqDeclTerm   contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end=")"
syn region coqDeclTerm   contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end="\.\_s"

" Theorems
syn region coqThm       contains=coqThmName matchgroup=coqVernacCmd start="\<\%(Program\_s\+\)\?\%(Theorem\|Lemma\|Example\|Corollary\)\>" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\.\_s" keepend
syn region coqThmName   contained contains=coqThmTerm,coqThmBinder matchgroup=coqIdent start="[_[:alpha:]][_'[:alnum:]]*" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\.\_s"
syn region coqThmTerm   contained contains=@coqTerm,coqProofBody matchgroup=coqVernacCmd start=":" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\>"
syn region coqThmBinder contained matchgroup=coqVernacPunctuation start="(" end=")" keepend

syn region coqGoal      contains=coqGoalTerm start="\<Goal\>" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\>" keepend
syn region coqGoalTerm  contained contains=@coqTerm,coqProofBody matchgroup=coqVernacCmd start="Goal" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\>" keepend

" Ltac
syn region coqLtacDecl     contains=coqLtacProfile start="\<Ltac\>" end="\.\_s" keepend
syn region coqLtacProfile  contained contains=coqLtacIdent,coqVernacPunctuation,coqLtacContents start="Ltac" end="\.\_s"
syn region coqLtacIdent    contained matchgroup=coqVernacCmd start="Ltac" matchgroup=coqIdent end="[_[:alpha:]][_'[:alnum:]]*"
syn region coqLtacContents contained contains=coqTactic,coqTacticKwd,coqLtac,coqProofPunctuation matchgroup=coqVernacPunctuation start=":=" end="\.\_s"

syn keyword coqLtac contained do info progress repeat try
syn keyword coqLtac contained abstract constr context end external eval fail first fresh fun goal
syn keyword coqLtac contained idtac in let ltac lazymatch match of rec reverse solve type with
syn match   coqLtac contained "|-\|=>\|||\|\[\|\]\|\<_\>\||"

" Proofs
syn region coqProofBody  contained contains=coqProofPunctuation,coqTactic,coqTacticKwd,coqProofComment,coqProofKwd,coqProofEnder,coqProofDelim,coqLtac matchgroup=coqVernacPunctuation start="\.\s" start="\.$" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\.\_s" end="\<Save\>.*\.\_s" keepend
syn region coqProofDelim contained matchgroup=coqProofDelim start="\<Proof\>" matchgroup=coqProofDot end="\.\_s"
syn region coqProofEnder contained matchgroup=coqProofDelim start="\<\%(Qed\|Defined\)\>" matchgroup=coqVernacPunctuation end="\.\_s"
syn region coqProofEnder contained matchgroup=coqError start="\<\%(Abort\|Admitted\)\>" matchgroup=coqVernacPunctuation end="\.\_s"
syn region coqProofEnder contained contains=coqIdent matchgroup=coqProofDelim start="\<Save\>" matchgroup=coqVernacPunctuation end="\.\_s"

syn keyword coqTactic    contained absurd apply assert assumption auto
syn keyword coqTactic    contained case[_eq] change clear[body] cofix cbv compare compute congruence constructor contradiction cut[rewrite]
syn keyword coqTactic    contained decide decompose dependant destruct discriminate double
syn keyword coqTactic    contained eapply eassumption econstructor elim[type] equality evar exact eexact exists
syn keyword coqTactic    contained fix f_equal fold functional generalize hnf
syn keyword coqTactic    contained idtac induction injection instantiate intro[s] intuition inversion[_clear]
syn keyword coqTactic    contained lapply left move omega pattern pose proof quote
syn keyword coqTactic    contained red refine reflexivity rename replace revert rewrite right ring
syn keyword coqTactic    contained set simpl[e] simplify_eq split subst stepl stepr symmetry
syn keyword coqTactic    contained transitivity trivial unfold vm_compute
syn keyword coqTacticKwd contained as by in using with into after until

  " The following is just to help other plugins to detect via syntax groups that we are inside a proof
syn keyword coqProofKwd         contained else end exists exists2 forall fun if in match let struct then where with
syn match   coqProofKwd         contained "|\|/\\\|\\/\|<->\|\~\|->\|=>\|{\|}\|&\|+\|="
syn match   coqProofPunctuation contained "(\|)\|:=\|:>\|:\|\.\|;\|,\|||\|\[\|\]\|@\|?"
syn region  coqProofComment     contained contains=coqProofComment,coqTodo start="(\*" end="\*)" extend keepend

" Definitions
syn region coqDef          contains=coqDefName matchgroup=coqVernacCmd start="\<\%(Program\_s\+\)\?\%(Definition\|Let\)\>" matchgroup=coqVernacPunctuation end=":="me=e-2 end="\.$"me=e-1 end="\.\s"me=e-2 nextgroup=coqDefContents1,coqProofBody keepend skipnl skipwhite skipempty
syn region coqDefName       contained contains=coqDefBinder,coqDefType,coqDefContents1 matchgroup=coqIdent start="[_[:alpha:]][_'[:alnum:]]*" matchgroup=NONE end="\.\_s" end=":="
syn region coqDefBinder     contained contains=coqDefBinderType matchgroup=coqVernacPunctuation start="(" end=")" keepend
syn region coqDefBinderType contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end=")"
syn region coqDefType       contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" matchgroup=NONE end="\.\_s" end=":="
syn region coqDefContents1  contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":=" matchgroup=coqVernacPunctuation end="\.\_s"

" Fixpoints
syn region coqFix     contains=coqFixBody start="\<\%(Program\_s\+\)\?\%(\%(\%(Co\)\?Fixpoint\)\|Fixpoint\|Function\)\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqFixBody       contained contains=coqFixName matchgroup=coqVernacCmd start="\%(\%(\%(Co\)\?Fixpoint\)\|Function\)" start="\<with\>" matchgroup=NONE end="\.\_s"
syn region coqFixName       contained contains=coqFixBinder,coqFixAnnot,coqFixTerm,coqFixContent matchgroup=coqIdent start="[_[:alpha:]][_'[:alnum:]]*" matchgroup=NONE end="\.\_s"
syn region coqFixBinder     contained contains=coqFixBinderType matchgroup=coqVernacPunctuation start="(" end=")" keepend
syn region coqFixBinderType contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end=")" keepend
syn region coqFixAnnot      contained contains=@coqTerm matchgroup=coqVernacPunctuation start="{\_s*struct" end="}" keepend
syn region coqFixTerm       contained contains=@coqTerm,coqFixContent matchgroup=coqVernacPunctuation start=":" end="\.\_s"
syn region coqFixContent    contained contains=coqFixBody,@coqTerm,coqKwdMatch,coqFixNot matchgroup=coqVernacPunctuation start=":=" end="\.\_s"
syn region coqFixNot        contained contains=coqNotationString,coqFixNotTerm matchgroup=coqVernacCmd start="\<where\>" end="\.\_s"
syn region coqFixNotTerm    contained contains=@coqTerm,coqFixBody,coqFixNotScope matchgroup=coqVernacPunctuation start=":=" end="\.\_s"
syn region coqFixNotScope   contained contains=coqFixBody matchgroup=coqVernacPunctuation start=":" end="\.\_s"

"Inductives
syn region coqInd            contains=coqIndBody start="\<\%(Co\)\?Inductive\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqIndBody     contained contains=coqIdent,coqIndTerm,coqIndBinder matchgroup=coqVernacCmd start="\%(Co\)\?Inductive" start="\<with\>" matchgroup=NONE end="\.\_s"
syn region coqIndBinder      contained contains=coqIndBinderTerm matchgroup=coqVernacPunctuation start="("  end=")" keepend
syn region coqIndBinderTerm  contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end=")"
syn region coqIndTerm        contained contains=@coqTerm,coqIndContent matchgroup=coqVernacPunctuation start=":" matchgroup=NONE end="\.\_s"
syn region coqIndContent     contained contains=coqIndConstructor start=":=" end="\.\_s"
syn region coqIndConstructor contained contains=coqConstructor,coqIndBinder,coqIndConsTerm,coqIndNot,coqIndBody matchgroup=coqVernacPunctuation start=":=\%(\_s*|\)\?" start="|" matchgroup=NONE end="\.\_s"
syn region coqIndConsTerm    contained contains=coqIndBody,@coqTerm,coqIndConstructor,coqIndNot matchgroup=coqConstructor start=":" matchgroup=NONE end="\.\_s"
syn region coqIndNot         contained contains=coqNotationString,coqIndNotTerm matchgroup=coqVernacCmd start="\<where\>" end="\.\_s"
syn region coqIndNotTerm     contained contains=@coqTerm,coqIndNotScope,coqIndBody matchgroup=coqVernacPunctuation start=":=" end="\.\_s"
syn region coqIndNotScope    contained contains=coqIndBody matchgroup=coqVernacPunctuation start=":" end="\.\_s"
syn match  coqConstructor    contained "[_[:alpha:]][_'[:alnum:]]*"

" Records
syn region coqRec        contains=coqRecProfile start="\<Record\>" matchgroup=coqVernacPunctuation end="\.\_s" keepend
syn region coqRecProfile contained contains=coqIdent,coqRecTerm,coqRecBinder matchgroup=coqVernacCmd start="Record" matchgroup=NONE end="\.\_s"
syn region coqRecBinder  contained contains=@coqTerm matchgroup=coqTermPunctuation start="("  end=")"
syn region coqRecTerm    contained contains=@coqTerm,coqRecContent matchgroup=coqVernacPunctuation start=":"  end="\.\_s"
syn region coqRecContent contained contains=coqConstructor,coqRecStart matchgroup=coqVernacPunctuation start=":=" end="\.\_s"
syn region coqRecStart   contained contains=coqRecField,@coqTerm start="{" matchgroup=coqVernacPunctuation end="}" keepend
syn region coqRecField   contained contains=coqField matchgroup=coqVernacPunctuation start="{" end=":"
syn region coqRecField   contained contains=coqField matchgroup=coqVernacPunctuation start=";" end=":"
syn match coqField       contained "[_[:alpha:]][_'[:alnum:]]*"

" Various (High priority)
syn region  coqComment           containedin=ALL contains=coqComment,coqTodo start="(\*" end="\*)" extend keepend
syn keyword coqTodo              contained TODO FIXME XXX NOTE
syn region  coqString            start=+"+ skip=+""+ end=+"+ extend

" Synchronization
syn sync minlines=50
syn sync maxlines=500

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_coq_syntax_inits")
 if version < 508
  let did_coq_syntax_inits = 1
  command -nargs=+ HiLink hi link <args>
 else
  command -nargs=+ HiLink hi def link <args>
 endif

 " PROOFS
 HiLink coqTactic                    Keyword
 HiLink coqLtac coqTactic
 HiLink coqProofKwd coqTactic
 HiLink coqProofPunctuation coqTactic
 HiLink coqTacticKwd coqTactic
 HiLink coqTacNotationKwd coqTactic
 HiLink coqEvalFlag coqTactic
 " Exception
 HiLink coqProofDot coqVernacular

 " PROOF DELIMITERS ("Proof", "Qed", "Defined", "Save")
 HiLink coqProofDelim                Underlined

 " TERMS AND TYPES
 HiLink coqTerm                      Type
 HiLink coqKwd             coqTerm
 HiLink coqTermPunctuation coqTerm

 " VERNACULAR COMMANDS
 HiLink coqVernacular                PreProc
 HiLink coqVernacCmd         coqVernacular
 HiLink coqVernacPunctuation coqVernacular
 HiLink coqHint              coqVernacular
 HiLink coqFeedback          coqVernacular
 HiLink coqTopLevel          coqVernacular

 " DEFINED OBJECTS
 HiLink coqIdent                     Identifier
 HiLink coqNotationString coqIdent

 " CONSTRUCTORS AND FIELDS
 HiLink coqConstructor               Keyword
 HiLink coqField coqConstructor

 " NOTATION SPECIFIC ("at level", "format", etc)
 HiLink coqNotationKwd               Special

 " USUAL VIM HIGHLIGHTINGS
   " Comments
   HiLink coqComment                   Comment
   HiLink coqProofComment coqComment

   " Todo
   HiLink coqTodo                      Todo

   " Errors
   HiLink coqError                     Error

   " Strings
   HiLink coqString                    String

 delcommand HiLink
endif

let b:current_syntax = "coq"
