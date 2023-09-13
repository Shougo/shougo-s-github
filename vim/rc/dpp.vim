let $CACHE = '~/.cache'->expand()
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

" Install plugin manager automatically.
for s:plugin in [
      \ 'Shougo/dpp.vim',
      \ ]->filter({ _, val -> &runtimepath !~# '/' .. val })
  " Search from current directory
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    " Search from $CACHE directory
    let s:dir = $CACHE .. '/dein/repos/github.com/' .. s:plugin
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
const s:dpp_base = '~/.cache/dpp/'

let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')

autocmd User DenopsReady
      \ call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp.ts'->expand())
