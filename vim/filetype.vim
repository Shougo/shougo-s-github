" My filetype file.

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  " Scala
  autocmd BufRead,BufNewFile *.scala        setfiletype scala
  " Nemerle
  autocmd BufRead,BufNewfile *.n setf nemerle
  " Perl6
  autocmd BufRead,BufNewfile *.p6 setf perl6
  " Perl5
  autocmd BufRead,BufNewfile *.p5 setf perl
  " TeXEruby
  autocmd BufRead,BufNewFile *.tex.erb setfiletype tex.eruby

  " Filetype detect for Assembly Language.
  autocmd BufRead,BufNewFile *.asm set ft=masm syntax=masm
  autocmd BufRead,BufNewFile *.inc set ft=masm syntax=masm
  autocmd BufRead,BufNewFile *.[sS] set ft=gas syntax=gas
  autocmd BufRead,BufNewFile *.hla set ft=hla syntax=hla

  " Markdown
  autocmd BufRead,BufNewFile *.mkd,*.markdown,*.md,*.mdown,*.mkdn
        \ setlocal filetype=mkd autoindent formatoptions=tcroqn2 comments=n:>
augroup END

