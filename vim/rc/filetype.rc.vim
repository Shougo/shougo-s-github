"---------------------------------------------------------------------------
" FileType:
"

augroup MyAutoCmd
  autocmd FileType,Syntax,BufEnter,BufWinEnter * call s:my_on_filetype()

  " Enable gauche syntax.
  autocmd FileType scheme nested let b:is_gauche=1 |
        \ setlocal lispwords=define |
        \ let b:current_syntax='' | syntax enable

  " Auto reload VimScript.
  autocmd BufWritePost,FileWritePost *.vim nested
        \ if &l:autoread > 0 | source <afile> |
        \   echo 'source ' . bufname('%') |
        \ endif

  " Reload .vimrc automatically.
  autocmd BufWritePost .vimrc,vimrc,*.rc.vim,*.toml
        \ | source $MYVIMRC | redraw

  autocmd FileType gitcommit,qfreplace setlocal nofoldenable

  autocmd FileType python setlocal foldmethod=indent

  " Update filetype.
  autocmd BufWritePost * nested
  \ if &l:filetype ==# '' || exists('b:ftdetect')
  \ |   unlet! b:ftdetect
  \ |   filetype detect
  \ | endif

  " Improved include pattern.
  autocmd FileType html
        \ setlocal includeexpr=substitute(v:fname,'^\\/','','') |
        \ setlocal path+=./;/
  autocmd FileType php setlocal path+=/usr/local/share/pear
  autocmd FileType apache setlocal path+=./;/

  autocmd FileType go highlight default link goErr WarningMsg |
        \ match goErr /\<err\>/
augroup END

augroup vimrc-highlight
  autocmd!
  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END

function! s:my_on_filetype() abort "{{{
  " Disable automatically insert comment.
  setl formatoptions-=ro | setl formatoptions+=mMBl

  " Disable auto wrap.
  if &l:textwidth != 70 && &filetype !=# 'help'
    setlocal textwidth=0
  endif

  " Use FoldCCtext().
  if &filetype !=# 'help'
    setlocal foldtext=FoldCCtext()
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0
    silent! IndentLinesDisable

    if v:version >= 703
      setlocal colorcolumn=
    endif
  endif
endfunction "}}}
