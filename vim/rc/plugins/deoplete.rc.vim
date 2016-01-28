"---------------------------------------------------------------------------
" deoplete.nvim
"

set completeopt+=noinsert

" <TAB>: completion.
imap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deolete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

inoremap <expr><C-g> deoplete#mappings#undo_completion()
" <C-l>: redraw candidates
inoremap <expr><C-l>       deoplete#mappings#refresh()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#mappings#close_popup() . "\<CR>"
endfunction

inoremap <expr> '  pumvisible() ? deoplete#mappings#close_popup() : "'"

" call deoplete#custom#set('_', 'matchers', ['matcher_head'])
" call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])

" Use auto delimiter
call deoplete#custom#set('_', 'converters',
      \ ['converter_auto_paren',
      \  'converter_auto_delimiter', 'remove_overlap'])

" call deoplete#custom#set('buffer', 'min_pattern_length', 9999)

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'
" let g:deoplete#keyword_patterns.tex = '\\?[a-zA-Z_]\w*'
let g:deoplete#keyword_patterns.tex = '[^\w|\s][a-zA-Z_]\w*'

let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.python = ''
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'

" inoremap <silent><expr> <C-t> deoplete#mappings#manual_complete('file')

let g:deoplete#enable_refresh_always = 1
