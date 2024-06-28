" hook_add {{{
nnoremap [Space]s
      \ <Cmd>call deol#start(#{
      \   command: [has('win32') ? 'cmd': 'zsh'],
      \   start_insert: v:false,
      \ })<CR>
nnoremap sD  <Cmd>call deol#kill_editor()<CR>
nnoremap <C-t> <Cmd>Ddu -name=deol -sync
      \ -ui-param-ff-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ -ui-param-ff-winRow=1
      \ -ui-param-ff-autoResize
      \ -ui-param-ff-cursorPos=`tabpagenr()`
      \ deol<CR>
" }}}

" hook_source {{{
call deol#set_option(#{
      \    internal_history_path: '~/.cache/deol-history',
      \    nvim_server: '~/.cache/nvim/server.pipe',
      \    prompt_pattern: has('win32') ? '\f\+>' : '\w*% \?',
      \ })
if !has('win32')
  call deol#set_option('external_history_path', '~/.zsh-history')
  call deol#set_option('command', ['zsh'])
endif

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
tnoremap <expr> <Tab> pum#visible() ?
      \ '<Cmd>call pum#map#select_relative(+1)<CR>' :
      \ '<Tab>'
tnoremap <expr> <S-Tab> pum#visible() ?
      \ '<Cmd>call pum#map#select_relative(-1)<CR>' :
      \ '<S-Tab>'
tnoremap <Down>   <Cmd>call pum#map#insert_relative(+1)<CR>
tnoremap <Up>     <Cmd>call pum#map#insert_relative(-1)<CR>
tnoremap <C-y>    <Cmd>call pum#map#confirm()<CR>
tnoremap <C-o>    <Cmd>call pum#map#confirm()<CR>
" }}}

" deol {{{
nnoremap <buffer> <C-n>  <Plug>(deol_next_prompt)
nnoremap <buffer> <C-p>  <Plug>(deol_previous_prompt)
nnoremap <buffer> <CR>   <Plug>(deol_execute_line)
nnoremap <buffer> A      <Plug>(deol_start_append_last)
nnoremap <buffer> I      <Plug>(deol_start_insert_first)
nnoremap <buffer> a      <Plug>(deol_start_append)
nnoremap <buffer> e      <Plug>(deol_edit)
nnoremap <buffer> i      <Plug>(deol_start_insert)
nnoremap <buffer> q      <Plug>(deol_quit)

nnoremap <buffer> [Space]gc
      \ <Cmd>call deol#send('git commit')<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call deol#send('git status')<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call deol#send('git commit --amend')<CR>

tnoremap <buffer><expr> <CR>
      \ (pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '')
      \ .. '<Plug>(deol_execute_line)'

call ddc#custom#patch_filetype('deol', 'sourceOptions', #{
      \   _: #{
      \     converters: [],
      \   },
      \ })

autocmd MyAutoCmd DirChanged <buffer>
      \ call deol#cd(v:event->get('cwd', getcwd()))
" }}}

" zsh {{{
inoreabbrev <buffer> g git
nnoremap <buffer> [Space]gc
      \ <Cmd>call deol#send('git commit')<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call deol#send('git status')<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call deol#send('git commit --amend')<CR>
" }}}
