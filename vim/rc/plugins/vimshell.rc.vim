"---------------------------------------------------------------------------
" vimshell.vim
"

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
let g:vimshell_right_prompt =
      \ 'gita#statusline#format("%{|/}ln%lb%{ <> |}rn%{/|}rb")'
let g:vimshell_prompt = '% '
"let g:vimshell_environment_term = 'xterm'
let g:vimshell_split_command = ''
let g:vimshell_enable_transient_user_prompt = 1
let g:vimshell_force_overwrite_statusline = 1

" let g:vimshell_prompt_expr =
"     \ 'escape($USER . ":". fnamemodify(getcwd(), ":~")."%", "\\[]()?! ")." "'
" let g:vimshell_prompt_pattern = '^\f\+:\%(\f\|\\.\)\+% '

autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings()
  if IsWindows()
    " Display user name on Windows.
    "let g:vimshell_prompt = $USERNAME."% "

    " Use ckw.
    let g:vimshell_use_terminal_command = 'ckw -e'
  else
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
  call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
  let g:vimshell_execute_file_list['rb'] = 'ruby'
  let g:vimshell_execute_file_list['pl'] = 'perl'
  let g:vimshell_execute_file_list['py'] = 'python'
  call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

  inoremap <buffer><expr>'  pumvisible() ? "\<C-y>" : "'"
  imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-h>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-k>  <Plug>(vimshell_zsh_complete)
  imap <buffer><C-g>  <Plug>(vimshell_history_neocomplete)

  xmap <buffer> y <Plug>(operator-concealedyank)

  nnoremap <silent><buffer> <C-j>
        \ :<C-u>Unite -buffer-name=files
        \ -default-action=lcd directory_mru<CR>

  call vimshell#altercmd#define('u', 'cdup')
  call vimshell#altercmd#define('g', 'git')
  call vimshell#altercmd#define('i', 'iexe')
  call vimshell#altercmd#define('t', 'texe')
  call vimshell#set_alias('l.', 'ls -d .*')
  call vimshell#set_alias('gvim', 'gexe gvim')
  call vimshell#set_galias('L', 'ls -l')
  call vimshell#set_galias('time', 'exe time -p')
  call vimshell#set_alias('.', 'source')

  " Auto jump.
  call vimshell#set_alias('j', ':Unite -buffer-name=files
        \ -default-action=lcd -no-split -input=$$args directory_mru')

  " Console.
  call vimshell#set_alias('con',
        \ 'lilyterm -d `=b:vimshell.current_dir`')

  call vimshell#set_alias('up', 'cdup')

  call vimshell#hook#add('chpwd',
        \ 'my_chpwd', s:vimshell_hooks.chpwd)
  " call vimshell#hook#add('emptycmd',
  "     \ 'my_emptycmd', s:vimshell_hooks.emptycmd)
  call vimshell#hook#add('notfound',
        \ 'my_notfound', s:vimshell_hooks.notfound)
  call vimshell#hook#add('preprompt',
        \ 'my_preprompt', s:vimshell_hooks.preprompt)
  call vimshell#hook#add('preexec',
        \ 'my_preexec', s:vimshell_hooks.preexec)
  " call vimshell#hook#set('preexec',
  "      \ [s:SID_PREFIX() . 'vimshell_hooks_preexec'])
endfunction

autocmd MyAutoCmd FileType int-* call s:interactive_settings()
function! s:interactive_settings()
  call vimshell#hook#set('input', [s:vimshell_hooks.input])
endfunction

autocmd MyAutoCmd FileType term-* call s:terminal_settings()
function! s:terminal_settings()
  inoremap <silent><buffer><expr> <Plug>(vimshell_term_send_semicolon)
        \ vimshell#term_mappings#send_key(';')
  inoremap <silent><buffer><expr> j<Space>
        \ vimshell#term_mappings#send_key('j')
  "inoremap <silent><buffer><expr> <Up>
  "      \ vimshell#term_mappings#send_keys("\<ESC>[A")

  " Sticky key.
  imap <buffer><expr> ;  <SID>texe_sticky_func()

  " Escape key.
  iunmap <buffer> <ESC><ESC>
  imap <buffer> <ESC>         <Plug>(vimshell_term_send_escape)
endfunction
function! s:texe_sticky_func()
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
endfunction

let s:vimshell_hooks = {}
function! s:vimshell_hooks.chpwd(args, context)
  if len(split(glob('*'), '\n')) < 100
    call vimshell#execute('ls')
  else
    call vimshell#execute('echo "Many files."')
  endif
endfunction
function! s:vimshell_hooks.emptycmd(cmdline, context)
  call vimshell#set_prompt_command('ls')
  return 'ls'
endfunction
function! s:vimshell_hooks.notfound(cmdline, context)
  return ''
endfunction
function! s:vimshell_hooks.preprompt(args, context)
  " call vimshell#execute('echo "preprompt"')
endfunction
function! s:vimshell_hooks.preexec(cmdline, context)
  " call vimshell#execute('echo "preexec"')

  let args = vimproc#parser#split_args(a:cmdline)
  if len(args) > 0 && args[0] ==# 'diff'
    call vimshell#set_syntax('diff')
  endif

  return a:cmdline
endfunction
function! s:vimshell_hooks.input(input, context)
  " echomsg 'input'
  return a:input
endfunction


if !exists('g:vimshell_interactive_interpreter_commands')
    let g:vimshell_interactive_interpreter_commands = {}
endif
let g:vimshell_interactive_interpreter_commands.python = 'ipython'
