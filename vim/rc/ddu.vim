" hook_add {{{
nnoremap s<Space> <Cmd>Ddu
      \ -name=files file
      \ -source-option-file-path=`'$BASE_DIR'->expand()`
      \ -ui-param-ff-split=floating
      \ <CR>
nnoremap ss
      \ <Cmd>Ddu -name=files-`tabpagenr()` file_point file_old
      \ `'.git'->finddir(';') != '' ? 'file_git' : ''`
      \ file -source-option-file-volatile
      \ file -source-param-file-new -source-option-file-volatile
      \ -unique -expandInput
      \ -resume=`ddu#get_items(#{ sources: ['file_point'] })->empty() ?
      \          'v:true' : 'v:false'`
      \ -ui-param-ff-displaySourceName=short
      \ -ui-param-ff-split=floating
      \ <CR>
nnoremap / <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -input=`'Pattern: '->MyDduInputFunc()->escape(' ')`
      \ <CR>
nnoremap * <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -input=`expand('<cword>')`
      \ <CR>
nnoremap ;g <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input=
      \'`'Pattern: '->MyDduInputFunc('<cword>'->expand())`'
      \ <CR>
xnoremap ;g y<Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input=
      \'`'Pattern: '->MyDduInputFunc(v:register->getreg())`'
      \ <CR>
nnoremap ;f <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input=
      \'`'Pattern: '->MyDduInputFunc('<cword>'->expand())`'
      \ -source-option-rg-path=
      \'`'Directory: '->MyDduInputFunc($'{getcwd()}/', 'dir')`'
      \ <CR>
nnoremap n <Cmd>Ddu
      \ -name=search -resume
      \ <CR>
nnoremap ;r <Cmd>Ddu
      \ -name=register register
      \ -source-option-register-defaultAction=
      \`'.'->col() == 1 ? 'insert' : 'append'`
      \ -ui-param-ff-autoResize
      \ <CR>
nnoremap ;d <Cmd>Ddu
      \ -name=outline markdown
      \ -ui-param-ff-ignoreEmpty
      \ -ui-param-ff-displayTree
      \ <CR>
nnoremap [Space]o <Cmd>Ddu
      \ -name=output output
      \ -source-param-output-command=
      \'`'Command: '->MyDduInputFunc('', 'command')`'
      \ <CR>
xnoremap <expr> ;r
      \ (mode() ==# 'V' ? '"_R<Esc>' : '"_d')
      \ .. '<Cmd>Ddu -name=register register
      \ -source-option-ff-defaultAction=insert
      \ -ui-param-ff-autoResize<CR>'

function! MyDduInputFunc(prompt='', text='', completion='custom,cmdline#_dummy')
  " NOTE: Disable cmdline area highlight
  const hl_normal = has('nvim') ?
        \ nvim_get_hl(0, #{ name: 'Normal'}) : hlget('Normal')
  const hl_msg = has('nvim') ?
        \ nvim_get_hl(0, #{ name: 'MsgArea'}) : hlget('MsgArea')
  const hl_cursor = has('nvim') ?
        \ nvim_get_hl(0, #{ name: 'Cursor'}) : hlget('Cursor')

  if has('nvim')
    call nvim_set_hl(0, 'MsgArea', #{ fg: hl_normal.bg, bg: hl_normal.bg })
    call nvim_set_hl(0, 'Cursor', #{ fg: hl_normal.bg, bg: hl_normal.bg })
  else
    call hlset([
          \   #{
          \     name: 'MsgArea',
          \     guifg: hl_normal[0].guibg,
          \     guibg: hl_normal[0].guibg,
          \   },
          \   #{
          \     name: 'Cursor',
          \     guifg: hl_normal[0].guibg,
          \     guibg: hl_normal[0].guibg,
          \   },
          \ ])
  endif

  const input = cmdline#input(a:prompt, a:text, a:completion)

  if has('nvim')
    call nvim_set_hl(0, 'MsgArea', hl_msg)
    call nvim_set_hl(0, 'Cursor', hl_cursor)
  else
    call hlset(hl_msg + hl_cursor)
  endif

  return input
endfunction

" Open filter window automatically
"autocmd MyAutoCmd User Ddu:uiReady
"      \ : if &l:filetype ==# 'ddu-ff'
"      \ |   call ddu#ui#do_action('openFilterWindow')
"      \ | endif

" Initialize ddu.vim lazily.
if !'g:shougo_s_github_load_state'->exists()
  call timer_start(1000, { _ -> LazyDdu() })
  function LazyDdu()
    call ddu#load('ui', ['ff'])
    call ddu#load('kind', ['file'])
  endfunction
endif
" }}}

" hook_source {{{
call ddu#custom#load_config('$BASE_DIR/ddu.ts'->expand())
" }}}

" hook_post_update {{{
call ddu#set_static_import_path()
" }}}
