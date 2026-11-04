" hook_add {{{
let g:goda_fi#config_dir = '$BASE_DIR/goda-fi'->expand()

nnoremap s<Space> <Cmd>call goda_fi#start(#{
      \   name: 'files',
      \   sources: ['filerec'],
      \   sourceOptions: #{
      \     filerec: #{
      \       path: '$BASE_DIR'->expand(),
      \     },
      \   },
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
      \   expandInput: v:true,
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
      \   input: 'Pattern: '->input()->escape(' '),
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
      \       input: 'Pattern: '->input('<cword>'->expand()),
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
      \       input: 'Pattern: '->input('<cword>'->expand()),
      \     },
      \   },
      \   sourceOptions: #{
      \     rg: #{
      \       path: 'Directory: '->input($'{getcwd()}/', 'dir'),
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
      \     },
      \   },
      \ })<CR>'

nnoremap [Space]f <Cmd>call goda_fi#start(#{
      \   name: 'filer-' .. win_getid(),
      \   ui: 'filer',
      \   resume: v:true,
      \   sources: [#{
      \     name: 'file',
      \     options: #{
      \       path: t:->get('goda_fi_ui_filer_path', getcwd()),
      \       limitPath: getcwd(),
      \       columns: ['filename'],
      \     }
      \   }],
      \   uiParams: #{
      \     filer: #{
      \       sort: 'filename',
      \       sortTreesFirst: v:true,
      \       split: 'no',
      \     },
      \   },
      \ })<CR>
" }}}

" hook_source {{{
call goda_fi#custom#action('kind', 'file', 'grep', { args -> s:grep(args) })
function s:grep(args) abort
  const path = a:args.items[0].action.path
  call goda_fi#start(#{
        \   name: a:args.options.name,
        \   push: v:true,
        \   sources: [
        \     #{
        \       name: 'rg',
        \       params: #{
        \         paths: [isdirectory(path) ? path : fnamemodify(path, ':h')],
        \         input: 'Pattern: '->cmdline#input(),
        \       },
        \     }
        \   ],
        \ })
  return 0
endfunction

function GodaFiOnPreview(args) abort
  call win_execute(a:args.previewWinId, 'normal! zt')
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

autocmd MyAutoCmd TabEnter,WinEnter,CursorHold,FocusGained *
      \ call goda_fi#ui#do_action('checkItems')

function GodaFiToggleHidden(name) abort
  const source_options = goda_fi#custom#get_current()
        \ ->get('sourceOptions', {})
        \ ->get(a:name, {})
  let matchers = source_options->get('matchers', [])->copy()
 
  const index = matchers->index('matcherhidden')
  if index >= 0
    call remove(matchers, index)
  else
    call add(matchers, 'matcherhidden')
  endif
  return matchers
endfunction

function GodaFiToggleUiParam(ui_name, param_name)
  return goda_fi#custom#get_current()
        \ ->get('uiParams', {})
        \ ->get(a:ui_name, {})
        \ ->get(a:param_name, v:false)
        \ ? v:false : v:true
endfunction
" }}}

" goda-fi-ff {{{
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
      \ <Cmd>call goda_fi#ui#do_action('expandItem',
      \   #{ mode: 'toggle' })<CR>
nnoremap <buffer> T
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'tabopen' })<CR>
nnoremap <expr><buffer> q
      \   '$'->winnr() == 1
      \ ? '<Cmd>enew<CR>'
      \ : '<Cmd>call goda_fi#ui#do_action("quit")<CR>'
nnoremap <buffer> <C-l>
      \ <Cmd>call goda_fi#ui#do_action('redraw')<CR>
nnoremap <buffer> N
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   b:goda_fi_name ==# 'file'
      \ ? #{ name: 'newFile' }
      \ : #{ name: 'new' })<CR>
nnoremap <buffer> e
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   goda_fi#ui#get_item()
      \   ->get('action', {})
      \   ->get('isDirectory', v:false)
      \ ? #{ name: 'narrow' }
      \ : #{ name: 'edit' })<CR>
" }}}

" goda-fi-filer {{{
nnoremap <buffer> <Space>
      \ <Cmd>call goda_fi#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> *
      \ <Cmd>call goda_fi#ui#do_action('toggleAllItems')<CR>
nnoremap <buffer> i
      \ <Cmd>call goda_fi#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> a
      \ <Cmd>call goda_fi#ui#do_action('chooseAction')<CR>
nnoremap <buffer> A
      \ <Cmd>call goda_fi#ui#do_action('inputAction')<CR>
nnoremap <buffer> q
      \ <Cmd>call goda_fi#ui#do_action('quit')<CR>
nnoremap <buffer> o
      \ <Cmd>call goda_fi#ui#do_action('expandItem',
      \   #{ mode: 'toggle', isGrouped: v:true, isInTree: v:false })<CR>
