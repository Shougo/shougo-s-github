" ddu-ff {{{
nnoremap <buffer> <CR>
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   ddu#ui#get_item()->get('action', {})->get('isDirectory', v:false)
      \ ? #{ name: 'narrow' }
      \ : #{ name: 'default' })<CR>
nnoremap <buffer> <2-LeftMouse>
      \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
nnoremap <buffer> <Space>
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> *
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
nnoremap <buffer> i
      \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> <C-l>
      \ <Cmd>call ddu#ui#do_action('redraw', #{ method: 'refreshItems' })<CR>
nnoremap <buffer> p
      \ <Cmd>call ddu#ui#do_action('previewPath')<CR>
nnoremap <buffer> P
      \ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> a
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
nnoremap <buffer> A
      \ <Cmd>call ddu#ui#do_action('inputAction')<CR>
nnoremap <buffer> I
      \ <Cmd>call ddu#ui#do_action('chooseInput')<CR>
nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',
      \ #{ mode: 'toggle' })<CR>
nnoremap <buffer> O
      \ <Cmd>call ddu#ui#do_action('collapseItem')<CR>
nnoremap <buffer> d
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   b:ddu_ui_name ==# 'filer'
      \ ? #{ name: 'trash' }
      \ : #{ name: 'delete' })<CR>
nnoremap <buffer> e
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   ddu#ui#get_item()->get('action', {})->get('isDirectory', v:false)
      \ ? #{ name: 'narrow' }
      \ : #{ name: 'edit' })<CR>
nnoremap <buffer> E
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ params: input('params: ', '{}')->eval() })<CR>
nnoremap <buffer> N
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   b:ddu_ui_name ==# 'file'
      \ ? #{ name: 'newFile' }
      \ : #{ name: 'new' })<CR>
nnoremap <buffer> r
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'quickfix' })<CR>
nnoremap <buffer> yy
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'yank' })<CR>
nnoremap <buffer> gr
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'grep' })<CR>
nnoremap <buffer> n
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'narrow' })<CR>
nnoremap <buffer> K
      \ <Cmd>call ddu#ui#do_action('kensaku')<CR>
nnoremap <buffer> <C-v>
      \ <Cmd>call ddu#ui#do_action('toggleAutoAction')<CR>
nnoremap <buffer> <C-p>
      \ <Cmd>call ddu#ui#do_action('previewExecute',
      \ #{ command: 'execute "normal! \<C-y>"' })<CR>
nnoremap <buffer> <C-n>
      \ <Cmd>call ddu#ui#do_action('previewExecute',
      \ #{ command: 'execute "normal! \<C-e>"' })<CR>

xnoremap <silent><buffer> <Space>
      \ :call ddu#ui#do_action('toggleSelectItem')<CR>

" Switch options
nnoremap <buffer> u
      \ <Cmd>call ddu#ui#multi_actions([
      \   [
      \      'updateOptions', #{
      \        filterParams: #{
      \          matcher_files: #{
      \             globs: 'Filter files: '
      \                    ->cmdline#input('', 'file')->split(','),
      \          },
      \        },
      \      }
      \   ],
      \   [
      \      'redraw', #{ method: 'refreshItems' },
      \   ],
      \ ])<CR>

" Switch sources
nnoremap <buffer> ff
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   sources: [
      \     #{ name: 'file' },
      \   ],
      \ })<CR>
      \<Cmd>call ddu#ui#do_action('redraw', #{ method: 'refreshItems' })<CR>

" Cursor move
nnoremap <C-n>
      \ <Cmd>call ddu#ui#multi_actions(
      \   ['cursorNext', 'itemAction'], 'files')<CR>
nnoremap <C-p>
      \ <Cmd>call ddu#ui#multi_actions(
      \   ['cursorPrevious', 'itemAction'], 'files')<CR>
nnoremap <buffer> <C-j>
      \ <Cmd>call ddu#ui#do_action('cursorNext')<CR>
nnoremap <buffer> <C-k>
      \ <Cmd>call ddu#ui#do_action('cursorPrevious')<CR>

nnoremap <buffer> >
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   uiParams: #{
      \     ff: #{
      \       winWidth: 80,
      \     },
      \   },
      \ })<CR>
      \<Cmd>call ddu#ui#do_action('redraw', #{ method: 'uiRedraw' })<CR>

nnoremap <buffer> M
      \ <Cmd>call ddu#ui#multi_actions([
      \   [
      \     'updateOptions', #{
      \       uiParams: #{
      \         ff: #{
      \           pathFilter: 'pathFilter regexp: '
      \               ->input(ddu#custom#get_current(b:ddu_ui_name)
      \               ->get('uiParams', {})
      \               ->get('ff', {})
      \               ->get('pathFilter', '')),
      \         },
      \       },
      \     },
      \   ],
      \   [
      \      'redraw', #{ method: 'refreshItems' },
      \   ],
      \ ])<CR>

nnoremap <buffer> U
      \ <Cmd>call ddu#ui#multi_actions([
      \   [
      \     'updateOptions', #{
      \       sourceParams: #{
      \         rg: #{
      \           globs: 'rg globs: '
      \               ->input(ddu#custom#get_current(b:ddu_ui_name)
      \               ->get('sourceParams', {})
      \               ->get('rg', {})
      \               ->get('globs', [])->join())
      \               ->split(),
      \         },
      \       },
      \     },
      \   ],
      \   [
      \      'redraw', #{ method: 'refreshItems' },
      \   ],
      \ ])<CR>

" }}}
