" My filetype file.                                      

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  " Scala
  autocmd! BufRead,BufNewFile *.scala        setfiletype scala
  " Nemerle
  autocmd BufNewfile,BufRead *.n setf nemerle
  " Perl6
  autocmd BufNewfile,BufRead *.p6 setf perl6 
  " Perl5
  autocmd BufNewfile,BufRead *.p5 setf perl
  " TeXEruby
  autocmd BufRead,BufNewFile *.tex.erb setfiletype tex.eruby
augroup END

