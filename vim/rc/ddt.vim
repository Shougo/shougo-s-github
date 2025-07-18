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
call ddt#custom#patch_global(#{
      \   debug: v:false,
      \   nvimServer: '~/.cache/nvim/server.pipe',
      \   uiParams: #{
      \     shell: #{
      \       aliases: #{
      \         ls: 'ls --color',
      \       },
      \       ansiColorHighlights: #{
      \         bgs: [
      \           'TerminalBG0', 'TerminalBG1',
      \           'TerminalBG2', 'TerminalBG3',
      \           'TerminalBG4', 'TerminalBG5',
      \           'TerminalBG6', 'TerminalBG7',
      \           'TerminalBG8', 'TerminalBG9',
      \           'TerminalBG10', 'TerminalBG11',
      \           'TerminalBG12', 'TerminalBG13',
      \           'TerminalBG14', 'TerminalBG15',
      \         ],
      \         bold: 'Bold',
      \         fgs: [
      \           'TerminalFG0', 'TerminalFG1',
      \           'TerminalFG2', 'TerminalFG3',
      \           'TerminalFG4', 'TerminalFG5',
      \           'TerminalFG6', 'TerminalFG7',
      \           'TerminalFG8', 'TerminalFG9',
      \           'TerminalFG10', 'TerminalFG11',
      \           'TerminalFG12', 'TerminalFG13',
      \           'TerminalFG14', 'TerminalFG15',
      \         ],
      \         italic: 'Italic',
      \         underline: 'Underlined',
      \       },
      \       noSaveHistoryCommands: [
      \         'history',
      \       ],
      \       userPrompt:
      \         "'| ' .. fnamemodify(getcwd(), ':~') .. MyGitStatus()",
      \       shellHistoryPath: '~/.cache/ddt-shell-history'->expand(),
      \     },
      \     terminal: #{
      \       command: ['zsh'],
      \       promptPattern: has('win32') ? '\f\+>' : '\w*% \?',
      \     },
      \   },
      \ })
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
        \ || now > s:cached_status[full_gitdir].check + 5
    const status = printf(" %s%s",
          \   ['git', 'rev-parse', '--abbrev-ref','HEAD']
          \   ->job#system(),
          \   ['git', 'status', '--short', '--ignore-submodules=all']
          \   ->job#system())
          \ ->substitute('\n$', '', '')
          \ ->split('\n')
          \ ->map({ _, val -> '| ' .. val })
          \ ->join("\n")
          \ ->substitute('^| ', '', '')
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
tnoremap <C-y>    <Cmd>call pum#map#confirm()<CR>
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
