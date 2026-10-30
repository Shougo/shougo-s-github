" hook_add {{{
nnoremap :
      \ <Cmd>call DdcCommandlinePre(':')<CR>:
nnoremap ?
      \ <Cmd>call DdcCommandlinePre('/')<CR>?
xnoremap :
      \ <Cmd>call DdcCommandlinePre(':')<CR>:
nnoremap ;;
      \ <Cmd>call cmdline#enable()<CR><Cmd>call DdcCommandlinePre(':')<CR>:
nnoremap ;  <Nop>

function DdcCommandlinePre(mode) abort
  if 'b:prev_buffer_config'->exists()
    return
  endif

  " Overwrite sources
  let b:prev_buffer_config = ddc#custom#get_buffer()

  if a:mode ==# ':'
    call ddc#custom#patch_buffer('sourceOptions', #{
          \   _: #{
          \     keywordPattern: '(~\w+)?[0-9a-zA-Z_:#*/.-]*',
          \   },
          \ })
  endif

  autocmd MyAutoCmd User DDCCmdlineLeave ++once call DdcCommandlinePost()

  call ddc#enable_cmdline_completion()
endfunction
function DdcCommandlinePost() abort
  " Restore config
  if 'b:prev_buffer_config'->exists()
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  endif
endfunction
" }}}

" hook_source {{{

inoremap <expr> <C-g>   ddc#map#insert_item(0)
cnoremap <expr> <C-g>   ddc#map#insert_item(0)

inoremap <expr> <TAB>
      \   ddc#ui#inline#visible()
      \ ? ddc#map#insert_item(0)
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1, "empty")<CR>'
      \ : col('.') <= 1 ? '<TAB>'
      \ : getline('.')[col('.') - 2] =~# '\s'
      \ ? '<TAB>'
      \ : ddc#map#manual_complete()
inoremap <expr> <C-e>
      \   ddc#map#can_complete()
      \ ? ddc#map#insert_item(0)
      \ : '<End>'
inoremap <expr> <C-l>  ddc#map#manual_complete()

cnoremap <expr> <Tab>
      \   ddc#ui#inline#visible()
      \ ? ddc#map#insert_item(0)
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1)<CR>'
      \ : ddc#map#manual_complete()
cnoremap <expr> <C-e>
      \   ddc#ui#inline#visible()
      \ ? ddc#map#insert_item(0)
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#cancel()<CR>'
      \ : '<End>'

xnoremap <Tab>   "_R<Cmd>call ddc#map#manual_complete()<CR>
snoremap <Tab>   <C-o>"_di<Cmd>call ddc#map#manual_complete()<CR>

call ddc#custom#load_config('$BASE_DIR/ddc.ts'->expand())

" Context config
"call ddc#custom#set_context_filetype('go', { ->
"      \     ddc#syntax#in('TSComment')
"      \   ? #{ sources: ['around', 'mocword'] }
"      \   : {}
"      \ })
"call ddc#custom#set_context_filetype('c', { ->
"      \     ddc#syntax#in('Comment')
"      \   ? #{ sources: ['around', 'mocword'] }
"      \   : {}
"      \ })
" Enable terminal completion
call ddc#enable_terminal_completion()

call ddc#enable(#{
      \   context_filetype: has('nvim') ? 'treesitter' : 'none',
      \ })
" }}}
