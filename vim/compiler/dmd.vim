" Vim compiler file
" Compiler:		dmd - DigitalMars D compiler
" Maintainer: huangliang (solotony@sohu.com) 
" Last Change: 06-Dec-2008.5 

if exists("current_compiler")
  finish
endif
let current_compiler = "dmd"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

if filereadable("dsss.conf")
    " exists dsss.conf
    CompilerSet makeprg=dsss\ build
else
    CompilerSet makeprg=dmd\ %\ -quiet\ -w\ -of%<
endif
"CompilerSet makeprg=build\ --info\ -silent\ %<
CompilerSet errorformat=
            \%E%f(%l):\ %m,
            \%Wwarning\ -\ %f\|%l\|:\ %m,
