"---------------------------------------------------------------------------
" Plugin:
"

if dein#tap('deoplete.nvim') && has('nvim') "{{{
  let g:loaded_neocomplete = 1
endif "}}}

if dein#tap('neocomplete.vim') && has('lua') "{{{
  let g:loaded_deoplete = 1
endif "}}}

if dein#tap('unite.vim') "{{{
  nnoremap <silent> ;b
        \ :<C-u>Unite -buffer-name=build`tabpagenr()` -no-quit build<CR>
  nnoremap <silent> ;o
        \ :<C-u>Unite outline -no-start-insert -resume<CR>
  nnoremap <silent> ;t
        \ :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
  nnoremap <silent> <C-k>
        \ :<C-u>Unite change jump<CR>
  nnoremap <silent> ;g
        \ :<C-u>Unite grep -buffer-name=grep`tabpagenr()`
        \ -auto-preview -no-split -no-empty -resume<CR>
  nnoremap <silent> ;r
        \ :<C-u>Unite -buffer-name=register
        \ -default-action=append register history/yank<CR>
  xnoremap <silent> ;r
        \ d:<C-u>Unite -buffer-name=register
        \ -default-action=append register history/yank<CR>
  nnoremap <silent> ;;
        \ :<C-u>Unite -start-insert command history/command<CR>

  " <C-t>: Tab pages
  nnoremap <silent> <C-t>
        \ :<C-u>Unite -auto-resize -select=`tabpagenr()-1` tab<CR>

  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
        \ jump_point file_point file_mru
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : ''`
        \ buffer_tab:- file file/new<CR>

  nnoremap <silent> [Window]<Space>
        \ :<C-u>Unite -buffer-name=files -path=~/.vim/rc file_rec<CR>
  nnoremap <silent> [Window]n
        \ :<C-u>Unite -start-insert -default-action=lcd dein<CR>
  nnoremap <silent> [Window]g
        \ :<C-u>Unite -start-insert ghq<CR>

  nnoremap <silent> <C-w>
        \ :<C-u>Unite -force-immediately window:all:no-current<CR>

  " Easily syntax change.
  nnoremap <silent> [Space]ft
        \ :<C-u>Unite -start-insert filetype filetype/new<CR>

  " t: tags-and-searches "{{{
  " The prefix key.
  nnoremap    [Tag]   <Nop>
  nmap    t [Tag]
  " Jump.
  nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "g\<C-]>" :
        \ ":\<C-u>UniteWithCursorWord -buffer-name=tag -immediately
        \  tag tag/include\<CR>"
  nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
        \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
  "}}}

  " Execute help.
  nnoremap <silent> <C-h>  :<C-u>Unite -buffer-name=help help<CR>

  " Execute help by cursor keyword.
  nnoremap <silent> g<C-h>  :<C-u>UniteWithCursorWord help<CR>

  " Search.
  nnoremap <silent> /
        \ :<C-u>Unite -buffer-name=search%`bufnr('%')`
        \ -start-insert line:forward:wrap<CR>
  nnoremap <silent> *
        \ :<C-u>UniteWithCursorWord -buffer-name=search%`bufnr('%')`
        \ line:forward:wrap<CR>
  nnoremap [Alt]/       /
  nnoremap [Alt]?       ?

  nnoremap <silent> n
        \ :<C-u>UniteResume search%`bufnr('%')`
        \  -no-start-insert -force-redraw<CR>
endif "}}}

if dein#tap('caw.vim')
  autocmd MyAutoCmd FileType * call s:init_caw()
  function! s:init_caw() abort
    if !&l:modifiable
      silent! nunmap <buffer> gc
      silent! xunmap <buffer> gc
      silent! nunmap <buffer> gcc
      silent! xunmap <buffer> gcc
    else
      nmap <buffer> gc <Plug>(caw:prefix)
      xmap <buffer> gc <Plug>(caw:prefix)
      nmap <buffer> gcc <Plug>(caw:i:toggle)
      xmap <buffer> gcc <Plug>(caw:i:toggle)
    endif
  endfunction
endif
