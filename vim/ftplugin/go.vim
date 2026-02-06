if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t
setlocal formatprg=gofmt

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab softtabstop=0 shiftwidth=0

let b:undo_ftplugin = 'setl fo< com< cms< fp<'
let b:undo_ftplugin .= ' | setl et< sts< sw<'
