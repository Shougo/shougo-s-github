"---------------------------------------------------------------------------
" vimrc functions:
"

function! vimrc#sticky_func() abort
  let sticky_table = {
        \',' : '<', '.' : '>', '/' : '?',
        \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')',
        \ '-' : '_', '=' : '+',
        \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
        \}
  let special_table = {
        \ "\<ESC>": "\<ESC>", "\<Space>": ';', "\<CR>": ";\<CR>",
        \ }

  let char = ''

  while 1
    silent! let char = nr2char(getchar())

    if char =~# '\l'
      let char = toupper(char)
      break
    elseif has_key(sticky_table, char)
      let char = sticky_table[char]
      break
    elseif has_key(special_table, char)
      let char = special_table[char]
      break
    endif
  endwhile

  return char
endfunction

function! vimrc#add_numbers(num) abort
  let prev_line = getline('.')[: col('.')-1]
  let next_line = getline('.')[col('.') :]
  let prev_num = matchstr(prev_line, '\d\+$')
  if prev_num !=# ''
    let next_num = matchstr(next_line, '^\d\+')
    let new_line = prev_line[: -len(prev_num)-1] .
          \ printf('%0'.len(prev_num . next_num).'d',
          \    max([0, substitute(prev_num . next_num, '^0\+', '', '')
          \         + a:num])) . next_line[len(next_num):]
  else
    let new_line = prev_line . substitute(next_line, '\d\+',
          \ "\\=printf('%0'.len(submatch(0)).'d',
          \         max([0, substitute(submatch(0), '^0\+', '', '')
          \              + a:num]))", '')
  endif

  if getline('.') !=# new_line
    call setline('.', new_line)
  endif
endfunction

function! vimrc#toggle_option(option_name) abort
  if a:option_name ==# 'laststatus'
    if &laststatus == 0
      setlocal laststatus=2
    else
      setlocal laststatus=0
    endif
  else
    execute 'setlocal' a:option_name.'!'
  endif

  execute 'setlocal' a:option_name.'?'
endfunction

function! vimrc#on_filetype() abort
  if execute('filetype') !~# 'OFF'
    return
  endif

  filetype plugin indent on
  syntax enable

  " Note: filetype detect does not work on startup
  filetype detect
endfunction

function! vimrc#enable_syntax() abort
  syntax enable

  if has('nvim') && exists(':TSEnableAll')
    TSBufEnable highlight
    TSBufEnable context_commentstring
  endif
endfunction
function! vimrc#disable_syntax() abort
  if &l:syntax !=# ''
    syntax off
  endif

  if has('nvim') && exists(':TSEnableAll')
    TSBufDisable highlight
    TSBufDisable context_commentstring
  endif
endfunction

function! vimrc#diagnostics_to_qf() abort
  if !has('nvim')
    return
  endif

  let qflist = []
  for diagnostic in v:lua.vim.diagnostic.get()
    call add(qflist, {
          \ 'bufnr': diagnostic.bufnr,
          \ 'lnum': diagnostic.lnum,
          \ 'col': diagnostic.col,
          \ 'text': diagnostic.message,
          \ })
  endfor

  if !empty(qflist)
    call setqflist(qflist)
    copen
  endif
endfunction
