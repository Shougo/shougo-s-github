"---------------------------------------------------------------------------
" vimshell.vim
"

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = ''
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