nnoremap <buffer> O
      \ <Cmd>call goda_fi#ui#do_action('expandItem',
      \   #{ maxLevel: -1 })<CR>
nnoremap <buffer> c
      \ <Cmd>call goda_fi#ui#multi_actions([
      \   ['itemAction', #{ name: 'copy' }],
      \   ['clearSelectAllItems'],
      \ ])<CR>
nnoremap <buffer> d
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'delete' })<CR>
nnoremap <buffer> D
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'trash' })<CR>
nnoremap <buffer> m
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'move' })<CR>
nnoremap <buffer> r
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'rename' })<CR>
nnoremap <buffer> x
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'executeSystem' })<CR>
nnoremap <buffer> p
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'paste' })<CR>
nnoremap <buffer> P
      \ <Cmd>call goda_fi#ui#do_action('togglePreview', #{
      \  imageExts: ['.jpg', '.png'],
      \ })<CR>
nnoremap <buffer> K
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'newDirectory' })<CR>
nnoremap <buffer> N
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'newFile' })<CR>
nnoremap <buffer> L
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'link' })<CR>
nnoremap <buffer> u
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'undo' })<CR>
nnoremap <buffer> ~
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'narrow', params: #{ path: '~'->expand() } })<CR>
nnoremap <buffer> =
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'narrow', params: #{ path: getcwd() } })<CR>
nnoremap <buffer> h
      \ <Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'narrow', params: #{ path: '..' } })<CR>
nnoremap <buffer> H
      \ <Cmd>call goda_fi#start(#{ sources: [#{ name: 'pathhistory' }] })<CR>
nnoremap <buffer> I
      \ <Cmd>call <SID>narrow_directory()<CR>
nnoremap <buffer> M
      \ <Cmd>call goda_fi#ui#multi_actions([
      \   [
      \     'updateOptions', #{
      \       uiParams: #{
      \         filer: #{
      \           fileFilter: 'fileFilter regexp: '
      \               ->input(goda_fi#custom#get_current()
      \               ->get('uiParams', {})
      \               ->get('filer', {})
      \               ->get('fileFilter', '')),
      \         },
      \       },
      \     },
      \   ],
      \   [
      \      'redraw', #{ method: 'refreshItems' },
      \   ],
      \ ])<CR>
nnoremap <buffer> .
      \ <Cmd>call goda_fi#ui#multi_actions([
      \   [
      \     'updateOptions', #{
      \       sourceOptions: #{
      \         file: #{
      \           matchers: GodaFiToggleHidden('file'),
      \         },
      \       },
      \     },
      \   ],
      \   [
      \      'redraw', #{ method: 'refreshItems' },
      \   ],
      \ ])<CR>
nnoremap <buffer> >
      \ <Cmd>call goda_fi#ui#do_action('updateOptions', #{
      \   uiParams: #{
      \     filer: #{
      \       displayRoot: GodaFiToggleUiParam('filer', 'displayRoot'),
      \     },
      \   },
      \ })<CR>
      \<Cmd>call goda_fi#ui#do_action('redraw')<CR>
nnoremap <buffer> <
      \ <Cmd>call goda_fi#ui#do_action('updateOptions', #{
      \   uiParams: #{
      \     filer: #{
      \       split: 'vertical',
      \     },
      \   },
      \ })<CR>
      \<Cmd>call goda_fi#ui#do_action('redraw')<CR>
nnoremap <buffer> <C-l>
      \ <Cmd>call goda_fi#ui#do_action('redraw')<CR>
nnoremap <buffer><expr> <CR>
      \   goda_fi#ui#get_item()->get('isTree', v:false)
      \ ? "<Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'narrow' })<CR>"
      \ : "<Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'open' })<CR>"
nnoremap <buffer><expr> l
      \   goda_fi#ui#get_item()->get('isTree', v:false)
      \ ? "<Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'narrow' })<CR>"
      \ : "<Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'open' })<CR>"
nnoremap <buffer><expr> <2-LeftMouse>
      \   goda_fi#ui#get_item()->get('isTree', v:false)
      \ ? "<Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'narrow' })<CR>"
      \ : "<Cmd>call goda_fi#ui#do_action('itemAction',
      \   #{ name: 'open' })<CR>"
nnoremap <buffer> gr
      \ <Cmd>call goda_fi#ui#do_action('itemAction', #{ name: 'grep' })<CR>
nnoremap <buffer> t
      \ <Cmd>call goda_fi#ui#do_action('itemAction', #{
      \   name: 'tabopen',
      \   params: #{ command: 'tabedit' },
      \ })<CR>
nnoremap <buffer> T
      \ <Cmd>call goda_fi#ui#do_action('cursorTreeTop')<CR>
nnoremap <buffer> B
      \ <Cmd>call goda_fi#ui#do_action('cursorTreeBottom')<CR>
" }}}
