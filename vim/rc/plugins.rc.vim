"---------------------------------------------------------------------------
" Plugin:
"

" changelog.vim"{{{
autocmd MyAutoCmd BufNewFile,BufRead *.changelog setf changelog
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "Shougo "
"}}}

" python.vim
let python_highlight_all = 1

" netrw.vim"{{{
let g:netrw_list_hide= '*.swp'
" Change default directory.
SetFixer set browsedir=current
"}}}

if dein#tap('deoplete.nvim') && has('nvim') "{{{
  let g:deoplete#enable_at_startup = 1
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/deoplete.rc.vim'
endif "}}}

if dein#tap('neocomplete.vim') && has('lua') "{{{
  let g:neocomplete#enable_at_startup = 1
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/neocomplete.rc.vim'
endif "}}}

if dein#tap('neosnippet.vim') "{{{
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/neosnippet.rc.vim'
endif "}}}

if dein#tap('echodoc.vim') "{{{
  let g:echodoc_enable_at_startup = 1
endif "}}}

if dein#tap('vimshell.vim') "{{{
  nmap [Space]s  <Plug>(vimshell_switch)
  nnoremap !  q:VimShellExecute<Space>

  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/vimshell.rc.vim'
endif "}}}

if dein#tap('vinarise.vim') "{{{
  let g:vinarise_enable_auto_detect = 1
endif "}}}

if dein#tap('unite.vim') "{{{
  " The prefix key.
  nnoremap    [unite]   <Nop>
  xnoremap    [unite]   <Nop>
  nmap    ;u [unite]
  xmap    ;u [unite]

  nnoremap <silent> ;b
        \ :<C-u>Unite -buffer-name=build`tabpagenr()` -no-quit build<CR>
  nnoremap <silent> ;t
        \ :<C-u>Unite -buffer-name=test`tabpagenr()` -no-quit build::test<CR>
  nnoremap <silent> ;o
        \ :<C-u>Unite outline -no-start-insert -resume<CR>
  nnoremap <silent> ;t
        \ :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
  xnoremap <silent> ;r
        \ d:<C-u>Unite -buffer-name=register
        \ -default-action=append register history/yank<CR>
  nnoremap <silent> <C-k>
        \ :<C-u>Unite change jump<CR>
  nnoremap <silent> ;g
        \ :<C-u>Unite grep -buffer-name=grep`tabpagenr()`
        \ -auto-preview -no-split -no-empty -resume<CR>
  nnoremap <silent> ;r
        \ :<C-u>Unite -buffer-name=register
        \ -default-action=append register history/yank<CR>
  nnoremap <silent> ;;
        \ :<C-u>Unite -start-insert command history/command<CR>

  " <C-t>: Tab pages
  nnoremap <silent> <C-t>
        \ :<C-u>Unite -auto-resize -select=`tabpagenr()-1` tab<CR>

  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
        \ jump_point file_point file_mru
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : ''`
        \ buffer_tab:- file file/new<CR>

  nnoremap <silent> [Window]r
        \ :<C-u>Unite -start-insert ref/`ref#detect()`<CR>
  nnoremap <silent> [Window]<Space>
        \ :<C-u>Unite -buffer-name=files -path=~/.vim/rc file_rec<CR>
  nnoremap <silent> [Window]n
        \ :<C-u>Unite -start-insert -default-action=lcd dein<CR>
  nnoremap <silent> [Window]g
        \ :<C-u>Unite -start-insert ghq<CR>
  nnoremap <silent> [Window]t
        \ :<C-u>Unite -start-insert tig<CR>

  nnoremap <silent> [Window]f
        \ :<C-u>Unite <CR>

  nnoremap <silent> <C-w>
        \ :<C-u>Unite -force-immediately window:all:no-current<CR>
  nnoremap <silent> [Space]b
        \ :<C-u>UniteBookmarkAdd<CR>

  " t: tags-and-searches "{{{
  " The prefix key.
  nnoremap    [Tag]   <Nop>
  nmap    t [Tag]
  " Jump.
  " nnoremap [Tag]t  g<C-]>
  nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "g\<C-]>" :
        \ ":\<C-u>UniteWithCursorWord -buffer-name=tag -immediately
        \  tag tag/include\<CR>"
  nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
        \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
  "}}}

  " Execute help.
  nnoremap <silent> <C-h>  :<C-u>Unite -buffer-name=help help<CR>

  " Execute help by cursor keyword.
  nnoremap <silent> g<C-h>  :<C-u>UniteWithCursorWord help<CR>

  " Search.
  nnoremap <silent> /
        \ :<C-u>Unite -buffer-name=search%`bufnr('%')`
        \ -start-insert line:forward:wrap<CR>
  nnoremap <silent> ?
        \ :<C-u>Unite -buffer-name=search%`bufnr('%')`
        \ -start-insert line:backward<CR>
  nnoremap <silent> *
        \ :<C-u>UniteWithCursorWord -buffer-name=search%`bufnr('%')`
        \ line:forward:wrap<CR>
  nnoremap [Alt]/       /
  nnoremap [Alt]?       ?

  nnoremap <silent> n
        \ :<C-u>UniteResume search%`bufnr('%')`
        \  -no-start-insert -force-redraw<CR>

  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/unite.rc.vim'
endif "}}}

if dein#tap('vim-smartchr') "{{{
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/smartchr.rc.vim'
endif "}}}

if dein#tap('vim-quickrun') "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endif "}}}

if dein#tap('vim-ref') "{{{
  function! s:ref_on_source() abort
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
    function! s:ref_my_settings() abort "{{{
      " Overwrite settings.
      nmap <buffer> [Tag]t  <Plug>(ref-keyword)
      nmap <buffer> [Tag]p  <Plug>(ref-back)
    endfunction"}}}
  endfunction

  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:ref_on_source()'
endif"}}}

if dein#tap('vimfiler.vim') "{{{
  nnoremap <silent>   [Space]v   :<C-u>VimFiler -invisible<CR>

  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/vimfiler.rc.vim'
endif "}}}

if dein#tap('eskk.vim') "{{{
  imap <C-j>     <Plug>(eskk:toggle)
  cmap <C-j>     <Plug>(eskk:toggle)

  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/eskk.rc.vim'
endif "}}}

if dein#tap('J6uil.vim') "{{{
  function! s:J6uil_on_source() abort
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

    function! s:j6uil_settings() abort
      setlocal wrap
      setlocal nofoldenable
      setlocal foldcolumn=0
      nmap <buffer> o <Plug>(J6uil_open_say_buffer)
      nmap <silent> <buffer> <CR> <Plug>(J6uil_action_enter)
    endfunction

    function! s:j6uil_say_settings() abort
      setlocal wrap
      setlocal nofoldenable
      setlocal foldcolumn=0
    endfunction
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:J6uil_on_source()'
endif "}}}

if dein#tap('vim-operator-surround') "{{{
  nmap <silent>sa <Plug>(operator-surround-append)a
  nmap <silent>sd <Plug>(operator-surround-delete)a
  nmap <silent>sr <Plug>(operator-surround-replace)a
  nmap <silent>sc <Plug>(operator-surround-replace)a
endif "}}}

if dein#tap('qfreplace.vim') "{{{
  autocmd MyAutoCmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>
endif "}}}

if dein#tap('open-browser.vim') "{{{
  nmap gs <Plug>(open-browser-wwwsearch)

  function! s:open_browser_on_source() abort
    nnoremap <Plug>(open-browser-wwwsearch)
          \ :<C-u>call <SID>www_search()<CR>
    function! s:www_search() abort
      let search_word = input('Please input search word: ')
      if search_word != ''
        execute 'OpenBrowserSearch' escape(search_word, '"')
      endif
    endfunction
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:open_browser_on_source()'
endif "}}}

if dein#tap('caw.vim') "{{{
  autocmd MyAutoCmd FileType * call s:init_caw()
  function! s:init_caw() abort
    if !&l:modifiable
      silent! nunmap <buffer> gc
      silent! xunmap <buffer> gc
      silent! nunmap <buffer> gcc
      silent! xunmap <buffer> gcc
    else
      nmap <buffer> gc <Plug>(caw:prefix)
      xmap <buffer> gc <Plug>(caw:prefix)
      nmap <buffer> gcc <Plug>(caw:i:toggle)
      xmap <buffer> gcc <Plug>(caw:i:toggle)
    endif
  endfunction
endif "}}}

if dein#tap('accelerated-jk') "{{{
  nmap <silent>j <Plug>(accelerated_jk_gj)
  nmap gj j
  nmap <silent>k <Plug>(accelerated_jk_gk)
  nmap gk k
endif "}}}

if dein#tap('concealedyank.vim') "{{{
  xmap Y <Plug>(operator-concealedyank)
endif "}}}

if dein#tap('vim-gita') "{{{
  nnoremap <silent> [Space]gs  :<C-u>Gita status<CR>
  nnoremap <silent> [Space]gc  :<C-u>Gita commit<CR>
  nnoremap <silent> [Space]ga  :<C-u>Gita commit --amend<CR>
  nnoremap <silent> [Space]gd  :<C-u>Gita diff<CR>
  nnoremap <silent> [Space]gb  :<C-u>Gita browse<CR>
  nnoremap <silent> [Space]gl  :<C-u>Gita blame<CR>

  let gita#features#commit#enable_default_mappings = 0
endif "}}}

if dein#tap('vim-choosewin') "{{{
  nmap g<C-w>  <Plug>(choosewin)
  let g:choosewin_overlay_enable = 1
  let g:choosewin_overlay_clear_multibyte = 1
  let g:choosewin_blink_on_land = 0
endif "}}}

if dein#tap('matchit.zip') "{{{
  function! s:matchit_on_post_source() abort "{{{
    " https://gist.github.com/k-takata/3d8e909a1a4955de7572

    " Load matchit.vim
    runtime macros/matchit.vim

    function! s:set_match_words() abort
      " Enable these pairs for all file types
      let words = ['(:)', '{:}', '[:]', '（:）', '「:」']
      if exists('b:match_words')
        for w in words
          if b:match_words !~ '\V' . w
            let b:match_words .= ',' . w
          endif
        endfor
      else
        let b:match_words = join(words, ',')
      endif
    endfunction
    augroup matchit-setting
      autocmd!
      autocmd BufEnter * call s:set_match_words()
    augroup END

    silent! execute 'doautocmd Filetype' &filetype
  endfunction"}}}
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:matchit_on_post_source()'
endif "}}}

if dein#tap('vim-fontzoom') "{{{
  nmap + <Plug>(fontzoom-larger)
  nmap _ <Plug>(fontzoom-smaller)
endif "}}}

if dein#tap('vim-operator-replace') "{{{
  xmap p <Plug>(operator-replace)
endif "}}}

if dein#tap('restart.vim') "{{{
  nnoremap <silent> [Space]re  :<C-u>Restart<CR>
endif "}}}

if dein#tap('vim-niceblock') "{{{
  xmap I  <Plug>(niceblock-I)
  xmap A  <Plug>(niceblock-A)
endif "}}}

if dein#tap('winmove.vim') "{{{
  nmap <Up>      <Plug>(winmove-up)
  nmap <Down>    <Plug>(winmove-down)
  nmap <Left>    <Plug>(winmove-left)
  nmap <Right>   <Plug>(winmove-right)
endif "}}}

if dein#tap('vim-fullscreen') "{{{
  nmap <C-CR> <Plug>(fullscreen-toggle)
endif "}}}

if dein#tap('vim-textobj-user') "{{{
  omap ab <Plug>(textobj-multiblock-a)
  omap ib <Plug>(textobj-multiblock-i)
  xmap ab <Plug>(textobj-multiblock-a)
  xmap ib <Plug>(textobj-multiblock-i)
endif "}}}

if dein#tap('glowshi-ft.vim') "{{{
  let g:glowshi_ft_no_default_key_mappings = 1
  map f <Plug>(glowshi-ft-f)
  map F <Plug>(glowshi-ft-F)

  let g:glowshi_ft_timeoutlen = 1000
endif "}}}

if dein#tap('junkfile.vim') "{{{
  nnoremap <silent> [Window]e
        \ :<C-u>Unite junkfile/new junkfile -start-insert<CR>
endif "}}}

if dein#tap('vim-jplus') "{{{
  nmap J <Plug>(jplus)
  vmap J <Plug>(jplus)
endif "}}}

if dein#tap('indentLine') "{{{
  let g:indentLine_faster = 1
  nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
endif "}}}

if dein#tap('vim-themis') "{{{
  " Set to $PATH.
  let s:bin = dein#get('vim-themis').rtp . '/bin'

  function! s:split_envpath(path) abort "{{{
    let delimiter = has('win32') ? ';' : ':'
    if stridx(a:path, '\' . delimiter) < 0
      return split(a:path, delimiter)
    endif

    let split = split(a:path, '\\\@<!\%(\\\\\)*\zs' . delimiter)
    return map(split,'substitute(v:val, ''\\\([\\'
          \ . delimiter . ']\)'', "\\1", "g")')
  endfunction"}}}

  function! s:join_envpath(list, orig_path, add_path) abort "{{{
    let delimiter = has('win32') ? ';' : ':'
    return (stridx(a:orig_path, '\' . delimiter) < 0
          \ && stridx(a:add_path, delimiter) < 0) ?
          \   join(a:list, delimiter) :
          \   join(map(copy(a:list), 's:escape(v:val)'), delimiter)
  endfunction"}}}

  " Escape a path for runtimepath.
  function! s:escape(path) abort "{{{
    return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
  endfunction"}}}

  let $PATH = s:join_envpath(
        \ dein#_uniq(insert(
        \    s:split_envpath($PATH), s:bin)), $PATH, s:bin)
  let $THEMIS_HOME = dein#get('vim-themis').rtp
  " let $THEMIS_VIM = printf('%s/%s',
  "       \ fnamemodify(exepath(v:progpath), ':h'),
  "       \ (has('nvim') ? 'nvim' : 'vim'))

  unlet s:bin
endif "}}}

if dein#tap('vim-gista') "{{{
  let g:gista#github_user = 'Shougo'
  let g:gista#directory = expand('$CACHE/gista')
endif "}}}

if dein#tap('jedi-vim') "{{{
  autocmd MyAutoCmd FileType python
        \ if has('python') || has('python3') |
        \   setlocal omnifunc=jedi#completions |
        \ else |
        \   setlocal omnifunc= |
        \ endif
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#smart_auto_mappings = 0
  let g:jedi#show_call_signatures = 0
endif "}}}

if dein#tap('vim-expand-region') "{{{
  xmap v <Plug>(expand_region_expand)
  xmap <C-v> <Plug>(expand_region_shrink)
endif "}}}

if dein#tap('vim-racer') "{{{
  let g:racer_cmd = expand('~/.cache/dein/racer/target/release/racer')
  let $RUST_SRC_PATH = expand('~/src/rust/src')
  let g:racer_experimental_completer = 1
endif "}}}

if dein#tap('vim-javacomplete2') "{{{
  autocmd MyAutoCmd FileType java setlocal omnifunc=javacomplete#Complete
endif "}}}

if dein#tap('sideways.vim') "{{{
  nnoremap <silent> " :SidewaysJumpLeft<CR>
  nnoremap <silent> ' :SidewaysJumpRight<CR>
  omap a, <Plug>SidewaysArgumentTextobjA
  xmap a, <Plug>SidewaysArgumentTextobjA
  omap i, <Plug>SidewaysArgumentTextobjI
  xmap i, <Plug>SidewaysArgumentTextobjI
endif "}}}

if dein#tap('vim-findent') "{{{
  augroup findent
    autocmd!
    autocmd BufRead * Findent! --no-warnings
  augroup END
endif "}}}

if dein#tap('neopairs.vim') "{{{
  let g:neopairs#enable = 0
endif "}}}

if dein#tap('FastFold') "{{{
  " Folding

  let g:tex_fold_enabled = 1

  " Vim script
  " augroup: a
  " function: f
  " lua: l
  " perl: p
  " ruby: r
  " python: P
  " tcl: t
  " mzscheme: m
  let g:vimsyn_folding = 'af'

  let g:xml_syntax_folding = 1
  let g:php_folding = 1
  let g:perl_fold = 1
endif "}}}

if dein#tap('vim-lua-ftplugin') "{{{
  let g:lua_define_completion_mappings = 0
  let g:lua_check_syntax = 0
  let g:lua_complete_omni = 1
  let g:lua_complete_dynamic = 0
endif "}}}

if dein#tap('vim-operator-flashy') "{{{
  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$
endif"}}}

if dein#tap('vim-easymotion') "{{{
  nmap w <Plug>(easymotion-lineforward)
  nnoremap W     w
  nmap b <Plug>(easymotion-linebackward)
  nnoremap B     b
  nmap [Alt]j <Plug>(easymotion-j)
  nmap [Alt]k <Plug>(easymotion-k)
  nmap ' <Plug>(easymotion-prefix)

  let g:EasyMotion_startofline = 0
  let g:EasyMotion_show_prompt = 0
  let g:EasyMotion_verbose = 0
endif"}}}

if dein#tap('vim-vimhelplint') "{{{
  autocmd MyAutoCmd FileType help  nnoremap <silent><buffer> ,r  :<C-u>VimhelpLint!<CR>
endif"}}}

if dein#tap('w3m.vim') "{{{
  nnoremap W     :<C-u>W3m<Space><C-r>+
endif"}}}
