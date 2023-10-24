" hook_add {{{
nnoremap s<Space> <Cmd>Ddu
      \ -name=files file
      \ -source-option-file-path=`expand('$BASE_DIR')`
      \ -ui-param-ff-split=floating
      \ <CR>
nnoremap ss
      \ <Cmd>Ddu -name=files-`tabpagenr()` file_point file_old
      \ `'.git'->finddir(';') != '' ? 'file_git' : ''`
      \ file -source-option-file-volatile
      \ file -source-param-file-new -source-option-file-volatile
      \ -unique -expandInput -sync
      \ -resume=`ddu#get_items(#{ sources: ['file_point'] })->empty() ?
      \          'v:true' : 'v:false'`
      \ -ui-param-ff-displaySourceName=short
      \ -ui-param-ff-split=floating
      \ <CR>
nnoremap / <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -ui-param-ff-startFilter=v:true
      \ <CR>
nnoremap * <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -input=`expand('<cword>')`
      \ -ui-param-ff-startFilter=v:false
      \ <CR>
nnoremap ;g <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input='`'Pattern: '->input('<cword>'->expand())`'
      \ <CR>
xnoremap ;g y<Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input='`'Pattern: '->input(v:register->getreg())`'
      \ <CR>
nnoremap ;f <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ff-ignoreEmpty
      \ -source-param-rg-input='`'Pattern: '->input('<cword>'->expand())`'
      \ -source-option-rg-path='`'Directory: '->input($'{getcwd()}/', 'dir')`'
      \ <CR>
nnoremap n <Cmd>Ddu
      \ -name=search -resume
      \ -ui-param-ff-startFilter=v:false
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
      \ -source-param-output-command='`'Command: '->input('', 'command')`'
      \ <CR>
xnoremap <expr> ;r
      \ (mode() ==# 'V' ? '"_R<Esc>' : '"_d')
      \ .. '<Cmd>Ddu -name=register register
      \ -source-option-ff-defaultAction=insert
      \ -ui-param-ff-autoResize<CR>'
nnoremap <C-o> <Cmd>Ddu jumplist <CR>

"inoremap <C-q> <Cmd>Ddu
"\ -name=register register
"\ -sync
"\ -source-option-register-defaultAction=append
"\ -ui-param-ff-startFilter=v:false
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
"\ -source-option-register-defaultAction=feedkeys
"\ -ui-param-ff-startFilter=v:false
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
  call timer_start(10, { _ -> LazyDdu() })
  function LazyDdu()
    call ddu#load('ui', ['ff'])
    call ddu#load('source', [
          \     'file', 'file_point', 'file_old', 'file_git',
          \   ])
    call ddu#load('filter', [
          \     'matcher_kensaku',
          \     'matcher_relative',
          \     'matcher_substring',
          \     'matcher_hidden',
          \     'sorter_alpha',
          \     'converter_hl_dir',
          \   ])
    call ddu#load('kind', ['file'])
  endfunction
endif
" }}}

" hook_source = {{{
call ddu#custom#load_config(expand('$BASE_DIR/ddu.ts'))
" }}}
