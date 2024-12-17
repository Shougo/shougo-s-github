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

" help
let g:help_example_languages = #{
      \   vim: 'vim',
      \   sh: 'sh',
      \   typescript: 'typescript',
      \   lua: 'lua',
      \ }

" Enable modeline for only Vim help files.
autocmd MyAutoCmd BufRead,BufWritePost *.txt,*.jax setlocal modeline

" Disable quotes keyword.
autocmd MyAutoCmd BufEnter,BufRead,BufNewFile *.md setlocal iskeyword-='

" For auto completion in gitcommit buffer.
autocmd MyAutoCmd BufReadPost COMMIT_EDITMSG call vimrc#append_diff()

" Update filetype.
autocmd MyAutoCmd BufWritePost * nested
\ : if &l:filetype ==# '' || 'b:ftdetect'->exists()
\ |   unlet! b:ftdetect
\ |   silent filetype detect
\ | endif

" from https://github.com/kuuote/dotvim/blob/46760385/conf/rc/autocmd.vim#L5
function! s:chmod(file) abort
  const perm = a:file->getfperm()
  const newperm = printf('%sx%sx%sx', perm[0:1], perm[3:4], perm[6:7])
  if perm !=# newperm
    call setfperm(a:file, newperm)
  endif
endfunction
autocmd MyAutoCmd BufWritePost * nested
      \ : if 1->getline()->stridx('#!/') ==# 0
      \ |   call s:chmod('<afile>'->expand())
      \ | endif

" For zsh "edit-command-line".
autocmd MyAutoCmd BufRead /tmp/* setlocal wrap

" Disable default plugins.
let g:loaded_2html_plugin      = v:true
let g:loaded_getscriptPlugin   = v:true
let g:loaded_gtags             = v:true
let g:loaded_gtags_cscope      = v:true
let g:loaded_gzip              = v:true
let g:loaded_logiPat           = v:true
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
