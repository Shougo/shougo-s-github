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
  execute 'set runtimepath^=' ..
        \ s:dein_dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
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
  let s:base_dir = '<sfile>'->expand()->fnamemodify(':h') .. '/'

  let g:dein#inline_vimrcs = ['options.rc.vim', 'mappings.rc.vim']
  if has('nvim')
    call add(g:dein#inline_vimrcs, 'neovim.rc.vim')
  elseif has('gui_running')
    call add(g:dein#inline_vimrcs, 'gui.rc.vim')
  endif
  if has('win32')
    call add(g:dein#inline_vimrcs, 'windows.rc.vim')
  else
    call add(g:dein#inline_vimrcs, 'unix.rc.vim')
  endif
  call map(g:dein#inline_vimrcs, { _, val -> s:base_dir .. val })

  let s:dein_toml = s:base_dir .. 'dein.toml'
  let s:dein_lazy_toml = s:base_dir .. 'deinlazy.toml'
  let s:dein_ddc_toml = s:base_dir .. 'ddc.toml'
  let s:dein_ddu_toml = s:base_dir .. 'ddu.toml'
  let s:dein_ft_toml = s:base_dir .. 'deinft.toml'
  let s:dein_neovim_toml = s:base_dir .. 'neovim.toml'
  let s:dein_vim_toml = s:base_dir .. 'vim.toml'

  call dein#begin(s:path, '<sfile>'->expand())

  call dein#load_toml(s:dein_toml, #{ lazy: 0 })
  call dein#load_toml(s:dein_lazy_toml, #{ lazy: 1 })
  call dein#load_toml(s:dein_ddc_toml, #{ lazy: 1 })
  call dein#load_toml(s:dein_ddu_toml, #{ lazy: 1 })
  if has('nvim')
    call dein#load_toml(s:dein_neovim_toml, #{ lazy : 1 })
  else
    call dein#load_toml(s:dein_vim_toml, #{ lazy : 1 })
  endif
  call dein#load_toml(s:dein_ft_toml)

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
