"---------------------------------------------------------------------------
" neocomplete.vim
"

let g:neocomplete#disable_auto_complete = 0

" Use smartcase.
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#auto_complete_delay = 30

" Use fuzzy completion.
let g:neocomplete#enable_fuzzy_completion = 1

" let g:neocomplete#enable_refresh_always = 1

" Set auto completion length.
let g:neocomplete#auto_completion_start_length = 2
" Set manual completion length.
let g:neocomplete#manual_completion_start_length = 0
" Set minimum keyword length.
let g:neocomplete#min_keyword_length = 3

let g:neocomplete#enable_auto_select = 1

let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $CACHE.'/vimshell/command-history',
      \ }

let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#max_list = 100
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#sources#omni#functions')
  let g:neocomplete#sources#omni#functions = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#enable_auto_close_preview = 1

" let g:neocomplete#force_omni_input_patterns.ruby =
"       \ '[^. *\t]\.\w*\|\h\w*::\w*'
" let g:neocomplete#sources#omni#input_patterns.ruby =
"      \ '[^. *\t]\.\w*\|\h\w*::\w*'

let g:marching_enable_neocomplete = 1
let g:neocomplete#force_omni_input_patterns.cpp =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

let g:neocomplete#sources#omni#input_patterns.python =
      \ '[^. *\t]\.\w*\|\h\w*'

let g:neocomplete#sources#omni#functions.go =
      \ 'gocomplete#Complete'

let g:neocomplete#sources#omni#input_patterns.php =
      \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

let g:neocomplete#sources#omni#input_patterns.lua =
      \ '\w\+[.:]\|require\s*(\?["'']\w*'

" Disable omni auto completion for Java.
" let g:neocomplete#sources#omni#input_patterns.java = ''

" Define keyword pattern.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\k*(\?'
let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::\w*'
let g:neocomplete#keyword_patterns.rst =
      \ '\$\$\?\w*\|[[:alpha:]_.\\/~-][[:alnum:]_.\\/~-]*\|\d\+\%(\.\d\+\)\+'

let g:neocomplete#ignore_source_files = []

let g:neocomplete#sources#vim#complete_functions = {
      \ 'Ref' : 'ref#complete',
      \ 'Unite' : 'unite#complete_source',
      \ 'VimShellExecute' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellInteractive' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellTerminal' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShell' : 'vimshell#complete',
      \ 'VimFiler' : 'vimfiler#complete',
      \ 'Vinarise' : 'vinarise#complete',
      \}
call neocomplete#custom#source('look', 'min_pattern_length', 4)
" call neocomplete#custom#source('_', 'sorters', [])
call neocomplete#custom#source('_', 'converters',
      \ ['converter_add_paren', 'converter_remove_overlap',
      \  'converter_delimiter', 'converter_abbr'])

" mappings."{{{
" <C-f>, <C-b>: page move.
inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   : "\<Left>"
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"
" <C-n>: neocomplete.
inoremap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
" <C-p>: keyword completion.
inoremap <expr> <C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
inoremap <expr> '  pumvisible() ? "\<C-y>" : "'"

inoremap <expr> <C-g>     neocomplete#undo_completion()
inoremap <expr> <C-l>     neocomplete#mappings#complete_common_string()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return neocomplete#smart_close_popup() . "\<CR>"
endfunction

" <TAB>: completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ neocomplete#start_manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
"}}}
