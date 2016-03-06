" dein configurations.

call dein#begin(expand('$CACHE/dein'))

let s:toml_path = '~/.vim/rc/dein.toml'
let s:toml_lazy_path = '~/.vim/rc/deinlazy.toml'

if dein#load_cache([expand('<sfile>'), s:toml_path, s:toml_lazy_path])
  call dein#load_toml(s:toml_path, {'lazy': 0})
  call dein#load_toml(s:toml_lazy_path, {'lazy' : 1})

  let s:vimrc_local = findfile('vimrc_local.vim', '.;')
  if s:vimrc_local !=# ''
    " Load develop version plugins.
    call dein#local(fnamemodify(s:vimrc_local, ':h'), {'frozen': 1},
          \ ['vim*', 'unite-*', 'deoplete-*', 'neco-*', '*.vim', '*.nvim'])
  endif

  call dein#save_cache()
endif

call dein#end()
