" hook_add {{{
nnoremap s<Space> <Cmd>Ddu
      \ -name=files file
      \ -source-option-path=`expand('$BASE_DIR')`
      \ <CR>
nnoremap ss
      \ <Cmd>Ddu -name=files file_point file_old
      \ `'.git'->finddir(';') != '' ? 'file_external' : ''`
      \ file -source-option-volatile
      \ file -source-param-new -source-option-volatile
      \ -unique -expandInput
      \ -ui-param-displaySourceName=short
      \ <CR>
nnoremap sr
      \ <Cmd>Ddu -name=files -resume<CR>
nnoremap / <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -ui-param-startFilter=v:false
      \ <CR>
nnoremap * <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -input=`expand('<cword>')`
      \ -ui-param-startFilter=v:false
      \ <CR>
nnoremap ;g <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ignoreEmpty
      \ -source-param-input='`'Pattern: '->input('<cword>'->expand())`'
      \ <CR>
xnoremap ;g y<Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ignoreEmpty
      \ -source-param-input='`'Pattern: '->input(v:register->getreg())`'
      \ <CR>
nnoremap ;f <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ignoreEmpty
      \ -source-param-input='`'Pattern: '->input('<cword>'->expand())`'
      \ -source-option-path=`'Directory: '->input($'{getcwd()}/', 'dir')`
      \ <CR>
nnoremap n <Cmd>Ddu
      \ -name=search -resume
      \ -ui-param-startFilter=v:false
      \ <CR>
nnoremap ;r <Cmd>Ddu
      \ -name=register register
      \ -source-option-defaultAction=`'.'->col() == 1 ? 'insert' : 'append'`
      \ -ui-param-autoResize
      \ <CR>
nnoremap ;d <Cmd>Ddu
      \ -name=outline markdown
      \ -ui-param-ignoreEmpty -ui-param-displayTree
      \ <CR>
xnoremap <expr> ;r
      \ (mode() ==# 'V' ? '"_R<Esc>' : '"_d')
      \ .. '<Cmd>Ddu -name=register register
      \ -source-option-defaultAction=insert
      \ -ui-param-autoResize<CR>'
nnoremap sg <Cmd>Ddu dein<CR>
nnoremap [Space]<Space> <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -source-param-range=window
      \ -ui-param-startFilter
      \ <CR>
nnoremap <C-o> <Cmd>Ddu jumplist <CR>

"inoremap <C-q> <Cmd>Ddu
"\ -name=register register
"\ -sync
"\ -source-option-defaultAction=append
"\ -source-param-range=window
"\ -ui-param-startFilter=v:false
"\ <CR>
inoremap <C-q> <Cmd>call ddu#start(#{
      \   name: 'file',
      \   ui: 'ff',
      \   sync: v:true,
      \   input: '.'->getline()[: '.'->col() - 1]->matchstr('\f*$'),
      \   sources: [
      \     #{ name: 'file', options: #{ defaultAction: 'feedkeys' } },
      \   ],
      \   uiParams: #{
      \     ff: #{
      \       startFilter: v:true,
      \       replaceCol: '.'->getline()[: '.'->col() - 1]->match('\f*$') + 1,
      \     },
      \   },
      \ })<CR>
"cnoremap <C-q> <Cmd>Ddu
"\ -name=register register
"\ -sync
"\ -source-option-defaultAction=feedkeys
"\ -source-param-range=window
"\ -ui-param-startFilter=v:false
"\ <CR><Cmd>call setcmdline('')<CR><CR>
cnoremap <C-q> <Cmd>call ddu#start(#{
      \   name: 'file',
      \   ui: 'ff',
      \   sync: v:true,
      \   input: getcmdline()[: getcmdpos() - 2]->matchstr('\f*$'),
      \   sources: [
      \     #{ name: 'file', options: #{ defaultAction: 'feedkeys' } },
      \   ],
      \   uiParams: #{
      \     ff: #{
      \       startFilter: v:true,
      \       replaceCol: getcmdline()[: getcmdpos() - 2]->match('\f*$') + 1,
      \     },
      \   },
      \ })<CR><Cmd>call setcmdline('')<CR><CR>

" Initialize ddu.vim lazily.
if !('g:shougo_s_github_load_state'->exists())
  call timer_start(10, { _ ->
        \   ddu#start(#{
        \     ui: 'ff',
        \     uiParams: #{
        \       ff: #{
        \         ignoreEmpty: v:true,
        \       },
        \     },
        \   })
        \ })
endif

" }}}

" hook_source = {{{
call ddu#custom#load_config(expand('$BASE_DIR/ddu.ts'))
" }}}
