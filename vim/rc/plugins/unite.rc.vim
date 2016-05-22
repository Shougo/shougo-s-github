"---------------------------------------------------------------------------
" unite.vim
"

let g:unite_enable_auto_select = 0

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

let g:unite_source_menu_menus.zsh = {
      \     'description' : 'Edit zsh files',
      \ }
let g:unite_source_menu_menus.zsh.file_candidates = [
      \       ['zshenv'    , '~/.zshenv'],
      \       ['zshrc'     , '~/.zshrc'],
      \       ['zplug'     , '~/.zplug'],
      \     ]

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

let g:unite_ignore_source_files = []

call unite#custom#profile('action', 'context', {
      \ 'start_insert' : 1
      \ })

" migemo.
call unite#custom#source('line_migemo', 'matchers', 'matcher_migemo')

" Custom filters."{{{
call unite#custom#source(
      \ 'buffer,file_rec,file_rec/async,file_rec/git', 'matchers',
      \ ['converter_relative_word', 'matcher_fuzzy'])
call unite#custom#source(
      \ 'file_mru', 'matchers',
      \ ['matcher_project_files', 'matcher_fuzzy',
      \  'matcher_hide_hidden_files', 'matcher_hide_current_file'])
" call unite#custom#source(
"       \ 'file', 'matchers',
"       \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
call unite#custom#source(
      \ 'file_rec,file_rec/async,file_rec/git,file_mru', 'converters',
      \ ['converter_uniq_word'])
call unite#custom#source(
      \ 'buffer', 'converters',
      \ ['converter_uniq_word','converter_word_abbr'])
call unite#filters#sorter_default#use(['sorter_rank'])
" call unite#filters#sorter_default#use(['sorter_length'])
"}}}

function! s:unite_my_settings() abort "{{{
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
  nnoremap <silent><buffer><expr> P
        \ unite#smart_map('P', unite#do_action('insert'))

  let unite = unite#get_current_unite()
  if unite.profile_name ==# '^search' || unite.profile_name ==# '^grep'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <silent><buffer><expr> !     unite#do_action('start')
  nnoremap <buffer><expr> S
        \ unite#mappings#set_current_sorters(
        \  empty(unite#mappings#get_current_sorters()) ?
        \   ['sorter_reverse'] : [])
  nnoremap <buffer><expr> cof
        \ unite#mappings#set_current_matchers(
        \ empty(unite#mappings#get_current_matchers()) ?
        \ ['matcher_fuzzy'] : [])
  nmap <buffer> x     <Plug>(unite_quick_match_jump)
endfunction"}}}

" Default configuration.
let default_context = {
      \ 'vertical' : 0,
      \ 'short_source_names' : 1,
      \ }

" let g:unite_abbr_highlight = 'TabLine'

if IsWindows()
else
  " Prompt choices.
  " let default_context.prompt = '» '
endif

call unite#custom#profile('default', 'context', default_context)

if executable('hw')
  " Use hw(highway)
  " https://github.com/tkengo/highway
  let g:unite_source_grep_command = 'hw'
  let g:unite_source_grep_default_opts = '--no-group --no-color'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ag')
  " Use ag(the silver searcher)
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
  " Use pt(the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('jvgrep')
  " For jvgrep
  " https://github.com/mattn/jvgrep
  let g:unite_source_grep_command = 'jvgrep'
  let g:unite_source_grep_default_opts = '-i --exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = '-R'
endif

" if executable('ack')
"   " For ack
"   "http://beyondgrep.com/
"   let g:unite_source_grep_command = 'ack'
"   let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
"   let g:unite_source_grep_recursive_opt = ''
" endif

" let g:unite_source_rec_async_command =
"       \ ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']

let g:unite_build_error_icon    = '~/.vim/signs/err.'
      \ . (IsWindows() ? 'bmp' : 'png')
let g:unite_build_warning_icon  = '~/.vim/signs/warn.'
      \ . (IsWindows() ? 'bmp' : 'png')

let g:unite_source_rec_max_cache_files = -1

nnoremap <silent> <Leader>st :NeoCompleteIncludeMakeCache<CR>
            \ :UniteWithCursorWord -immediately -sync
            \ -default-action=context_split tag/include<CR>
nnoremap <silent> [Space]n  :UniteNext<CR>
nnoremap <silent> [Space]p  :UnitePrevious<CR>

