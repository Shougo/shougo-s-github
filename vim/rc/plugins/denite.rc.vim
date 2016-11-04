"---------------------------------------------------------------------------
" denite.nvim
"

call denite#custom#var('file_rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#source(
      \ 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
call denite#custom#source('file_rec,grep', 'matchers', ['matcher_cpsm'])
call denite#custom#source('grep', 'matchers',
      \ ['matcher_ignore_globs', 'matcher_cpsm'])
call denite#custom#source('file_mru', 'converters',
      \ ['converter_relative_word'])

call denite#custom#map('_', "\<C-j>", 'move_to_next_line')
call denite#custom#map('_', "\<C-k>", 'move_to_prev_line')
call denite#custom#map('insert', "'", 'enter_mode:normal')

call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#option('default', 'prompt', '>')

let s:menus = {}
let s:menus.vim = {
    \ 'description': 'Vim',
    \ }
let s:menus.vim.file_candidates = [
    \ ['    > Edit configuation file (init.vim)', '~/.config/nvim/init.vim']
    \ ]
call denite#custom#var('menu', 'menus', s:menus)

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [
      \ '.git/', '.ropeproject/', '__pycache__/',
      \ 'venv/',
      \ 'images/',
      \ '*.min.*',
      \ 'img/', 'fonts/'])
