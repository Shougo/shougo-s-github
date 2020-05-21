"---------------------------------------------------------------------------
" deoplete.nvim
"

" <TAB>: completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <expr><C-g>       deoplete#refresh()
inoremap <expr><C-e>       deoplete#cancel_popup()
inoremap <silent><expr><C-l>       deoplete#complete_common_string()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
endfunction

" cpsm test
" call deoplete#custom#source('_', 'matchers', ['matcher_cpsm'])
" call deoplete#custom#source('_', 'sorters', [])

call deoplete#custom#source('_', 'matchers',
      \ ['matcher_fuzzy', 'matcher_length'])
call deoplete#custom#source('denite', 'matchers',
      \ ['matcher_full_fuzzy', 'matcher_length'])
" call deoplete#custom#source('eskk,tabnine', 'matchers', [])
call deoplete#custom#source('eskk', 'matchers', [])
" call deoplete#custom#source('buffer', 'mark', '')
" call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
" call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
" call deoplete#custom#source('buffer', 'mark', '*')

call deoplete#custom#option('ignore_sources', {
      \ '_': ['buffer'],
      \ 'c': ['tabnine'],
      \ 'help': ['tabnine'],
      \ })

call deoplete#custom#source('tabnine', 'rank', 600)
call deoplete#custom#source('tabnine', 'min_pattern_length', 2)
" call deoplete#custom#source('tabnine', 'is_volatile', v:false)
call deoplete#custom#var('tabnine', {
      \ 'line_limit': 300,
      \ 'max_num_results': 5,
      \ 'markers': ['.git/'],
      \ })

call deoplete#custom#source('zsh', 'filetypes', ['zsh', 'sh'])
call deoplete#custom#source('nextword', 'filetypes',
      \ ['markdown', 'help', 'gitcommit', 'text'])

call deoplete#custom#source('_', 'converters', [
      \ 'converter_remove_overlap',
      \ 'converter_case',
      \ 'matcher_length',
      \ 'converter_truncate_abbr',
      \ 'converter_truncate_info',
      \ 'converter_truncate_menu',
      \ ])
call deoplete#custom#source('tabnine', 'converters', [
      \ 'converter_remove_overlap',
      \ 'converter_truncate_info',
      \ ])
call deoplete#custom#source('eskk', 'converters', [])

" call deoplete#custom#source('buffer', 'min_pattern_length', 9999)
" call deoplete#custom#source('clang', 'input_pattern', '\.\w*|\.->\w*|\w+::\w*')
" call deoplete#custom#source('clang', 'max_pattern_length', -1)

call deoplete#custom#option('keyword_patterns', {
      \ '_': '[a-zA-Z_]\k*\(?',
      \ 'tex': '[^\w|\s][a-zA-Z_]\w*',
      \ })

" inoremap <silent><expr> <C-t> deoplete#manual_complete('file')

call deoplete#custom#option({
      \ 'auto_refresh_delay': 10,
      \ 'camel_case': v:true,
      \ 'skip_multibyte': v:true,
      \ 'auto_preview': v:true,
      \ })
call deoplete#custom#option('num_processes', 1)

" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', 'deoplete.log')
" call deoplete#custom#source('clang', 'debug_enabled', 1)

call deoplete#custom#option('candidate_marks',
      \ ['A', 'S', 'D', 'F', 'G'])
inoremap <expr>A       pumvisible() ? deoplete#insert_candidate(0) : 'A'
inoremap <expr>S       pumvisible() ? deoplete#insert_candidate(1) : 'S'
inoremap <expr>D       pumvisible() ? deoplete#insert_candidate(2) : 'D'
inoremap <expr>F       pumvisible() ? deoplete#insert_candidate(3) : 'F'
inoremap <expr>G       pumvisible() ? deoplete#insert_candidate(4) : 'G'

autocmd MyAutoCmd BufEnter * call s:tabnine_check()
function! s:tabnine_check() abort
  if finddir('.git') !=# ''
    return
  endif

  " Disable tabnine source
  call deoplete#custom#buffer_option('ignore_sources', ['tabnine'])
endfunction
call s:tabnine_check()
