" hook_add {{{
nnoremap :       <Cmd>call CommandlinePre(':')<CR>:
nnoremap ?       <Cmd>call CommandlinePre('/')<CR>?
xnoremap :       <Cmd>call CommandlinePre(':')<CR>:
nnoremap +       <Cmd>call CommandlinePre('dda')<CR>:Dda<Space>

function! CommandlinePre(mode) abort
  " Overwrite sources
  let b:prev_buffer_config = ddc#custom#get_buffer()

  if a:mode ==# ':'
    call ddc#custom#patch_buffer('sourceOptions', #{
          \   _: #{
          \     keywordPattern: '[0-9a-zA-Z_:#-]*',
          \   },
          \ })

    " Use zsh source for :! completion
    call ddc#custom#set_context_buffer({ ->
          \ getcmdline()->stridx('!') ==# 0 ? {
          \   'cmdlineSources': [
          \     'shell-native', 'cmdline', 'cmdline-history', 'around',
          \   ],
          \ } : {} })

    "call ddc#custom#patch_buffer('ui', 'inline')
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

" hook_source {{{
call ddc#custom#load_config('$BASE_DIR/ddc.ts'->expand())

" Context config
"call ddc#custom#set_context_filetype('go', { ->
"      \   ddc#syntax#in('TSComment') ?
"      \   #{ sources: ['around', 'mocword'] } : {}
"      \ })
"call ddc#custom#set_context_filetype('c', { ->
"      \   ddc#syntax#in('Comment') ?
"      \   #{ sources: ['around', 'mocword'] } : {}
"      \ })

" For insert mode completion
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1, 'empty')<CR>
inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
"inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm_suffix()<CR>
inoremap <C-o>   <Cmd>call pum#map#confirm_word()<CR>
inoremap <Home>  <Cmd>call pum#map#insert_relative(-9999, 'ignore')<CR>
inoremap <End>   <Cmd>call pum#map#insert_relative(+9999, 'ignore')<CR>
inoremap <C-g>   <Cmd>call pum#set_option(#{
      \   preview: !pum#_options().preview,
      \ })<CR>
inoremap <C-t>   <C-v><Tab>
"inoremap <C-z>   <Cmd>call pum#update_current_item(#{ display: 'hoge' })<CR>
"inoremap <C-y>   <Cmd>call pum#map#scroll_preview(+1)<CR>
"inoremap <C-e>   <Cmd>call pum#map#scroll_preview(-1)<CR>

inoremap <expr> <TAB>
      \ pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1, "empty")<CR>'
      \ : col('.') <= 1 ? '<TAB>'
      \ : getline('.')[col('.') - 2] =~# '\s'
      \ ? '<TAB>'
      \ : ddc#map#manual_complete()
inoremap <expr> <C-e> pum#visible()
      \ ? '<Cmd>call pum#map#cancel()<CR>'
      \ : '<End>'
inoremap <expr> <C-l>  ddc#map#manual_complete()

" For command line mode completion
cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-o>   <Cmd>call pum#map#confirm()<CR>
cnoremap <C-q>   <Cmd>call pum#map#select_relative(+1)<CR>
cnoremap <C-z>   <Cmd>call pum#map#select_relative(-1)<CR>
cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
"cnoremap <C-y>   <Cmd>call pum#map#scroll_preview(+1)<CR>
"cnoremap <C-e>   <Cmd>call pum#map#scroll_preview(-1)<CR>

cnoremap <expr> <Tab>
      \   wildmenumode()
      \ ? &wildcharm->nr2char()
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1)<CR>'
      \ : ddc#map#manual_complete()
cnoremap <expr> <C-t>       ddc#map#insert_item(0)
cnoremap <expr> <C-e>
      \   pum#visible()
      \ ? '<Cmd>call pum#map#cancel()<CR>'
      \ : '<End>'

xnoremap <Tab>   "_R<Cmd>call ddc#map#manual_complete()<CR>
snoremap <Tab>   <C-o>"_di<Cmd>call ddc#map#manual_complete()<CR>

" Enable terminal completion
call ddc#enable_terminal_completion()

call ddc#enable(#{
      \   context_filetype: has('nvim') ? 'treesitter' : 'none',
      \ })
" }}}

" hook_post_update {{{
call ddc#set_static_import_path()
" }}}
