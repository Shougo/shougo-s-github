" hook_add {{{
nnoremap [Space]f <Cmd>Ddu
      \ -name=filer-`win_getid()` -ui=filer -resume -sync file
      \ -source-option-file-path=`t:->get('ddu_ui_filer_path', getcwd())`
      \ -source-option-file-columns=filename<CR>
" }}}

" hook_source {{{
autocmd MyAutoCmd TabEnter,WinEnter,CursorHold,FocusGained *
      \ call ddu#ui#do_action('checkItems')
" }}}

" ddu-filer = {{{
nnoremap <buffer> <Space>
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> *
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
nnoremap <buffer> a
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
nnoremap <buffer> A
      \ <Cmd>call ddu#ui#do_action('inputAction')<CR>
nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',
      \ #{ mode: 'toggle' })<CR>
nnoremap <buffer> O
      \ <Cmd>call ddu#ui#do_action('expandItem',
      \ #{ maxLevel: -1 })<CR>
"nnoremap <buffer> O
"\ <Cmd>call ddu#ui#do_action('collapseItem')<CR>
nnoremap <buffer> c
      \ <Cmd>call ddu#ui#multi_actions([
      \   ['itemAction', #{ name: 'copy' }],
      \   ['clearSelectAllItems'],
      \ ])<CR>
nnoremap <buffer> d
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'delete' })<CR>
nnoremap <buffer> D
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'trash' })<CR>
nnoremap <buffer> m
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'move' })<CR>
nnoremap <buffer> r
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'rename' })<CR>
nnoremap <buffer> x
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'executeSystem' })<CR>
nnoremap <buffer> p
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'paste' })<CR>
nnoremap <buffer> P
      \ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
nnoremap <buffer> K
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'newDirectory' })<CR>
nnoremap <buffer> N
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'newFile' })<CR>
nnoremap <buffer> L
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'link' })<CR>
nnoremap <buffer> u
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'undo' })<CR>
nnoremap <buffer> ~
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'narrow', params: #{ path: expand('~') } })<CR>
nnoremap <buffer> =
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'narrow', params: #{ path: getcwd() } })<CR>
nnoremap <buffer> h
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'narrow', params: #{ path: '..' } })<CR>
nnoremap <buffer> H
      \ <Cmd>call ddu#start(#{ sources: [#{ name: 'path_history' }] })<CR>
nnoremap <buffer> I
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{
      \   name: 'narrow',
      \   params: #{
      \     path: 'cwd: '
      \           ->input(b:ddu_ui_filer_path, 'dir')
      \           ->fnamemodify(':p'),
      \   }
      \ })<CR>
nnoremap <buffer> .
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   sourceOptions: #{
      \     file: #{
      \       matchers: ToggleHidden('file'),
      \     },
      \   },
      \ })<CR>
nnoremap <buffer> >
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   uiParams: #{
      \     filer: #{
      \       displayRoot: ToggleUiParam('filer', 'displayRoot'),
      \     },
      \   },
      \ })<CR>
nnoremap <buffer> <
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   ui: 'ff',
      \   uiParams: #{
      \     ff: #{
      \       split: 'vertical',
      \     },
      \   },
      \ })<CR>
nnoremap <buffer> <C-l>
      \ <Cmd>call ddu#ui#do_action('checkItems')<CR>
nnoremap <buffer><expr> <CR>
      \ ddu#ui#get_item()->get('isTree', v:false) ?
      \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'narrow' })<CR>" :
      \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open' })<CR>"
nnoremap <buffer><expr> l
      \ ddu#ui#get_item()->get('isTree', v:false) ?
      \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'narrow' })<CR>" :
      \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open' })<CR>"
nnoremap <buffer> gr
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'grep' })<CR>
nnoremap <buffer> t
      \ <Cmd>call ddu#ui#do_action('itemAction', #{
      \   name: 'tabopen',
      \   params: #{ command: 'tabedit' },
      \ })<CR>

function! ToggleHidden(name)
  return ddu#custom#get_current(b:ddu_ui_name)
        \ ->get('sourceOptions', {})
        \ ->get(a:name, {})
        \ ->get('matchers', [])
        \ ->empty() ? ['matcher_hidden'] : []
endfunction

function! ToggleUiParam(ui_name, param_name)
  return ddu#custom#get_current(b:ddu_ui_name)
        \ ->get('uiParams', {})
        \ ->get(a:ui_name, {})
        \ ->get(a:param_name, v:false)
        \ ? v:false : v:true
endfunction
" }}}
