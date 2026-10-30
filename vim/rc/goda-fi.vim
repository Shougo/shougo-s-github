" hook_add {{{
let g:goda_fi#config_dir = '$BASE_DIR/goda-fi'->expand()

nnoremap s<Space> <Cmd>call goda_fi#start(#{
      \   name: 'files',
      \   sources: ['file'],
      \   sourceOptions: #{ file: #{ path: '$BASE_DIR'->expand() } },
      \   uiParams: #{
      \     ff: #{ split: 'horizontal' }
      \   },
      \   resume: v:true,
      \ })<CR>
nnoremap sf <Cmd>call goda_fi#start(#{
      \   name: 'files-' .. win_getid(),
      \   sources: ['filepoint'],
      \   uiParams: #{
      \     ff: #{
      \       split: 'horizontal',
      \       displaySourceName: 'short',
      \     },
      \   },
      \ })<CR>
nnoremap ss <Cmd>call goda_fi#start(#{
      \   name: 'files-' .. win_getid(),
      \   sources: ('.git'->finddir(';') != '' ? ['fileexternal'] : [])
      \     + [
      \       #{ name: 'file', options: #{ volatile: v:true } },
      \       #{
      \         name: 'file',
      \         options: #{ volatile: v:true },
      \         params: #{ new: v:true },
      \       },
      \   ],
      \   unique: v:true,
      \   resume: v:true,
      \   uiParams: #{
      \     ff: #{
      \       split: 'horizontal',
      \       displaySourceName: 'short',
      \     }
      \   },
      \ })<CR>
nnoremap s; <Cmd>call goda_fi#start(#{
      \   name: 'rec', sources: ['filerec'], resume: v:true,
      \ })<CR>
nnoremap sb <Cmd>call goda_fi#start(#{
      \   name: 'buffer',
      \   sources: ['buffer'],
      \ })<CR>

autocmd MyAutoCmd FileType goda-fi-ff call s:goda_fi_ff_my_settings()
function s:goda_fi_ff_my_settings() abort
  nnoremap <buffer> <CR>
        \ <Cmd>call goda_fi#ui#do_action('itemAction')<CR>
  nnoremap <buffer> i
        \ <Cmd>call goda_fi#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer> <Space>
        \ <Cmd>call goda_fi#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> *
        \ <Cmd>call goda_fi#ui#do_action('toggleAllItems')<CR>
  nnoremap <buffer> p
        \ <Cmd>call goda_fi#ui#do_action('preview',
        \   #{ toggle: v:true })<CR>
  nnoremap <buffer> t
        \ <Cmd>call goda_fi#ui#do_action('itemAction',
        \   #{ name: 'tabopen' })<CR>
  nnoremap <buffer> q
        \ <Cmd>call goda_fi#ui#do_action('quit')<CR>
endfunction

autocmd MyAutoCmd User GodaFi:uiOpenFilterWindow
      \ call s:goda_fi_filter_my_settings()
function s:goda_fi_filter_my_settings() abort
  set cursorline
  cnoremap <buffer> <C-f>
        \ <Cmd>call goda_fi#ui#do_action('cursorNext',
        \   #{ loop: v:true })<CR>
  cnoremap <buffer> <C-b>
        \ <Cmd>call goda_fi#ui#do_action('cursorPrevious',
        \   #{ loop: v:true })<CR>
endfunction
autocmd MyAutoCmd User GodaFi:uiCloseFilterWindow
      \ call s:goda_fi_filter_cleanup()
function s:goda_fi_filter_cleanup() abort
  set nocursorline
  silent! cunmap <buffer> <C-f>
  silent! cunmap <buffer> <C-b>
endfunction
" }}}
