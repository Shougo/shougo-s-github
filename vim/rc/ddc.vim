" hook_source {{{
call ddc#custom#patch_global(#{
      \   ui: 'pum',
      \   sources: ['codeium', 'around', 'file'],
      \   autoCompleteEvents: [
      \     'InsertEnter', 'TextChangedI', 'TextChangedP',
      \     'CmdlineEnter', 'CmdlineChanged', 'TextChangedT',
      \   ],
      \   cmdlineSources: {
      \     ':': ['cmdline-history', 'cmdline', 'around'],
      \     '@': ['cmdline-history', 'input', 'file', 'around'],
      \     '>': ['cmdline-history', 'input', 'file', 'around'],
      \     '/': ['around', 'line'],
      \     '?': ['around', 'line'],
      \     '-': ['around', 'line'],
      \     '=': ['input'],
      \   },
      \ })

call ddc#custom#patch_global('sourceOptions', #{
      \   _: #{
      \     ignoreCase: v:true,
      \     matchers: ['matcher_head', 'matcher_length'],
      \     sorters: ['sorter_rank'],
      \     converters: [
      \       'converter_remove_overlap', 'converter_truncate_abbr',
      \     ],
      \   },
      \   around: #{
      \     mark: 'A',
      \   },
      \   buffer: #{
      \     mark: 'B',
      \   },
      \   necovim: #{
      \     mark: 'vim',
      \   },
      \   nvim-lua: #{
      \     mark: 'lua',
      \     forceCompletionPattern: '\.\w*',
      \   },
      \   cmdline: #{
      \     mark: 'cmdline',
      \     forceCompletionPattern: '\S/\S*|\.\w*',
      \     dup: 'force',
      \   },
      \   copilot: #{
      \     mark: 'cop',
      \     matchers: [],
      \     minAutoCompleteLength: 0,
      \     isVolatile: v:false,
      \   },
      \   codeium: #{
      \     mark: 'cod',
      \     matchers: ['matcher_length'],
      \     minAutoCompleteLength: 0,
      \     isVolatile: v:true,
      \   },
      \   input: #{
      \     mark: 'input',
      \     forceCompletionPattern: '\S/\S*',
      \     isVolatile: v:true,
      \     dup: 'force',
      \   },
      \   line: #{
      \     mark: 'line',
      \     matchers: ['matcher_vimregexp'],
      \   },
      \   mocword: #{
      \     mark: 'mocword',
      \     minAutoCompleteLength: 3,
      \     isVolatile: v:true,
      \   },
      \   nvim-lsp: #{
      \     mark: 'lsp',
      \     forceCompletionPattern: '\.\w*|::\w*|->\w*',
      \     dup: 'force',
      \   },
      \   rtags: #{
      \     mark: 'R',
      \     forceCompletionPattern: '\.\w*|::\w*|->\w*',
      \   },
      \   file: #{
      \     mark: 'F',
      \     isVolatile: v:true,
      \     minAutoCompleteLength: 1000,
      \     forceCompletionPattern: '\S/\S*',
      \   },
      \   cmdline-history: #{
      \     mark: 'history',
      \     sorters: [],
      \   },
      \   shell-history: #{
      \     mark: 'shell'
      \   },
      \   zsh: #{
      \     mark: 'zsh',
      \     isVolatile: v:true,
      \     forceCompletionPattern: '\S/\S*',
      \   },
      \   rg: #{
      \     mark: 'rg',
      \     minAutoCompleteLength: 5,
      \     enabledIf: "finddir('.git', ';') != ''",
      \   },
      \   skkeleton: #{
      \     mark: 'skk',
      \     matchers: ['skkeleton'],
      \     sorters: [],
      \     minAutoCompleteLength: 2,
      \     isVolatile: v:true,
      \   },
      \ })

call ddc#custom#patch_global('sourceParams', #{
      \   buffer: #{
      \     requireSameFiletype: v:false,
      \     limitBytes: 50000,
      \     fromAltBuf: v:true,
      \     forceCollect: v:true,
      \   },
      \   file: #{
      \     filenameChars: '[:keyword:].',
      \   },
      \ })

call ddc#custom#patch_filetype(
      \   ['help', 'markdown', 'gitcommit'],
      \   'sources',
      \   ['around', 'codeium', 'mocword']
      \ )
