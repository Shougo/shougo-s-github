" Vim syntax file

syntax match vimWrongFunctionCall /^\s*\zs[[:alnum:]#:]\+(.*$/
highlight link vimWrongFunctionCall Error
syntax match vimWrongLet /^\s*\zs[[:alnum:]:]\+\s*=\s*.*$/
highlight link vimWrongLet Error
