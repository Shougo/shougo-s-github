"---------------------------------------------------------------------------
" denite.nvim
"

if executable('rg')
  call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
else
  call denite#custom#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

call denite#custom#source('file/old', 'matchers',
      \ ['matcher/fuzzy', 'matcher/project_files'])
call denite#custom#source('tag', 'matchers', ['matcher/substring'])
if has('nvim')
  call denite#custom#source('file/rec', 'matchers',
        \ ['matcher/cpsm'])
endif
call denite#custom#source('file/old', 'converters',
      \ ['converter/relative_word'])

call denite#custom#map('insert', "'",
      \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('normal', 'r',
      \ '<denite:do_action:quickfix>', 'noremap')
call denite#custom#map('insert', '<BS>',
      \ '<denite:smart_delete_char_before_caret>', 'noremap')
call denite#custom#map('insert', '<C-h>',
      \ '<denite:smart_delete_char_before_caret>', 'noremap')
call denite#custom#map('insert', ';',
      \ 'vimrc#sticky_func()', 'expr')

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

" call denite#custom#option('default', 'prompt', '>')
" call denite#custom#option('default', 'short_source_names', v:true)
call denite#custom#option('default', {
      \ 'auto_accel': v:true,
      \ 'prompt': '>',
      \ 'source_names': 'short',
      \ })

let s:menus = {}
let s:menus.vim = {
    \ 'description': 'Vim',
    \ }
let s:menus.vim.file_candidates = [
    \ ['    > Edit configuation file (init.vim)', '~/.config/nvim/init.vim']
    \ ]
call denite#custom#var('menu', 'menus', s:menus)

call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

call denite#custom#action('file', 'test',
      \ {context -> execute('let g:foo = 1')})

call denite#custom#action('file', 'test2',
      \ {context -> denite#do_action(context, 'open', context['targets'])})
