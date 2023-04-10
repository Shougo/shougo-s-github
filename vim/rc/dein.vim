let $CACHE = '~/.cache'->expand()
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

" Load dein.
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dein_dir->isdirectory())
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dein_dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dein_dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif


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

let s:path = $CACHE .. '/dein'
if dein#min#load_state(s:path)
  let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')

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
  call dein#load_toml('$BASE_DIR/deinft.toml')

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
endif
