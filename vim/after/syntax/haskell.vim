"=============================================================================
" What Is This: Add some conceal operator for your haskell files
" File:         haskell.vim (conceal enhancement)
" Author:       Vincent Berthoux <twinside@gmail.com>
" Last Change:  2010 aoû 14
" Version:      1.0
" Require:
"   set nocompatible
"     somewhere on your .vimrc
"
"   Vim 7.3 or Vim compiled with conceal patch
"
" Usage:
"   Drop this file in your
"       ~/.vim/after/syntax folder (Linux/MacOSX/BSD...)
"       ~/vimfiles/after/syntax folder (Windows)
"
" Additional:
"     * if you want to avoid the loading, add the following
"       line in your .vimrc :
"        let g:no_haskell_conceal = 1
"
if exists('g:no_haskell_conceal') || !has('conceal')
    finish
endif

syntax match hsNiceOperator "\\" conceal cchar=λ
syntax match hsNiceOperator "<-" conceal cchar=←
syntax match hsNiceOperator "->" conceal cchar=→
syntax match hsNiceOperator "<=" conceal cchar=≲
syntax match hsNiceOperator ">=" conceal cchar=≳
syntax match hsNiceOperator "==" conceal cchar=≡
syntax match hsNiceOperator "\/=" conceal cchar=≠
syntax match hsNiceOperator "=>" conceal cchar=⇒
syntax match hsNiceOperator ">>" conceal cchar=»
syntax match hsNiceOperator "\:\:" conceal cchar=∷
syntax match hsniceoperator "++" conceal cchar=⧺
syntax match hsNiceOperator "\<forall\>" conceal cchar=∀
    
" Only replace the dot, avoid taking spaces around.
syntax match hsNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘
syntax match hsNiceOperator "\.\." conceal cchar=‥

sy match hs_DeclareFunction /^[a-z_(]\S*\(\s\|\n\)*::/me=e-2 contains=hs_FunctionName,hs_OpFunctionName

syntax match hsNiceOperator "\<sum\>" conceal cchar=∑
syntax match hsNiceOperator "\<product\>" conceal cchar=∏ 
syntax match hsNiceOperator "\<sqrt\>" conceal cchar=√ 
syntax match hsNiceOperator "\<pi\>" conceal cchar=π


hi link hsNiceOperator Operator
hi! link Conceal Operator
set conceallevel=2

