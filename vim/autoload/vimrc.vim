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
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
        \}

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
  if execute('filetype') =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction

function! vimrc#visual_paste(direction) range abort
  let registers = {}

  for name in ['"', '0']
    let registers[name] = {'type': getregtype(name), 'value': getreg(name)}
  endfor

  execute 'normal!' a:direction

  for [name, register] in items(registers)
    call setreg(name, register.value, register.type)
  endfor
endfunction

" Todo: support vim-treesitter plugin
function! vimrc#enable_syntax() abort
  if has('nvim') && exists(':TSEnableAll')
    TSBufEnable highlight
    TSBufEnable context_commentstring
  endif
endfunction
function! vimrc#disable_syntax() abort
  syntax off
  if has('nvim') && exists(':TSEnableAll')
    TSBufDisable highlight
    TSBufDisable context_commentstring
  endif
endfunction
function! vimrc#check_syntax() abort
  let max_size = 500000
  let max_head_size = 10000
  let max_line = line('$')
  let fsize = line2byte(max_line + 1)
  let head_size = line2byte(min([max_line + 1, 5]))

  if fsize <= max_size && head_size <= max_head_size
    return
  endif

  let confirm = confirm(printf(
        \ '"%s" is too large.(%d lines, %s bytes) Enable syntax?',
        \ bufname('%'), max_line, fsize), "&Yes\n&No", 2)
  redraw

  if confirm == 1
    call vimrc#enable_syntax()
  else
    call vimrc#disable_syntax()
  endif
endfunction
