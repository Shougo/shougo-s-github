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
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <silent><expr><C-g>       deoplete#manual_complete('tabnine')
inoremap <silent><expr><C-e>       deoplete#cancel_popup()
inoremap <silent><expr><C-l>       deoplete#complete_common_string()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
endfunction

call deoplete#custom#source('_', 'matchers',
      \ ['matcher_fuzzy', 'matcher_length'])
call deoplete#custom#source('denite', 'matchers',
      \ ['matcher_full_fuzzy', 'matcher_length'])
call deoplete#custom#source('eskk', 'matchers', [])

call deoplete#custom#option('ignore_sources', {
      \ '_': ['tabnine'],
      \ })

call deoplete#custom#source('tabnine', 'rank', 600)
call deoplete#custom#source('tabnine', 'min_pattern_length', 2)
call deoplete#custom#var('tabnine', {
      \ 'line_limit': 300,
      \ 'max_num_results': 10,
      \ })

call deoplete#custom#source('zsh', 'filetypes', ['zsh', 'sh'])
call deoplete#custom#source('nextword', 'filetypes',
      \ ['markdown', 'help', 'gitcommit', 'text'])

call deoplete#custom#source('_', 'ignore_case', v:true)
call deoplete#custom#source('_', 'smart_case', v:true)
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

call deoplete#custom#option('keyword_patterns', {
      \ '_': '[a-zA-Z_]\k*\(?',
      \ 'tex': '[^\w|\s][a-zA-Z_]\w*',
      \ })

call deoplete#custom#option({
      \ 'auto_preview': v:true,
      \ 'camel_case': v:true,
      \ 'nofile_complete_filetypes': ['denite-filter', 'zsh'],
      \ 'num_processes': 4,
      \ 'refresh_always': v:false,
      \ 'refresh_backspace': v:false,
      \ 'skip_multibyte': v:true,
      \ })

" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', 'deoplete.log')
