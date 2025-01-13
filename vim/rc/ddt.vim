" hook_add {{{
nnoremap [Space]s  <Cmd>call ddt#start(#{
      \   name: 'terminal-' .. win_getid(),
      \   ui: 'terminal',
      \   uiParams: #{
      \     terminal: #{
      \       command: ['zsh'],
      \       promptPattern: '\w*% \?',
      \       startInsert: v:true,
      \     },
      \   },
      \ })<CR>
nnoremap sD  <Cmd>call ddt#ui#terminal#kill_editor()<CR>
nnoremap <C-t> <Cmd>Ddu -name=ddt -sync
      \ -ui-param-ff-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ -ui-param-ff-winRow=1
      \ -ui-param-ff-autoResize
      \ -ui-param-ff-cursorPos=`tabpagenr()`
      \ ddt_tab<CR>
" }}}

" hook_source {{{
" Set terminal colors
if has('nvim')
  let g:terminal_color_0  = '#6c6c6c'
  let g:terminal_color_1  = '#ff6666'
  let g:terminal_color_2  = '#66ff66'
  let g:terminal_color_3  = '#ffd30a'
  let g:terminal_color_4  = '#1e95fd'
  let g:terminal_color_5  = '#ff13ff'
  let g:terminal_color_6  = '#1bc8c8'
  let g:terminal_color_7  = '#c0c0c0'
  let g:terminal_color_8  = '#383838'
  let g:terminal_color_9  = '#ff4444'
  let g:terminal_color_10 = '#44ff44'
  let g:terminal_color_11 = '#ffb30a'
  let g:terminal_color_12 = '#6699ff'
  let g:terminal_color_13 = '#f820ff'
  let g:terminal_color_14 = '#4ae2e2'
  let g:terminal_color_15 = '#ffffff'
else
  let g:terminal_ansi_colors = [
        \ '#6c6c6c', '#ff6666', '#66ff66', '#ffd30a',
        \ '#1e95fd', '#ff13ff', '#1bc8c8', '#c0c0c0',
        \ '#383838', '#ff4444', '#44ff44', '#ffb30a',
        \ '#6699ff', '#f820ff', '#4ae2e2', '#ffffff',
        \ ]
endif

tnoremap <C-t> <Tab>
tnoremap <expr> <Tab>
      \ pum#visible()
      \ ? '<Cmd>call pum#map#select_relative(+1)<CR>'
      \ : '<Tab>'
tnoremap <expr> <S-Tab>
      \   pum#visible()
      \ ? '<Cmd>call pum#map#select_relative(-1)<CR>'
      \ : '<S-Tab>'
tnoremap <Down>   <Cmd>call pum#map#insert_relative(+1)<CR>
tnoremap <Up>     <Cmd>call pum#map#insert_relative(-1)<CR>
tnoremap <C-y>    <Cmd>call pum#map#confirm()<CR>
tnoremap <C-o>    <Cmd>call pum#map#confirm()<CR>
" }}}

" ddt-terminal {{{
nnoremap <buffer> <C-n>
      \ <Cmd>call ddt#ui#do_action('nextPrompt')<CR>
nnoremap <buffer> <C-p>
      \ <Cmd>call ddt#ui#do_action('previousPrompt')<CR>

autocmd MyAutoCmd DirChanged <buffer>
      \ call ddt#ui#do_action('cd', #{
      \   directory: v:event->get('cwd', getcwd()),
      \ })

if exists('b:ddt_terminal_directory')
  execute 'tcd' b:ddt_terminal_directory->fnameescape()
endif
" }}}
