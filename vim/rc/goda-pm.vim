let s:cache = '~/.cache'->expand()
if !s:cache->isdirectory()
  call mkdir(s:cache, 'p')
endif

function GodaPmInitPlugin(plugin)
  " Search from ~/work directory
  let dir = '~/work/'->expand() .. a:plugin->fnamemodify(':t')
  if !dir->isdirectory()
    " Search from s:cache directory
    let dir = s:cache .. '/goda-pm/repos/github.com/' .. a:plugin
    if !dir->isdirectory()
      " Install plugin automatically.
      execute '!git clone
            \ (https://github.com/' .. a:plugin)->shellescape()
            \ dir->shellescape()
    endif
  endif

  if !dir->isdirectory()
    throw printf('Plugin directory was not created: %s', dir)
  endif

  const runtime_dir = dir->fnamemodify(':p')
        \ ->substitute('[/\\]$', '', '')

  execute 'set runtimepath^=' .. fnameescape(runtime_dir)
endfunction

" NOTE: goda-pm.vim path must be added
call GodaPmInitPlugin('Shougo/goda-pm.vim')

"---------------------------------------------------------------------------
" goda-pm configurations.

" Set goda-pm base path (required)
const s:goda_pm_base = '~/.cache/goda-pm'->expand()

let $BASE_DIR = '<script>:h'->expand()

" The configuration (main.go) lives with your dotfiles
let g:goda_pm#config_dir = '$BASE_DIR/goda-pm'->expand()

if s:goda_pm_base->goda_pm#min#load_state()
  " NOTE: goda.vim and goda-pm-ext-lazy.vim is needed to make the state
  call GodaPmInitPlugin('Shougo/goda.vim')
  call GodaPmInitPlugin('Shougo/goda-pm-lazy.vim')

  autocmd MyAutoCmd VimEnter * ++once
        \ : echohl WarningMsg
        \ | echomsg 'goda-pm load_state() failed'
        \ | echohl NONE
        \ | call goda_pm#make_state(s:goda_pm_base)
else
  "autocmd MyAutoCmd BufWritePost *.lua,*.vim,*.toml,*.go,vimrc,.vimrc
  "      \ : if !goda_pm#check_files(s:goda_pm_base)->empty()
  "      \ |   call goda_pm#make_state(s:goda_pm_base)
  "      \ | endif
endif

autocmd MyAutoCmd User GodaPm:makeStatePost
      \ : echohl WarningMsg
      \ | echomsg 'goda-pm make_state() is done'
      \ | echohl NONE

" Enable toml syntax.
if !has('nvim')
  autocmd MyAutoCmd CursorHold */rc/*.toml call goda_pm#toml_syntax()
endif
