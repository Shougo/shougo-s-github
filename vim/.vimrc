"---------------------------------------------------------------------------
" Shougo's .vimrc
"---------------------------------------------------------------------------
" Initialize:"{{{
"

let s:iswin = has('win32') || has('win64')

" Use English interface.
if s:iswin
  " For Windows.
  language message en
else
  " For Linux.
  language mes C
endif

" Use ',' instead of '\'.
" It is not mapped with respect well unless I set it before setting for plug in.
let mapleader = ','
" Use <Leader> in global plugin.
let g:mapleader = ','
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = 'm'

" Release keymappings for plug-in.
nnoremap ;  <Nop>
xnoremap ;  <Nop>
nnoremap m  <Nop>
xnoremap m  <Nop>
nnoremap ,  <Nop>
xnoremap ,  <Nop>

if s:iswin
  " Exchange path separator.
  set shellslash
endif

" In Windows/Linux, take in a difference of ".vim" and "$VIM/vimfiles".
if s:iswin
  let $DOTVIM = expand('~/.vim')
else
  let $DOTVIM = $HOME."/.vim"
endif

" Because a value is not set in $MYGVIMRC with the console, set it.
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand('~/.gvimrc')
endif

if s:iswin
  let &runtimepath = join([expand('~/.vim'), expand('$VIM/runtime'), expand('~/.vim/after')], ',')
endif

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:set_default(var, val)
  if !exists(a:var) || type({a:var}) != type(a:val)
    let {a:var} = a:val
  endif
endfunction

filetype plugin on
filetype indent on

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

if filereadable(expand('~/.secret_vimrc'))
  execute 'source' expand('~/.secret_vimrc')
endif

" Load settings for each location."{{{
augroup vimrc-local
  autocmd!
  autocmd VimEnter * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('vimrc_local.vim', escape(a:loc, ' '), -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

if has('vim_starting')
  call s:vimrc_local(getcwd())
endif

" Load bundles.
call pathogen#runtime_append_all_bundles()
"}}}

"}}}

"---------------------------------------------------------------------------
" Encoding:"{{{
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
set encoding=utf-8

" Setting of terminal encoding."{{{
if !has('gui_running')
  if &term == 'win32' || &term == 'win64'
    " Setting when use the non-GUI Japanese console.

    " Garbled unless set this.
    set termencoding=cp932
    " Japanese input changes itself unless set this.
    " Be careful because the automatic recognition of the character code is not possible!
    set encoding=japan
  else
    if $ENV_ACCESS ==# 'linux'
      set termencoding=euc-jp
    elseif $ENV_ACCESS ==# 'colinux'
      set termencoding=utf-8
    else  " fallback
      set termencoding=  " same as 'encoding'
    endif
  endif
elseif s:iswin
  " For system.
  set termencoding=cp932
endif
"}}}

" The automatic recognition of the character code."{{{
if !exists('did_encoding_settings') && has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " Does iconv support JIS X 0213?
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " Build encodings.
  let &fileencodings = 'ucs-bom'
  if &encoding !=# 'utf-8'
    let &fileencodings = &fileencodings . ',' . 'ucs-2le'
    let &fileencodings = &fileencodings . ',' . 'ucs-2'
  endif
  let &fileencodings = &fileencodings . ',' . s:enc_jis

  if &encoding ==# 'utf-8'
    let &fileencodings = &fileencodings . ',' . s:enc_euc
    let &fileencodings = &fileencodings . ',' . 'cp932'
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    let &fileencodings = &fileencodings . ',' . 'utf-8'
    let &fileencodings = &fileencodings . ',' . 'cp932'
  else  " cp932
    let &fileencodings = &fileencodings . ',' . 'utf-8'
    let &fileencodings = &fileencodings . ',' . s:enc_euc
  endif
  let &fileencodings = &fileencodings . ',' . &encoding

  unlet s:enc_euc
  unlet s:enc_jis

  let did_encoding_settings = 1
endif
"}}}

if has('kaoriya')
  " For Kaoriya only.
  "set fileencodings=guess
endif

" When do not include Japanese, use encoding for fileencoding.
function! AU_ReCheck_FENC()
  if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
    let &fileencoding=&encoding
  endif
endfunction

autocmd MyAutoCmd BufReadPost * call AU_ReCheck_FENC()

" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
" A fullwidth character is displayed in vim properly.
set ambiwidth=double

" Command group opening with a specific character code again."{{{
" In particular effective when I am garbled in a terminal.
" Open in UTF-8 again.
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
" Open in iso-2022-jp again.
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
" Open in Shift_JIS again.
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
" Open in EUC-jp again.
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
" Open in UTF-16BE again.
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>

" Aliases.
command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
"}}}

" Tried to make a file note version."{{{
" Don't save it because dangerous.
command! WUtf8 setlocal fenc=utf-8
command! WIso2022jp setlocal fenc=iso-2022-jp
command! WCp932 setlocal fenc=cp932
command! WEuc setlocal fenc=euc-jp
command! WUtf16 setlocal fenc=ucs-2le
command! WUtf16be setlocal fenc=ucs-2
" Aliases.
command! WJis  WIso2022jp
command! WSjis  WCp932
command! WUnicode WUtf16
"}}}

" Handle it in nkf and open.
command! Nkf !nkf -g %

" Appoint a line feed."{{{
command! -bang -bar -complete=file -nargs=? Unix edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac edit<bang> ++fileformat=mac <args>
command! -bang -bar -complete=file -nargs=? Dos edit<bang> ++fileformat=dos <args>
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WMac write<bang> ++fileformat=mac <args> | edit <args>
command! -bang -complete=file -nargs=? WDos write<bang> ++fileformat=dos <args> | edit <args>
"}}}"}}}

"---------------------------------------------------------------------------
" Search:"{{{
"
" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase option.
set smartcase

" Enable incremental search.
set incsearch
" Don't highlight search result.
set nohlsearch

" Searches wrap around the end of the file.
set wrapscan
"}}}

"---------------------------------------------------------------------------
" Input Japanese:"{{{
"
if has('multi_byte_ime')
  " Settings of default ime condition.
  set iminsert=0 imsearch=0
  nnoremap / :<C-u>set imsearch=0<CR>/
  xnoremap / :<C-u>set imsearch=0<CR>/
  nnoremap ? :<C-u>set imsearch=0<CR>?
  xnoremap ? :<C-u>set imsearch=0<CR>?
endif
"}}}

"---------------------------------------------------------------------------
" Edit:"{{{
"
" Enable no Vi compatible commands.
set nocompatible

" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" ファイルの<Tab>が対応する空白の数
"set tabstop=8
" <Tab>の代わりに挿入する空白の数
"set softtabstop=4
" 自動インデントに使われる空白の数
"set shiftwidth=4
" インデントをshiftwidthの倍数に丸める
set shiftround

" Enable modeline.
set modeline

" Use clipboard register.
set clipboard& clipboard+=unnamed

" Disable auto wrap.
autocmd MyAutoCmd FileType * set textwidth=0

" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" 括弧入力時に対応する括弧を表示
set showmatch
" 移動キーを押しても括弧の強調を有効にする
set cpoptions-=m
set matchtime=3
" <>にもマッチするようにする
set matchpairs+=<:>

" 保存していなくても別のファイルを表示できるようにする
set hidden

" Auto reload if file is changed.
"set autoread

" Ignore case on insert completion.
set infercase

" Search home directory path on cd.
" But can't complete.
set cdpath+=~

" Enable folding.
set foldenable
set foldmethod=marker
" Show folding level.
set foldcolumn=3

" Use vimgrep.
set grepprg=internal

" = をファイル名の一部と認識しない
set isfname-==

" Reload .vimrc and .gvimrc automatically.
if !has('gui_running') && !s:iswin
  autocmd MyAutoCmd BufWritePost .vimrc nested source $MYVIMRC | echo "source $MYVIMRC"
else
  autocmd MyAutoCmd BufWritePost .vimrc source $MYVIMRC |
        \if has('gui_running') | source $MYGVIMRC | echo "source $MYVIMRC"
  autocmd MyAutoCmd BufWritePost .gvimrc if has('gui_running') | source $MYGVIMRC | echo "source $MYGVIMRC"
endif

" Keymapping timeout.
set timeout timeoutlen=1000 ttimeoutlen=50

" CursorHold time.
set updatetime=3000

" Set swap directory.
set directory-=.

" Set tags file.
" Don't search tags file in current directory. And search upward.
set tags& tags-=tags tags+=./tags;
set notagbsearch

" Enable virtualedit in visual block mode.
set virtualedit=block

" Set keyword help.
set keywordprg=:help

" Make a scratch buffer when unnamed buffer.
augroup vimrc-scratch-buffer"{{{
  autocmd!
  autocmd BufEnter * call s:scratch_buffer()
  autocmd FileType qfreplace autocmd! vimrc-scratch * <buffer>

  function! s:scratch_buffer()
    if exists('b:scratch_buffer') || bufname('%') != '' || &l:buftype != ''
      return
    endif
    let b:scratch_buffer = 1
    setlocal buftype=nofile nobuflisted noswapfile bufhidden=hide
    augroup vimrc-scratch
      autocmd! * <buffer>
      autocmd BufWriteCmd <buffer> call s:scratch_on_BufWriteCmd()
    augroup END
  endfunction
  function! s:scratch_on_BufWriteCmd()
    silent! setl buftype< buflisted< swapfile< bufhidden< nomodified
    autocmd! vimrc-scratch * <buffer>
    unlet! b:scratch_buffer
    execute 'saveas' . (v:cmdbang ? '!' : '') ' <afile>'
    filetype detect
  endfunction
augroup END"}}}
"}}}

"---------------------------------------------------------------------------
" View:"{{{
"
" Show line number.
"set number
" タブや改行を表示
set list
" どの文字でタブや改行を表示するかを設定
set listchars=tab:>-,extends:>,precedes:<
" Wrap long line.
set wrap
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
" Always display statusline.
set laststatus=2
" Height of command line.
set cmdheight=2
" Show command on statusline.
set showcmd
" Show title.
set title
" Title length.
set titlelen=95
" Title string.
set titlestring=%{expand('%:p:.')}%(\ %m%r%w%)\ %<\(%{SnipMid(getcwd(),80-len(expand('%:p:.')),'...')}\)\ -\ Vim

" Set tabline.
function! s:my_tabline()  "{{{
  let l:s = ''

  for l:i in range(1, tabpagenr('$'))
    let l:bufnrs = tabpagebuflist(i)
    let l:curbufnr = l:bufnrs[tabpagewinnr(l:i) - 1]  " first window, first appears

    let l:no = (l:i <= 10 ? l:i-1 : '#')  " display 0-origin tabpagenr.
    let l:mod = getbufvar(bufnr("%"), "&modified") ? '!' : ' '
    let l:title = gettabwinvar(l:i, tabpagewinnr(l:i), 'title')
    if l:title == ''
      let l:title = fnamemodify(gettabwinvar(l:i, tabpagewinnr(l:i), 'cwd'), ':t')
      if l:title == ''
        let l:title = fnamemodify(bufname(l:curbufnr),':t')
        if l:title == ''
          let l:title = '[No Name]'
        endif
      endif
    endif

    let l:s .= '%'.l:i.'T'
    let l:s .= '%#' . (l:i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let l:s .= l:no . ':' . l:title . l:mod
    let l:s .= '%#TabLineFill#  '
  endfor

  let l:s .= '%#TabLineFill#%T%=%#TabLine#|%999X %X'
  return l:s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2

" Set statusline.
set statusline=%{expand('%:p:.')}\ %<\(%{SnipMid(getcwd(),80-len(expand('%:p:.')),'...')}\)\ %=%m%y%{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}%{eskk#is_enabled()?eskk#get_stl():SkkGetModeStr()}\ %3p%%

" Turn down a long line appointed in 'breakat'
set linebreak
set showbreak=>\
set breakat=\ \	;:,!?

" Do not display greetings message at the time of Vim start.
set shortmess=aTI

" Don't create backup.
set nowritebackup
set nobackup

" Disable bell.
set visualbell
set vb t_vb=

" Display candidate supplement.
set nowildmenu
set wildmode=list:longest,full
" Increase history amount.
set history=200
" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
" Can supplement a tag in a command-line.
set wildoptions=tagfile

" Enable spell check.
set spelllang=en_us

" Completion setting.
set completeopt=menuone,preview
" Don't complete from other buffer.
set complete=.
"set complete=.,w,b,i,t
" Set popup menu max height.
set pumheight=20

" Report changes.
set report=0

" Maintain a current line at the time of movement as much as possible.
set nostartofline

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=60
" Set minimal height for current window.
set winheight=20
" Set maximam maximam command line window.
set cmdwinheight=5

" Adjust window size of preview and help.
set previewheight=3
set helpheight=12

" Don't redraw while macro executing.
set lazyredraw

" Enable menu in console.
if !has('gui_running')
  source $VIMRUNTIME/menu.vim
  set cpo-=<
  set wcm=<C-z>
  noremap <F2> :emenu <C-z>
endif

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
"set display+=uhex

" Disable automatically insert comment.
autocmd MyAutoCmd FileType * set formatoptions-=ro

"}}}

"---------------------------------------------------------------------------
" Syntax:"{{{
"
" Enable syntax color.
syntax enable

" Enable smart indent.
set autoindent smartindent

augroup MyAutoCmd"{{{
  " Enable gauche syntax.
  autocmd FileType scheme nested let b:is_gauche=1 | setlocal lispwords=define |
        \let b:current_syntax='' | syntax enable

  " Easily load VimScript.
  autocmd FileType vim nnoremap <silent><buffer> [Space]so :write \| source % \| echo "source " . bufname('%')<CR>

  " Auto reload VimScript.
  autocmd BufWritePost,FileWritePost *.vim if &autoread | source <afile> | echo "source " . bufname('%') | endif

  " Manage long Rakefile easily
  autocmd BufNewfile,BufRead Rakefile foldmethod=syntax foldnestmax=1

  " Close help and git window by pressing q.
  autocmd FileType help,git-status,git-log,qf,gitcommit,quickrun,qfreplace,ref nnoremap <buffer> q <C-w>c
  autocmd FileType * if &readonly |  nnoremap <buffer> q <C-w>c | endif 

  " Close help and git window by pressing q.
  autocmd FileType ref nnoremap <buffer> <TAB> <C-w>w

  " Enable omni completion."{{{
  autocmd FileType ada setlocal omnifunc=adacomplete#Complete
  autocmd FileType c setlocal omnifunc=ccomplete#Complete
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  "autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  "autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  "autocmd FileType * if &l:omnifunc == '' | setlocal omnifunc=syntaxcomplete#Complete | endif
  "}}}
augroup END
"}}}

" Java
let g:java_highlight_functions = 'style'
let g:java_highlight_all = 1
let g:java_allow_cpp_keywords = 1

" PHP
let g:php_folding = 1

" Python
let g:python_highlight_all = 1

" XML
let g:xml_syntax_folding = 1

" Vim
let g:vimsyntax_noerror = 1
"let g:vim_indent_cont = 0

"}}}"}}}

"---------------------------------------------------------------------------
" Plugin:"{{{
"

" yanktmp.vim"{{{
" Because I don't use it that much, I demote it to Sy.
nnoremap S    <Nop>
xnoremap S    <Nop>
nmap <silent> Sy    <Plug>(yanktmp_yank)
xmap <silent> Sy    <Plug>(yanktmp_yank)
nmap <silent> Sp    <Plug>(yanktmp_paste_p)
xmap <silent> Sp    <Plug>(yanktmp_paste_p)
nmap <silent> SP    <Plug>(yanktmp_paste_P)
xmap <silent> SP    <Plug>(yanktmp_paste_P)
"}}}

" neocomplcache.vim"{{{
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
" Set auto completion length.
let g:neocomplcache_auto_completion_start_length = 2
" Set manual completion length.
let g:neocomplcache_manual_completion_start_length = 0
" Set minimum keyword length.
let g:neocomplcache_min_keyword_length = 3
let g:neocomplcache_enable_cursor_hold_i = 1
let g:neocomplcache_cursor_hold_i_time = 250
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_lock_buffer_name_pattern = '\*neoui\*\|\[neoui\]'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions',
      \ 'scala' : $DOTVIM.'/dict/scala.dict',
      \ 'ruby' : $DOTVIM.'/dict/ruby.dict'
      \ }

let g:neocomplcache_omni_function_list = {
      \ 'python' : 'pythoncomplete#Complete',
      \ 'ruby' : 'rubycomplete#Complete',
      \ }

" Define keyword pattern.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

let g:neocomplcache_snippets_dir = $HOME.'/snippets'

if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

if !exists('g:neocomplcache_same_filetype_lists')
  let g:neocomplcache_same_filetype_lists = {}
endif
"let g:neocomplcache_same_filetype_lists.perl = 'ref'

if !exists('g:neocomplcache_vim_completefuncs')
  let g:neocomplcache_vim_completefuncs = {}
endif
let g:neocomplcache_vim_completefuncs.Ref = 'ref#complete'
let g:neocomplcache_vim_completefuncs.NeoUI = 'neoui#complete'

" Plugin key-mappings."{{{
imap <silent>L     <Plug>(neocomplcache_snippets_expand)
"imap <expr>L    neocomplcache#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-n>"
smap <silent>L     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
"imap <silent>J     <Plug>(neocomplcache_snippets_jump)
inoremap <expr><C-l>     neocomplcache#complete_common_string()
"}}}

" Test."{{{
"let g:neocomplcache_auto_completion_start_length = 1
"let g:neocomplcache_plugin_completion_length_list = {
"\ 'snippets_complete' : 1,
"\ 'buffer_complete' : 2,
"\ 'syntax_complete' : 2,
"\ 'tags_complete' : 3,
"\ 'vim_complete' : 4,
"\ }
"let g:neocomplcache_disable_plugin_list = {
"\'vim_complete' : 1
"\}"}}}

" For neocomplcache."{{{
" <C-f>, <C-b>: page move.
inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   :
      \neocomplcache#complfunc#completefunc_complete#call_completefunc('googlesuggest_complete#completefunc')
" <C-y>: paste.
inoremap <expr><C-y>  pumvisible() ? neocomplcache#close_popup() :  "\<C-r>\""
" <C-e>: close popup.
inoremap <expr><C-e>  pumvisible() ? neocomplcache#cancel_popup() : "\<End>"
" <C-k>: omni completion.
inoremap <expr> <C-k>  &filetype == 'vim' ? neocomplcache#start_manual_complete('vim_complete') : neocomplcache#manual_omni_complete()
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> pumvisible() ? neocomplcache#cancel_popup()."\<C-h>" : "\<C-h>"
inoremap <expr><BS> pumvisible() ? neocomplcache#cancel_popup()."\<C-h>" : "\<C-h>"
" <C-n>: neocomplcache.
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
" <C-p>: keyword completion.
inoremap <expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
inoremap <expr>'  pumvisible() ? neocomplcache#close_popup() : "'"
"inoremap <expr>;  pumvisible() ? "\<C-n>" : ";"
inoremap <expr>[  pumvisible() ? "\<Down>" : "["
inoremap <expr>]  pumvisible() ? "\<Up>" : "]"

" <CR>: close popup and save indent.
inoremap <expr><CR>  (pumvisible() ? "\<C-e>":'') . (&indentexpr != '' ? "\<C-f>\<CR>X\<BS>":"\<CR>")
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : "\<C-x>\<C-u>\<C-p>"
function! s:check_back_space()"{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
"}}}
"}}}

" NERD_comments.vim"{{{
let NERDSpaceDelims = 0
let NERDShutUp = 1
" Disable <C-c>.
nnoremap <C-c> <C-c>
nunmap <C-c>
"}}}

" vimshell.vim"{{{

"let g:vimshell_user_prompt = "3\ngetcwd()"
"let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
"let g:vimshell_user_prompt = 'printf("%s  %50s", fnamemodify(getcwd(), ":~"), vimshell#vcs#info("(%s)-[%b]"))'
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
let g:vimshell_enable_smart_case = 1
let g:vimshell_ignore_case = 0
let g:vimshell_prompt = "% "

if s:iswin
  " Display user name on Windows.
  "let g:vimshell_prompt = $USERNAME."% "

  " Use ckw.
  let g:vimshell_use_ckw = 1
else
  " Display user name on Linux.
  "let g:vimshell_prompt = $USER."% "

  call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
  call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
  call vimshell#set_execute_file('tgz,gz', 'gzcat')
  call vimshell#set_execute_file('tbz,bz2', 'bzcat')
endif

" Initialize execute file list.
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
let g:vimshell_execute_file_list['rb'] = 'ruby'
let g:vimshell_execute_file_list['pl'] = 'perl'
let g:vimshell_execute_file_list['py'] = 'python'
call vimshell#set_execute_file('html,xhtml', 'gexe firefox')


" <C-Space>: switch to vimshell.
nmap <C-@>  <Plug>(vimshell_switch)
imap <C-@>  <Plug>(vimshell_switch)
" !: vimshell interactive execute.
nnoremap !  :<C-u>VimShellInteractive<Space>
" &: vimshell background execute.
nnoremap &  :<C-u>VimShellExecute<Space>

autocmd MyAutoCmd FileType vimshell
      \   imap <buffer><silent> &  <C-o>:call vimshell#mappings#push_and_execute('cd ..')<CR>
      \| nnoremap <buffer> T  Ga
      \| nmap <buffer> R   Gah<CR>
      \| imap <buffer> <BS> <Plug>(vimshell_another_delete_backword_char)
      \| imap <buffer> <C-h> <Plug>(vimshell_another_delete_backword_char)
      \| call vimshell#altercmd#define('g', 'git')
      \| call vimshell#altercmd#define('i', 'iexe')
      \| call vimshell#set_alias('l.', 'ls -d .*')
      \| call vimshell#set_galias('L', 'ls -l')
      \| call vimshell#hook#set('chpwd', [s:SID_PREFIX().'my_chpwd'])
      \| call vimshell#hook#set('emptycmd', [s:SID_PREFIX().'my_emptycmd'])
      \| call vimshell#hook#set('preexec', [s:SID_PREFIX().'my_preexec'])
      \| call vimshell#hook#set('preprompt', [s:SID_PREFIX().'my_preprompt'])

autocmd MyAutoCmd FileType int-*
      \  imap <buffer> <BS> <Plug>(vimshell_int_another_delete_backword_char)
      \| imap <buffer> <C-h> <Plug>(vimshell_int_another_delete_backword_char)

function! s:my_chpwd(args, context)
  call vimshell#execute('ls')
endfunction
function! s:my_emptycmd(cmdline, context)
  call vimshell#set_prompt_command('ls')
  return 'ls'
endfunction
function! s:my_preprompt(args, context)
  call vimshell#execute('echo "preprompt"')
endfunction
function! s:my_preexec(cmdline, context)
  call vimshell#execute('echo "preexec"')
  return a:cmdline
endfunction

"}}}

" scratch.vim"{{{
let g:scratch_buffer_name = 'scratch'
"}}}

" netrw.vim"{{{
let g:netrw_list_hide= '*.swp'
nnoremap <silent> <BS> :<C-u>Explore<CR>
" Change default directory.
set browsedir=current
if executable('wget')
  let g:netrw_http_cmd = 'wget'
endif
"}}}

" hexedit.vim"{{{
nnoremap <Leader>he  :<C-u>Hedit<CR>
nnoremap <Leader>hv  :<C-u>Hview<CR>
nnoremap <Leader>hw  :<C-u>Hwrite<CR>
nnoremap <Leader>hc  :<C-u>Hconvert<CR>
nnoremap <Leader>hr  :<C-u>Hredraw<CR>
nnoremap <Leader>hR  :<C-u>Hreset<CR>
"}}}

" errormarker.vim"{{{
let errormarker_errortext      = "!!"
let errormarker_warningtext    = "??"
let g:errormarker_errorgroup   = "Error"
let g:errormarker_warninggroup = "Todo"
if s:iswin
  let g:errormarker_erroricon    = $DOTVIM . "/signs/err.bmp"
  let g:errormarker_warningicon  = $DOTVIM . "/signs/warn.bmp"
else
  let g:errormarker_erroricon    = $DOTVIM . "/signs/err.png"
  let g:errormarker_warningicon  = $DOTVIM . "/signs/warn.png"
endif
"}}}

" git.vim ----------------------------------------------------- {{{
let g:git_no_default_mappings = 1
let g:git_use_vimproc = 1
let g:git_command_edit = 'rightbelow vnew'
nnoremap <silent> [Space]gd :<C-u>GitDiff --cached<CR>
nnoremap <silent> [Space]gD :<C-u>GitDiff<CR>
nnoremap <silent> [Space]gs :<C-u>GitStatus<CR>
nnoremap <silent> [Space]gl :<C-u>GitLog<CR>
nnoremap <silent> [Space]gL :<C-u>GitLog -u \| head -10000<CR>
nnoremap <silent> [Space]ga :<C-u>GitAdd<CR>
nnoremap <silent> [Space]gA :<C-u>GitAdd <cfile><CR>
nnoremap <silent> [Space]gc :<C-u>GitCommit<CR>
nnoremap <silent> [Space]gp :<C-u>Git push
nnoremap <silent> [Space]gt :<C-u>Git tag<Space>
"}}}

" neoui.vim"{{{
" The prefix key.
nnoremap    [neoui]   <Nop>
nmap    ' [neoui]
nnoremap    [neoui]'   :<C-u>NeoUI file buffer file/mru<CR>
nnoremap [neoui]u  :<C-u>NeoUI<Space>
"nnoremap <silent> [neoui]c  :<C-u>NeoUI cmd_mru/cmd<CR>
nnoremap <silent> [neoui]d  :<C-u>NeoUI file<CR>
nnoremap <silent> [neoui]g  :<C-u>NeoUI metarw/git<CR>
nnoremap <silent> [neoui]l  :<C-u>NeoUI launcher<CR>
nnoremap <silent> [neoui]u  :<C-u>NeoUI bundle<CR>
nnoremap <silent> [neoui]q  :<C-u>NeoUI quickfix/buffer<CR>
nnoremap <silent> [neoui]r  :<C-u>NeoUI ref<CR>
nnoremap <silent> [neoui]s  :<C-u>NeoUI source<CR>
"nnoremap <silent> [neoui]/  :<C-u>NeoUI cmd_mru/search<CR>
nnoremap <silent> [Space]<Space>  :<C-u>NeoUI buffer file file/mru<CR>

autocmd MyAutoCmd FileType neoui call s:neoui_my_settings()

function! s:neoui_my_settings()"{{{
  call neoui#define_default_ui_key_mappings(1)

  " Overwrite settings.
  inoremap <buffer> <silent> <Tab> <C-n>
  imap <buffer> <silent> jj <Plug>(neoui-quit-session)
  nmap <buffer> <silent> jj <Plug>(neoui-quit-session)
  imap <buffer> <silent> <Esc> <Plug>(neoui-choose-action)
  inoremap <buffer> <expr> [ pumvisible()? "\<C-n>" : "["
  nmap <buffer> <silent> <Esc> <Plug>(neoui-choose-action)
  let &iminsert = 0
  let &imsearch = 0
endfunction"}}}

call neoui#custom_prefix('common', 'home', substitute($HOME, '\\', '/', 'g'))
call neoui#custom_prefix('common', '~', substitute($HOME, '\\', '/', 'g'))
call neoui#custom_prefix('common', '.v', substitute($DOTVIM, '\\', '/', 'g'))
call neoui#custom_prefix('common', 'runtime', substitute($VIMRUNTIME, '\\', '/', 'g'))

let g:ku_file_mru_limit = 200
"}}}

" smartword.vim"{{{
" Replace w and others with smartword-mappings
nmap w  <Plug>(smartword-w)
nmap b  <Plug>(smartword-b)
nmap ge  <Plug>(smartword-ge)
xmap w  <Plug>(smartword-w)
xmap b  <Plug>(smartword-b)
" Operator pending mode.
omap <Leader>w  <Plug>(smartword-w)
omap <Leader>b  <Plug>(smartword-b)
omap <Leader>ge  <Plug>(smartword-ge)
"}}}

" camlcasemotion.vim"{{{
nmap <silent> W <Plug>CamelCaseMotion_w
xmap <silent> W <Plug>CamelCaseMotion_w
nmap <silent> B <Plug>CamelCaseMotion_b
xmap <silent> W <Plug>CamelCaseMotion_b
""}}}

" AutoProtectFile.vim
let g:autoprotectfile_readonly_paths = "$VIMRUNTIME/*,~/important"
let g:autoprotectfile_nomodifiable_paths = "$VIMRUNTIME/*,~/important"

" smartchr.vim"{{{
inoremap <expr> & smartchr#one_of('&', ' & ', ' && ')
inoremap <expr> <Bar> smartchr#one_of('<Bar>', ' <Bar> ', ' <Bar><Bar> ')
inoremap <expr> , smartchr#one_of(', ', ',')

inoremap <expr> ? smartchr#one_of('?', '? ')

" Smart =.
inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
      \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
      \ : smartchr#one_of(' = ', '=', ' == ')
augroup MyAutoCmd
  " Substitute .. into -> .
  autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
  autocmd FileType perl,php inoremap <buffer> <expr> . smartchr#loop(' . ', '->', '.')
  autocmd FileType perl,php inoremap <buffer> <expr> - smartchr#loop('-', '->')
  autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')

  autocmd FileType haskell
        \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
        \| inoremap <buffer> <expr> - smartchr#loop('-', ' <- ')
        \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
        \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
        \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
        \| inoremap <buffer> <expr> . smartchr#loop(' . ', '..', '.')

  autocmd FileType scala
        \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
        \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
        \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
        \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')

  autocmd FileType eruby
        \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
        \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
augroup END
"}}}

" eev.vim"{{{
nmap >  <Plug>(eev_search_forward)
nmap <  <Plug>(eev_search_forward)
nmap <C-e>  <Plug>(eev_eval)
nmap <C-u>  <Plug>(eev_create)
"}}}

" smarttill.vim"{{{
xmap q  <Plug>(smarttill-t)
xmap Q  <Plug>(smarttill-T)
" Operator pending mode.
omap q  <Plug>(smarttill-t)
omap Q  <Plug>(smarttill-T)
"}}}

" changelog.vim"{{{
autocmd MyAutoCmd BufNewFile,BufRead *.changelog setf changelog
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "Shougo "
"}}}

" quickrun.vim"{{{
function! s:init_quickrun()
  for [key, com] in items({
        \   '<Leader>x' : '<=@i >:',
        \   '<Leader>p' : '<=@i >!',
        \   '<Leader>"' : '<=@i >=@"',
        \   '<Leader>w' : '<=@i >',
        \   '<Leader>q' : '<=@i >>',
        \   '<Leader>vx' : '-eval 1 <=@i >:',
        \   '<Leader>vp' : '-eval 1 <=@i >!',
        \   '<Leader>v"' : '-eval 1 <=@i >=@"',
        \   '<Leader>vw' : '-eval 1 <=@i >',
        \   '<Leader>vq' : '-eval 1 <=@i >>',
        \ })
    execute 'nnoremap <silent>' key ':QuickRun' com '-mode n<CR>'
    execute 'vnoremap <silent>' key ':QuickRun' com '-mode v<CR>'
  endfor

  call s:set_default('g:QuickRunConfig', {'mkd': {'command': 'mdv2html'}})
  call s:set_default('g:QuickRunConfig', {'xmodmap': {}})
endfunction
call s:init_quickrun()
nmap <silent> [Space]r <Plug>(quickrun-op)

if !exists('g:quickrun_config')
  " Enable async.
  let g:quickrun_config = {
        \   '*': {'runmode': 'async:remote:vimproc'},
        \ }

  if s:iswin
    function! TexEncoding()
      if &fileencoding ==# 'utf-8'
        let l:arg = 'utf8 '
      elseif &fileencoding =~# '^euc-\%(jp\|jisx0213\)$'
        let l:arg = 'euc '
      elseif &fileencoding =~# '^iso-2022-jp'
        let l:arg = 'jis '
      else " cp932
        let l:arg = 'sjis '
      endif

      return l:arg
    endfunction
    let tex = 'platex -kanji={TexEncoding()}'
    let g:quickrun_config.tex = { 'command' : tex, 'exec': ['%c %s', 'dvipdfmx %s:r.dvi'] }
  else
    let tex = 'platex'
    let g:quickrun_config.tex = { 'command' : tex, 'exec': ['%c %s', 'dvipdfmx %s:r.dvi', 'open %s:r.pdf'] }
  endif
  unlet tex

  let g:quickrun_config.vim = {}
endif
"}}}

" python.vim
let python_highlight_all = 1

" fakeclip.vim
map "&Y "&y$

" Align.vim
let g:Align_xstrlen=3

" poslist.vim
nmap <C-k> <Plug>(poslist-prev-pos)
nmap <C-j> <Plug>(poslist-next-pos)
nmap ( <Plug>(poslist-prev-buf)
nmap ) <Plug>(poslist-next-buf)

" ref.vim"{{{
if s:iswin
  let g:ref_pydoc_cmd = 'pydoc.bat'
  let g:ref_refe_encoding = 'cp932'
else
  let g:ref_refe_encoding = 'euc-jp'
endif
"}}}

" vimfiler.vim"{{{
nmap    [Space]vv   <Plug>(vimfiler_switch)
nmap    [Space]vf   <Plug>(vimfiler_split_create)
nmap    [Space]vs   <Plug>(vimfiler_simple)
nmap    [Space]vh   :<C-u>edit %:h<CR>

" Set local mappings.
nmap <C-p>       <Plug>(vimfiler_open_previous_file)
nmap <C-n>       <Plug>(vimfiler_open_next_file)

call vimfiler#set_execute_file('vim', 'vim')
call vimfiler#set_execute_file('txt', 'notepad')
"let g:vimfiler_split_command = ''
"let g:vimfiler_edit_command = 'tabedit'
"let g:vimfiler_pedit_command = 'vnew'

" Linux default.
"let g:vimfiler_external_copy_directory_command = 'cp -r $src $dest'
"let g:vimfiler_external_copy_file_command = 'cp $src $dest'
"let g:vimfiler_external_delete_command = 'rm -r $srcs'
"let g:vimfiler_external_move_command = 'mv $srcs $dest'

" Windows default.
"let g:vimfiler_external_delete_command = 'system rmdir /Q /S $srcs'
"let g:vimfiler_external_copy_file_command = 'system copy $src $dest'
"let g:vimfiler_external_copy_directory_command = ''
"let g:vimfiler_external_move_command = 'move /Y $srcs $dest'

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_detect_drives = ['C', 'D', 'E', 'F', 'G', 'H', 'I', 
      \ 'J', 'K', 'L', 'M', 'N'] 

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()"{{{
  " Overwrite settings.
endfunction"}}}
"}}}

" eskk.vim"{{{
if !exists('g:eskk_disable') || !g:eskk_disable
  runtime! plugin/eskk.vim
  map! <C-o> <Plug>(eskk:toggle)
  EskkMap jj <Plug>(eskk:disable)<Esc>
  EskkMap -type=sticky ;
  
  let g:eskk_dictionary = {
        \   'path': expand('~/.skk-eskk-jisyo'),
        \   'sorted': 0,
        \   'encoding': 'utf-8',
        \}
  let g:eskk_large_dictionary = {
        \   'path': expand('~/SKK-JISYO.L'),
        \   'sorted': 1,
        \   'encoding': 'euc-jp',
        \}
  let g:eskk_dont_map_default_if_already_mapped = 1
  
  if &encoding == 'utf-8' && !has('gui_running')
    " ▽の代わりに <>
    let g:eskk_marker_henkan = '<>'
    " ▼の代わりに >>
    let g:eskk_marker_henkan_select = '>>'
  endif
  
  let g:eskk_show_annotation = 1 
  let g:eskk_hira_input_style = 'msime'
endif
"}}}

" skk.vim"{{{
if !exists('g:plugin_skk_disable') || !g:plugin_skk_disable
  map! <C-j> <Plug>(skk-toggle-im)
  imap jj <Plug>(skk-disable-im)<ESC>
  
  let g:skk_auto_save_jisyo = 1
  let g:skk_user_rom_kana_rules = ""
        \. "z 	　\<NL>"
        \. "z9	（\<NL>"
        \. "z0	）\<NL>"
  if &encoding == 'utf-8' && !has('gui_running')
    " ▽の代わりに <>
    let g:skk_marker_white = '<>'
    " ▼の代わりに >>
    let g:skk_marker_black = '>>'
  endif
  " Use remap.
  let g:skk_remap_lang_mode = 1
  let g:skk_large_jisyo = expand('~/SKK-JISYO.L')
endif
"}}}

" stickykey.vim
"imap ;           <Plug>(stickykey-shift)

" metarw.vim
" Define wrapper commands.
call metarw#define_wrapper_commands(1)

let g:ku_file_mru_limit = 200

" ref.vim"{{{
let g:skk_sticky_key = ';'
"let g:skk_completion_key = ''
"}}}

" lingr-vim"{{{
" Keymapping.
autocmd MyAutoCmd FileType lingr-say imap <buffer> <CR> <Plug>(lingr-say-insert-mode-say)
"}}}


" rsense.vim"{{{
let g:rsenseHome = 'c:/rsense'
let g:rsenseUseOmniFunc = 1
"}}}
" gccsense.vim"{{{
let g:gccsenseUseOmniFunc = 1
let g:gccsenseCDriver = '/usr/local/bin/gcc-code-assist'
let g:gccsenseCPPDriver = '/usr/local/bin/g++-code-assist'
"}}}

" surround.vim"{{{
let g:surround_no_mappings = 1
autocmd MyAutoCmd FileType * call s:define_surround_keymappings()

function! s:define_surround_keymappings()
  if !&modifiable
    return
  endif

  nmap <buffer>         ds   <Plug>Dsurround
  nmap <buffer>         cs   <Plug>Csurround
  nmap <buffer>         ys   <Plug>Ysurround
  nmap <buffer>         yS   <Plug>YSurround
  nmap <buffer>         yss  <Plug>Yssurround
  nmap <buffer>         ySs  <Plug>YSsurround
  nmap <buffer>         ySS  <Plug>YSsurround
endfunction
"}}}

" qfreplace.vim
autocmd MyAutoCmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>
"}}}

"---------------------------------------------------------------------------
" Key-mappings: "{{{
"

" Use <C-Space>.
map <C-Space>  <C-@>
cmap <C-Space>  <C-@>

" Visual mode keymappings: "{{{
" <CR>: change.
xnoremap <CR>  c
" <TAB>: indent.
xnoremap <TAB>  >
" <S-TAB>: unindent.
xnoremap <S-TAB>  <
"}}}

" Selection mode keymappings: "{{{
snoremap <CR>     <Space><BS>
snoremap <Space>  <Space><BS>
snoremap <C-f>  <ESC>a
snoremap <C-b>  <ESC>bi
"}}}

" Insert mode keymappings: "{{{
" <C-t>: insert tab.
inoremap <C-t>  <C-v><TAB>
" <C-d>: delete char.
inoremap <C-d>  <Del>
" <C-a>: move to head.
inoremap <silent><C-a>  <C-o>^
" <A-b>: previous word.
inoremap <A-b>  <S-Left>
" <A-f>: next word.
inoremap <A-f>  <S-Right>
" Enable undo <C-w> and <C-u>.
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>

" <?>: toggle preview window.
"inoremap <silent><C-a>  <C-o>:<C-u>call<SID>preview_window_toggle()<CR>
" <C-a>: toggle preview window.
inoremap <silent><C-a>  <Home>
" H, D: delete camlcasemotion.
inoremap <expr>H           <SID>camelcase_delete(0)
inoremap <expr>D           <SID>camelcase_delete(1)
function! s:camelcase_delete(is_reverse)
  let l:save_ve = &l:virtualedit
  setlocal virtualedit=all
  if a:is_reverse
    let l:cur_text = getline('.')[virtcol('.')-1 : ]
  else
    let l:cur_text = getline('.')[: virtcol('.')-2]
  endif
  let &l:virtualedit = l:save_ve

  let l:pattern = '\d\+\|\u\+\ze\%(\u\l\|\d\)\|\u\l\+\|\%(\a\|\d\)\+\ze_\|\%(\k\@!\S\)\+\|\%(_\@!\k\)\+\>\|[_]\|\s\+'

  if a:is_reverse
    let l:cur_cnt = len(matchstr(l:cur_text, '^\%('.l:pattern.'\)'))
  else
    let l:cur_cnt = len(matchstr(l:cur_text, '\%('.l:pattern.'\)$'))
  endif

  let l:close = neocomplcache#cancel_popup()
  "let l:close = neocomplcache#close_popup()
  let l:del = a:is_reverse ? "\<Del>" : "\<BS>"

  return (pumvisible() ? l:close : '') . repeat(l:del, l:cur_cnt)
endfunction
" <C-x><C-f>: filname completion.
inoremap <expr><C-x><C-f>  neocomplcache#manual_filename_complete()
"}}}

" Command-line mode keymappings:"{{{
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
" <C-s>: view history.
cnoremap <C-s>          <C-f>
" <C-l>: view completion list.
cnoremap <C-l>          <C-d>
" <A-b>, W: move to previous word.
cnoremap <A-b>          <S-Left>
" <A-f>, B: move to next word.
cnoremap <A-f>          <S-Right>
cnoremap <S-TAB>        <C-p>
" <C-g>: decide candidate.
cnoremap <C-g>          <Space><C-h>
" <C-t>: insert space.
cnoremap <C-t>          <Space>
"}}}

" Command line buffer."{{{
nnoremap <sid>(command-line-enter) q:
xnoremap <sid>(command-line-enter) q:
nnoremap <sid>(command-line-norange) q:<C-u>

nmap ;  <sid>(command-line-enter)
xmap ;  <sid>(command-line-enter)

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
  nnoremap <buffer> q :<C-u>quit<CR>
  nnoremap <buffer> <TAB> :<C-u>quit<CR>
  nnoremap <buffer> ; :
  xnoremap <buffer> ; :
  inoremap <buffer><expr><CR> pumvisible() ? "\<C-e>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-e>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-e>\<C-h>" : "\<C-h>"

  " Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : "\<C-x>\<C-u>\<C-p>"

  " Altercmd.
  call altercmd#define('<buffer>', 'grep', 'Grep', 'i')

  startinsert!
endfunction"}}}

" [Space]: Other useful commands "{{{
" スペースキーのマッピングを見やすくする
" noremapに<Space>で始まるものを使うと[Space]が表示されなくなるので注意！
nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>

" Toggle highlight.
nnoremap <silent> [Space]/  :<C-u>call ToggleOption('hlsearch')<CR>
" Toggle cursorline.
nnoremap <silent> [Space]cl  :<C-u>call ToggleOption('cursorline')<CR>
" Set autoread.
nnoremap [Space]ar  :<C-u>setlocal autoread<CR>
" Output encoding information.
nnoremap <silent> [Space]en  :<C-u>setlocal encoding? termencoding? fenc? fencs?<CR>
" Set fileencoding.
nnoremap [Space]fe  :<C-u>set fileencoding=
" Set local.
nnoremap [Space]sl  :<C-u>setlocal<Space>
" Set spell check.
nnoremap [Space]sp  :<C-u>call ToggleOption('spell')<CR>
" Echo syntax name.
nnoremap [Space]sy  :<C-u>echo synIDattr(synID(line('.'), col('.'), 1), "name")<CR>

" Easily edit .vimrc and .gvimrc "{{{
nnoremap <silent> [Space]ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> [Space]eg  :<C-u>edit $MYGVIMRC<CR>
" Load .gvimrc after .vimrc edited at GVim.
nnoremap <silent> [Space]rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif \| echo "source $MYVIMRC"<CR>
nnoremap <silent> [Space]rg :<C-u>source $MYGVIMRC \| echo "source $MYGVIMRC"<CR>
"}}}

" Easily edit snippets file
nnoremap [Space]er  :<C-u>NeoComplCacheEditRuntimeSnippets<Space>
nnoremap [Space]es  :<C-u>NeoComplCacheEditSnippets<Space>

" Easily check registers and marks.
nnoremap <silent> [Space]mk  :<C-u>marks<CR>
nnoremap <silent> [Space]re  :<C-u>registers<CR>

" Easily check key-mappings.
nnoremap [Space]mpn  :<C-u>nnoremap<Space>
nnoremap [Space]mpi  :<C-u>inoremap<Space>
nnoremap [Space]mpc  :<C-u>cnoremap<Space>

" Saves "{{{
" :wはよく使うので<Space>wにマッピングする
nnoremap <silent> [Space]w  :<C-u>update<CR>
" :w!はよく使うので<Space>fwにマッピングする
nnoremap <silent> [Space]fw  :<C-u>write!<CR>
" :qはよく使うので<Space>qにマッピングする
nnoremap <silent> [Space]q  :<C-u>quit<CR>
" :qaは<Space>aqにマッピングする
nnoremap <silent> [Space]aq  :<C-u>quitall<CR>
" :q!はよく使うので<Space>fqにマッピングする
nnoremap <silent> [Space]fq  :<C-u>quitall!<CR>
" <Leader><Leader>で変更があれば保存
nnoremap <Leader><Leader> :<C-u>update<CR>
"}}}

" Change current directory.
nnoremap <silent> [Space]cd :<C-u>CD<CR>

" Delete windows ^M codes.
nnoremap <silent> [Space]<C-m> mmHmt:<C-u>%s/<C-v><CR>$//ge<CR>'tzt'm

" Delete spaces before newline.
nnoremap <silent> [Space]ss mmHmt:<C-u>%s/<Space>$//ge<CR>`tzt`m

" Easily syntax change."{{{
nnoremap [Space]0 :setl syntax=<CR>
nnoremap [Space]1 :setl syntax=xhtml<CR>
nnoremap [Space]2 :setl syntax=php<CR>
nnoremap [Space]3 :setl syntax=python<CR>
nnoremap [Space]4 :setl syntax=ruby<CR>
nnoremap [Space]5 :setl ft=javascript<CR>
" Detect syntax
nnoremap [Space]$ :filetype detect<cr>
nnoremap [Space]ft :setfiletype<Space>
"}}}

" Save and make. "{{{
nnoremap <silent> [Space]ma    :wall \| Make!<CR>
" Save and make current file only.
nnoremap <silent> [Space]mo    :wall \| call <SID>UpdateQuickFix("", 1, 1)<CR>
" Save and make test.
nnoremap <silent> [Space]mt    :wall \| echo system('make -s test')<CR>
" Toggle automatically make.
nnoremap <silent> [Space]mm :call <SID>EnableFlyMake()<CR>
"}}}

" Exchange gj and gk to j and k. "{{{
command! -nargs=? -bar -bang ToggleGJK call s:ToggleGJK()
nnoremap <silent> [Space]gj :<C-u>ToggleGJK<CR>
xnoremap <silent> [Space]gj :<C-u>ToggleGJK<CR>
function! s:ToggleGJK()
  if exists('b:enable_mapping_gjk') && b:enable_mapping_gjk
    let b:enable_mapping_gjk = 0
    noremap <buffer> j j
    noremap <buffer> k k
    noremap <buffer> gj gj
    noremap <buffer> gk gk

    xnoremap <buffer> j j
    xnoremap <buffer> k k
    xnoremap <buffer> gj gj
    xnoremap <buffer> gk gk
  else
    let b:enable_mapping_gjk = 1
    noremap <buffer> j gj
    noremap <buffer> k gk
    noremap <buffer> gj j
    noremap <buffer> gk k

    xnoremap <buffer> j gj
    xnoremap <buffer> k gk
    xnoremap <buffer> gj j
    xnoremap <buffer> gk k
  endif
endfunction"}}}

" Screen evaluation "{{{
if &term =~ "^screen"
  nnoremap <silent> [Space]se :<C-u>call ScreenEval(getline('.'))<CR>
  xnoremap <silent> [Space]se "zy:<C-u>call ScreenEval(@z)<CR>
endif"}}}

" Change tab width. "{{{
nnoremap <silent> [Space]t2 :<C-u>setl shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> [Space]t4 :<C-u>setl shiftwidth=4 softtabstop=4<CR>
nnoremap <silent> [Space]t8 :<C-u>setl shiftwidth=8 softtabstop=8<CR>
"}}}

" Easily ctags command."{{{
nnoremap <silent> [Space]tr :<C-u>silent !ctags -R<CR>
" Easily helptags command.
if !exists('g:loaded_vimrc_local')
  nnoremap <silent> [Space]td :<C-u>helptags $VIMRUNTIME/doc<CR>:<C-u>call pathogen#helptags()<CR>
else
  nnoremap <silent> [Space]td :<C-u>helptags $VIMRUNTIME/doc<CR>:<C-u>helptags $HOME/.vim/doc<CR>
endif
"}}}

" Fast search pair.
nnoremap [Space]p    %
xnoremap [Space]p    %

" Fast screen move.
nnoremap [Space]j    z<CR><C-f>z.
xnoremap [Space]j    z<CR><C-f>z.
nnoremap [Space]k    z-<C-b>z.
xnoremap [Space]k    z-<C-b>z.

" [Space]<C-n>, [Space]<C-p>: Move window position {{{
nnoremap <silent> [Space]<C-n> :<C-u>call <SID>call <SID>swap_window(v:count1)<CR>
nnoremap <silent> [Space]<TAB> :<C-u>call <SID>call <SID>swap_window(v:count1)<CR>
nnoremap <silent> [Space]<C-p> :<C-u>call <SID>call <SID>swap_window(-v:count1)<CR>

function! s:modulo(n, m) "{{{
  let d = a:n * a:m < 0 ? 1 : 0
  return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
endfunction "}}}

function! s:swap_window(n) "{{{
  let curbuf = bufnr('%')
  let target = s:modulo(winnr() + a:n - 1, winnr('$')) + 1

  execute 'hide' winbufnr(target) . 'buffer'
  execute target . 'wincmd w'
  execute curbuf . 'buffer'
endfunction "}}}
" }}}
"}}}

" t: tags-and-searches "{{{
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Jump.
nnoremap [Tag]t  <C-]>
" Jump next.
nnoremap <silent> [Tag]n  :<C-u>tag<CR>
" Jump previous.
nnoremap <silent> [Tag]p  :<C-u>pop<CR>
" Jump history list.
nnoremap <silent> [Tag]l  :<C-u>tags<CR>
" Jump the selected tag.
nnoremap <silent> [Tag]s  :<C-u>tselect<CR>
" 現在の候補を表示
nnoremap <silent> [Tag]i  :<C-u>0tnext<CR>
" 次の候補へ
nnoremap <silent> [Tag]N  :<C-u>tnext<CR>
" 前の候補へ
nnoremap <silent> [Tag]P  :<C-u>tprevious<CR>
" 最初の候補へ
nnoremap <silent> [Tag]F  :<C-u>tfirst<CR>
" 前の候補へ
nnoremap <silent> [Tag]L  :<C-u>tlast<CR>
" タグを指定してジャンプする
nnoremap [Tag]f  :<C-u>tag<Space>
" Display in preview window.
nnoremap [Tag]'t  <C-w>}
xnoremap [Tag]'t  <C-w>}
nnoremap <silent> [Tag]'n  :<C-u>ptnext<CR>
nnoremap <silent> [Tag]'p  :<C-u>ptprevious<CR>
nnoremap <silent> [Tag]'P  :<C-u>ptfirst<CR>
nnoremap <silent> [Tag]'N  :<C-u>ptlast<CR>
" Close preview window.
nnoremap <silent> [Tag]'c  :<C-u>pclose<CR>
" Jump and split.
nnoremap [Tag]]  <C-w>]
"}}}

" s: Windows and buffers(High priority) "{{{
" The prefix key.
nnoremap    [Window]   <Nop>
nmap    s [Window]
nnoremap C         s
xnoremap C         s
nnoremap <silent> [Window]p  :<C-u>call <SID>split_nicely()<CR>
nnoremap <silent> [Window]v  :<C-u>vsplit<CR>
nnoremap <silent> [Window]c  :<C-u>close<CR>
nnoremap <silent> -  :<C-u>close<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]w  :<C-u>call <SID>MovePreviousWindow()<CR>
"nnoremap <silent><expr> <Tab>   winnr('$') == 1? ":\<C-u>call \<SID>split_nicely()\<CR>" :  "\<C-w>w"

" A .vimrc snippet that allows you to move around windows beyond tabs
nnoremap <silent> <Tab> :<C-u>call <SID>NextWindowOrTab()<CR>
nnoremap <silent> <S-Tab> :<C-u>call <SID>PreviousWindowOrTab()<CR>

function! s:NextWindowOrTab()
  if tabpagenr('$') == 1 && winnr('$') == 1
    call s:split_nicely()
  elseif winnr() < winnr("$")
    wincmd w
  else
    tabnext
    1wincmd w
  endif
endfunction

function! s:PreviousWindowOrTab()
  if winnr() > 1
    wincmd W
  else
    tabprevious
    execute winnr("$") . "wincmd w"
  endif
endfunction

nnoremap <silent> [Window]<Space>  :<C-u>call <SID>ToggleSplit()<CR>
function! s:MovePreviousWindow()
  let l:prev_name = winnr()
  silent! wincmd p
  if l:prev_name == winnr()
    silent! wincmd w
  endif
endfunction
" If window isn't splited, split buffer.
function! s:ToggleSplit()
  let l:prev_name = winnr()
  silent! wincmd w
  if l:prev_name == winnr()
    split
  else
    close
  endif
endfunction
" Split nicely."{{{
command! SplitNicely call s:split_nicely()
function! s:split_nicely()
  " Split nicely.
  if winwidth(0) > 2 * &winwidth
    vsplit
  else
    split
  endif
  wincmd p
endfunction
"}}}
" Delete current buffer."{{{
nnoremap <silent> [Window]d  :<C-u>call <SID>CustomBufferDelete(0)<CR>
nnoremap <silent> _  :<C-u>call <SID>CustomBufferDelete(0)<CR>
function! s:CustomBufferDelete(is_force)
  let current = bufnr('%')

  call s:CustomAlternateBuffer()

  if a:is_force
    silent! execute 'bdelete! ' . current
  else
    silent! execute 'bdelete ' . current
  endif
endfunction
"}}}
" Delete input buffer."{{{
nnoremap <silent> [Window]D  :<C-u>call <SID>InputBufferDelete(0)<CR>
function! s:InputBufferDelete(is_force)
  call s:ViewBufferList()

  " Create list.
  let [l:cnt, l:pos, l:list] = [0, 1, {}]
  while l:pos <= bufnr('$')
    if buflisted(l:pos)
      let l:list[l:cnt] = l:pos
      let l:cnt += 1
    endif
    let l:pos += 1
  endwhile

  let l:input = input('Select delete buffer: ', '')
  if l:input == ''
    " Cancel.
    return
  endif

  for l:in in split(l:input)
    if !has_key(l:list, l:in) || !bufexists(l:list[l:in])
      echo "\nDon't exists buffer " . l:in
      continue
    endif

    if l:in == bufnr('%') || l:in == bufname('%')
      call s:CustomAlternateBuffer()
    endif

    echo bufnr(l:list[l:in])
    if a:is_force
      silent! execute 'bdelete! ' . l:list[l:in]
    else
      silent! execute 'bdelete ' . l:list[l:in]
    endif
  endfor
endfunction
"}}}
" Force delete current buffer.
nnoremap <silent> [Window]fq  :<C-u>call <SID>CustomBufferDelete(1)<CR>
nnoremap <silent> [Window]fQ  :<C-u>call <SID>InputBufferDelete(1)<CR>
" Delete current buffer and close current window.
nnoremap <silent> [Window]d  :<C-u>call <SID>CustomBufferDelete(0)<CR>:if winnr() != 1 <Bar> close<CR>:endif<CR>
nnoremap <silent> [Window]fd  :<C-u>call <SID>CustomBufferDelete(1)<CR>:<C-u>close<CR>
" Buffer move.
nnoremap <silent> <C-s>  :<C-u>bnext<CR>
nnoremap <silent> <C-d>  :<C-u>bprevious<CR>
" Fast buffer switch."{{{
nnoremap <silent> [Window]s :<C-u>call <SID>CustomAlternateBuffer()<CR>
function! s:CustomAlternateBuffer()
  if bufnr('%') != bufnr('#') && buflisted(bufnr('#'))
    buffer #
  else
    let l:cnt = 0
    let l:pos = 1
    let l:current = 0
    while l:pos <= bufnr('$')
      if buflisted(l:pos)
        if l:pos == bufnr('%')
          let l:current = l:cnt
        endif

        let l:cnt += 1
      endif

      let l:pos += 1
    endwhile

    if l:current > l:cnt / 2
      bprevious
    else
      bnext
    endif
  endif
endfunction
"}}}
nnoremap <silent> [Window]q  :<C-u>call <SID>CustomBufferDelete(0)<CR>
" Edit"{{{
nnoremap [Window]b  :<C-u>edit<Space>
nnoremap <silent> [Window]en  :<C-u>new<CR>
nnoremap <silent> [Window]ee  :<C-u>enew<CR>
nnoremap <silent> [Window]ej  :<C-u>JunkFile<CR>
nnoremap [Window]r  :<C-u>REdit<Space>
"}}}
" View buffer list.
nnoremap <silent> [Window]l  :<C-u>NeoUI buffer<CR>
"}}}

" <C-t>: Tab pages"{{{
"
" The prefix key.
nnoremap [Tabbed]   <Nop>
" Create tab page.
nnoremap <silent> [Tabbed]c  :<C-u>tabnew<CR>
nnoremap <silent> [Tabbed]d  :<C-u>tabclose<CR>
nnoremap <silent> [Tabbed]o  :<C-u>tabonly<CR>
nnoremap <silent> [Tabbed]i  :<C-u>tabs<CR>
nmap [Tabbed]<C-n>  [Tabbed]n
nmap [Tabbed]<C-c>  [Tabbed]c
nmap [Tabbed]<C-o>  [Tabbed]o
nmap [Tabbed]<C-i>  [Tabbed]i
" Move to other tab page.
nnoremap <silent> [Tabbed]j
      \ :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
nnoremap <silent> [Window]j
      \ :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
nnoremap <silent> [Tabbed]k  :<C-u>tabprevious<CR>
nnoremap <silent> [Window]k  :<C-u>tabprevious<CR>
nnoremap <silent> [Tabbed]K  :<C-u>tabfirst<CR>
nnoremap <silent> [Window][  :<C-u>tabfirst<CR>
nnoremap <silent> [Tabbed]J  :<C-u>tablast<CR>
nnoremap <silent> [Window]]  :<C-u>tablast<CR>
nnoremap <silent> [Tabbed]l
      \ :<C-u>execute 'tabmove' min([tabpagenr() + v:count1 - 1, tabpagenr('$')])<CR>
nnoremap <silent> [Tabbed]h
      \ :<C-u>execute 'tabmove' max([tabpagenr() - v:count1 - 1, 0])<CR>
nnoremap <silent> [Tabbed]L  :<C-u>tabmove<CR>
nnoremap <silent> [Tabbed]H  :<C-u>tabmove 0<CR>
nmap [Tabbed]n  [Tabbed]j
nmap [Tabbed]p  [Tabbed]k
nmap [Tabbed]<C-t>  [Tabbed]j
nmap [Tabbed]<C-l>  [Tabbed]l
nmap [Tabbed]<C-h>  [Tabbed]h

" Move to previous tab.
nnoremap <silent>[Tabbed]<Space> :<C-u>TabRecent<CR>
nnoremap [Tabbed]r :<C-u>TabRecent<Space>

" Change current tab like GNU screen.
" Note that the numbers in {lhs}s are 0-origin.  See also 'tabline'.
for i in range(10)
  execute 'nnoremap <silent>' ('[Tabbed]'.(i))  ((i+1).'gt')
  execute 'nnoremap <silent>' ('[Window]'.(i))  ((i+1).'gt')
endfor
unlet i
"}}}

" e: Change basic commands "{{{
" The prefix key.
nnoremap [Alt]   <Nop>
xnoremap [Alt]   <Nop>
nmap    e  [Alt]
xmap    e  [Alt]

" Indent paste.
"nnoremap [Alt]p pm``[=`]``
"nnoremap [Alt]P Pm``[=`]``
nnoremap <silent> [Alt]p o<Esc>pm``[=`]``^
xnoremap <silent> [Alt]p o<Esc>pm``[=`]``^
nnoremap <silent> [Alt]P O<Esc>Pm``[=`]``^
xnoremap <silent> [Alt]P O<Esc>Pm``[=`]``^
" Insert blank line.
nnoremap <silent> [Alt]o o<Space><BS><ESC>
nnoremap <silent> [Alt]O O<Space><BS><ESC>
" Yank to end line.
nmap [Alt]y y$
nmap Y y$
" Delete first character.
nnoremap [Alt]x ^"_x
nnoremap X ^"_x
nnoremap x "_x
" Line selection <C-v>.
nnoremap [Alt]V 0<C-v>$h
" Folding close.
nnoremap [Alt]h  zc

" Useless commands
nnoremap [Alt];  ;
nnoremap [Alt],  ,

"}}}

" <C-g>: Argument list  "{{{
"
" The prefix key.
nnoremap [Argument]   <Nop>
nmap    <C-g>  [Argument]

nnoremap [Argument]<Space>  :<C-u>args<Space>
nnoremap <silent> [Argument]l  :<C-u>args<CR>
nnoremap <silent> [Argument]n  :<C-u>next<CR>
nnoremap <silent> [Argument]p  :<C-u>previous<CR>
nnoremap <silent> [Argument]P  :<C-u>first<CR>
nnoremap <silent> [Argument]N  :<C-u>last<CR>
nnoremap <silent> [Argument]wp :<C-u>wnext<CR>
nnoremap <silent> [Argument]wn :<C-u>wprevious<CR>
"}}}

" q: Quickfix  "{{{

" The prefix key.
nnoremap [Quickfix]   <Nop>
nmap    q  [Quickfix]
" Disable Ex-mode.
nnoremap Q  q

" For quickfix list  "{{{3
nnoremap <silent> [Quickfix]n  :<C-u>cnext<CR>
nnoremap <silent> [Quickfix]p  :<C-u>cprevious<CR>
nnoremap <silent> [Quickfix]r  :<C-u>crewind<CR>
nnoremap <silent> [Quickfix]N  :<C-u>cfirst<CR>
nnoremap <silent> [Quickfix]P  :<C-u>clast<CR>
nnoremap <silent> [Quickfix]fn :<C-u>cnfile<CR>
nnoremap <silent> [Quickfix]fp :<C-u>cpfile<CR>
nnoremap <silent> [Quickfix]l  :<C-u>clist<CR>
nnoremap <silent> [Quickfix]q  :<C-u>cc<CR>
nnoremap <silent> [Quickfix]o  :<C-u>copen<CR>
nnoremap <silent> [Quickfix]c  :<C-u>cclose<CR>
nnoremap <silent> [Quickfix]en :<C-u>cnewer<CR>
nnoremap <silent> [Quickfix]ep :<C-u>colder<CR>
nnoremap <silent> [Quickfix]m  :<C-u>make<CR>
nnoremap [Quickfix]M  :<C-u>make<Space>
nnoremap [Quickfix]g  :<C-u>grep<Space>
" Toggle quickfix window.
nnoremap <silent> [Quickfix]<Space> :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction

" For location list (mnemonic: Quickfix list for the current Window)  "{{{3
nnoremap <silent> [Quickfix]wn  :<C-u>lnext<CR>
nnoremap <silent> [Quickfix]wp  :<C-u>lprevious<CR>
nnoremap <silent> [Quickfix]wr  :<C-u>lrewind<CR>
nnoremap <silent> [Quickfix]wP  :<C-u>lfirst<CR>
nnoremap <silent> [Quickfix]wN  :<C-u>llast<CR>
nnoremap <silent> [Quickfix]wfn :<C-u>lnfile<CR>
nnoremap <silent> [Quickfix]wfp :<C-u>lpfile<CR>
nnoremap <silent> [Quickfix]wl  :<C-u>llist<CR>
nnoremap <silent> [Quickfix]wq  :<C-u>ll<CR>
nnoremap <silent> [Quickfix]wo  :<C-u>lopen<CR>
nnoremap <silent> [Quickfix]wc  :<C-u>lclose<CR>
nnoremap <silent> [Quickfix]wep :<C-u>lolder<CR>
nnoremap <silent> [Quickfix]wen :<C-u>lnewer<CR>
nnoremap <silent> [Quickfix]wm  :<C-u>lmake<CR>
nnoremap [Quickfix]wM  :<C-u>lmake<Space>
nnoremap [Quickfix]w<Space>  :<C-u>lmake<Space>
nnoremap [Quickfix]wg  :<C-u>lgrep<Space>
"}}}

"}}}

" \: Preview window "{{{
" The prefix key.
nnoremap [Preview]   <Nop>
nmap    \  [Preview]

" Toggle preview window."{{{
nnoremap <silent> [Preview]0  :<C-u>call<SID>preview_window_toggle()<CR>
function! s:preview_window_toggle()
  silent! wincmd P
  if &previewwindow
    pclose
  elseif expand('%') != ''
    mkview
    silent! pedit
    silent! loadview
    if foldclosed(line('.')) != -1
      " Open folding.
      normal! zogv0
    endif
  else
    normal! ma
    silent! pedit
    normal! `a
    if foldclosed(line('.')) != -1
      " Open folding.
      normal! zogv0
    endif
  endif
endfunction"}}}
" Open preview window.
nnoremap [Preview]o  :<C-u>pedit<CR>
" Close preview window.
nnoremap [Preview]c  :<C-u>pclose<CR>
" Move to preview window."{{{
nnoremap <silent> [Preview]p :<C-u>call<SID>move_to_preview_window()<CR>
function! s:move_to_preview_window()
  if &previewwindow
    wincmd p
  else
    silent! wincmd P
  endif
endfunction"}}}
"}}}

" Jump mark can restore column."{{{
nnoremap \  `
" mもMに降格
nnoremap M  m
"}}}

" Don't calc octal.
set nrformats-=octal

" Move search word and fold open."{{{
nnoremap n  nzv
nnoremap N  Nzv
nnoremap #  #zv
nnoremap g*  g*zv
nnoremap g#  g#zv
"}}}

" Smart <C-f>, <C-b>.
nnoremap <silent> <C-f> z<CR><C-f>z.
nnoremap <silent> <C-b> z-<C-b>z.

" Execute help."{{{
nnoremap <C-h>  :<C-u>help<Space>
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>help<Space><C-r><C-w><CR>
"}}}

" Disable ZZ.
nnoremap ZZ  <Nop>

" Like gv, but select the last changed text.
nnoremap gc  `[v`]
" Specify the last changed text as {motion}.
vnoremap <silent> gc  :<C-u>normal gc<CR>
onoremap <silent> gc  :<C-u>normal gc<CR>

" Auto escape / and ? in search command.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Smart }."{{{
nnoremap <silent> } :<C-u>call ForwardParagraph()<CR>
onoremap <silent> } :<C-u>call ForwardParagraph()<CR>
xnoremap <silent> } <Esc>:<C-u>call ForwardParagraph()<CR>mzgv`z
function! ForwardParagraph()
  let cnt = v:count ? v:count : 1
  let i = 0
  while i < cnt
    if !search('^\s*\n.*\S','W')
      normal! G$
      return
    endif
    let i = i + 1
  endwhile
endfunction
"}}}

" Context sensitive H,L."{{{
nnoremap <silent> H :<C-u>call HContext()<CR>
nnoremap <silent> L :<C-u>call LContext()<CR>
xnoremap <silent> H <ESC>:<C-u>call HContext()<CR>mzgv`z
xnoremap <silent> L <ESC>:<C-u>call LContext()<CR>mzgv`z
function! HContext()
  let l:moved = MoveCursor("H")
  if !l:moved && line('.') != 1
    execute "normal! " . "\<pageup>H"
  endif
endfunction
function! LContext()
  let l:moved = MoveCursor("L")

  if !l:moved && line('.') != line('$')
    execute "normal! " . "\<pagedown>L"
  endif
endfunction
function! MoveCursor(key)
  let l:cnum = col('.')
  let l:lnum = line('.')
  let l:wline = winline()

  execute "normal! " . v:count . a:key
  let l:moved =  l:cnum != col('.') || l:lnum != line('.') || l:wline != winline()

  return l:moved
endfunction
"}}}

" Smart home and smart end."{{{
nnoremap <silent> gh  :<C-u>call SmartHome("n")<CR>
nnoremap <silent> gl  :<C-u>call SmartEnd("n")<CR>
xnoremap <silent> gh  <ESC>:<C-u>call SmartHome("v")<CR>
xnoremap <silent> gl  <ESC>:<C-u>call SmartEnd("v")<CR>
nnoremap <expr> gm    (virtcol('$')/2).'\|'
xnoremap <expr> gm    (virtcol('$')/2).'\|'
" Smart home function"{{{
function! SmartHome(mode)
  let l:curcol = col(".")

  if &wrap
    normal! g^
  else
    normal! ^
  endif
  if col(".") == l:curcol
    if &wrap
      normal! g0
    else
      normal! 0
    endif
  endif

  if a:mode == "v"
    normal! msgv`s
  endif

  return ""
endfunction"}}}

" Smart end function"{{{
function! SmartEnd(mode)
  let l:curcol = col(".")
  let l:lastcol = a:mode == "i" ? col("$") : col("$") - 1

  " Gravitate towards ending for wrapped lines
  if l:curcol < l:lastcol - 1
    call cursor(0, l:curcol + 1)
  endif

  if l:curcol < l:lastcol
    if &wrap
      normal! g$
    else
      normal! $
    endif
  else
    normal! g_
  endif

  " Correct edit mode cursor position, put after current character
  if a:mode == "i"
    call cursor(0, col(".") + 1)
  endif

  if a:mode == "v"
    normal! msgv`s
  endif

  return ""
endfunction "}}}
"}}}

" Jump to a line and the line of before and after of the same indent."{{{
" Useful for Python.
nnoremap <silent> g{ :<C-u>call search("^" . matchstr(getline(line(".") + 1), '\(\s*\)') ."\\S", 'b')<CR>^
nnoremap <silent> g} :<C-u>call search("^" . matchstr(getline(line(".")), '\(\s*\)') ."\\S")<CR>^
"}}}

" Select rectangle.
xnoremap r <C-v>
" Select until end of current line in visual mode.
xnoremap v $h

" Insert buffer directory in command line."{{{
" Expand path.
cnoremap <C-x> <C-r>=<SID>GetBufferDirectory(1)<CR>/
" Expand file (not ext).
cnoremap <C-z> <C-r>=<SID>GetBufferDirectory(0)<CR>
function! s:GetBufferDirectory(with_ext)
  if a:with_ext
    let l:path = expand('%:p:h')
  else
    let l:path = expand('%:p:r')
  endif
  let l:cwd = getcwd()
  if match(l:path, l:cwd) != 0
    return l:path
  elseif strlen(l:path) > strlen(l:cwd)
    return strpart(l:path, strlen(l:cwd) + 1)
  else
    return '.'
  endif
endfunction
"}}}

" Paste current line.
nnoremap cp Pjdd
" Paste next line.
nnoremap <silent> gp o<ESC>p^
nnoremap <silent> gP O<ESC>P^
xnoremap <silent> gp o<ESC>p^
xnoremap <silent> gP O<ESC>P^

" Redraw.
nnoremap <silent> <C-l>    :<C-u>redraw!<CR>

" Folding."{{{
" If press h on head, fold close.
"nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press h on head, range fold close.
"xnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'
" Useful command.
nnoremap zz   za
"}}}

" Search a parenthesis.
onoremap <silent> q /["',.{}()[\]<>]<CR>

" Auto escape / substitute.
xnoremap s y:%s/<C-r>=substitute(@0, '/', '\\/', 'g')<Return>//g<Left><Left>

" Use operator-replace.
nmap [Alt]r <Plug>(operator-replace)
xmap [Alt]r <Plug>(operator-replace)
xmap p <Plug>(operator-replace)
xmap P <Plug>(operator-replace)

" Move last modified text.
nnoremap gb `.zz
nnoremap g, g;
nnoremap g; g,

" Change the height of the current window to match the visual selection and scroll
" the text so that all of the selection is visible.
xmap <C-w><C-_>  <C-w>_
xnoremap <silent> <C-w>_  :<C-u><C-r>=line("'>") - line("'<") + 1<CR>wincmd _<CR>`<zt

" Sticky shift in English keyboard."{{{
" Sticky key.
inoremap <expr> ;  <SID>sticky_func()
cnoremap <expr> ;  <SID>sticky_func()
snoremap <expr> ;  <SID>sticky_func()

function! s:sticky_func()
  let l:sticky_table = {
        \',' : '<', '.' : '>', '/' : '?',
        \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')', '-' : '_', '=' : '+',
        \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
        \}
  let l:special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
        \}

  if mode() !~# '^c'
    echo 'Input sticky key: '
  endif
  let l:char = ''

  while l:char == ''
    let l:char = nr2char(getchar())
  endwhile

  if l:char =~ '\l'
    return toupper(l:char)
  elseif has_key(l:sticky_table, l:char)
    return l:sticky_table[l:char]
  elseif has_key(l:special_table, l:char)
    return l:special_table[l:char]
  else
    return ''
  endif
endfunction
"}}}

" Easy escape."{{{
silent! inoremap <unique>jj           <ESC>
onoremap jj           <ESC>
cnoremap jj           <C-c>
onoremap j;           j
inoremap j;           j
cnoremap j;           j
"}}}

" Smart word search."{{{
" Search cursor word by word unit.
nnoremap <silent> *  :<C-u>call <SID>SetSearch('""yiw', 'word')<CR>
" Search cursor word.
nnoremap <silent> g* :<C-u>call <SID>SetSearch('""yiw')<CR>
" Search from cursor to word end.
nnoremap <silent> #  :<C-u>call <SID>SetSearch('""ye')<CR>

" Search selected text.
xnoremap <silent> * :<C-u>call <SID>SetSearch('""vgvy')<CR>
xnoremap <silent> # :<C-u>call <SID>SetSearch('""vgvy')<CR>

""""""""""""""""""""""""""""""
" Set search word.
" If set additional parametar, search by word unit.
""""""""""""""""""""""""""""""
function! s:SetSearch(cmd, ...)
  let saved_reg = @"
  if a:cmd != ''
    silent exec 'normal! '.a:cmd
  endif
  let pattern = escape(@", '\\/.*$^~[]')
  let pattern = substitute(pattern, '\n$', '', '')
  if a:0 > 0
    let pattern = '\<'.pattern.'\>'
  endif
  let @/ = pattern
  let @" = saved_reg
  echo @/
endfunction "}}}

" Execute countable 'n.'.
" EXAMPLE: 3@n
let @n='n.'

" a>, i], etc... "{{{
" <angle>
onoremap aa  a>
xnoremap aa  a>
onoremap ia  i>
xnoremap ia  i>

" [rectangle]
onoremap ar  a]
xnoremap ar  a]
onoremap ir  i]
xnoremap ir  i]

" 'quote'
onoremap aq  a'
xnoremap aq  a'
onoremap iq  i'
xnoremap iq  i'

" "double quote"
onoremap ad  a"
xnoremap ad  a"
onoremap id  i"
xnoremap id  i"
"}}}

" almigh-t
onoremap <silent> q
      \      :for i in range(v:count1)
      \ <Bar>   call search('.\&\(\k\<Bar>\_s\)\@!', 'W')
      \ <Bar> endfor<CR>

" Upcase word.
nnoremap [Alt]u  gUiw
nnoremap U  gU

" Easy home directory."{{{
function! HomedirOrBackslash()
  if getcmdtype() == ':' && (getcmdline() =~# '^e\%[dit] ' || getcmdline() =~? '^r\%[ead]\?!' || getcmdline() =~? '^cd ')
    return '~/'
  else
    return '\'
  endif
endfunction
cnoremap <expr> <Bslash> HomedirOrBackslash()
"}}}

"}}}

"---------------------------------------------------------------------------
" Commands:"{{{
"
" Toggle options. "{{{
function! ToggleOption(option_name)
  execute 'setlocal' a:option_name.'!'
  execute 'setlocal' a:option_name.'?'
endfunction  "}}}
" Toggle variables. "{{{
function! ToggleVariable(variable_name)
  if eval(a:variable_name)
    execute 'let' a:variable_name.' = 0'
  else
    execute 'let' a:variable_name.' = 1'
  endif
  echo printf('%s = %s', a:variable_name, eval(a:variable_name))
endfunction  "}}}

" :Hg (alternative of ':helpg[rep]')"{{{
" Because if use default ':helpgrep', Japanese texts are garbled.
command! -nargs=1 Hg call NewHelpgrep("<args>")
function! NewHelpgrep( arg )
  " Convert helpgrep argments.
  exec ":helpgrep " . iconv(a:arg, "cp932", "utf-8")
endfunction
"}}}

" 指定したファイルとの差分を表示
command! -nargs=1 -complete=file VDsplit vertical diffsplit <args>
" 最後の保存から、どれだけ編集したのか差分を表示
command! DiffOrig vert new | setlocal bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" diffモードを解除する
command! -nargs=0 Undiff setlocal nodiff noscrollbind wrap

" Smart make."{{{
" Unlike normal ':make', don't flick.
function! s:UpdateQuickFix(command, jump, only)
  " Rubyではruby -wcで文法チェックを行う
  if filereadable("Makefile")
    let lines = split(system('make -s'), "\n")
    cgetexpr lines
  else
    " Do ':make'
    if a:command != ''
      if a:only
        " Current file only.
        execute 'make '.expand("%:r").'.o'
      else
        silent make
      endif
    else
      execute "silent make " . a:command
    endif
  endif

  let n_error = len(filter(getqflist(), 'v:val.valid || v:val.type == "E"'))
  let n_warning = len(filter(getqflist(), 'v:val.type == "W"'))
  if n_error == 0
    cclose
    redraw
    echo printf('QuickFix: no error and %d warnings.  :)', n_warning)
  else
    copen

    if a:jump
      cc
      normal! zv
    else
      wincmd p
    endif
    redraw
    echo printf('QuickFix: %d errors and %d warnings.', n_error, n_warning)
  endif
  " for errormarker.vim
  silent doautocmd QuickFixCmdPost make
endfunction"}}}

command! -nargs=? -bar -bang Make call s:UpdateQuickFix("<args>", len('<bang>'), 0)

" arg: 1->enable / 0->disable / omitted->toggle"{{{
function! s:EnableFlyMake(...)
  if a:0
    let b:flymake_enabled = a:1
  else
    let b:flymake_enabled = (!exists('b:flymake_enabled') || !b:flymake_enabled)
  endif
  redraw
  augroup MyAutoCmd
    if s:flymake_enabled
      autocmd BufWritePost * Make
      echo "flymake enabled."
    else
      echo "flymake disabled."
    endif
  augroup END
endfunction"}}}

" Change current directory."{{{
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
  if a:directory == ''
    lcd %:p:h
  else
    execute 'lcd' a:directory
  endif

  if a:bang == ''
    pwd
  endif
endfunction"}}}
call altercmd#define('cd', 'CD')

function! s:Batch() range"{{{
  " read vimscript from selected area.
  let l:selected = getline(a:firstline, a:lastline)
  " get temp file.
  let l:tempfile = tempname()
  " try-finally
  try
    " write vimscript to temp file.
    call writefile(l:selected, l:tempfile)
    try
      " execute temp file.
      execute "source " . l:tempfile
    catch
      " catch exception
      echohl WarningMsg |
            \ echo "EXCEPTION :" v:exception |
            \ echo "THROWPOINT:" v:throwpoint |
            \ echohl None
    endtry
  finally
    " delete temp file.
    if filewritable(l:tempfile)
      call delete(l:tempfile)
    endif
  endtry
endfunction"}}}
" Range source.
command! -range -narg=0 Batch :<line1>,<line2>call s:Batch()

" Substitute indent.
command! -range=% LeadUnderscores <line1>,<line2>s/^\s*/\=repeat('_', strlen(submatch(0)))/g
nnoremap <silent> [Space]u        :LeadUnderscores<CR>
xnoremap <silent> [Space]u        :LeadUnderscores<CR>

" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction"}}}

command! -nargs=1 -bang -bar -complete=file Rename saveas<bang> <args> | call delete(expand('#:p'))

command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
call altercmd#define('grep', 'Grep')
function! s:grep(args)
  let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
  execute 'vimgrep' '/' . escape(substitute(a:args[0], bufname('#'), '#', 'g'), '\&/') . '/j ' . target
  if !empty(getqflist()) | copen | endif
endfunction

" Calc Vim fight power.
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
      \        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
      \        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)

" Capture {{{
command!
      \ -nargs=+ -bang
      \ -complete=command
      \ Capture
      \ call s:cmd_capture([<f-args>], <bang>0)

function! C(cmd)
  redir => result
  silent execute a:cmd
  redir END
  return result
endfunction

function! s:cmd_capture(args, banged) "{{{
  new
  silent put =C(join(a:args))
  1,2delete _
endfunction "}}}
" }}}

" :HighlightWith {filetype} ['a 'b]  XXX: Don't work in some case."{{{
command! -nargs=+ -range=% HighlightWith <line1>,<line2>call s:highlight_with(<q-args>)
xnoremap [Space]h :HighlightWith<Space><C-f>

function! s:highlight_with(args) range
  if a:firstline == 1 && a:lastline == line('$')
    return
  endif
  let c = get(b:, 'highlight_count', 0)
  let ft = matchstr(a:args, '^\w\+')
  if globpath(&rtp, 'syntax/' . ft . '.vim') == ''
    return
  endif
  unlet! b:current_syntax
  let save_isk= &l:isk  " For scheme.
  execute printf('syntax include @highlightWith%d syntax/%s.vim',
        \              c, ft)
  let &l:isk= save_isk
  execute printf('syntax region highlightWith%d start=/\%%%dl/ end=/\%%%dl$/ '
        \            . 'contains=@highlightWith%d',
        \             c, a:firstline, a:lastline, c)
  let b:highlight_count = c + 1
endfunction"}}}
"}}}

"---------------------------------------------------------------------------
" Functions:"{{{
"

" LevenShtein argorithm."{{{
function! CalcLeven(str1, str2)
  let [l:p1, l:p2, l:l1, l:l2] = [[], [], len(a:str1), len(a:str2)]

  for l:i in range(l:l2+1)
    call add(l:p1, l:i)
  endfor
  for l:i in range(l:l2+1)
    call add(l:p2, 0)
  endfor

  for l:i in range(l:l1)
    let l:p2[0] = l:p1[0] + 1
    for l:j in range(l:l2)
      let l:p2[l:j+1] = min([l:p1[l:j] + ((a:str1[l:i] == a:str2[l:j]) ? 0 : 1),
            \l:p1[l:j+1] + 1, l:p2[l:j]+1])
    endfor
    let [l:p1, l:p2] = [l:p2, l:p1]
  endfor

  return l:p1[l:l2]
endfunction"}}}

function! SnipMid(str, len, mask)"{{{
  if a:len >= len(a:str)
    return a:str
  elseif a:len <= len(a:mask)
    return a:mask
  endif

  let len_head = (a:len - len(a:mask)) / 2
  let len_tail = a:len - len(a:mask) - len_head

  return (len_head > 0 ? a:str[: len_head - 1] : '') . a:mask . (len_tail > 0 ? a:str[-len_tail :] : '')
endfunction"}}}

" Search match pair."{{{
function! MatchPair(string, start_pattern, end_pattern, start_cnt)
  let l:end = -1
  let l:start_pattern = '\%(' . a:start_pattern . '\)'
  let l:end_pattern = '\%(' . a:end_pattern . '\)'

  let l:i = a:start_cnt
  let l:max = len(a:string)
  let l:nest_level = 0
  while l:i < l:max
    if match(a:string, l:start_pattern, l:i) >= 0
      let l:i = matchend(a:string, l:start_pattern, l:i)
      let l:nest_level += 1
    elseif match(a:string, l:end_pattern, l:i) >= 0
      let l:end = match(a:string, l:end_pattern, l:i)
      let l:nest_level -= 1

      if l:nest_level == 0
        return l:end
      endif

      let l:i = matchend(a:string, l:end_pattern, l:i)
    else
      break
    endif
  endwhile

  if l:nest_level != 0
    return -1
  else
    return l:end
  endif
endfunction"}}}

" For snipMate.
function! Filename(...)
  let l:filename = expand('%:t:r')
  if l:filename == ''
    return a:0 == 2 ? a:2 : ''
  elseif a:0 == 0 || a:1 == ''
    return l:filename
  else
    return substitute(a:1, '$1', l:filename, 'g')
  endif
endfunction
"}}}

"---------------------------------------------------------------------------
" Platform depends:"{{{
"
if s:iswin
  " For Windows"{{{

  " WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
  if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
  endif

  " Shell settings.
  " Use NYAOS.
  "set shell=nyaos.exe
  "set shellcmdflag=-e
  "set shellpipe=\|&\ tee
  "set shellredir=>%s\ 2>&1
  "set shellxquote=\"

  " Use bash.
  "set shell=bash.exe
  "set shellcmdflag=-c
  "set shellpipe=2>&1\|\ tee
  "set shellredir=>%s\ 2>&1
  "set shellxquote=\"

  " Change colorscheme.
  " Don't override colorscheme.
  if !exists('g:colors_name') && !has('gui_running')
    colorscheme darkblue
  endif
  " Disable error messages.
  let g:CSApprox_verbose_level = 0

  " そこそこ見れる補完リストにする
  hi Pmenu ctermbg=8
  hi PmenuSel ctermbg=1
  hi PmenuSbar ctermbg=0

  " Display the directory of the baing current buffer in afx.
  noremap <silent> <F1> :execute '!start runafx.bat' '-s "-p%:p"'<cr>
  "}}}
else
  " For Linux"{{{

  if exists('$WINDIR')
    " Cygwin.

    " Use bash.
    set shell=bash
  else
    " Use zsh.
    set shell=zsh
  endif

  " Set path.
  let $PATH = expand('~/bin').':/usr/local/bin/:'.$PATH

  " For non GVim.
  if !has('gui_running')
    " Enable 256 color terminal.
    set t_Co=256

    if has('gui')
      " Use CSApprox.vim

      " Convert colorscheme in Konsole.
      let g:CSApprox_konsole = 1
      let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
      if !exists('g:colors_name')
        colorscheme candy
      endif
    else
      " Use guicolorscheme.vim
      autocmd MyAutoCmd VimEnter,BufAdd * if !exists('g:colors_name') | GuiColorScheme candy
      
      " Disable error messages.
      let g:CSApprox_verbose_level = 0
    endif

    " For prevent bug.
    autocmd MyAutoCmd VimLeave * set term=screen

    " For screen."{{{
    if &term =~ '^screen'
      augroup MyAutoCmd
        " Show filename on screen statusline.
        " But invalid 'another' screen buffer.
        autocmd BufEnter * if $WINDOW != 0 &&  bufname("") !~ "[A-Za-z0-9\]*://"
              \ | silent! exe '!echo -n "kv:%:t\\"' | endif
        " なぜかは知らないがmouseを空にしないと終了時にフリーズする
        autocmd VimLeave * :set mouse=
      augroup END

      " screenでマウスを使用するとフリーズするのでその対策
      set ttymouse=xterm2

      " Split Vim and screen.
      function! ScreenSpiritOpen(cmd)
        call system("screen -X eval split  focus 'screen " . a:cmd ."' focus")
      endfunction
      function! ScreenEval(str)
        let s = substitute(a:str, "[\n]*$", "\n\n", "") " 最後が改行 * 2で終わるようにする。
        call writefile(split(s, "\n"), "/tmp/vim-screen", "b")
        call system("screen -X eval focus 'readreg p /tmp/vim-screen' 'paste p' focus")
      endfunction

      command! -nargs=1 Screen call ScreenSpiritOpen("<args>")

      " Pseudo :suspend with automtic cd.
      " Assumption: Use GNU screen.
      " Assumption: There is a window with the title "another".
      noremap <silent> <C-z>  :<C-u>call PseudoSuspendWithAutomaticCD()<CR>

      if !exists('g:gnu_screen_availablep')
        " Check the existence of $WINDOW to avoid using GNU screen in Vim on
        " a remote machine (for example, "screen -t remote ssh example.com").
        let g:gnu_screen_availablep = len($WINDOW) != 0
      endif
      function! PseudoSuspendWithAutomaticCD()
        if g:gnu_screen_availablep
          " \015 = <C-m>
          " To avoid adding the cd script into the command-line history,
          " there are extra leading whitespaces in the cd script.
          silent execute '!screen -X eval'
                \         '''select another'''
                \         '''stuff " cd \"'.getcwd().'\"  \#\#,vim-auto-cd\015"'''
          redraw!
          let g:gnu_screen_availablep = (v:shell_error == 0)
        endif

        if !g:gnu_screen_availablep
          suspend
        endif
      endfunction
    endif
    "}}}
  endif

  "}}}
endif

"}}}

"---------------------------------------------------------------------------
" Others:"{{{
"
" Enable mouse support.
set mouse=a

" If true Vim master, use English help file.
set helplang& helplang=en,ja

" Default home directory.
let g:home = getcwd()

" Each tab has current directory."{{{
command! -nargs=? TabCD
      \   execute 'cd' fnameescape(<q-args>)
      \ | let t:cwd = getcwd()

autocmd MyAutoCmd TabEnter *
      \   if !exists('t:cwd')
      \ |   let t:cwd = getcwd()
      \ | endif
    \ | execute 'cd' fnameescape(t:cwd)

" Exchange ':cd' to ':TabCD'.
cnoreabbrev <expr> lhs (getcmdtype() == ':' && getcmdline() ==# 'cd') ? 'TabCD' : 'cd'
"}}}

" For snipMate.
let g:snips_author = 'Shougo'
"}}}

set secure

"
" vim: foldmethod=marker
