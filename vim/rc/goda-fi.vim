" hook_add {{{
let g:goda_fi#config_dir = '$BASE_DIR/goda-fi'->expand()

nnoremap s<Space> <Cmd>call goda_fi#start(#{
      \   name: 'files',
      \   sources: ['file'],
      \   sourceOptions: #{ file: #{ path: '$BASE_DIR'->expand() } },
      \   uiParams: #{
      \     ff: #{
      \       split: has('nvim') ? 'floating' : 'horizontal',
      \     },
      \   },
      \   resume: v:true,
      \ })<CR>
nnoremap sf <Cmd>call goda_fi#start(#{
      \   name: 'files-' .. win_getid(),
      \   sources: ['filepoint'],
      \   uiParams: #{
      \     ff: #{
      \       split: has('nvim') ? 'floating' : 'horizontal',
      \       displaySourceName: 'short',
      \     },
      \   },
      \ })<CR>
nnoremap ss <Cmd>call goda_fi#start(#{
      \   name: 'files-' .. win_getid(),
      \   sources: ['fileold']
      \     + ('.git'->finddir(';') != '' ? ['filegit'] : [])
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
      \       split: has('nvim') ? 'floating' : 'horizontal',
      \       displaySourceName: 'short',
      \     }
      \   },
      \ })<CR>
nnoremap / <Cmd>call goda_fi#start(#{
      \   name: 'search',
      \   sources: ['line'],
      \   resume: v:false,
      \   uiParams: #{
      \     ff: #{
      \       ignoreEmpty: v:true,
      \     },
      \   },
      \   sourceParams: #{
      \     line: #{
      \       ignoreEmptyInput: v:true,
      \     },
      \   },
      \   input: 'Pattern: '->cmdline#input()->escape(' '),
      \ })<CR>
nnoremap * <Cmd>call goda_fi#start(#{
      \   name: 'search',
      \   sources: ['line'],
      \   resume: v:false,
      \   input: expand('<cword>'),
      \ })<CR>
nnoremap ;g <Cmd>call goda_fi#start(#{
      \   name: 'search',
      \   sources: ['rg'],
      \   resume: v:false,
      \   uiParams: #{
      \     ff: #{
      \       ignoreEmpty: v:true,
      \     },
      \   },
      \   sourceParams: #{
      \     rg: #{
      \       input: 'Pattern: '->cmdline#input('<cword>'->expand()),
      \     },
      \   },
      \ })<CR>
nnoremap ;f <Cmd>call goda_fi#start(#{
      \   name: 'search',
      \   sources: ['rg'],
      \   resume: v:false,
      \   uiParams: #{
      \     ff: #{
      \       ignoreEmpty: v:true,
      \     },
      \   },
      \   sourceParams: #{
      \     rg: #{
      \       input: 'Pattern: '->cmdline#input('<cword>'->expand()),
      \     },
      \   },
      \   sourceOptions: #{
      \     rg: #{
      \       path: 'Directory: '->cmdline#input($'{getcwd()}/', 'dir'),
      \     },
      \    },
      \ })<CR>
nnoremap ;a <Cmd>call goda_fi#start(#{
      \   name: 'search',
      \   sources: ['rg'],
      \   resume: v:false,
      \   sourceOptions: #{
      \     rg: #{
      \       volatile: v:true,
      \     },
      \   },
      \ })<CR>
nnoremap n <Cmd>call goda_fi#start(#{
      \   name: 'search',
      \   resume: v:true,
      \ })<CR>
nnoremap ;r <Cmd>call goda_fi#start(#{
      \   name: 'register',
      \   sources: ['register'],
      \   sourceOptions: #{
      \     register: #{
      \       defaultAction: '.'->col() == 1 ? 'insert' : 'append',
      \     },
      \   },
      \   uiParams: #{
      \     ff: #{
      \       autoResize: v:true,
      \     },
      \   },
      \ })<CR>
xnoremap <expr> ;r
      \ (mode() ==# 'V' ? '"_R<Esc>' : '"_d')
      \ .. '<Cmd>call goda_fi#start(#{
      \   name: "register",
      \   sources: ["register"],
      \   uiOptions: #{
      \     ff: #{
      \       defaultAction: "insert",
      \     },
      \   },
      \   uiParams: #{
      \     ff: #{
      \       autoResize: v:true,
      \     }
      \   },
      \ })<CR>'

function GodaFiOnPreview(args) abort
  call win_execute(a:args.previewWinId, 'normal! zt')
endfunction

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
        \ <Cmd>call goda_fi#ui#do_action('toggleAutoAction')<CR>
  nnoremap <buffer> P
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
