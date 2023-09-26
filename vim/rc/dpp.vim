let $CACHE = '~/.cache'->expand()
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

" Install plugin manager automatically.
for s:plugin in [
      \ 'Shougo/dpp.vim',
      \ 'denops/denops.vim',
      \ ]->filter({ _, val ->
      \           &runtimepath !~# '/' .. val->fnamemodify(':t') })
  " Search from current directory
  let s:dir = 'dpp.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    " Search from $CACHE directory
    let s:dir = $CACHE .. '/dpp/repos/github.com/' .. s:plugin
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/' .. s:plugin s:dir
    endif
  endif

  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfor


"---------------------------------------------------------------------------
" dpp configurations.

" Set dpp base path (required)
const s:dpp_base = '~/.cache/dpp'

let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')


if dpp#min#load_state(s:dpp_base)
  autocmd User DenopsReady
        \ call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp.ts'->expand())
endif
