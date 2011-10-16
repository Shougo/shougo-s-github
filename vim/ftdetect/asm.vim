" Filetype detect for Assembly Language.

autocmd BufRead,BufNewFile *.asm set ft=masm syntax=masm
autocmd BufRead,BufNewFile *.inc set ft=masm syntax=masm
autocmd BufRead,BufNewFile *.[sS] set ft=gas syntax=gas
autocmd BufRead,BufNewFile *.hla set ft=hla syntax=hla
