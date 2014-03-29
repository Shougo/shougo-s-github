"---------------------------------------------------------------------------
" Plugin:
"

if neobundle#tap('neocomplete.vim') "{{{
  let g:neocomplete#enable_at_startup = 1
  let neobundle#tapped.hooks.on_source =
        \ '~/.vim/rc/plugins/neocomplete.rc.vim'

  call neobundle#untap()
endif "}}}

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

if neobundle#tap('neocomplcache.vim') "{{{
  let g:neocomplcache_enable_at_startup = 0
  let neobundle#tapped.hooks.on_source =
        \ '~/.vim/rc/plugins/neocomplcache.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet.vim') "{{{
  let neobundle#tapped.hooks.on_source =
        \ '~/.vim/rc/plugins/neosnippet.rc.vim'

  call neobundle#untap()
endif "}}}

" echodoc.vim"{{{
let bundle = neobundle#get('echodoc.vim')
function! bundle.hooks.on_source(bundle)
  let g:echodoc_enable_at_startup = 1
endfunction
unlet bundle
"}}}

if neobundle#tap('vimshell.vim') "{{{
  " <C-Space>: switch to vimshell.
  nmap <C-@>  <Plug>(vimshell_switch)
  nnoremap !  q:VimShellExecute<Space>
  nnoremap [Space]i  q:VimShellInteractive<Space>
  nnoremap [Space]t  q:VimShellTerminal<Space>

  let neobundle#tapped.hooks.on_source =
        \ '~/.vim/rc/plugins/vimshell.rc.vim'

  call neobundle#untap()
endif "}}}

" netrw.vim"{{{
let g:netrw_list_hide= '*.swp'
" Change default directory.
set browsedir=current
"}}}

" vinarise.vim"{{{
let g:vinarise_enable_auto_detect = 1
"}}}

if neobundle#tap('unite.vim') "{{{
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

  nnoremap <expr><silent> [Window]r  ":\<C-u>Unite -start-insert ref/".ref#detect()."\<CR>"
  nnoremap <silent> [Window]<Space>  :<C-u>Unite -buffer-name=files file_rec:~/.vim/rc<CR>
  nnoremap <silent> [Window]n  :<C-u>Unite -default-action=lcd neobundle:!<CR>

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

  let neobundle#tapped.hooks.on_source =
        \ '~/.vim/rc/plugins/unite.rc.vim'

  call neobundle#untap()
endif "}}}

" camlcasemotion.vim"{{{
nmap <silent> W <Plug>CamelCaseMotion_w
xmap <silent> W <Plug>CamelCaseMotion_w
omap <silent> W <Plug>CamelCaseMotion_w
nmap <silent> B <Plug>CamelCaseMotion_b
xmap <silent> B <Plug>CamelCaseMotion_b
omap <silent> B <Plug>CamelCaseMotion_b
""}}}

if neobundle#tap('vim-smartchr') "{{{
  let g:neocomplete#enable_at_startup = 1
  let neobundle#tapped.hooks.on_source =
        \ '~/.vim/rc/plugins/smartchr.rc.vim'

  call neobundle#untap()
endif "}}}

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
  let g:ref_cache_dir = expand('$CACHE/ref')
  let g:ref_use_vimproc = 1
  if IsWindows()
    let g:ref_refe_encoding = 'cp932'
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

if neobundle#tap('vimfiler.vim') "{{{
  "nmap    [Space]v   <Plug>(vimfiler_switch)
  nnoremap <silent>   [Space]v   :<C-u>VimFiler -find<CR>
  nnoremap    [Space]ff   :<C-u>VimFilerExplorer<CR>

  let neobundle#tapped.hooks.on_source =
        \ '~/.vim/rc/plugins/vimfiler.rc.vim'

  call neobundle#untap()
endif "}}}

" eskk.vim"{{{
imap <C-j>     <Plug>(eskk:toggle)

let bundle = neobundle#get('eskk.vim')
function! bundle.hooks.on_source(bundle)
  let g:eskk#directory = expand('$CACHE/eskk')

  let g:eskk#large_dictionary = {
        \   'path': expand('$CACHE/SKK-JISYO.L'),
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
  \   'path': expand('$CACHE/skk-jisyo'),
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
  let g:J6uil_config_dir = expand('$CACHE/J6uil')
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

" wildfire
nmap <Enter>      <Plug>(wildfire-fuel)
vmap <Enter>      <Plug>(wildfire-fuel)
vmap <S-Enter>    <Plug>(wildfire-water)

if !exists('g:wildfire_objects')
  let g:wildfire_objects = [
        \ 'i''', 'i"', 'i)', 'a)', 'i]', 'a]',
        \ 'i}', 'a}', 'i>', 'a>', 'ip', 'it',
        \ 'at'
        \]
endif

