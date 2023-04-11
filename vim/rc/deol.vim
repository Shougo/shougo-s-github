" hook_add {{{
nnoremap <expr> [Space]s
      \ printf('<Cmd>Deol %s -no-start-insert -toggle<CR>',
      \        has('win32') ? 'cmd': 'zsh')
nnoremap sD  <Cmd>call deol#kill_editor()<CR>
nnoremap <C-t> <Cmd>Ddu -name=deol
      \ -ui-param-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ -ui-param-winRow=1 -ui-param-autoResize
      \ -ui-param-cursorPos=`tabpagenr()-1`
      \ deol<CR>
" }}}

" hook_source {{{
let g:deol#enable_dir_changed = v:false
let g:deol#prompt_pattern = '\w*% \?'
let g:deol#shell_history_path = '~/.zsh-history'
let g:deol#extra_options = #{
      \   term_kill: 'kill',
      \ }
let g:deol#nvim_server = '~/.cache/nvim/server.pipe'

call ddu#custom#patch_global(#{
      \   sourceParams: #{
      \     deol: #{
      \       command: ['zsh'],
      \     },
      \   }
      \ })

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

tnoremap <expr><C-t> ddc#map#manual_complete()
tnoremap <expr> <Tab> pum#visible() ?
      \ '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ '<Tab>'
tnoremap <expr> <S-Tab> pum#visible() ?
      \ '<Cmd>call pum#map#insert_relative(-1)<CR>' :
      \ '<S-Tab>'
tnoremap <Down>   <Cmd>call pum#map#select_relative(+1)<CR>
tnoremap <Up>     <Cmd>call pum#map#select_relative(-1)<CR>
tnoremap <expr> <C-y>
      \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<C-y>'
tnoremap <expr> <C-e>
      \ pum#visible() ? '<Cmd>call pum#map#cancel()<CR>' : '<C-e>'
tnoremap <expr> <C-g>   ddc#map#manual_complete()
tnoremap <C-o>   <Cmd>call pum#map#confirm()<CR>
" }}}

" deol {{{
nnoremap <buffer> [Space]gc
      \ <Cmd>call deol#send('git commit')<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call deol#send('git status')<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call deol#send('git commit --amend')<CR>
nmap <buffer> e <Plug>(deol_edit)
tmap <buffer><expr> <CR>
      \ (pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '')
      \ .. '<Plug>(deol_execute_line)'

call ddc#custom#patch_buffer('sourceOptions', #{
      \   _: #{
      \     converters: [],
      \   },
      \ })
" }}}

" zsh {{{
nnoremap <buffer> [Space]gc
      \ <Cmd>call deol#send('git commit')<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call deol#send('git status')<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call deol#send('git commit --amend')<CR>
" }}}
