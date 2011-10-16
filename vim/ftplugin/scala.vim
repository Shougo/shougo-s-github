
" For javadoc.
setlocal iskeyword+=@-@

setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.scala
setlocal suffixes+=.class
setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/
setlocal commentstring=//%s
setlocal formatoptions-=t formatoptions+=croql
setlocal dict=$DOTVIM/dict/java.dict,$DOTVIM/dict/scala.dict

