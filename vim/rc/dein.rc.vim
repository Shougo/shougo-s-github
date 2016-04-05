" dein configurations.

let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

let s:toml_path = '~/.vim/rc/dein.toml'
let s:toml_lazy_path = '~/.vim/rc/deinlazy.toml'
let s:toml_neovim_path = '~/.vim/rc/deineo.toml'

call dein#begin(s:path, [expand('<sfile>'),
      \ s:toml_path, s:toml_lazy_path, s:toml_neovim_path])

call dein#load_toml(s:toml_path, {'lazy': 0})
call dein#load_toml(s:toml_lazy_path, {'lazy' : 1})
if has('nvim')
  call dein#load_toml(s:toml_neovim_path, {})
endif

let s:vimrc_local = findfile('vimrc_local.vim', '.;')
if s:vimrc_local !=# ''
  " Load develop version plugins.
  call dein#local(fnamemodify(s:vimrc_local, ':h'),
        \ {'frozen': 1, 'merged': 0},
        \ ['vim*', 'unite-*', 'neco-*', '*.vim'])
  if has('nvim')
    call dein#local(fnamemodify(s:vimrc_local, ':h'),
          \ {'frozen': 1, 'merged': 0},
          \ ['deoplete-*', '*.nvim'])
  endif
endif

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
