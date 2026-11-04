" hook_add {{{
let g:goda_term#config_dir = '$BASE_DIR/goda-term'->expand()

nnoremap [Space]s  <Cmd>call goda_term#start(#{
      \   name: t:->get('goda_term_ui_terminal_last_name',
      \                 'shell-' .. win_getid()),
      \   ui: 'shell',
      \ })<CR>
nnoremap [Space]t <Cmd>call goda_term#start(#{
      \   name: t:->get('goda_term_ui_terminal_last_name',
      \                 'terminal-' .. win_getid()),
      \   ui: 'terminal',
      \ })<CR>
" }}}

" hook_source {{{

function GodaShellGitStatus()
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
    let lines = [
          \   'git',
          \   'status',
          \   '--short',
          \   '--branch',
          \   '--ignore-submodules=all',
          \ ]->job#system()->split('\n')
    if lines->empty()
      let status = ''
    else
      " "## main...origin/main [ahead 1]" /
      " "## No commits yet on main" /
      " "## HEAD (no branch)"
      let branch = lines[0]
            \ ->substitute(
            \   '^## \%(No commits yet on \|Initial commit on \)\=', '', '')
            \ ->substitute('\.\.\..*$', '', '')
      let status = ([' ' .. branch] + lines[1:]
            \       ->map({ _, val -> '| ' .. val }))->join("\n")
    endif

    " Detect unsaved buffers
    for buf in #{ buflisted: 1 }->getbufinfo()
      if buf.changed && buf.name !=# ''
        " Check if the file is tracked by git
        let status .= "\n"
        let status .= printf('|    %s (unsaved)', buf.name->fnamemodify(':.'))
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
