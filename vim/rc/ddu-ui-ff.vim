" ddu-ff {{{
nnoremap <buffer> <CR>
      \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
nnoremap <buffer> <Space>
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> *
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
nnoremap <buffer> i
      \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> <C-l>
      \ <Cmd>call ddu#ui#do_action('refreshItems')<CR>
nnoremap <buffer> p
      \ <Cmd>call ddu#ui#do_action('previewPath')<CR>
nnoremap <buffer> P
      \ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> <C-h>
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> a
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
nnoremap <buffer> A
      \ <Cmd>call ddu#ui#do_action('inputAction')<CR>
nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',
      \ #{ mode: 'toggle' })<CR>
nnoremap <buffer> O
      \ <Cmd>call ddu#ui#do_action('collapseItem')<CR>
nnoremap <buffer> d
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ b:ddu_ui_name ==# 'filer' ?
      \ #{ name: 'trash' } : #{ name: 'delete' })<CR>
nnoremap <buffer> e
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ ddu#ui#get_item()->get('action', {})->get('isDirectory', v:false) ?
      \ #{ name: 'narrow' } : #{ name: 'edit' })<CR>
nnoremap <buffer> E
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ params: input('params: ', '{}')->eval() })<CR>
nnoremap <buffer> N
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ b:ddu_ui_name ==# 'file' ?
      \ #{ name: 'newFile' } : #{ name: 'new' })<CR>
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
nnoremap <buffer> <C-l>
      \ <Cmd>call ddu#redraw(b:ddu_ui_name, #{ refreshItems: v:true })<CR>

xnoremap <silent><buffer> <Space>
      \ :call ddu#ui#do_action('toggleSelectItem')<CR>

" Switch options
nnoremap <buffer> u
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   filterParams: #{
      \     matcher_files: #{
      \       globs: 'Filter files: '->input('', 'file')->split(','),
      \     },
      \   },
      \ })<CR>

" Switch sources
nnoremap <buffer> ff
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   sources: [
      \     #{ name: 'file' },
      \   ],
      \ })<CR>

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
" }}}

" ddu-ff-filter {{{
if has('nvim')
  inoremap <buffer> <CR>
        \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
else
  inoremap <buffer> <CR>
        \ <Esc><Cmd>call ddu#ui#do_action('itemAction')<CR>
endif
inoremap <buffer> <C-f>
      \ <Cmd>call ddu#ui#do_action('cursorNext', #{ loop: v:true })<CR>
inoremap <buffer> <C-b>
      \ <Cmd>call ddu#ui#do_action('cursorPrevious', #{ loop: v:true })<CR>
inoremap <buffer> <C-v>
      \ <Cmd>call ddu#ui#do_action('toggleAutoAction')<CR>

inoremap <expr><buffer> <BS>
      \ getline('.')[col('.') - 2] ==# '' ? '' : "\<BS>"

" NOTE: Use select_relative for filter
inoremap <buffer><expr> <TAB>
      \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1, "loop")<CR>' :
      \ ddc#map#manual_complete()

nnoremap <buffer> P
      \ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
nnoremap <buffer> a
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
nnoremap <buffer> <CR>
      \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
nnoremap <buffer> ff
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   sources: [
      \     #{ name: 'file' },
      \   ],
      \ })<CR>
" }}}
