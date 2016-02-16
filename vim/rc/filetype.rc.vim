"---------------------------------------------------------------------------
" FileType:
"

" Enable smart indent.
SetFixer set autoindent smartindent

augroup MyAutoCmd
  autocmd FileType,Syntax,BufEnter,BufWinEnter * call s:my_on_filetype()

  " Enable gauche syntax.
  autocmd FileType scheme nested let b:is_gauche=1 | setlocal lispwords=define |
        \let b:current_syntax='' | syntax enable

  " Auto reload VimScript.
  autocmd BufWritePost,FileWritePost *.vim nested
        \ if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') |
        \ endif

  " Reload .vimrc automatically.
  autocmd BufWritePost .vimrc,vimrc,*.rc.vim,*.toml nested
        \ | source $MYVIMRC | redraw

  autocmd FileType gitcommit,qfreplace setlocal nofoldenable

  autocmd FileType ref nnoremap <buffer> <TAB> <C-w>w

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
  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=100 | endif
augroup END

" Python
let g:python_highlight_all = 1

" Vim
let g:vimsyntax_noerror = 1
"let g:vim_indent_cont = 0

" Bash
let g:is_bash = 1

" Java
let g:java_highlight_functions = 'style'
let g:java_highlight_all=1
let g:java_highlight_debug=1
let g:java_allow_cpp_keywords=1
let g:java_space_errors=1
let g:java_highlight_functions=1

" JavaScript
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

" Markdown
let g:markdown_fenced_languages = []

" Go
if $GOROOT != ''
  SetFixer set runtimepath+=$GOROOT/misc/vim
endif

" Tex
let g:tex_flavor = 'latex'

" http://mattn.kaoriya.net/software/vim/20140523124903.htm
let g:markdown_fenced_languages = [
      \  'coffee',
      \  'css',
      \  'erb=eruby',
      \  'javascript',
      \  'js=javascript',
      \  'json=javascript',
      \  'ruby',
      \  'sass',
      \  'xml',
      \  'vim',
      \]

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

" Do not display completion messages
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
SetFixer set noshowmode
try
  SetFixer set shortmess+=c
catch /^Vim\%((\a\+)\)\=:E539: Illegal character/
  autocmd MyAutoCmd VimEnter *
        \ highlight ModeMsg guifg=bg guibg=bg |
        \ highlight Question guifg=bg guibg=bg
endtry