call ddc#custom#patch_filetype(['ddu-ff-filter'], #{
      \   keywordPattern: '[0-9a-zA-Z_:#-]*',
      \   sources: ['line', 'buffer'],
      \   specialBufferCompletion: v:true,
      \ })

if has('nvim')
  call ddc#custom#patch_filetype(
        \   ['typescript', 'typescriptreact', 'go', 'python'],
        \   'sources',
        \   ['codeium', 'nvim-lsp', 'around']
        \ )
  call ddc#custom#patch_filetype(
        \   ['lua'],
        \   'sources',
        \   ['codeium', 'nvim-lua', 'around']
        \ )
endif

call ddc#custom#patch_filetype(['FineCmdlinePrompt'], #{
      \   keywordPattern: '[0-9a-zA-Z_:#-]*',
      \   sources: ['cmdline-history', 'around'],
      \   specialBufferCompletion: v:true,
      \ })

" Context config
call ddc#custom#set_context_filetype('go', { ->
      \   ddc#syntax#in('TSComment') ?
      \   #{ sources: ['around', 'mocword'] } : {}
      \ })
call ddc#custom#set_context_filetype('c', { ->
      \   ddc#syntax#in('Comment') ?
      \   #{ sources: ['around', 'mocword'] } : {}
      \ })

" For insert mode completion
inoremap <expr> <TAB>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#map#manual_complete()
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-x><C-f>
      \ <Cmd>call ddc#map#manual_complete(#{ sources: ['file'] })<CR>
"inoremap <expr> <C-e>
"      \ ddc#map#insert_item(0, '<Cmd>call pum#map#cancel()<CR>')
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-o>   <Cmd>call pum#map#confirm_word()<CR>

" Refresh the completion
inoremap <expr> <C-l>  ddc#map#manual_complete()

" For command line mode completion
cnoremap <expr> <Tab>
      \ wildmenumode() ? &wildcharm->nr2char() :
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ ddc#map#manual_complete()
cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-o>   <Cmd>call pum#map#confirm()<CR>
"cnoremap <expr> <C-e>
"      \ ddc#map#insert_item(0, '<Cmd>call pum#map#cancel()<CR>')

" For terminal completion
call ddc#enable_terminal_completion()
call ddc#custom#patch_filetype(['deol'], #{
      \   specialBufferCompletion: v:true,
      \   keywordPattern: '[0-9a-zA-Z_./#:-]*',
      \   sources: ['zsh', 'shell-history', 'around'],
      \ })

" Narrowing by ddu
"inoremap <C-l> <Cmd>call ddu#start(#{
"      \   name: 'ddc',
"      \   ui: 'ff',
"      \   input: matchstr(getline('.')[: col('.') - 1], '\k*$'),
"      \   sources: [
"      \     #{ name: 'ddc', options: #{ defaultAction: 'complete' } },
"      \   ],
"      \   uiParams: #{
"      \     ff: #{
"      \       startFilter: v:true,
"      \       replaceCol: match(getline('.')[: col('.') - 1], '\k*$') + 1,
"      \     },
"      \   },
"      \ })<CR>

call ddc#enable()
" }}}

" hook_add {{{
nnoremap :       <Cmd>call CommandlinePre(':')<CR>:
nnoremap ?       <Cmd>call CommandlinePre('/')<CR>?
xnoremap :       <Cmd>call CommandlinePre(':')<CR>:
nnoremap +       <Cmd>call CommandlinePre('dda')<CR>:Dda<Space>

function! CommandlinePre(mode) abort
  " Overwrite sources
  let b:prev_buffer_config = ddc#custom#get_buffer()

  if a:mode ==# ':'
    call ddc#custom#patch_buffer('keywordPattern', '[0-9a-zA-Z_:#-]*')
  elseif a:mode ==# 'dda'
    " For AI completion
    call ddc#custom#patch_buffer('cmdlineSources', ['around', 'mocword'])
  endif

  autocmd MyAutoCmd User DDCCmdlineLeave ++once call CommandlinePost()

  call ddc#enable_cmdline_completion()
endfunction
function! CommandlinePost() abort
  " Restore config
  if 'b:prev_buffer_config'->exists()
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  endif
endfunction
" }}}
