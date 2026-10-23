" hook_add {{{
let g:goda_cmp#config_dir = '$BASE_DIR/goda-cmp'->expand()

autocmd MyAutoCmd BufWritePost ~/.config/vim/rc/goda-cmp/*.go
      \ call goda_cmp#build()

function GodaCmpCommandlinePre(mode) abort
  if 'b:prev_buffer_config'->exists()
    return
  endif

  " Overwrite sources
  let b:prev_buffer_config = goda_cmp#get_buffer()

  if a:mode ==# ':'
    call goda_cmp#patch_buffer(#{
          \   sourceOptions: #{
          \     _: #{
          \       keywordPattern: '(~\w+)?[0-9a-zA-Z_:#*/.-]*',
          \     },
          \   },
          \ })
  endif

  autocmd User GodaCmpCmdlineLeave ++once call GodaCmpCommandlinePost()

  call goda_cmp#enable_cmdline()
endfunction
function GodaCmpCommandlinePost() abort
  " Restore config
  if 'b:prev_buffer_config'->exists()
    call goda_cmp#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  endif
endfunction
" }}}

" hook_source {{{
call ddc#disable()

nnoremap :  <Cmd>call GodaCmpCommandlinePre(':')<CR>:
nnoremap ?  <Cmd>call GodaCmpCommandlinePre('/')<CR>?
xnoremap :  <Cmd>call GodaCmpCommandlinePre(':')<CR>:
nnoremap ;; <Cmd>call cmdline#enable()<CR><Cmd>call
      \ GodaCmpCommandlinePre(':')<CR>:
nnoremap ;  <Nop>

inoremap <expr> <C-g>   goda_cmp#map#insert_item(0)
cnoremap <expr> <C-g>   goda_cmp#map#insert_item(0)

inoremap <expr> <TAB>
      \   goda_cmp#ui#inline#visible()
      \ ? goda_cmp#map#insert_item(0)
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1, "empty")<CR>'
      \ : col('.') <= 1 ? '<TAB>'
      \ : getline('.')[col('.') - 2] =~# '\s'
      \ ? '<TAB>'
      \ : goda_cmp#map#manual_complete()
inoremap <expr> <C-e>
      \   goda_cmp#map#can_complete()
      \ ? goda_cmp#map#insert_item(0)
      \ : '<End>'
inoremap <expr> <C-l>  goda_cmp#map#manual_complete()

cnoremap <expr> <Tab>
      \   goda_cmp#ui#inline#visible()
      \ ? goda_cmp#map#insert_item(0)
      \ : wildmenumode()
      \ ? &wildcharm->nr2char()
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1)<CR>'
      \ : goda_cmp#map#manual_complete()
cnoremap <expr> <C-e>
      \   goda_cmp#ui#inline#visible()
      \ ? goda_cmp#map#insert_item(0)
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#cancel()<CR>'
      \ : '<End>'

xnoremap <Tab>   "_R<Cmd>call goda_cmp#map#manual_complete()<CR>
snoremap <Tab>   <C-o>"_di<Cmd>call goda_cmp#map#manual_complete()<CR>

call pum#set_option(#{
      \   preview: v:true,
      \   previewer: 'goda_cmp#get_previewer',
      \ })

call goda_cmp#patch_global(#{
      \   contextFiletype: has('nvim') ? 'treesitter' : 'none',
      \ })

" Terminal completion
call goda_cmp#enable_terminal()

call goda_cmp#enable()
" }}}
