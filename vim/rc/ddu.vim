" hook_add {{{
nnoremap s<Space> <Cmd>Ddu
      \ -name=files file
      \ -source-option-file-path=`'$BASE_DIR'->expand()`
      \ -ui-param-ff-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ <CR>
nnoremap ss
      \ <Cmd>Ddu -name=files-`tabpagenr()` file_point file_old
      \ `'.git'->finddir(';') != '' ? 'file_git' : ''`
      \ file -source-option-file-volatile
      \ file -source-param-file-new -source-option-file-volatile
      \ -unique -expandInput
      \ -resume=`
      \      ddu#get_items(#{ sources: ['file_point'] })->empty()
      \    ? 'v:true'
      \    : 'v:false'
      \ `
      \ -ui-param-ff-displaySourceName=short
      \ -ui-param-ff-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ <CR>
nnoremap / <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-line-ignoreEmptyInput
      \ -input=`'Pattern: '->cmdline#input()->escape(' ')`
      \ <CR>
nnoremap * <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -input=`expand('<cword>')`
      \ <CR>
nnoremap ;g <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input=
      \'`'Pattern: '->cmdline#input('<cword>'->expand())`'
      \ <CR>
xnoremap ;g y<Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input=
      \'`'Pattern: '->cmdline#input(v:register->getreg())`'
      \ <CR>
nnoremap ;f <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input=
      \'`'Pattern: '->cmdline#input('<cword>'->expand())`'
      \ -source-option-rg-path=
      \'`'Directory: '->cmdline#input($'{getcwd()}/', 'dir')`'
      \ <CR>
nnoremap ;a <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -source-option-rg-volatile
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
      \'`'Command: '->cmdline#input('', 'command')`'
      \ <CR>
xnoremap <expr> ;r
      \ (mode() ==# 'V' ? '"_R<Esc>' : '"_d')
      \ .. '<Cmd>Ddu -name=register register
      \ -source-option-ff-defaultAction=insert
      \ -ui-param-ff-autoResize<CR>'

xnoremap ;g <Cmd>call DduUrlItems()<CR>

function! DduUrlItems()
  const region = getregion(getpos('v'), getpos('.'), #{ type: mode() })
  if region->empty()
    return
  endif

  const url = region[0]->substitute('\s*\n\?$', '', '')

  call ddu#start(#{
        \   sources: ['item'],
        \   sourceParams: #{
        \     item: #{
        \       items: [
        \        #{
        \          word: url,
        \          kind: 'url',
        \          action: #{
        \            url: url,
        \          },
        \        },
        \       ],
        \     },
        \   },
        \   ui: 'ff',
        \   uiParams: #{
        \     ff: #{
        \       immediateUiAction: 'chooseAction',
        \     },
        \   },
        \ })
endfunction

" Open filter window automatically
"autocmd User Ddu:uiDone ++nested
"      \ call ddu#ui#async_action('openFilterWindow')

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
