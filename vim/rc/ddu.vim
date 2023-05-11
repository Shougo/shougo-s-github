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
      \ -sync -unique -expandInput
      \ -ui-param-displaySourceName=short
      \ <CR>
nnoremap sr
      \ <Cmd>Ddu -name=files -resume<CR>
nnoremap / <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -ui-param-startFilter
      \ <CR>
nnoremap * <Cmd>Ddu
      \ -name=search line -resume=v:false
      \ -input=`expand('<cword>')`
      \ -ui-param-startFilter=v:false
      \ <CR>
nnoremap ;g <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ignoreEmpty
      \ -source-param-input=`'Pattern: '->input('<cword>'->expand())`
      \ <CR>
xnoremap ;g y<Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ignoreEmpty
      \ -source-param-input=`'Pattern: '->input(v:register->getreg())`
      \ <CR>
nnoremap ;f <Cmd>Ddu
      \ -name=search rg -resume=v:false
      \ -ui-param-ignoreEmpty
      \ -source-param-input=`'Pattern: '->input('<cword>'->expand())`
      \ -source-option-path=`'Directory: '->input(getcwd() .. '/', 'dir')`
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

"inoremap <C-q> <Cmd>Ddu
"\ -name=register register
"\ -source-option-defaultAction=append
"\ -source-param-range=window
"\ -ui-param-startFilter=v:false
"\ <CR>
inoremap <C-q> <Cmd>call ddu#start(#{
      \   name: 'file',
      \   ui: 'ff',
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
"\ -source-option-defaultAction=feedkeys
"\ -source-param-range=window
"\ -ui-param-startFilter=v:false
"\ <CR><Cmd>call setcmdline('')<CR><CR>
cnoremap <C-q> <Cmd>call ddu#start(#{
      \   name: 'file',
      \   ui: 'ff',
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
}}}

" hook_source = {{{
call ddu#custom#alias('source', 'file_rg', 'file_external')
call ddu#custom#alias('action', 'tabopen', 'open')

call ddu#custom#patch_global(#{
      \   ui: 'ff',
      \   uiOptions: #{
      \     filer: #{
      \       toggle: v:true,
      \     },
      \   },
      \   uiParams: #{
      \     ff: #{
      \       filterSplitDirection: 'floating',
      \       previewFloating: v:true,
      \       previewSplit: 'no',
      \       highlights: #{
      \         floating: 'Normal',
      \       },
      \       updateTime: 0,
      \       winWidth: 100,
      \     },
      \     filer: #{
      \       split: 'no',
      \       sort: 'filename',
      \       sortTreesFirst: v:true,
      \       toggle: v:true,
      \     },
      \   },
      \   sourceOptions: #{
      \     _: #{
      \       ignoreCase: v:true,
      \       matchers: ['matcher_substring'],
      \     },
      \     file_old: #{
      \       matchers: [
      \         'matcher_substring',
      \         'matcher_relative',
      \         'matcher_ignore_current_buffer',
      \       ],
      \     },
      \     file_external: #{
      \       matchers: [
      \         'matcher_substring',
      \       ],
      \     },
      \     file_rec: #{
      \       matchers: [
      \         'matcher_substring', 'matcher_hidden',
      \       ],
      \     },
      \     file: #{
      \       matchers: [
      \         'matcher_substring', 'matcher_hidden',
      \       ],
      \       sorters: ['sorter_alpha'],
      \     },
      \     dein: #{
      \       defaultAction: 'cd',
      \     },
      \     markdown: #{
      \       sorters: [],
      \     },
      \     line: #{
      \       matchers: [
      \         'matcher_kensaku',
      \       ],
      \     },
      \     path_history: #{
      \       defaultAction: 'uiCd',
      \     },
      \     rg: #{
      \       matchers: [
      \         'matcher_substring', 'matcher_files',
      \       ],
      \     },
      \   },
      \   sourceParams: #{
      \     file_external: #{
      \       cmd: ['git', 'ls-files', '-co', '--exclude-standard'],
      \     },
      \     rg: #{
      \       args: [
      \         '--ignore-case', '--column', '--no-heading',
      \         '--color', 'never',
      \       ],
      \     },
      \     file_rg: #{
      \       cmd: [
      \         'rg', '--files', '--glob', '!.git',
      \         '--color', 'never', '--no-messages'],
      \       updateItems: 50000,
      \     },
      \   },
      \   filterParams: #{
      \     matcher_kensaku: #{
      \       highlightMatched: 'Search',
      \     },
      \     matcher_substring: #{
      \       highlightMatched: 'Search',
      \     },
      \     matcher_ignore_files: #{
      \       ignoreGlobs: ['test_*.vim'],
      \       ignorePatterns: [],
      \     },
      \   },
      \   kindOptions: #{
      \     file: #{
      \       defaultAction: 'open',
      \     },
      \     word: #{
      \       defaultAction: 'append',
      \     },
      \     deol: #{
      \       defaultAction: 'switch',
      \     },
      \     action: #{
      \       defaultAction: 'do',
      \     },
      \     readme_viewer: #{
      \       defaultAction: 'open',
      \     },
      \   },
      \   kindParams: #{
      \     action: #{
      \       quit: v:true,
      \     },
      \   },
      \   actionOptions: #{
      \     narrow: #{
      \       quit: v:false,
      \     },
      \     tabopen: #{
      \       quit: v:false,
      \     },
      \   },
      \ })
call ddu#custom#patch_local('files', #{
      \   uiParams: #{
      \     ff: #{
      \       split: 'floating',
      \     }
      \   },
      \ })

call ddu#custom#action('kind', 'file', 'grep', { args -> GrepAction(args) })
function! GrepAction(args)
  call ddu#start(#{
        \   name: a:args.options.name,
        \   push: v:true,
        \   sources: [
        \     #{
        \       name: 'rg',
        \       params: #{
        \         path: a:args.items[0].action.path,
        \         input: 'Pattern: '->input(),
        \       },
        \     },
        \   ],
        \ })
endfunction

" Define cd action for "ddu-ui-filer"
call ddu#custom#action('kind', 'file', 'uiCd', { args -> UiCdAction(args) })
function! UiCdAction(args)
  const path = a:args.items[0].action.path
  const directory = path->isdirectory() ? path : path->fnamemodify(':h')

  call ddu#ui#do_action('itemAction',
        \ #{ name: 'narrow', params: #{ path: directory } })
endfunction
" }}}
