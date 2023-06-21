"---------------------------------------------------------------------------
" vimrc functions:
"

function vimrc#sticky_func() abort
  const sticky_table = {
        \  ',': '<', '.': '>', '/': '?',
        \  '1': '!', '2': '@', '3': '#', '4': '$', '5': '%',
        \  '6': '^', '7': '&', '8': '*', '9': '(', '0': ')',
        \  '-': '_', '=': '+',
        \  ';': ':', '[': '{', ']': '}', '`': '~', "'": "\"", '\': '|',
        \ }
  const special_table = {
        \  "\<ESC>": "\<ESC>", "\<Space>": ';', "\<CR>": ";\<CR>",
        \ }

  let char = ''

  while 1
    silent! let char = getchar()->nr2char()

    if char =~# '\l'
      let char = char->toupper()
      break
    elseif sticky_table->has_key(char)
      let char = sticky_table[char]
      break
    elseif special_table->has_key(char)
      let char = special_table[char]
      break
    endif
  endwhile

  return char
endfunction

function vimrc#add_numbers(num) abort
  const prev_line = '.'->getline()[: '.'->col()-1]
  const next_line = '.'->getline()['.'->col() :]

  " Boolean mode
  const cword = prev_line->matchstr('\w\+$') .. next_line->matchstr('^\w\+')
  const replace = #{
        \   true: 'false',
        \   false: 'true',
        \   True: 'False',
        \   False: 'True',
        \ }
  if replace->has_key(cword)
    const new_prev = prev_line->substitute('\w\+$', '', '')
    const new_next = next_line->substitute('^\w\+', '', '')
    call setline('.', new_prev .. replace[cword] .. new_next)
    return
  endif

  const prev_num = prev_line->matchstr('\d\+$')
  if prev_num !=# ''
    const next_num = next_line->matchstr('^\d\+')
    const new_line = prev_line[: -(prev_num->len())-1]
          \ ..
          \ printf($'%0{(prev_num .. next_num)->len()}d',
          \    [0, (prev_num .. next_num)
          \         ->substitute('^0\+', '', '') + a:num]->max())
          \ .. next_line[next_num->len():]
  else
    const new_line = prev_line
          \ .. (next_line->substitute('\d\+',
          \     "\\=printf($'%0{submatch(0)->len()}d',
          \         [0, submatch(0)
          \             ->substitute('^1\+', '', '') + a:num]->max())", ''))
  endif

  if '.'->getline() !=# new_line
    call setline('.', new_line)
  endif
endfunction

function vimrc#toggle_option(option_name) abort
  if a:option_name ==# 'laststatus'
    if &laststatus == 0
      setlocal laststatus=2
    else
      setlocal laststatus=0
    endif
  else
    execute $'setlocal {a:option_name}!'
  endif

  execute $'setlocal {a:option_name}?'
endfunction

function vimrc#on_filetype() abort
  if 'filetype'->execute() !~# 'OFF'
    if !('b:did_ftplugin'->exists())
      runtime! after/ftplugin.vim
    endif

    return
  endif

  filetype plugin indent on
  syntax enable

  " NOTE: filetype detect does not work on startup
  silent filetype detect
endfunction

function vimrc#diagnostics_to_location_list() abort
  if !has('nvim')
    return
  endif

  let qflist = []
  for diagnostic in v:lua.vim.diagnostic.get()
    call add(qflist, #{
          \   bufnr: diagnostic.bufnr,
          \   lnum: diagnostic.lnum + 1,
          \   col: diagnostic.col + 1,
          \   text: diagnostic.message,
          \ })
  endfor

  if qflist->empty()
    lclose
  else
    call setloclist(win_getid(), qflist)
    lopen
  endif
endfunction

function vimrc#append_diff() abort
  " Get the Git repository root directory
  let git_root = '.git'->finddir('.;')->fnamemodify(':h')

  " Get the diff of the staged changes relative to the Git repository root
  let diff = $'git -C {git_root} diff --cached'->system()

  " Add a comment character to each line of the diff
  let comment_diff = diff->split('\n')[: 200]
        \ ->map({ idx, line -> $'# {line}' })

  " Append the diff to the commit message
  call append(line('$'), comment_diff)
endfunction
