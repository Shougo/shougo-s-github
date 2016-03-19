"---------------------------------------------------------------------------
" Plugin:
"

if dein#tap('deoplete.nvim') && has('nvim') "{{{
  let g:loaded_neocomplete = 1
  let g:deoplete#enable_at_startup = 1
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/deoplete.rc.vim'
endif "}}}

if dein#tap('neocomplete.vim') && has('lua') "{{{
  let g:loaded_deoplete = 1
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
  nnoremap <silent> ;b
        \ :<C-u>Unite -buffer-name=build`tabpagenr()` -no-quit build<CR>
  nnoremap <silent> ;o
        \ :<C-u>Unite outline -no-start-insert -resume<CR>
  nnoremap <silent> ;t
        \ :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
  nnoremap <silent> <C-k>
        \ :<C-u>Unite change jump<CR>
  nnoremap <silent> ;g
        \ :<C-u>Unite grep -buffer-name=grep`tabpagenr()`
        \ -auto-preview -no-split -no-empty -resume<CR>
  nnoremap <silent> ;r
        \ :<C-u>Unite -buffer-name=register
        \ -default-action=append register history/yank<CR>
  xnoremap <silent> ;r
        \ d:<C-u>Unite -buffer-name=register
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

  nnoremap <silent> [Window]<Space>
        \ :<C-u>Unite -buffer-name=files -path=~/.vim/rc file_rec<CR>
  nnoremap <silent> [Window]n
        \ :<C-u>Unite -start-insert -default-action=lcd dein<CR>
  nnoremap <silent> [Window]g
        \ :<C-u>Unite -start-insert ghq<CR>

  nnoremap <silent> <C-w>
        \ :<C-u>Unite -force-immediately window:all:no-current<CR>

  " Easily syntax change.
  nnoremap <silent> [Space]ft
        \ :<C-u>Unite -start-insert filetype filetype/new<CR>

  " t: tags-and-searches "{{{
  " The prefix key.
  nnoremap    [Tag]   <Nop>
  nmap    t [Tag]
  " Jump.
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
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/ref.rc.vim'
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
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/J6uil.rc.vim'
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

if dein#tap('vim-fontzoom') "{{{
  nmap + <Plug>(fontzoom-larger)
  nmap _ <Plug>(fontzoom-smaller)
endif "}}}

if dein#tap('vim-operator-replace') "{{{
  xmap p <Plug>(operator-replace)
endif "}}}

if dein#tap('vim-niceblock') "{{{
  xmap I  <Plug>(niceblock-I)
  xmap A  <Plug>(niceblock-A)
endif "}}}

if dein#tap('vim-fullscreen') "{{{
  nmap <C-CR> <Plug>(fullscreen-toggle)
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

if dein#tap('vim-racer') "{{{
  let $RUST_SRC_PATH = expand('~/src/rust/src')
  let g:racer_experimental_completer = 1
endif "}}}

if dein#tap('vim-javacomplete2') "{{{
  autocmd MyAutoCmd FileType java setlocal omnifunc=javacomplete#Complete
endif "}}}

if dein#tap('vim-findent') "{{{
  " Note: It is too slow.
  " autocmd MyAutoCmd BufRead * Findent! --no-warnings
  nnoremap <silent> [Space]i    :<C-u>Findent! --no-warnings<CR>
endif "}}}

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

if dein#tap('csapprox') "{{{
  " Convert colorscheme in Konsole.
  let g:CSApprox_konsole = 1
  let g:CSApprox_attr_map = {
        \ 'bold' : 'bold',
        \ 'italic' : '', 'sp' : ''
        \ }
endif"}}}

if dein#tap('vim-ft-help_fold') "{{{
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'FastFoldUpdate'
endif"}}}
