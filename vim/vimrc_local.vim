if exists('g:loaded_vimrc_local')
  finish
endif
let g:loaded_vimrc_local = 1
for dir in filter(split(glob('*'), '\n'), 'isdirectory(v:val)')
  let base = fnamemodify(dir, ':t')
  let dir = fnamemodify(dir, ':p')[: -2]
  let &rtp = dir . ',' . &rtp . ',' . dir . '/after'
  
  augroup vimrc-local-dev-plugin
    execute 'autocmd SourcePre */' . base . '/*/plugin/*.vim'
          \       'unlet! g:loaded_{expand("<afile>:p:r:s?.*/plugin/??:gs?[/\\\\]?_?")}'
  augroup END
endfor
