let $CACHE = '~/.cache'->expand()
if !$CACHE->isdirectory()
  call mkdir($CACHE, 'p')
endif

function InitPlugin(plugin)
  " Search from ~/work directory
  let dir = '~/work/'->expand() .. a:plugin->fnamemodify(':t')
  if !dir->isdirectory()
    " Search from $CACHE directory
    let dir = $CACHE .. '/dpp/repos/github.com/' .. a:plugin
    if !dir->isdirectory()
      " Install plugin automatically.
      execute '!git clone https://github.com/' .. a:plugin dir
    endif
  endif

  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

" NOTE: dpp.vim path must be added
call InitPlugin('Shougo/dpp.vim')
call InitPlugin('Shougo/dpp-ext-lazy')


"---------------------------------------------------------------------------
" dpp configurations.

" Set dpp base path (required)
const s:dpp_base = '~/.cache/dpp'->expand()

let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')

if s:dpp_base->dpp#min#load_state()
  " NOTE: denops.vim and dpp plugins are must be added
  for s:plugin in [
        \   'Shougo/dpp-ext-installer',
        \   'Shougo/dpp-ext-local',
        \   'Shougo/dpp-ext-packspec',
        \   'Shougo/dpp-ext-toml',
        \   'Shougo/dpp-protocol-git',
        \   'vim-denops/denops.vim',
        \ ]
    call InitPlugin(s:plugin)
  endfor

  " NOTE: Manual load is needed for neovim
  " Because "--noplugin" is used to optimize.
  if has('nvim')
    runtime! plugin/denops.vim
  endif

  autocmd MyAutoCmd User DenopsReady
        \ : echohl WarningMsg
        \ | echomsg 'dpp load_state() is failed'
        \ | echohl NONE
        \ | call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp.ts'->expand())
else
  autocmd MyAutoCmd BufWritePost *.lua,*.vim,*.toml,*.ts,vimrc,.vimrc
        \ call dpp#check_files()
endif

autocmd MyAutoCmd User Dpp:makeStatePost
      \ : echohl WarningMsg
      \ | echomsg 'dpp make_state() is done'
      \ | echohl NONE
