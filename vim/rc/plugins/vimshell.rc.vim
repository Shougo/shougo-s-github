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
  endif

  inoremap <buffer><expr>'  pumvisible() ? "\<C-y>" : "'"
  imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-h>  <Plug>(vimshell_another_delete_backward_char)

  call vimshell#altercmd#define('g', 'git')
  call vimshell#set_alias('.', 'source')

  call vimshell#hook#add('chpwd', 'my_chpwd', s:vimshell_hooks.chpwd)
endfunction

let s:vimshell_hooks = {}
function! s:vimshell_hooks.chpwd(args, context) abort
  call vimshell#execute((len(split(glob('*'), '\n')) < 100) ?
        \ 'ls' : 'echo "Many files."')
endfunction

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
          \   join(map(copy(a:list),
          \        "substitute(v:path, ',\\|\\\\,\\@=', '\\\\\\0', 'g')"),
          \        delimiter)
  endfunction"}}}

  let $PATH = s:join_envpath(
        \ dein#util#_uniq(insert(
        \    s:split_envpath($PATH), s:bin)), $PATH, s:bin)
  let $THEMIS_HOME = dein#get('vim-themis').rtp

  unlet s:bin
endif"}}}
