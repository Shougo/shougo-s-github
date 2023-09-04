" hook_add {{{

" Bash
let g:is_bash = v:true

" Ruby
let g:ruby_no_expensive = v:true

" Java
let g:java_highlight_functions = 'style'
let g:java_highlight_all = v:true
let g:java_highlight_debug = v:true
let g:java_allow_cpp_keywords = v:true
let g:java_space_errors = v:true
let g:java_highlight_functions = v:true

" Tex
let g:tex_flavor = 'latex'

" markdown
let g:vim_markdown_frontmatter = v:true
let g:vim_markdown_toml_frontmatter = v:true
let g:vim_markdown_json_frontmatter = v:true
let g:vim_markdown_no_default_key_mappings = v:true

" Enable modeline for only Vim help files.
autocmd MyAutoCmd BufRead,BufWritePost *.txt,*.jax setlocal modeline

" Enable dein toml synatx.
" NOTE: For neovim use nvim-treesitter syntax instead.
if !has('nvim')
  autocmd MyAutoCmd CursorHold */rc/*.toml call dein#toml#syntax()
endif

" Disable quotes keyword.
autocmd MyAutoCmd BufEnter,BufRead,BufNewFile *.md setlocal iskeyword-='

" For auto completion in gitcommit buffer.
autocmd MyAutoCmd BufEnter COMMIT_EDITMSG syntax enable
autocmd MyAutoCmd BufReadPost COMMIT_EDITMSG call vimrc#append_diff()

" Update filetype.
autocmd MyAutoCmd BufWritePost * nested
\ : if &l:filetype ==# '' || 'b:ftdetect'->exists()
\ |   unlet! b:ftdetect
\ |   silent filetype detect
\ | endif

" For zsh "edit-command-line".
autocmd MyAutoCmd BufRead /tmp/* setlocal wrap

" Disable default plugins.
let g:loaded_2html_plugin      = v:true
let g:loaded_logiPat           = v:true
let g:loaded_getscriptPlugin   = v:true
let g:loaded_gzip              = v:true
let g:loaded_gtags             = v:true
let g:loaded_gtags_cscope      = v:true
let g:loaded_man               = v:true
let g:loaded_matchit           = v:true
let g:loaded_matchparen        = v:true
let g:loaded_netrwFileHandlers = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_netrwSettings     = v:true
let g:loaded_rrhelper          = v:true
let g:loaded_shada_plugin      = v:true
let g:loaded_spellfile_plugin  = v:true
let g:loaded_tarPlugin         = v:true
let g:loaded_tutor_mode_plugin = v:true
let g:loaded_vimballPlugin     = v:true
let g:loaded_zipPlugin         = v:true
" }}}

" _ {{{
" Disable automatically insert comment.
setl formatoptions-=t
setl formatoptions-=c
setl formatoptions-=r
setl formatoptions-=o
setl formatoptions+=mMBl

" Disable auto wrap.
if &l:textwidth != 70 && &filetype !=# 'help'
  setlocal textwidth=0
endif

if !&l:modifiable
  setlocal nofoldenable
  setlocal foldcolumn=0
  setlocal colorcolumn=
endif
" }}}

" python {{{
"setlocal foldmethod=indent
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
" }}}

" html {{{
setlocal includeexpr=v:fname->substitute('^\\/','','')
setlocal path+=./;/
" }}}

" go {{{
highlight default link goErr WarningMsg
match goErr /\<err\>/
" }}}

" vim {{{
setlocal shiftwidth=2 softtabstop=2
setlocal iskeyword+=:,#
setlocal indentkeys+=\\,endif,endfunction,endfor,endwhile,endtry
" }}}

" qfreplace {{{
setlocal nofoldenable
" }}}

" help {{{
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-
setlocal conceallevel=0

function! s:set_highlight(group) abort
  for group in ['helpBar', 'helpBacktick', 'helpStar', 'helpIgnore']
    execute 'highlight link' group a:group
  endfor
endfunction
call s:set_highlight('Special')

function! s:right_align(linenr) abort
  let m = a:linenr->getline()->matchlist(
        \ '^\(\S\+\%(\s\S\+\)\?\)\?\s\+\(\*.\+\*\)')
  if m->empty()
    return
  endif
  call setline(a:linenr, m[1] .. ' '->repeat(
        \ &l:textwidth - len(m[1]) - len(m[2])) .. m[2])
endfunction
function! s:right_aligns(start, end) abort
  for linenr in range(a:start, a:end)
    call s:right_align(linenr)
  endfor
endfunction
command! -range -buffer RightAlign
      \ call s:right_aligns('<line1>'->expand(), '<line2>'->expand())

nnoremap <buffer> mm      <Cmd>RightAlign<CR>
xnoremap <silent><buffer> mm      :RightAlign<CR>

autocmd MyAutoCmd CursorHold <buffer> ++once call s:vim_syntax()
function! s:vim_syntax() abort
  unlet! b:current_syntax
  silent! syntax include @helpVimScript syntax/vim.vim
  syntax region helpVimScript
        \ start='\%(^\s*\|\s\)>\%(vim\)\?$' end='^<\|^$'
        \ contains=@helpVimScript keepend
endfunction
" }}}

" ruby {{{
setlocal iskeyword+=!
setlocal iskeyword+=?
setlocal shiftwidth=2 softtabstop=2 tabstop=2
" }}}

" typescript {{{
setlocal shiftwidth=2
" }}}

" toml {{{
setlocal foldenable foldmethod=expr foldexpr=s:fold_expr(v:lnum)
function! s:fold_expr(lnum)
  const line = getline(a:lnum)
  return line ==# '' || line =~# '^\s\+'
endfunction
" }}}

" yaml {{{
setlocal iskeyword+=-
" }}}
