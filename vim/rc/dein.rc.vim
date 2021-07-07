" dein configurations.

let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = v:true

let g:dein#inline_vimrcs = ['options.rc.vim', 'mappings.rc.vim']
if has('nvim')
  call add(g:dein#inline_vimrcs, 'neovim.rc.vim')
elseif has('gui_running')
  call add(g:dein#inline_vimrcs, 'gui.rc.vim')
endif
if IsWindows()
  call add(g:dein#inline_vimrcs, 'windows.rc.vim')
else
  call add(g:dein#inline_vimrcs, 'unix.rc.vim')
endif
call map(g:dein#inline_vimrcs,
      \ { _, val -> resolve(expand('~/.vim/rc/' . val)) })

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

let s:dein_toml = '~/.vim/rc/dein.toml'
let s:dein_lazy_toml = '~/.vim/rc/deinlazy.toml'
let s:dein_ft_toml = '~/.vim/rc/deinft.toml'

call dein#begin(s:path, [
      \ expand('<sfile>'), s:dein_toml, s:dein_lazy_toml, s:dein_ft_toml
      \ ])

call dein#load_toml(s:dein_toml, {'lazy': 0})
call dein#load_toml(s:dein_lazy_toml, {'lazy' : 1})
call dein#load_toml(s:dein_ft_toml)

if filereadable('vimrc_local.vim')
  " Load develop version plugins.
  call dein#local(getcwd(),
        \ {'frozen': 1, 'merged': 0},
        \ ['vim*', 'nvim-*', 'unite-*', 'neco-*', '*.vim', 'denite.nvim'])
  call dein#local(getcwd(),
        \ {'frozen': 1, 'merged': 0},
        \ ['deoplete-*', '*.nvim'])
endif

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
