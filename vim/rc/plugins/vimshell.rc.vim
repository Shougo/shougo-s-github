"---------------------------------------------------------------------------
" vimshell.vim
"

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt =
      \ 'gita#statusline#format("%{|/}ln%lb%{ <> |}rn%{/|}rb")'
let g:vimshell_prompt = '% '
let g:vimshell_split_command = ''
let g:vimshell_enable_transient_user_prompt = 1
let g:vimshell_force_overwrite_statusline = 1

autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings() abort
  if !IsWindows()
    " Display user name on Linux.
    "let g:vimshell_prompt = $USER."% "

    " Use zsh history.
    let g:vimshell_external_history_path = expand('~/.zsh-history')

    call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
    call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
    let g:vimshell_execute_file_list['zip'] = 'zipinfo'
    call vimshell#set_execute_file('tgz,gz', 'gzcat')
    call vimshell#set_execute_file('tbz,bz2', 'bzcat')

    " Use gnome-terminal.
    let g:vimshell_use_terminal_command = 'gnome-terminal -e'
  endif

  " Initialize execute file list.
  let g:vimshell_execute_file_list = {}

  inoremap <buffer><expr>'  pumvisible() ? "\<C-y>" : "'"
  imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-h>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-k>  <Plug>(vimshell_zsh_complete)
  imap <buffer><C-g>  <Plug>(vimshell_history_neocomplete)

  nnoremap <silent><buffer> <C-j>
        \ :<C-u>Unite -buffer-name=files
        \ -default-action=lcd directory_mru<CR>

  call vimshell#altercmd#define('g', 'git')
  call vimshell#set_alias('.', 'source')

  call vimshell#hook#add('chpwd',
        \ 'my_chpwd', s:vimshell_hooks.chpwd)
  call vimshell#hook#add('notfound',
        \ 'my_notfound', s:vimshell_hooks.notfound)
  call vimshell#hook#add('preprompt',
        \ 'my_preprompt', s:vimshell_hooks.preprompt)
  call vimshell#hook#add('preexec',
        \ 'my_preexec', s:vimshell_hooks.preexec)
endfunction

autocmd MyAutoCmd FileType term-* call s:terminal_settings()
function! s:terminal_settings() abort
  inoremap <silent><buffer><expr> <Plug>(vimshell_term_send_semicolon)
        \ vimshell#term_mappings#send_key(';')
  inoremap <silent><buffer><expr> j<Space>
        \ vimshell#term_mappings#send_key('j')

  " Sticky key.
  imap <buffer><expr> ;  <SID>texe_sticky_func()

  " Escape key.
  iunmap <buffer> <ESC><ESC>
  imap <buffer> <ESC>         <Plug>(vimshell_term_send_escape)
endfunction
function! s:texe_sticky_func() abort "{{{
  let sticky_table = {
        \',' : '<', '.' : '>', '/' : '?',
        \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')',
        \ '-' : '_', '=' : '+',
        \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
        \}
  let special_table = {
        \ "\<ESC>" : "\<ESC>", "\<CR>" : ";\<CR>"
        \ "\<Space>" : "\<Plug>(vimshell_term_send_semicolon)",
        \}

  if mode() !~# '^c'
    echo 'Input sticky key: '
  endif
  let char = ''

  while char == ''
    let char = nr2char(getchar())
  endwhile

  if char =~ '\l'
    return toupper(char)
  elseif has_key(sticky_table, char)
    return sticky_table[char]
  elseif has_key(special_table, char)
    return special_table[char]
  else
    return ''
  endif
endfunction "}}}

let s:vimshell_hooks = {}
function! s:vimshell_hooks.chpwd(args, context) abort
  if len(split(glob('*'), '\n')) < 100
    call vimshell#execute('ls')
  else
    call vimshell#execute('echo "Many files."')
  endif
endfunction
function! s:vimshell_hooks.notfound(cmdline, context) abort
  return ''
endfunction
function! s:vimshell_hooks.preprompt(args, context) abort
  " call vimshell#execute('echo "preprompt"')
endfunction
function! s:vimshell_hooks.preexec(cmdline, context) abort
  " call vimshell#execute('echo "preexec"')

  let args = vimproc#parser#split_args(a:cmdline)
  if len(args) > 0 && args[0] ==# 'diff'
    call vimshell#set_syntax('diff')
  endif

  return a:cmdline
endfunction


if !exists('g:vimshell_interactive_interpreter_commands')
    let g:vimshell_interactive_interpreter_commands = {}
endif
let g:vimshell_interactive_interpreter_commands.python = 'ipython'

" For themis"{{{
if dein#tap('vim-themis')
  " Set to $PATH.
  let s:bin = dein#get('vim-themis').rtp . '/bin'

  function! s:split_envpath(path) abort "{{{
    let delimiter = has('win32') ? ';' : ':'
    if stridx(a:path, '\' . delimiter) < 0
      return split(a:path, delimiter)
    endif

    let split = split(a:path, '\\\@<!\%(\\\\\)*\zs' . delimiter)
    return map(split,'substitute(v:val, ''\\\([\\'
          \ . delimiter . ']\)'', "\\1", "g")')
  endfunction"}}}

  function! s:join_envpath(list, orig_path, add_path) abort "{{{
    let delimiter = has('win32') ? ';' : ':'
    return (stridx(a:orig_path, '\' . delimiter) < 0
          \ && stridx(a:add_path, delimiter) < 0) ?
          \   join(a:list, delimiter) :
          \   join(map(copy(a:list), 's:escape(v:val)'), delimiter)
  endfunction"}}}

  " Escape a path for runtimepath.
  function! s:escape(path) abort "{{{
    return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
  endfunction"}}}

  let $PATH = s:join_envpath(
        \ dein#util#_uniq(insert(
        \    s:split_envpath($PATH), s:bin)), $PATH, s:bin)
  let $THEMIS_HOME = dein#get('vim-themis').rtp

  unlet s:bin
endif"}}}
