let $CACHE = '~/.cache'->expand()
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

" Install plugin manager automatically.
for s:plugin in [
      \ 'Shougo/dein.vim',
      \ ]->filter({ _, val -> &runtimepath !~# $'/{val}' })
  " Search from current directory
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    " Search from $CACHE directory
    let s:dir = $'{$CACHE}/dein/repos/github.com/{s:plugin}'
    if !(s:dir->isdirectory())
      execute $'!git clone https://github.com/{s:plugin}' s:dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfor


"---------------------------------------------------------------------------
" dein configurations.

" In Windows, auto_recache is disabled.  It is too slow.
let g:dein#auto_recache = !has('win32')

let g:dein#auto_remote_plugins = v:false
let g:dein#enable_notification = v:true
let g:dein#install_check_diff = v:true
let g:dein#install_check_remote_threshold = 24 * 60 * 60
let g:dein#install_progress_type = 'floating'
let g:dein#lazy_rplugins = v:true
let g:dein#types#git#enable_partial_clone = v:true

let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')

let s:path = $'{$CACHE}/dein'
if !dein#min#load_state(s:path)
  finish
endif

let g:dein#inline_vimrcs = [
      \ '$BASE_DIR/options.rc.vim',
      \ '$BASE_DIR/mappings.rc.vim',
      \ ]
if has('nvim')
  call add(g:dein#inline_vimrcs, '$BASE_DIR/neovim.rc.vim')
elseif has('gui_running')
  call add(g:dein#inline_vimrcs, '$BASE_DIR/gui.rc.vim')
endif
if has('win32')
  call add(g:dein#inline_vimrcs, '$BASE_DIR/windows.rc.vim')
else
  call add(g:dein#inline_vimrcs, '$BASE_DIR/unix.rc.vim')
endif

call dein#begin(s:path, '<sfile>'->expand())

call dein#load_toml('$BASE_DIR/dein.toml', #{ lazy: 0 })
call dein#load_toml('$BASE_DIR/deinlazy.toml', #{ lazy: 1 })
call dein#load_toml('$BASE_DIR/ddc.toml', #{ lazy: 1 })
call dein#load_toml('$BASE_DIR/ddu.toml', #{ lazy: 1 })
if has('nvim')
  call dein#load_toml('$BASE_DIR/neovim.toml', #{ lazy : 1 })
else
  call dein#load_toml('$BASE_DIR/vim.toml', #{ lazy : 1 })
endif

const work_directory = '~/work'->expand()
if work_directory->isdirectory()
  " Load develop version plugins.
  call dein#local(work_directory,
        \ #{ frozen: 1, merged: 0 }, [
        \   'vim*', 'nvim-*', '*.vim', '*.nvim',
        \   'ddc-*', 'ddu-*',
        \   'skkeleton', 'neco-vim',
        \ ])
endif

call dein#end()
call dein#save_state()

" NOTE: filetype detection is needed
if '%'->bufname() !=# ''
  filetype detect
endif
