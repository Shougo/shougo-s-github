"---------------------------------------------------------------------------
" vimrc functions:
"

function! vimrc#sticky_func() abort
  const sticky_table = {
        \  ',': '<', '.': '>', '/': '?',
        \  '1': '!', '2': '@', '3': '#', '4': '$', '5': '%',
        \  '6': '^', '7': '&', '8': '*', '9': '(', '0': ')',
        \  '-': '_', '=': '+',
        \  ';': ':', '[': '{', ']': '}', '`': '~', "'": "\"", '\': '|',
        \ }
  const special_table = {
        \   "\<ESC>": "\<ESC>",
        \   "\<Space>": ';',
        \   "\<CR>": ";\<CR>",
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

function! vimrc#add_numbers(num) abort
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
          \ printf('%0' .. (prev_num .. next_num)->len() .. 'd',
          \    [0, (prev_num .. next_num)
          \         ->substitute('^0\+', '', '') + a:num]->max())
          \ .. next_line[next_num->len():]
  else
    const new_line = prev_line
          \ .. (next_line->substitute('\d\+',
          \     "\\=printf($'%0{submatch(0)->len()}d',
          \         [0, submatch(0)
          \             ->substitute('^0\+', '', '') + a:num]->max())", ''))
  endif

  if '.'->getline() !=# new_line
    call setline('.', new_line)
  endif
endfunction

function! vimrc#toggle_option(option_name) abort
  const option_val = bufnr()->getbufvar('&' .. a:option_name)

  if a:option_name ==# 'laststatus'
    if &laststatus == 0
      setlocal laststatus=2
    else
      setlocal laststatus=0
    endif
  elseif option_val->type() ==# v:t_string
    if option_val !=# ''
      execute $'setlocal {a:option_name}=""'
    else
      execute $'setlocal {a:option_name}&'
    endif
  else
    execute $'setlocal {a:option_name}!'
  endif

  execute $'setlocal {a:option_name}?'
endfunction

function! vimrc#on_filetype() abort
  if 'filetype'->execute() =~# 'OFF'
    if !'b:did_ftplugin'->exists()
      runtime! after/ftplugin.vim
    endif

    filetype plugin indent on
  endif

  if line('$') < 10000 && &l:filetype ==# '' && &l:syntax ==# ''
    if bufname()->stridx('/doc/') >= 0
      " In help file, filetype detect does not work well.
      autocmd MyAutoCmd CursorHold * ++once silent filetype detect
    else
      silent filetype detect
    endif

    if has('nvim') && bufnr()->bufloaded()
      lua <<END
      if vim.treesitter.get_parser(nil, nil, { error = false }) then
        vim.treesitter.start()
      else
        vim.cmd('syntax enable')
      end
END
    else
      syntax enable
    endif
  endif
endfunction

function! vimrc#diagnostics_to_location_list() abort
  if !has('nvim')
    return
  endif

  let qflist = []
  const current = '%'->bufname()->fnamemodify(':p')
  for diagnostic in v:lua.vim.diagnostic.get()
    " Skip files which out of the current buffer
    let bufname = diagnostic.bufnr->bufname()
    if bufname->fnamemodify(':p') !=# current
      continue
    endif

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
    call setloclist(win_getid(), qflist, 'r')
    lopen
  endif
endfunction

function! vimrc#append_diff() abort
  " Get the Git repository root directory
  const git_dir = '.git'->finddir('.;')
  if git_dir ==# ''
    return
  endif
  const git_root = git_dir->fnamemodify(':h')

  " Get the diff of the staged changes relative to the Git repository root
  const diff = ['git', '-C', git_root, 'diff', '--cached']->system()

  " Add a comment character to each line of the diff
  const comment_diff = diff->split('\n')[: 199]
        \ ->map({ -> '# '.. v:val })

  " Append the diff to the commit message
  call append('$'->line(), comment_diff)
endfunction

" --- findent ------------------------------------------------------------
" Guess 'expandtab' and 'shiftwidth' from the buffer contents.
" Tabs are assumed to be 8 columns wide when spaces and tabs are mixed
" (e.g. Vim's own C sources: sw=4, ts=8, noexpandtab).
function! s:indent_width(ws) abort
  let col = 0
  for c in a:ws->split('\zs')
    let col = c ==# "\t" ? (col / 8 + 1) * 8 : col + 1
  endfor
  return col
endfunction

function! vimrc#findent() abort
  let [hard, soft, pure_tab, prev, deltas] = [0, 0, v:true, 0, {}]
  for line in 1->getline(['$'->line(), 1000]->min())
    " Skip blank lines and C comment continuation lines (' * ...').
    if line =~# '^\s*$' || line =~# '^\s\+\*' | continue | endif
    let ws = line->matchstr('^\s*')
    if ws =~# ' '
      let pure_tab = v:false
    endif
    let n = s:indent_width(ws)
    if ws =~# "\t"
      let hard += 1
    elseif n >= 8
      " Space-only indent of 8+ columns: a tab would have been used
      " if the file were written with 'noexpandtab'.
      let soft += 1
    endif
    let d = (n - prev)->abs()
    if 2 <= d && d <= 8
      let deltas[d] = get(deltas, d, 0) + 1
    endif
    let prev = n
  endfor

  if hard > 0 && pure_tab
    " Tabs only: keep the user's 'tabstop' and indent by one tab.
    setlocal noexpandtab shiftwidth=0 softtabstop=0
    return
  endif
  let [sw, best] = [0, 0]
  for [d, c] in deltas->items()
    if c > best | let [sw, best] = [d->str2nr(), c] | endif
  endfor
  if sw == 0 | return | endif
  if soft > hard
    execute 'setlocal expandtab softtabstop=-1 shiftwidth=' .. sw
  else
    execute 'setlocal noexpandtab tabstop=8 softtabstop=-1 shiftwidth=' .. sw
  endif

  setlocal expandtab? tabstop? softtabstop? shiftwidth?
endfunction
