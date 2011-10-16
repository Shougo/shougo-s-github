" Vim indent file
" Language:     Coq
" Maintainer: 	Vincent Aravantinos <vincent.aravantinos@gmail.com>
" Thanks:       Some functions were inspired by the ocaml indent file
"               written by Jean-Francois Yuen, Mike Leary and Markus Mottl
" Last Change: 2007 Dec 2  - Bugfix.
"              2007 Nov 28 - Handle proofs that do not start with 'Proof'.
"              2007 Nov 27 - Initial version. 

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal expandtab
setlocal indentexpr=GetCoqIndent()
setlocal indentkeys=o,O,0=.,0=end,0=End,0=in,0=\|,0=Qed,0=Defined,0=Abort,0=Admitted,0},0)
setlocal nolisp
setlocal nosmartindent

" Comment handling
if !exists("no_coq_comments")
  if (has("comments"))
    setlocal comments=srn:(*,mb:*,exn:*)
    setlocal fo=cqort
  endif
endif

" Only define the function once.
if exists("*GetCoqIndent")
  finish
endif

let s:inside_proof = 0

" Some useful patterns
let s:vernac = '\C\<\%(Abort\|About\|Add\|Admitted\|Arguments\|Axiom\|Back\|Bind\|Canonical\|Cd\|Check\|Close\|Coercion\|CoFixpoint\|CoInductive\|Combined\|Conjecture\|Corollary\|Declare\|Defined\|Definition\|Delimit\|Derive\|Drop\|End\|Eval\|Example\|Existential\|Export\|Extract\|Extraction\|Fact\|Fixpoint\|Focus\|Function\|Functional\|Goal\|Hint\|Hypothes[ie]s\|Identity\|Implicit\|Import\|Inductive\|Infix\|Inspect\|Lemma\|Let\|Load\|Locate\|Ltac\|Module\|Mutual\|Notation\|Opaque\|Open\|Parameters\=\|Print\|Program\|Proof\|Proposition\|Pwd\|Qed\|Quit\|Record\|Recursive\|Remark\|Remove\|Require\|Reserved\|Reset\|Restart\|Restore\|Resume\|Save\|Scheme\|Search\%(About\|Pattern\|Rewrite\)\=\|Section\|Set\|Show\|Structure\|SubClass\|Suspend\|Tactic\|Test\|Theorem\|Time\|Transparent\|Undo\|Unfocus\|Unset\|Variables\?\|Whelp\|Write\)\>'
let s:tactic = '\C\<\%(absurd\|apply\|assert\|assumption\|auto\|case_eq\|change\|clear\%(body\)\?\|cofix\|cbv\|compare\|compute\|congruence\|constructor\|contradiction\|cut\%(rewrite\)\?\|decide\|decompose\|dependant\|destruct\|discriminate\|do\|double\|eapply\|eassumption\|econstructor\|elim\%(type\)\?\|equality\|evar\|exact\|eexact\|exists\|f_equal\|fold\|functional\|generalize\|hnf\|idtac\|induction\|info\|injection\|instantiate\|intros\?\|intuition\|inversion\%(_clear\)\?\|lapply\|left\|move\|omega\|pattern\|pose\|proof\|quote\|red\|refine\|reflexivity\|rename\|repeat\|replace\|revert\|rewrite\|right\|ring\|set\|simple\?\|simplify_eqsplit\|split\|subst\|stepl\|stepr\|symmetry\|transitivity\|trivial\|try\|unfold\|vm_compute'

    " Skipping pattern, for comments
    " (stolen from indent/ocaml.vim, thanks to the authors)
    function s:GetLineWithoutFullComment(lnum)
      let lnum = prevnonblank(a:lnum - 1)
      let previousline = substitute(getline(lnum), '(\*.*\*)\s*$', '', '')
      while previousline =~ '^\s*$' && lnum > 0
        let lnum = prevnonblank(lnum - 1)
        let previousline = substitute(getline(lnum), '(\*.*\*)\s*$', '', '')
      endwhile
      return lnum
    endfunction

    " Indent of a previous match
    function s:indent_of_previous(patt)
      return indent(search(a:patt, 'bW'))
    endfunction

    " Indent pairs
    function s:indent_of_previous_pair(pstart, pmid, pend)
      call search(a:pend, 'bW')
      return indent(searchpair(a:pstart, a:pmid, a:pend, 'bWn', 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"'))
    endfunction

    " Main function
    function GetCoqIndent()
      " Find a non-commented currentline above the current currentline.
      let lnum = s:GetLineWithoutFullComment(v:lnum)

      " At the start of the file use zero indent.
      if lnum == 0
        return 0
      endif

      let ind = indent(lnum)
      let previousline = substitute(getline(lnum), '(\*.*\*)\s*$', '', '')

      let currentline = getline(v:lnum)

      " current line begins with '.':
      if currentline =~ '^\s*\.'
        return s:indent_of_previous(s:vernac)

        " current line begins with 'end':
      elseif currentline =~ '\C^\s*end\>'
        return s:indent_of_previous_pair('\<match\>', '','\<end\>')

        " current line begins with 'in':
      elseif currentline =~ '^\s*\<in\>'
        return s:indent_of_previous_pair('\<let\>', '','\<in\>')

        " current line begins with '|':
      elseif currentline =~ '^\s*|'
        return ind
        
        " start of proof
      elseif previousline =~ '^\s*Proof\.$'
        let s:inside_proof = 1
        return ind + &sw

        " end of proof
      elseif currentline =~ '^\s*}'
        return s:indent_of_previous_pair('{','','}')
      elseif currentline =~ '^\s*)'
        return s:indent_of_previous_pair('(','',')')
      elseif currentline =~ '\<\%(Qed\|Defined\|Abort\|Admitted\)\>'
        let s:inside_proof = 0
        return s:indent_of_previous(s:vernac.'\&\%(\<\%(Qed\|Defined\|Abort\|Admitted\)\>\)\@!')

        " previous line begins with 'Section':
      elseif previousline =~ '^\s*Section\>'
        return ind + &sw

        " current line begins with 'End':
      elseif currentline =~ '^\s*End\>'
        return ind - &sw

        " previous line has the form '|...'
      elseif previousline =~ '|\%(.\%(\.\|end\)\@!\)*$'
        return ind + &sw + &sw

        " unterminated vernacular sentences
      elseif previousline =~ s:vernac.'.*[^.]$' && previousline !~ '^\s*$'
        return ind + &sw

        " back to normal indent after lines ending with '.'
      elseif previousline =~ '\.$'
        if (synIDattr(synID(line('.')-1,col('.'),0),"name") =~? '\cproof\|tactic')
          return ind
        else
          return s:indent_of_previous(s:vernac)
        endif

        " previous line ends with 'with'
      elseif previousline =~ '\<with$'
        return ind + &sw

        " unterminated 'let ... in'
      elseif previousline =~ '\<let\>\%(.\%(\<in\>\)\@!\)*$'
        return ind + &sw

        " else
      else
        return ind
      endif
    endfunction

    " vim:sw=2
