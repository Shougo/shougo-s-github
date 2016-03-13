"---------------------------------------------------------------------------
" vimfiler.vim
"

let g:vimfiler_enable_clipboard = 0

call vimfiler#custom#profile('default', 'context', {
      \ 'safe' : 0,
      \ 'auto_expand' : 1,
      \ 'parent' : 0,
      \ })

let g:vimfiler_as_default_explorer = 1
if IsWindows()
  let g:vimfiler_detect_drives = [
        \ 'C:/', 'D:/', 'E:/', 'F:/', 'G:/', 'H:/', 'I:/',
        \ 'J:/', 'K:/', 'L:/', 'M:/', 'N:/']
endif

" %p : full path
" %d : current directory
" %f : filename
" %F : filename removed extensions
" %* : filenames
" %# : filenames fullpath
let g:vimfiler_sendto = {
      \ 'unzip' : 'unzip %f',
      \ 'zip' : 'zip -r %F.zip %*',
      \ 'Inkscape' : 'inkspace',
      \ 'GIMP' : 'gimp %*',
      \ 'gedit' : 'gedit',
      \ }

if IsWindows()
  " Use trashbox.
  let g:unite_kind_file_use_trashbox = 1
else
  " Like Textmate icons.
  let g:vimfiler_tree_leaf_icon = ' '
  let g:vimfiler_tree_opened_icon = '▾'
  let g:vimfiler_tree_closed_icon = '▸'
  let g:vimfiler_file_icon = ' '
  let g:vimfiler_readonly_file_icon = '✗'
  let g:vimfiler_marked_file_icon = '✓'
endif
" let g:vimfiler_readonly_file_icon = '[O]'

let g:vimfiler_quick_look_command =
      \ IsWindows() ? 'maComfort.exe -ql' :
      \ IsMac() ? 'qlmanage -p' : 'gloobus-preview'

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings() abort "{{{
  call vimfiler#set_execute_file('vim', ['vim', 'notepad'])
  call vimfiler#set_execute_file('txt', 'vim')
  call vimfiler#set_execute_file('pdf', 'zathura')

  " Overwrite settings.
  nnoremap <silent><buffer> J
        \ <C-u>:Unite -buffer-name=files
        \ -default-action=lcd directory_mru<CR>
  " Call sendto.
  " nnoremap <buffer> - <C-u>:Unite sendto<CR>
  " setlocal cursorline

  nnoremap <silent><buffer><expr> gy vimfiler#do_action('tabopen')
  nmap <buffer> p <Plug>(vimfiler_quick_look)
  nmap <buffer> <Tab> <Plug>(vimfiler_switch_to_other_window)

  " Migemo search.
  if !empty(unite#get_filters('matcher_migemo'))
    nnoremap <silent><buffer><expr> /  line('$') > 10000 ?  'g/' :
          \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>"
  endif
endfunction"}}}

" let g:vimfiler_ignore_pattern = ''
