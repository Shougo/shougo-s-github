" hook_add {{{
nnoremap [Space]s  <Cmd>call ddt#start(#{
      \   name: t:->get('ddt_ui_shell_last_name',
      \                 'shell-' .. win_getid()),
      \   ui: 'shell',
      \ })<CR>
nnoremap [Space]t  <Cmd>call ddt#start(#{
      \   name: t:->get('ddt_ui_terminal_last_name',
      \                 'terminal-' .. win_getid()),
      \   ui: 'terminal',
      \ })<CR>
nnoremap sD  <Cmd>call ddt#ui#kill_editor()<CR>
nnoremap <C-t> <Cmd>Ddu -name=ddt -sync
      \ -ui-param-ff-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ -ui-param-ff-winRow=1
      \ -ui-param-ff-autoResize
      \ -ui-param-ff-cursorPos=`tabpagenr()`
      \ ddt_tab<CR>
" }}}

" hook_source {{{
call ddt#custom#load_config('$BASE_DIR/ddt.ts'->expand())

function! MyGitStatus()
  const gitdir = '.git'->finddir(';')
  if gitdir ==# ''
    return ''
  endif

  if !'s:cached_status'->exists()
    let s:cached_status = {}
  endif

  const full_gitdir = gitdir->fnamemodify(':p')
  const gitdir_time = full_gitdir->getftime()
  const now = localtime()
  if !s:cached_status->has_key(full_gitdir)
        \ || gitdir_time > s:cached_status[full_gitdir].timestamp
        \ || now > s:cached_status[full_gitdir].check + 1
    " Get normal git status
    let status = printf(" %s%s",
          \   ['git', 'rev-parse', '--abbrev-ref','HEAD']
          \   ->job#system(),
          \   ['git', 'status', '--short', '--ignore-submodules=all']
          \   ->job#system())
          \ ->substitute('\n$', '', '')
          \ ->split('\n')
          \ ->map({ _, val -> '| ' .. val })
          \ ->join("\n")
          \ ->substitute('^| ', '', '')

    " Detect unsaved buffers
    for buf in #{ buflisted: 1 }->getbufinfo()
      if buf.changed && buf.name !=# ''
        " Check if the file is tracked by git
        let status .= "\n"
        let status .= printf('| ?? %s (unsaved)', buf.name->fnamemodify(':.'))
      endif
    endfor

    let s:cached_status[full_gitdir] = #{
          \   check: now,
          \   timestamp: gitdir_time,
          \   status: status,
          \ }
  endif

  return s:cached_status[full_gitdir].status
endfunction

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
tnoremap <expr> <C-y>
      \   pum#visible()
      \ ? '<Cmd>call pum#map#confirm()<CR>'
      \ : '<Cmd>call feedkeys(""->input(), "n")<CR>'
tnoremap <C-o>    <Cmd>call pum#map#confirm()<CR>
" }}}

" ddt-terminal {{{
nnoremap <buffer> <C-n>
      \ <Cmd>call ddt#ui#do_action('nextPrompt')<CR>
nnoremap <buffer> <C-p>
      \ <Cmd>call ddt#ui#do_action('previousPrompt')<CR>
nnoremap <buffer> <C-y>
      \ <Cmd>call ddt#ui#do_action('pastePrompt')<CR>
nnoremap <buffer> <CR>
      \ <Cmd>call ddt#ui#do_action('executeLine')<CR>
nnoremap <buffer> [Space]gd
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git diff',
      \ })<CR>
nnoremap <buffer> [Space]gc
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git commit',
      \ })<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git status',
      \ })<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git commit --amend',
      \ })<CR>
nnoremap <buffer> <C-h> <Cmd>Ddu -name=ddt -sync
      \ -input='`ddt#ui#get_input()`'
      \ ddt_shell_history<CR>
tnoremap <buffer> <C-z>  <Esc>q

augroup ddt-ui-terminal
  autocmd!
  autocmd DirChanged <buffer>
        \ : if (v:event->has_key('cwd') &&
        \       t:->get('ddt_ui_last_directory') !=# v:event.cwd)
        \ |   call ddt#ui#do_action('cd', #{
        \       directory: v:event.cwd,
        \     })
        \ | endif
augroup END

if exists('b:ddt_terminal_directory')
  execute 'tcd' b:ddt_terminal_directory->fnameescape()
endif
" }}}

" ddt-shell {{{
nnoremap <buffer> <C-n>
      \ <Cmd>call ddt#ui#do_action('nextPrompt')<CR>
nnoremap <buffer> <C-p>
      \ <Cmd>call ddt#ui#do_action('previousPrompt')<CR>
nnoremap <buffer> <C-y>
      \ <Cmd>call ddt#ui#do_action('pastePrompt')<CR>
nnoremap <buffer> <CR>
      \ <Cmd>call ddt#ui#do_action('executeLine')<CR>
inoremap <buffer> <CR>
      \ <Cmd>call ddt#ui#do_action('executeLine')<CR>
inoremap <buffer> <C-c>
      \ <Cmd>call ddt#ui#do_action('terminate')<CR>
inoremap <buffer> <C-z>
      \ <Cmd>call ddt#ui#do_action('pushBufferStack')<CR>
nnoremap <buffer> [Space]gd
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git diff',
      \ })<CR>
nnoremap <buffer> [Space]gc
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git commit',
      \ })<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git status',
      \ })<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git commit --amend',
      \ })<CR>
inoremap <buffer><expr> <C-n>
      \   pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1, "empty")<CR>'
      \ : ddc#map#manual_complete(#{ sources: ['shell_history'] })
inoremap <buffer><expr> <C-p>
      \   pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(-1, "empty")<CR>'
      \ : ddc#map#manual_complete(#{ sources: ['shell_history'] })
nnoremap <buffer> <C-h> <Cmd>Ddu -name=ddt -sync
      \ -input='`ddt#ui#get_input()`'
      \ ddt_shell_history<CR>

augroup ddt-ui-shell
  autocmd!
  autocmd DirChanged <buffer>
        \ : if (v:event->has_key('cwd') &&
        \       t:->get('ddt_ui_last_directory') !=# v:event.cwd)
        \ |   call ddt#ui#do_action('cd', #{
        \       directory: v:event.cwd,
        \     })
        \ | endif
augroup END

if exists('b:ddt_shell_directory')
  execute 'tcd' b:ddt_shell_directory->fnameescape()
endif
" }}}
