"---------------------------------------------------------------------------
" unite.vim
"

let g:unite_enable_auto_select = 0
let g:unite_restore_alternate_file = 1

" For unite-alias.
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.line_migemo = 'line'
let g:unite_source_alias_aliases.message = {
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

" Custom filters."{{{
call unite#custom#source(
      \ 'buffer,file_rec,file_rec/async,file_rec/git', 'matchers',
      \ ['converter_relative_word', 'matcher_fuzzy'])
call unite#custom#source(
      \ 'file_mru', 'matchers',
      \ ['matcher_project_files', 'matcher_fuzzy',
      \  'matcher_hide_hidden_files', 'matcher_hide_current_file'])
call unite#custom#source(
      \ 'file_rec,file_rec/async,file_rec/git,file_mru', 'converters',
      \ ['converter_uniq_word'])
call unite#custom#source(
      \ 'buffer', 'converters',
      \ ['converter_uniq_word','converter_word_abbr'])
call unite#filters#sorter_default#use(['sorter_rank'])
"}}}

function! s:unite_my_settings() abort "{{{
  " Directory partial match.
  call unite#custom#default_action('directory', 'narrow')

  " Overwrite settings.
  imap <buffer>  <BS>      <Plug>(unite_delete_backward_path)
  imap <buffer>  jj        <Plug>(unite_insert_leave)
  imap <buffer> <C-w>      <Plug>(unite_delete_backward_path)
  nnoremap <silent><buffer> <Tab>     <C-w>w

  let unite = unite#get_current_unite()
  if unite.profile_name ==# '^search' || unite.profile_name ==# '^grep'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nmap <buffer> x     <Plug>(unite_quick_match_jump)
endfunction"}}}

" Default configuration.
let default_context = {
      \ 'vertical' : 0,
      \ 'short_source_names' : 1,
      \ }

call unite#custom#profile('default', 'context', default_context)

if executable('ag')
  " Use ag(the silver searcher)
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
endif

" let g:unite_source_rec_async_command =
"       \ ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']

let s:ext = (IsWindows() ? 'bmp' : 'png')
let g:unite_build_error_icon    = '~/.vim/signs/err.' . s:ext
let g:unite_build_warning_icon  = '~/.vim/signs/warn.' . s:ext

let g:unite_source_rec_max_cache_files = -1

nnoremap <silent> [Space]n  :UniteNext<CR>
nnoremap <silent> [Space]p  :UnitePrevious<CR>
