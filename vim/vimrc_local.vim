if exists('g:loaded_vimrc_local')
  finish
endif

let g:loaded_vimrc_local = 1
for dir in filter(split(glob('*'), '\n'),
      \ "isdirectory(v:val) && (glob(v:val.'/*/*.vim') != ''
      \  || glob(v:val.'/*/*/*.vim') != '')")
  let base = fnamemodify(dir, ':t')
  let dir = fnamemodify(dir, ':p')[: -2]
  let after = dir . '/after'
  execute 'set rtp^='.fnameescape(dir)
  if isdirectory(after)
    execute 'set rtp+='.fnameescape(after)
  endif

  augroup vimrc-local-dev-plugin
    execute 'autocmd SourcePre */' . base . '/*/plugin/*.vim'
          \  'unlet! g:loaded_{expand("<afile>:p:r:s?.*/plugin/??:gs?[/\\\\]?_?")}'
  augroup END
endfor

