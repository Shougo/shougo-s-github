"---------------------------------------------------------------------------
" denite.nvim
"

call denite#custom#var('file_rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#source(
      \ 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])

call denite#custom#map('_', "\<C-j>", 'move_to_next_line')
call denite#custom#map('_', "\<C-k>", 'move_to_prev_line')
