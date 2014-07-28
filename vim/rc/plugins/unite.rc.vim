"---------------------------------------------------------------------------
" unite.vim
"

" For unite-menu.
let g:unite_source_menu_menus = {}

let g:unite_source_menu_menus.enc = {
      \     'description' : 'Open with a specific character code again.',
      \ }
let g:unite_source_menu_menus.enc.command_candidates = [
      \       ['utf8', 'Utf8'],
      \       ['iso2022jp', 'Iso2022jp'],
      \       ['cp932', 'Cp932'],
      \       ['euc', 'Euc'],
      \       ['utf16', 'Utf16'],
      \       ['utf16-be', 'Utf16be'],
      \       ['jis', 'Jis'],
      \       ['sjis', 'Sjis'],
      \       ['unicode', 'Unicode'],
      \     ]

let g:unite_source_menu_menus.fenc = {
      \     'description' : 'Change file fenc option.',
      \ }
let g:unite_source_menu_menus.fenc.command_candidates = [
      \       ['utf8', 'WUtf8'],
      \       ['iso2022jp', 'WIso2022jp'],
      \       ['cp932', 'WCp932'],
      \       ['euc', 'WEuc'],
      \       ['utf16', 'WUtf16'],
      \       ['utf16-be', 'WUtf16be'],
      \       ['jis', 'WJis'],
      \       ['sjis', 'WSjis'],
      \       ['unicode', 'WUnicode'],
      \     ]

let g:unite_source_menu_menus.ff = {
      \     'description' : 'Change file format option.',
      \ }
let g:unite_source_menu_menus.ff.command_candidates = {
      \       'unix'   : 'WUnix',
      \       'dos'    : 'WDos',
      \       'mac'    : 'WMac',
      \     }

let g:unite_source_menu_menus.unite = {
      \     'description' : 'Start unite sources',
      \ }
let g:unite_source_menu_menus.unite.command_candidates = {
      \       'history'    : 'Unite history/command',
      \       'quickfix'   : 'Unite qflist -no-quit',
      \       'resume'     : 'Unite -buffer-name=resume resume',
      \       'directory'  : 'Unite -buffer-name=files '.
      \             '-default-action=lcd directory_mru',
      \       'mapping'    : 'Unite mapping',
      \       'message'    : 'Unite output:message',
      \       'scriptnames': 'Unite output:scriptnames',
      \     }

let g:unite_source_history_yank_enable = 1

" For unite-alias.
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.test = {
      \ 'source' : 'file_rec',
      \ 'args'   : '~/',
      \ }
let g:unite_source_alias_aliases.line_migemo = 'line'
let g:unite_source_alias_aliases.calc = 'kawaii-calc'
let g:unite_source_alias_aliases.l = 'launcher'
let g:unite_source_alias_aliases.kill = 'process'
let g:unite_source_alias_aliases.message = {
      \ 'source' : 'output',
      \ 'args'   : 'message',
      \ }
let g:unite_source_alias_aliases.mes = {
      \ 'source' : 'output',
      \ 'args'   : 'message',
      \ }
let g:unite_source_alias_aliases.scriptnames = {
      \ 'source' : 'output',
      \ 'args'   : 'scriptnames',
      \ }

autocmd MyAutoCmd FileType unite call s:unite_my_settings()

let g:unite_ignore_source_files = ['function.vim', 'command.vim']

call unite#custom#profile('action', 'context', {
      \ 'start_insert' : 1
      \ })

" Set "-no-quit" automatically in grep unite source.
call unite#custom#profile('source/grep', 'context', {
      \ 'no_quit' : 1
      \ })

" migemo.
call unite#custom#source('line_migemo', 'matchers', 'matcher_migemo')

" Custom filters."{{{
call unite#custom#source(
      \ 'buffer,file_rec,file_rec/async,file_rec/git', 'matchers',
      \ ['converter_relative_word', 'matcher_fuzzy'])
call unite#custom#source(
      \ 'file_mru', 'matchers',
      \ ['matcher_project_files', 'matcher_fuzzy', 'matcher_hide_hidden_files'])
" call unite#custom#source(
"       \ 'file', 'matchers',
"       \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
call unite#custom#source(
      \ 'file_rec,file_rec/async,file_rec/git,file_mru', 'converters',
      \ ['converter_file_directory'])
call unite#filters#sorter_default#use(['sorter_rank'])
"}}}

function! s:unite_my_settings() "{{{
  " Directory partial match.
  call unite#custom#alias('file', 'h', 'left')
  call unite#custom#default_action('directory', 'narrow')
  " call unite#custom#default_action('file', 'my_tabopen')

  call unite#custom#default_action('versions/git/status', 'commit')

  " call unite#custom#default_action('directory', 'cd')

  " Overwrite settings.
  imap <buffer>  <BS>      <Plug>(unite_delete_backward_path)
  imap <buffer>  jj        <Plug>(unite_insert_leave)
  imap <buffer>  <Tab>     <Plug>(unite_complete)
  imap <buffer> '          <Plug>(unite_quick_match_default_action)
  nmap <buffer> '          <Plug>(unite_quick_match_default_action)
  nmap <buffer> cd         <Plug>(unite_quick_match_default_action)
  nmap <buffer> <C-z>      <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>      <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-w>      <Plug>(unite_delete_backward_path)
  nmap <buffer> <C-j>      <Plug>(unite_toggle_auto_preview)
  nnoremap <silent><buffer> <Tab>     <C-w>w
  nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))

  let unite = unite#get_current_unite()
  if unite.profile_name ==# '^search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <silent><buffer><expr> !     unite#do_action('start')
  nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
        \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])

  nnoremap <silent><buffer><expr> p
        \ empty(filter(range(1, winnr('$')),
        \ 'getwinvar(v:val, "&previewwindow") != 0')) ?
        \ unite#do_action('preview') : ":\<C-u>pclose!\<CR>"
endfunction"}}}

" Default configuration.
let default_context = {
      \ 'vertical' : 0,
      \ 'cursor_line_highlight' : 'TabLineSel',
      \ 'short_source_names' : 1,
      \ }

" let g:unite_abbr_highlight = 'TabLine'

if IsWindows()
else
  " Like Textmate icons.
  let default_context.marked_icon = '✗'

  " Prompt choices.
  let default_context.prompt = '» '
endif

call unite#custom#profile('default', 'context', default_context)

if executable('ag')
  " Use ag in unite grep source.
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '-i --nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('jvgrep')
  " For jvgrep.
  let g:unite_source_grep_command = 'jvgrep'
  let g:unite_source_grep_default_opts = '-i --exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = '-R'
elseif executable('ack-grep')
  " For ack.
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '-i --no-heading --no-color -a'
  let g:unite_source_grep_recursive_opt = ''
endif

let g:unite_build_error_icon    = '~/.vim/signs/err.'
      \ . (IsWindows() ? 'bmp' : 'png')
let g:unite_build_warning_icon  = '~/.vim/signs/warn.'
      \ . (IsWindows() ? 'bmp' : 'png')

let g:unite_source_rec_max_cache_files = -1

