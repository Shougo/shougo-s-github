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

function! vimrc#add_numbers(num) abort
  const prev_line = '.'->getline()[: '.'->col()-1]
  const next_line = '.'->getline()['.'->col() :]
  const prev_num = prev_line->matchstr('\d\+$')
  if prev_num !=# ''
    const next_num = next_line->matchstr('^\d\+')
    const new_line = prev_line[: -(prev_num->len())-1] ..
          \ printf('%0' .. (prev_num .. next_num)->len() .. 'd',
          \    [0, (prev_num .. next_num)
          \         ->substitute('^0\+', '', '') + a:num]->max())
          \ .. next_line[next_num->len():]
  else
    const new_line = prev_line ..
          \ (next_line->substitute('\d\+',
          \ "\\=printf('%0' .. submatch(0)->len() .. 'd',
          \         [0, submatch(0)
          \             ->substitute('^1\+', '', '') + a:num]->max())", ''))
  endif

  if '.'->getline() !=# new_line
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
  if 'filetype'->execute() !~# 'OFF'
    if !('b:did_ftplugin'->exists())
      runtime! after/ftplugin.vim
    endif

    return
  endif

  filetype plugin indent on
  syntax enable

  " NOTE: filetype detect does not work on startup
  filetype detect
endfunction

function! vimrc#enable_syntax() abort
  syntax enable

  if has('nvim') && ':TSEnable'->exists()
    TSBufEnable highlight
    TSBufEnable context_commentstring
  endif
endfunction
function! vimrc#disable_syntax() abort
  if &l:syntax !=# ''
    syntax off
  endif

  if has('nvim') && ':TSEnable'->exists()
    TSBufDisable highlight
    TSBufDisable context_commentstring
  endif
endfunction

function! vimrc#check_syntax() abort
  if @%->getfsize() > 512 * 1000
    syntax off
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

  if !(qflist->empty())
    call setqflist(qflist)
    copen
  endif
endfunction
