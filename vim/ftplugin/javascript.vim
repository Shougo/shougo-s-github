"" for spidermonkey
setlocal makeprg=smjs\ -w\ -s\ -C\ %
setlocal errorformat=%f:%l:%m
"
"" for rhino
" setlocal makeprg=rhino\ -w\ -strict\ -debug\ %
" setlocal errorformat="js: %f, line %l:%m"

" au BufWritePost <buffer> silent make
