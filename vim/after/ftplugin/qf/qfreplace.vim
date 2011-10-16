" Perform the replacement in quickfix.
" Version: 0.3
" Author : thinca <http://d.hatena.ne.jp/thinca/>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '| execute "delcommand Qfreplace"'


command! -nargs=? -buffer Qfreplace call qfreplace#start(<q-args>)
