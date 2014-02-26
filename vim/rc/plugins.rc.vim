"---------------------------------------------------------------------------
" Plugin:
"

" neocomplete.vim"{{{
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1

let bundle = neobundle#get('neocomplete.vim')
function! bundle.hooks.on_source(bundle)
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#enable_camel_case = 1

  " Use fuzzy completion.
  let g:neocomplete#enable_fuzzy_completion = 1

  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  " Set auto completion length.
  let g:neocomplete#auto_completion_start_length = 2
  " Set manual completion length.
  let g:neocomplete#manual_completion_start_length = 0
  " Set minimum keyword length.
  let g:neocomplete#min_keyword_length = 3

  " For auto select.
  let g:neocomplete#enable_complete_select = 1
  try
    let completeopt_save = &completeopt
    set completeopt+=noinsert,noselect
  catch
    let g:neocomplete#enable_complete_select = 0
  finally
    let &completeopt = completeopt_save
  endtry
  let g:neocomplete#enable_auto_select = 1
  let g:neocomplete#enable_refresh_always = 0
  let g:neocomplete#enable_cursor_hold_i = 0

  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.cache/vimshell/command-history',
        \ }

  let g:neocomplete#enable_auto_delimiter = 1
  let g:neocomplete#disable_auto_select_buffer_name_pattern =
        \ '\[Command Line\]'
  let g:neocomplete#max_list = 100
  let g:neocomplete#force_overwrite_completefunc = 1
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

  " let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::\w*'
  let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::\w*'

  let g:neocomplete#sources#omni#functions.go =
        \ 'gocomplete#Complete'

  let g:neocomplete#sources#omni#input_patterns.php =
  \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

  " Disable omni auto completion for Java.
  let g:neocomplete#sources#omni#input_patterns.java = ''

  " Define keyword pattern.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ = '\h\w*'
  let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::\w*'

  let g:neocomplete#ignore_source_files = ['tag.vim']

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

  " mappings."{{{
  " <C-f>, <C-b>: page move.
  inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
  inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   : "\<Left>"
  " <C-y>: paste.
  inoremap <expr><C-y>  pumvisible() ? neocomplete#close_popup() :  "\<C-r>\""
  " <C-e>: close popup.
  inoremap <expr><C-e>  pumvisible() ? neocomplete#cancel_popup() : "\<End>"
  " <C-k>: unite completion.
  imap <C-k>  <Plug>(neocomplete_start_unite_complete)
  inoremap <expr> O  &filetype == 'vim' ? "\<C-x>\<C-v>" : "\<C-x>\<C-o>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  " <C-n>: neocomplete.
  inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
  " <C-p>: keyword completion.
  inoremap <expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
  inoremap <expr>'  pumvisible() ? neocomplete#close_popup() : "'"

  inoremap <expr><C-x><C-f>
        \ neocomplete#start_manual_complete('file')

  inoremap <expr><C-g>     neocomplete#undo_completion()
  inoremap <expr><C-l>     neocomplete#complete_common_string()

  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#smart_close_popup() . "\<CR>"
  endfunction

  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ neocomplete#start_manual_complete()
  function! s:check_back_space() "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction"}}}
  " <S-TAB>: completion back.
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

  " For cursor moving in insert mode(Not recommended)
  inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
  inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
  inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
  inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
  "}}}
endfunction
"}}}

" vim-marching"{{{
let s:hooks = neobundle#get_hooks('vim-marching')
function! s:hooks.on_source(bundle)
  let g:marching_clang_command_option = '-std=c++1y'
  let g:marching_include_paths = filter(
        \ split(glob('/usr/include/c++/*'), '\n') +
        \ split(glob('/usr/include/*/c++/*'), '\n') +
        \ split(glob('/usr/include/*/'), '\n'),
        \ 'isdirectory(v:val)')

  let g:marching_enable_neocomplete = 1
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif

  let g:neocomplete#force_omni_input_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endfunction
unlet s:hooks
"}}}

" neocomplcache.vim"{{{
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 0

let hooks = neobundle#get_hooks('neocomplcache')
function! hooks.on_source(bundle)
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 0
  " Use camel case completion.
  let g:neocomplcache_enable_camel_case_completion = 0
  " Use underbar completion.
  let g:neocomplcache_enable_underbar_completion = 0
  " Use fuzzy completion.
  let g:neocomplcache_enable_fuzzy_completion = 0

  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  " Set auto completion length.
  let g:neocomplcache_auto_completion_start_length = 2
  " Set manual completion length.
  let g:neocomplcache_manual_completion_start_length = 0
  " Set minimum keyword length.
  let g:neocomplcache_min_keyword_length = 3
  " let g:neocomplcache_enable_cursor_hold_i = v:version > 703 ||
  "       \ v:version == 703 && has('patch289')
  let g:neocomplcache_enable_cursor_hold_i = 0
  let g:neocomplcache_cursor_hold_i_time = 300
  let g:neocomplcache_enable_insert_char_pre = 0
  let g:neocomplcache_enable_prefetch = 1
  let g:neocomplcache_skip_auto_completion_time = '0.6'

  " For auto select.
  let g:neocomplcache_enable_auto_select = 1

  let g:neocomplcache_enable_auto_delimiter = 1
  let g:neocomplcache_disable_auto_select_buffer_name_pattern =
        \ '\[Command Line\]'
  "let g:neocomplcache_disable_auto_complete = 0
  let g:neocomplcache_max_list = 100
  let g:neocomplcache_force_overwrite_completefunc = 1
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  if !exists('g:neocomplcache_omni_functions')
    let g:neocomplcache_omni_functions = {}
  endif
  if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_enable_auto_close_preview = 1
  " let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

  " For clang_complete.
  let g:neocomplcache_force_overwrite_completefunc = 1
  let g:neocomplcache_force_omni_patterns.c =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_force_omni_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:clang_complete_auto = 0
  let g:clang_auto_select = 0
  let g:clang_use_library   = 1

  " Define keyword pattern.
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  " let g:neocomplcache_keyword_patterns.default = '\h\w*'
  let g:neocomplcache_keyword_patterns['default'] = '[0-9a-zA-Z:#_]\+'
  let g:neocomplcache_keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

  let g:neocomplcache_vim_completefuncs = {
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
endfunction

function! CompleteFiles(findstart, base)
  if a:findstart
    " Get cursor word.
    let cur_text = strpart(getline('.'), 0, col('.') - 1)

    return match(cur_text, '\f*$')
  endif

  let words = split(expand(a:base . '*'), '\n')
  let list = []
  let cnt = 0
  for word in words
    call add(list, {
          \ 'word' : word,
          \ 'abbr' : printf('%3d: %s', cnt, word),
          \ 'menu' : 'file_complete'
          \ })
    let cnt += 1
  endfor

  return { 'words' : list, 'refresh' : 'always' }
endfunction

unlet bundle
"}}}

" neosnippet.vim"{{{
let bundle = neobundle#get('neosnippet.vim')
function! bundle.hooks.on_source(bundle)
  imap <silent>L     <Plug>(neosnippet_jump_or_expand)
  smap <silent>L     <Plug>(neosnippet_jump_or_expand)
  xmap <silent>L     <Plug>(neosnippet_start_unite_snippet_target)
  imap <silent>K     <Plug>(neosnippet_expand_or_jump)
  smap <silent>K     <Plug>(neosnippet_expand_or_jump)
  imap <silent>G     <Plug>(neosnippet_expand)
  imap <silent>S     <Plug>(neosnippet_start_unite_snippet)
  xmap <silent>o     <Plug>(neosnippet_register_oneshot_snippet)
  xmap <silent>U     <Plug>(neosnippet_expand_target)

  " let g:neosnippet#enable_snipmate_compatibility = 1

  " let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
  let g:neosnippet#snippets_directory = '~/.vim/snippets'
endfunction

unlet bundle
"}}}

" echodoc.vim"{{{
let bundle = neobundle#get('echodoc.vim')
function! bundle.hooks.on_source(bundle)
  let g:echodoc_enable_at_startup = 1
endfunction
unlet bundle
"}}}

" vimshell.vim"{{{
" Plugin key-mappings."{{{
" <C-Space>: switch to vimshell.
nmap <C-@>  <Plug>(vimshell_switch)
nnoremap !  q:VimShellExecute<Space>
nnoremap [Space]i  q:VimShellInteractive<Space>
nnoremap [Space]t  q:VimShellTerminal<Space>

nnoremap <silent> [Space];  <C-u>:VimShellPop<CR>
"}}}

let bundle = neobundle#get('vimshell')
function! bundle.hooks.on_source(bundle)
  " let g:vimshell_user_prompt = "3\ngetcwd()"
  let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  " let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
  let g:vimshell_prompt = '% '
  " let g:vimshell_prompt = "(U'w'){ "
  "let g:vimshell_environment_term = 'xterm'
  let g:vimshell_split_command = ''
  let g:vimshell_enable_transient_user_prompt = 1
  let g:vimshell_force_overwrite_statusline = 1

  autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
  function! s:vimshell_settings()
    if IsWindows()
      " Display user name on Windows.
      "let g:vimshell_prompt = $USERNAME."% "

      " Use ckw.
      let g:vimshell_use_terminal_command = 'ckw -e'
    else
      " Display user name on Linux.
      "let g:vimshell_prompt = $USER."% "

      " Use zsh history.
      let g:vimshell_external_history_path = expand('~/.zsh-history')

      call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
      call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
      let g:vimshell_execute_file_list['zip'] = 'zipinfo'
      call vimshell#set_execute_file('tgz,gz', 'gzcat')
      call vimshell#set_execute_file('tbz,bz2', 'bzcat')

      " Use gnome-terminal.
      let g:vimshell_use_terminal_command = 'gnome-terminal -e'
    endif

    " Initialize execute file list.
    let g:vimshell_execute_file_list = {}
    call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python'
    call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

    inoremap <buffer><expr>'  pumvisible() ? "\<C-y>" : "'"
    imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
    imap <buffer><C-h>  <Plug>(vimshell_another_delete_backward_char)
    imap <buffer><C-k>  <Plug>(vimshell_zsh_complete)
    imap <buffer><C-g>  <Plug>(vimshell_history_neocomplete)

    xmap <buffer> y <Plug>(operator-concealedyank)

    nnoremap <silent><buffer> <C-j>
          \ :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>

    call vimshell#altercmd#define('u', 'cdup')
    call vimshell#altercmd#define('g', 'git')
    call vimshell#altercmd#define('i', 'iexe')
    call vimshell#altercmd#define('t', 'texe')
    call vimshell#set_alias('l.', 'ls -d .*')
    call vimshell#set_alias('gvim', 'gexe gvim')
    call vimshell#set_galias('L', 'ls -l')
    call vimshell#set_galias('time', 'exe time -p')
    call vimshell#set_alias('.', 'source')

    " Auto jump.
    call vimshell#set_alias('j', ':Unite -buffer-name=files
          \ -default-action=lcd -no-split -input=$$args directory_mru')

    call vimshell#set_alias('up', 'cdup')

    call vimshell#hook#add('chpwd', 'my_chpwd', s:vimshell_hooks.chpwd)
    " call vimshell#hook#add('emptycmd', 'my_emptycmd', s:vimshell_hooks.emptycmd)
    call vimshell#hook#add('notfound', 'my_notfound', s:vimshell_hooks.notfound)
    call vimshell#hook#add('preprompt', 'my_preprompt', s:vimshell_hooks.preprompt)
    call vimshell#hook#add('preexec', 'my_preexec', s:vimshell_hooks.preexec)
    " call vimshell#hook#set('preexec', [s:SID_PREFIX() . 'vimshell_hooks_preexec'])
  endfunction

  autocmd MyAutoCmd FileType int-* call s:interactive_settings()
  function! s:interactive_settings()
    call vimshell#hook#set('input', [s:vimshell_hooks.input])
  endfunction

  autocmd MyAutoCmd FileType term-* call s:terminal_settings()
  function! s:terminal_settings()
    inoremap <silent><buffer><expr> <Plug>(vimshell_term_send_semicolon)
          \ vimshell#term_mappings#send_key(';')
    inoremap <silent><buffer><expr> j<Space>
          \ vimshell#term_mappings#send_key('j')
    "inoremap <silent><buffer><expr> <Up>
    "      \ vimshell#term_mappings#send_keys("\<ESC>[A")

    " Sticky key.
    imap <buffer><expr> ;  <SID>texe_sticky_func()

    " Escape key.
    iunmap <buffer> <ESC><ESC>
    imap <buffer> <ESC>         <Plug>(vimshell_term_send_escape)
  endfunction
  function! s:texe_sticky_func()
    let sticky_table = {
          \',' : '<', '.' : '>', '/' : '?',
          \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
          \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')', '-' : '_', '=' : '+',
          \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
          \}
    let special_table = {
          \ "\<ESC>" : "\<ESC>", "\<CR>" : ";\<CR>"
          \ "\<Space>" : "\<Plug>(vimshell_term_send_semicolon)",
          \}

    if mode() !~# '^c'
      echo 'Input sticky key: '
    endif
    let char = ''

    while char == ''
      let char = nr2char(getchar())
    endwhile

    if char =~ '\l'
      return toupper(char)
    elseif has_key(sticky_table, char)
      return sticky_table[char]
    elseif has_key(special_table, char)
      return special_table[char]
    else
      return ''
    endif
  endfunction

  let s:vimshell_hooks = {}
  function! s:vimshell_hooks.chpwd(args, context)
    if len(split(glob('*'), '\n')) < 100
      call vimshell#execute('ls')
    else
      call vimshell#execute('echo "Many files."')
    endif
  endfunction
  function! s:vimshell_hooks.emptycmd(cmdline, context)
    call vimshell#set_prompt_command('ls')
    return 'ls'
  endfunction
  function! s:vimshell_hooks.notfound(cmdline, context)
    return ''
  endfunction
  function! s:vimshell_hooks.preprompt(args, context)
    " call vimshell#execute('echo "preprompt"')
  endfunction
  function! s:vimshell_hooks.preexec(cmdline, context)
    " call vimshell#execute('echo "preexec"')

    let args = vimproc#parser#split_args(a:cmdline)
    if len(args) > 0 && args[0] ==# 'diff'
      call vimshell#set_syntax('diff')
    endif

    return a:cmdline
  endfunction
  function! s:vimshell_hooks.input(input, context)
    " echomsg 'input'
    return a:input
  endfunction
endfunction

unlet bundle
"}}}

" netrw.vim"{{{
let g:netrw_list_hide= '*.swp'
" Change default directory.
set browsedir=current
"}}}

" vinarise.vim"{{{
let g:vinarise_enable_auto_detect = 1
"}}}

" unite.vim"{{{
" The prefix key.
nnoremap    [unite]   <Nop>
xnoremap    [unite]   <Nop>
nmap    ;u [unite]
xmap    ;u [unite]

nnoremap <expr><silent> ;b  <SID>unite_build()
function! s:unite_build()
  return ":\<C-u>Unite -buffer-name=build". tabpagenr() ." -no-quit build\<CR>"
endfunction
nnoremap <silent> ;o
      \ :<C-u>Unite outline -start-insert -resume<CR>
nnoremap <silent> ;t
      \ :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
xnoremap <silent> ;r
      \ d:<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> <C-k>
      \ :<C-u>Unite change jump<CR>
nnoremap <silent><expr> ;g
      \ ":\<C-u>Unite grep -buffer-name=grep%".tabpagenr()." -auto-preview -no-quit -no-empty -resume\<CR>"
nnoremap <silent> ;r
      \ :<C-u>Unite -buffer-name=register register history/yank<CR>

" <C-t>: Tab pages
nnoremap <silent><expr> <C-t>
      \ ":\<C-u>Unite -select=".(tabpagenr()-1)." tab\<CR>"

if IsWindows()
  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique
        \ jump_point file_point buffer_tab file_mru
        \ file_rec:! file file/new<CR>
else
  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique
        \ jump_point file_point buffer_tab file_mru
        \ file_rec/async:! file file/new<CR>
endif

nnoremap <silent> [Window]f
      \ :<C-u>Unite <CR>

nnoremap <silent> [Window]w
      \ :<C-u>Unite window<CR>
nnoremap <silent> [Space]b
      \ :<C-u>UniteBookmarkAdd<CR>

" t: tags-and-searches "{{{
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Jump.
" nnoremap [Tag]t  g<C-]>
nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "g\<C-]>" :
      \ ":\<C-u>UniteWithCursorWord -buffer-name=tag -immediately tag tag/include\<CR>"
nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
      \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"

" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
"}}}

" Execute help.
nnoremap <silent> <C-h>  :<C-u>Unite -buffer-name=help help<CR>

" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>UniteWithCursorWord help<CR>

" Search.
nnoremap <silent><expr> /
      \ ":\<C-u>Unite -buffer-name=search%".bufnr('%')." -start-insert line:forward:wrap\<CR>"
nnoremap <expr> g/  <SID>smart_search_expr('g/',
      \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>")
nnoremap <silent><expr> ?
      \ ":\<C-u>Unite -buffer-name=search%".bufnr('%')." -start-insert line:backward\<CR>"
nnoremap <silent><expr> *
      \ ":\<C-u>UniteWithCursorWord -buffer-name=search%".bufnr('%')." line:forward:wrap\<CR>"
nnoremap [Alt]/       /
nnoremap [Alt]?       ?
cnoremap <expr><silent><C-g>        (getcmdtype() == '/') ?
      \ "\<ESC>:Unite -buffer-name=search line:forward:wrap -input=".getcmdline()."\<CR>" : "\<C-g>"

function! s:smart_search_expr(expr1, expr2)
  return line('$') > 5000 ?  a:expr1 : a:expr2
endfunction

nnoremap <silent><expr> n
      \ ":\<C-u>UniteResume search%".bufnr('%')." -no-start-insert\<CR>"

let g:unite_source_history_yank_enable = 1

" For unite-alias.
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.test = {
      \ 'source' : 'file_rec',
      \ 'args'   : '~/',
      \ }
let g:unite_source_alias_aliases.line_migemo = 'line'
let g:unite_source_alias_aliases.calc = 'kawaii-calc'
let g:unite_source_alias_aliases.l = 'launcher'
let g:unite_source_alias_aliases.kill = 'process'
let g:unite_source_alias_aliases.message = {
      \ 'source' : 'output',
      \ 'args'   : 'message',
      \ }
let g:unite_source_alias_aliases.mes = {
      \ 'source' : 'output',
      \ 'args'   : 'message',
      \ }
let g:unite_source_alias_aliases.scriptnames = {
      \ 'source' : 'output',
      \ 'args'   : 'scriptnames',
      \ }

" For unite-menu.
let g:unite_source_menu_menus = {}

let g:unite_source_menu_menus.enc = {
      \     'description' : 'Open with a specific character code again.',
      \ }
let g:unite_source_menu_menus.enc.command_candidates = [
      \       ['utf8', 'Utf8'],
      \       ['iso2022jp', 'Iso2022jp'],
      \       ['cp932', 'Cp932'],
      \       ['euc', 'Euc'],
      \       ['utf16', 'Utf16'],
      \       ['utf16-be', 'Utf16be'],
      \       ['jis', 'Jis'],
      \       ['sjis', 'Sjis'],
      \       ['unicode', 'Unicode'],
      \     ]

let g:unite_source_menu_menus.fenc = {
      \     'description' : 'Change file fenc option.',
      \ }
let g:unite_source_menu_menus.fenc.command_candidates = [
      \       ['utf8', 'WUtf8'],
      \       ['iso2022jp', 'WIso2022jp'],
      \       ['cp932', 'WCp932'],
      \       ['euc', 'WEuc'],
      \       ['utf16', 'WUtf16'],
      \       ['utf16-be', 'WUtf16be'],
      \       ['jis', 'WJis'],
      \       ['sjis', 'WSjis'],
      \       ['unicode', 'WUnicode'],
      \     ]

let g:unite_source_menu_menus.ff = {
      \     'description' : 'Change file format option.',
      \ }
let g:unite_source_menu_menus.ff.command_candidates = {
      \       'unix'   : 'WUnix',
      \       'dos'    : 'WDos',
      \       'mac'    : 'WMac',
      \     }

let g:unite_source_menu_menus.unite = {
      \     'description' : 'Start unite sources',
      \ }
let g:unite_source_menu_menus.unite.command_candidates = {
      \       'history'    : 'Unite history/command',
      \       'quickfix'   : 'Unite qflist -no-quit',
      \       'resume'     : 'Unite -buffer-name=resume resume',
      \       'directory'  : 'Unite -buffer-name=files '.
      \             '-default-action=lcd directory_mru',
      \       'mapping'    : 'Unite mapping',
      \       'message'    : 'Unite output:message',
      \       'scriptnames': 'Unite output:scriptnames',
      \     }

let bundle = neobundle#get('unite.vim')
function! bundle.hooks.on_source(bundle)
  autocmd MyAutoCmd FileType unite call s:unite_my_settings()

  let g:unite_ignore_source_files = ['function.vim', 'command.vim']

  call unite#custom#profile('action', 'context', {'start_insert' : 1})

  " Set "-no-quit" automatically in grep unite source.
  call unite#custom#profile('source/grep', 'context', {'no_quit' : 1})

  " migemo.
  call unite#custom#source('line_migemo', 'matchers', 'matcher_migemo')

  " Custom filters."{{{
  call unite#custom#source(
        \ 'buffer,file_rec,file_rec/async', 'matchers',
        \ ['matcher_fuzzy'])
  call unite#custom#source(
        \ 'file_mru', 'matchers',
        \ ['matcher_project_files', 'matcher_fuzzy'])
  " call unite#custom#source(
  "       \ 'file', 'matchers',
  "       \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
  call unite#custom#source(
        \ 'file_rec/async,file_mru', 'converters',
        \ ['converter_file_directory'])
  call unite#filters#sorter_default#use(['sorter_rank'])
  "}}}

  function! s:unite_my_settings() "{{{
    " Directory partial match.
    call unite#custom#alias('file', 'h', 'left')
    call unite#custom#default_action('directory', 'narrow')
    " call unite#custom#default_action('file', 'my_tabopen')

    call unite#custom#default_action('versions/git/status', 'commit')

    " call unite#custom#default_action('directory', 'cd')

    " Custom actions."{{{
    let my_tabopen = {
          \ 'description' : 'my tabopen items',
          \ 'is_selectable' : 1,
          \ }
    function! my_tabopen.func(candidates) "{{{
      call unite#take_action('tabopen', a:candidates)

      let dir = isdirectory(a:candidates[0].word) ?
            \ a:candidates[0].word : fnamemodify(a:candidates[0].word, ':p:h')
      execute g:unite_kind_openable_lcd_command '`=dir`'
    endfunction"}}}
    call unite#custom#action('file,buffer', 'tabopen', my_tabopen)
    unlet my_tabopen
    "}}}

    " Overwrite settings.
    imap <buffer>  <BS>      <Plug>(unite_delete_backward_path)
    imap <buffer>  jj      <Plug>(unite_insert_leave)
    imap <buffer><expr> j unite#smart_map('j', '')
    imap <buffer> <TAB>   <Plug>(unite_select_next_line)
    imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
    imap <buffer> '     <Plug>(unite_quick_match_default_action)
    nmap <buffer> '     <Plug>(unite_quick_match_default_action)
    imap <buffer><expr> x
          \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
    nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
    nmap <buffer> cd     <Plug>(unite_quick_match_default_action)
    nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    " imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
    " nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
    nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
    " nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    " imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    nmap <silent><buffer> <Tab>     :call <SID>NextWindow()<CR>
    nnoremap <silent><buffer><expr> l
          \ unite#smart_map('l', unite#do_action('default'))
    " nmap <buffer> <C-e>     <Plug>(unite_narrowing_input_history)

    let unite = unite#get_current_unite()
    if unite.profile_name ==# '^search'
      nnoremap <silent><buffer><expr> r     unite#do_action('replace')
    else
      nnoremap <silent><buffer><expr> r     unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
    nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
          \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])

    nnoremap <silent><buffer><expr> p
          \ empty(filter(range(1, winnr('$')),
          \ 'getwinvar(v:val, "&previewwindow") != 0')) ?
          \ unite#do_action('preview') : ":\<C-u>pclose!\<CR>"
  endfunction"}}}

  " Variables.
  let g:unite_enable_split_vertically = 0
  let g:unite_winheight = 20
  let g:unite_enable_start_insert = 0
  let g:unite_enable_short_source_names = 1

  let g:unite_cursor_line_highlight = 'TabLineSel'
  " let g:unite_abbr_highlight = 'TabLine'

  if IsWindows()
  else
    " Like Textmate icons.
    let g:unite_marked_icon = '✗'

    " Prompt choices.
    "let g:unite_prompt = '❫ '
    let g:unite_prompt = '» '
  endif

  if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
          \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
          \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
  elseif executable('pt')
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
  elseif executable('jvgrep')
    " For jvgrep.
    let g:unite_source_grep_command = 'jvgrep'
    let g:unite_source_grep_default_opts = '--exclude ''\.(git|svn|hg|bzr)'''
    let g:unite_source_grep_recursive_opt = '-R'
  elseif executable('ack-grep')
    " For ack.
    let g:unite_source_grep_command = 'ack-grep'
    let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
    let g:unite_source_grep_recursive_opt = ''
  endif

  let g:unite_build_error_icon    = '~/.vim/signs/err.'
        \ . (IsWindows() ? 'bmp' : 'png')
  let g:unite_build_warning_icon  = '~/.vim/signs/warn.'
        \ . (IsWindows() ? 'bmp' : 'png')
endfunction

unlet bundle
"}}}

" camlcasemotion.vim"{{{
nmap <silent> W <Plug>CamelCaseMotion_w
xmap <silent> W <Plug>CamelCaseMotion_w
omap <silent> W <Plug>CamelCaseMotion_w
nmap <silent> B <Plug>CamelCaseMotion_b
xmap <silent> B <Plug>CamelCaseMotion_b
omap <silent> B <Plug>CamelCaseMotion_b
""}}}

" smartchr.vim"{{{
let bundle = neobundle#get('vim-smartchr')
function! bundle.hooks.on_source(bundle)
  inoremap <expr> , smartchr#one_of(', ', ',')

  " Smart =.
  inoremap <expr> =
        \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
        \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
        \ : smartchr#one_of(' = ', '=', ' == ')
  augroup MyAutoCmd
    " Substitute .. into -> .
    autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
    autocmd FileType perl,php inoremap <buffer> <expr> . smartchr#loop(' . ', '->', '.')
    autocmd FileType perl,php inoremap <buffer> <expr> - smartchr#loop('-', '->')
    autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')

    autocmd FileType haskell,int-ghci
          \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
          \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
          \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
          \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
          \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
          \| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')

    autocmd FileType scala
          \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
          \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
          \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
          \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')

    autocmd FileType eruby
          \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
          \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
  augroup END
endfunction

unlet bundle
"}}}

" changelog.vim"{{{
autocmd MyAutoCmd BufNewFile,BufRead *.changelog setf changelog
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "Shougo "
"}}}

" quickrun.vim"{{{
nmap <silent> <Leader>r <Plug>(quickrun)
"}}}

" python.vim
let python_highlight_all = 1

" ref.vim"{{{
let bundle = neobundle#get('vim-ref')
function! bundle.hooks.on_source(bundle)
  let g:ref_cache_dir = expand('~/.cache/ref')
  let g:ref_use_vimproc = 1
  if IsWindows()
    let g:ref_refe_encoding = 'cp932'
  else
    let g:ref_refe_encoding = 'euc-jp'
  endif

  " ref-lynx.
  if IsWindows()
    let lynx = 'C:/lynx/lynx.exe'
    let cfg  = 'C:/lynx/lynx.cfg'
    let g:ref_lynx_cmd = s:lynx.' -cfg='.s:cfg.' -dump -nonumbers %s'
    let g:ref_alc_cmd = s:lynx.' -cfg='.s:cfg.' -dump %s'
  endif

  let g:ref_lynx_use_cache = 1
  let g:ref_lynx_start_linenumber = 0 " Skip.
  let g:ref_lynx_hide_url_number = 0

  autocmd MyAutoCmd FileType ref call s:ref_my_settings()
  function! s:ref_my_settings() "{{{
    " Overwrite settings.
    nmap <buffer> [Tag]t  <Plug>(ref-keyword)
    nmap <buffer> [Tag]p  <Plug>(ref-back)
  endfunction"}}}
endfunction

unlet bundle
"}}}

if neobundle#tap('vimfiler') "{{{
  "nmap    [Space]v   <Plug>(vimfiler_switch)
  nnoremap <silent>   [Space]v   :<C-u>VimFiler -find<CR>
  nnoremap    [Space]ff   :<C-u>VimFilerExplorer<CR>

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:vimfiler_enable_clipboard = 0
    let g:vimfiler_safe_mode_by_default = 0

    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_detect_drives = IsWindows() ? [
          \ 'C:/', 'D:/', 'E:/', 'F:/', 'G:/', 'H:/', 'I:/',
          \ 'J:/', 'K:/', 'L:/', 'M:/', 'N:/'] :
          \ split(glob('/mnt/*'), '\n') + split(glob('/media/*'), '\n') +
          \ split(glob('/Users/*'), '\n')

    " %p : full path
    " %d : current directory
    " %f : filename
    " %F : filename removed extensions
    " %* : filenames
    " %# : filenames fullpath
    let g:vimfiler_sendto = {
          \ 'unzip' : 'unzip %f',
          \ 'zip' : 'zip -r %F.zip %*',
          \ 'Inkscape' : 'inkspace',
          \ 'GIMP' : 'gimp %*',
          \ 'gedit' : 'gedit',
          \ }

    if IsWindows()
      " Use trashbox.
      let g:unite_kind_file_use_trashbox = 1
    else
      " Like Textmate icons.
      let g:vimfiler_tree_leaf_icon = ' '
      let g:vimfiler_tree_opened_icon = '▾'
      let g:vimfiler_tree_closed_icon = '▸'
      let g:vimfiler_file_icon = ' '
      let g:vimfiler_readonly_file_icon = '✗'
      let g:vimfiler_marked_file_icon = '✓'
    endif
    " let g:vimfiler_readonly_file_icon = '[O]'

    let g:vimfiler_quick_look_command =
          \ IsWindows() ? 'maComfort.exe -ql' :
          \ IsMac() ? 'qlmanage -p' : 'gloobus-preview'

    autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
    function! s:vimfiler_my_settings() "{{{
      call vimfiler#set_execute_file('vim', ['vim', 'notepad'])
      call vimfiler#set_execute_file('txt', 'vim')

      " Overwrite settings.
      nnoremap <silent><buffer> J
            \ <C-u>:Unite -buffer-name=files -default-action=lcd directory_mru<CR>
      " Call sendto.
      " nnoremap <buffer> - <C-u>:Unite sendto<CR>
      " setlocal cursorline

      nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
      nnoremap <silent><buffer><expr> gy vimfiler#do_action('tabopen')
      nmap <buffer> p <Plug>(vimfiler_quick_look)
      nmap <buffer> <Tab> <Plug>(vimfiler_switch_to_other_window)

      " Migemo search.
      if !empty(unite#get_filters('matcher_migemo'))
        nnoremap <silent><buffer><expr> /  line('$') > 10000 ?  'g/' :
              \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>"
      endif

      " One key file operation.
      " nmap <buffer> c <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_copy_file)
      " nmap <buffer> m <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_move_file)
      " nmap <buffer> d <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_delete_file)
    endfunction"}}}
  endfunction

  call neobundle#untap()
endif "}}}

" eskk.vim"{{{
imap <C-j>     <Plug>(eskk:toggle)

let bundle = neobundle#get('eskk.vim')
function! bundle.hooks.on_source(bundle)
  let g:eskk#directory = expand('~/.cache/eskk')

  let g:eskk#large_dictionary = {
        \   'path': expand('~/.cache/SKK-JISYO.L'),
        \   'sorted': 1,
        \   'encoding': 'euc-jp',
        \}
  " Disable skk.vim
  let g:plugin_skk_disable = 1

  let g:eskk#debug = 0

  " Don't keep state.
  let g:eskk#keep_state = 0

  let g:eskk#show_annotation = 1
  let g:eskk#rom_input_style = 'msime'
  let g:eskk#egg_like_newline = 1
  let g:eskk#egg_like_newline_completion = 1

  " Disable mapping.
  "let g:eskk#map_normal_keys = 0

  " Toggle debug.
  nnoremap <silent> [Space]ed  :<C-u>call ToggleVariable('g:eskk#debug')<CR>

  autocmd MyAutoCmd User eskk-initialize-post
        \ EskkMap -remap jj <Plug>(eskk:disable)<Esc>

  let g:eskk#dictionary = {
  \   'path': expand('~/.cache/skk-jisyo'),
  \   'sorted': 0,
  \   'encoding': 'utf-8',
  \}
  " Use /bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"
  " instead of this settings.
  "if &encoding == 'utf-8' && !has('gui_running')
  " GNOME Terminal only.

  " Use <> instead of ▽.
  "let g:eskk#marker_henkan = '<>'
  " Use >> instead of ▼.
  "let g:eskk#marker_henkan_select = '>>'
  "endif

  " Define table.
  autocmd MyAutoCmd User eskk-initialize-pre call s:eskk_initial_pre()
  function! s:eskk_initial_pre() "{{{
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    call t.add_map('z ', '　')
    call t.add_map('~', '〜')
    call t.add_map('zc', '©')
    call t.add_map('zr', '®')
    call t.add_map('z9', '（')
    call t.add_map('z0', '）')
    call eskk#register_mode_table('hira', t)
    unlet t
  endfunction "}}}
endfunction

unlet bundle
"}}}

" j6uil.vim"{{{
let bundle = neobundle#get('J6uil.vim')
function! bundle.hooks.on_source(bundle)
  let g:J6uil_config_dir = expand('~/.cache/J6uil')
  let g:J6uil_no_default_keymappings = 1
  let g:J6uil_display_offline  = 0
  let g:J6uil_display_online   = 0
  let g:J6uil_echo_presence    = 1
  let g:J6uil_display_icon     = 1
  let g:J6uil_display_interval = 0
  let g:J6uil_updatetime       = 1000
  let g:J6uil_align_message    = 0

  silent! delcommand NeoComplCacheCachingBuffer

  autocmd MyAutoCmd FileType J6uil call s:j6uil_settings()
  autocmd MyAutoCmd FileType J6uil_say call s:j6uil_say_settings()

  function! s:j6uil_settings()
    setlocal wrap
    setlocal nofoldenable
    setlocal foldcolumn=0
    nmap <buffer> o <Plug>(J6uil_open_say_buffer)
    nmap <silent> <buffer> <CR> <Plug>(J6uil_action_enter)
    call neocomplete#initialize()
    NeoCompleteBufferMakeCache
  endfunction

  function! s:j6uil_say_settings()
    setlocal wrap
    setlocal nofoldenable
    setlocal foldcolumn=0
  endfunction
endfunction
"}}}

" surround.vim"{{{
nmap <silent>sa <Plug>(operator-surround-append)
nmap <silent>sd <Plug>(operator-surround-delete)
nmap <silent>sr <Plug>(operator-surround-replace)
"}}}

" qfreplace.vim
autocmd MyAutoCmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>

if neobundle#tap('open-browser.vim') "{{{
  nmap gs <Plug>(open-browser-wwwsearch)

  function! neobundle#tapped.hooks.on_source(bundle)
    nnoremap <Plug>(open-browser-wwwsearch)
          \ :<C-u>call <SID>www_search()<CR>
    function! s:www_search()
      let search_word = input('Please input search word: ')
      if search_word != ''
        execute 'OpenBrowserSearch' escape(search_word, '"')
      endif
    endfunction
  endfunction

  call neobundle#untap()
endif "}}}

" caw.vim"{{{
autocmd MyAutoCmd FileType * call s:init_caw()
function! s:init_caw()
  if !&l:modifiable
    silent! nunmap <buffer> gc
    silent! xunmap <buffer> gc
    silent! nunmap <buffer> gcc
    silent! xunmap <buffer> gcc

    return
  endif

  nmap <buffer> gc <Plug>(caw:prefix)
  xmap <buffer> gc <Plug>(caw:prefix)
  nmap <buffer> gcc <Plug>(caw:i:toggle)
  xmap <buffer> gcc <Plug>(caw:i:toggle)
endfunction
"}}}

" autodate.vim"{{{
let autodate_format = '%d %3m %Y'
let autodate_keyword_pre = 'Last \%(Change\|Modified\):'
"}}}

" Conque.vim"{{{
let g:ConqueTerm_EscKey = '<Esc>'
let g:ConqueTerm_PyVersion = 3
"}}}

" fontzoom.vim"{{{
nmap + <Plug>(fontzoom-larger)
nmap _ <Plug>(fontzoom-smaller)
"}}}

" Operator-replace.
nmap R <Plug>(operator-replace)
xmap R <Plug>(operator-replace)
xmap p <Plug>(operator-replace)

" Taglist.
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1

" restart.vim {{{
let g:restart_save_window_values = 0
nnoremap <silent> [Space]re  :<C-u>Restart<CR>
"}}}

if neobundle#tap('accelerated-jk') "{{{
  nmap <silent>j <Plug>(accelerated_jk_gj)
  nmap gj j
  nmap <silent>k <Plug>(accelerated_jk_gk)
  nmap gk k

  call neobundle#untap()
endif "}}}

" switch.vim{{{
" http://www.vimninjas.com/2012/09/12/switch/
let g:variable_style_switch_definitions = [
\   {
\     'f': {
\       'foo': 'bar'
\     },
\
\     'b': {
\       'bar': 'foo'
\     },
\   }
\ ]
" nnoremap <silent> + :call switch#Switch(g:variable_style_switch_definitions)<CR>
nnoremap <silent> ! :Switch<cr>
"}}}

" vim-niceblock
" Improved visual selection.
xmap I  <Plug>(niceblock-I)
xmap A  <Plug>(niceblock-A)

" winmove.vim"{{{
nmap <Up>      <Plug>(winmove-up)
nmap <Down>    <Plug>(winmove-down)
nmap <Left>    <Plug>(winmove-left)
nmap <Right>   <Plug>(winmove-right)
"}}}

if neobundle#tap('vim-smalls')
  nmap S <Plug>(smalls)

  call neobundle#untap()
endif

if neobundle#tap('concealedyank.vim')
  xmap Y <Plug>(operator-concealedyank)
endif

if neobundle#tap('vim-vcs')
  nnoremap <silent> [Space]gs  :<C-u>Vcs status<CR>
  nnoremap <silent> [Space]gc  :<C-u>Vcs commit<CR>

  call neobundle#untap()
endif

if neobundle#tap('vim-choosewin')
  nmap <C-w>  <Plug>(choosewin)
  let g:choosewin_overlay_enable = 1
  let g:choosewin_overlay_clear_multibyte = 1
  let g:choosewin_blink_on_land = 0
endif
