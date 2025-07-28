let $CACHE = '~/.cache'->expand()
if !$CACHE->isdirectory()
  call mkdir($CACHE, 'p')
endif

function DppInitPlugin(plugin)
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
call DppInitPlugin('Shougo/dpp.vim')
call DppInitPlugin('Shougo/dpp-ext-lazy')

" For denops local server.
"let g:denops_server_addr = '127.0.0.1:32123'

"---------------------------------------------------------------------------
" dpp configurations.

" Set dpp base path (required)
const s:dpp_base = '~/.cache/dpp'->expand()

let $BASE_DIR = '<script>:h'->expand()

function DppMakeState()
  call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp.ts'->expand())
endfunction

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
    call DppInitPlugin(s:plugin)
  endfor

  " NOTE: Manual load is needed for Neovim
  " Because "--noplugin" is used to optimize.
  if has('nvim')
    runtime! plugin/denops.vim
  endif

  autocmd MyAutoCmd User DenopsReady
        \ : echohl WarningMsg
        \ | echomsg 'dpp load_state() is failed'
        \ | echohl NONE
        \ | call DppMakeState()
else
  autocmd MyAutoCmd BufWritePost *.lua,*.vim,*.toml,*.ts,vimrc,.vimrc
        \ call dpp#check_files()

  " Check new plugins
  autocmd MyAutoCmd BufWritePost *.toml
        \ : if !dpp#sync_ext_action('installer', 'getNotInstalled')->empty()
        \ |  call dpp#async_ext_action('installer', 'install')
        \ | endif
endif

autocmd MyAutoCmd User Dpp:makeStatePost
      \ : echohl WarningMsg
      \ | echomsg 'dpp make_state() is done'
      \ | echohl NONE
