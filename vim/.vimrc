"---------------------------------------------------------------------------
" Shougo's .vimrc
"---------------------------------------------------------------------------
" Initialize:"{{{
"

" Enable no Vi compatible commands.
set nocompatible

let s:is_windows = has('win32') || has('win64')

" Use English interface.
if s:is_windows
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

if s:is_windows
  " Exchange path separator.
  set shellslash
endif

" In Windows/Linux, take in a difference of ".vim" and "$VIM/vimfiles".
let $DOTVIM = expand('~/.vim')

" Because a value is not set in $MYGVIMRC with the console, set it.
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand('~/.gvimrc')
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

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

if filereadable(expand('~/.secret_vimrc'))
  execute 'source' expand('~/.secret_vimrc')
endif

filetype off

if has('vim_starting')"{{{
  " Load settings for each location.
  function! s:vimrc_local(loc)
    let files = findfile('vimrc_local.vim', escape(a:loc, ' '), -1)
    for i in reverse(filter(files, 'filereadable(v:val)'))
      source `=i`
    endfor
  endfunction

  " Set runtimepath.
  if s:is_windows
    let &runtimepath = join([
          \ expand('~/.vim'),
          \ expand('$VIM/runtime'),
          \ expand('~/.vim/after')], ',')
  endif

  call s:vimrc_local(getcwd())

  " Load neobundle.
  if &runtimepath !~ '/neobundle.vim'
    execute 'set runtimepath+=' . expand('~/.bundle/neobundle.vim')
  endif

  " Enable syntax color.
  syntax enable
endif
"}}}

let g:neobundle_enable_tail_path = 1

call neobundle#rc(expand('~/.bundle'))

" neobundle.vim"{{{
NeoBundle 'anyakichi/vim-surround'
NeoBundleLazy 'basyura/TweetVim'
NeoBundleLazy 'basyura/twibill.vim'
" NeoBundleLazy 'c9s/perlomni.vim'
NeoBundleLazy 'choplin/unite-vim_hacks'
NeoBundleLazy 'liquidz/vimfiler-sendto'
NeoBundle 'Shougo/echodoc'
NeoBundle 'Shougo/neocomplcache',

NeoBundle 'Shougo/neosnippet'
" NeoBundle 'git@github.com:Shougo/neocomplcache-snippets-complete.git'

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-build'
NeoBundle 'Shougo/unite-ssh'
NeoBundle 'Shougo/vim-vcs',
      \ { 'depends' : 'thinca/vim-openbuf' }
NeoBundle 'Shougo/vimfiler',
      \ { 'depends' : 'Shougo/unite.vim' }
" NeoBundle 'Shougo/vimfiler', 'ver.1.50'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vim-ft-vim_fold'

NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vinarise'
" NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'Shougo/unite-outline'
NeoBundleLazy 'hail2u/vim-css3-syntax'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'kana/vim-smartword'
NeoBundle 'kana/vim-smarttill'
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'kana/vim-textobj-user'
" NeoBundleLazy 'kana/vim-wwwsearch'
NeoBundleLazy 'kien/ctrlp.vim'
NeoBundle 'Shougo/foldCC'
NeoBundleLazy 'mattn/wwwrenderer-vim'
NeoBundle 'mattn/webapi-vim'
" NeoBundle 'basyura/webapi-vim'
" NeoBundle 'pocket7878/presen-vim',
" \ { 'depends' : 'pocket7878/curses-vim'}
NeoBundleLazy 'rson/vim-conque'
NeoBundle 'sjl/gundo.vim'
NeoBundle 't9md/vim-surround_custom_mapping'
" NeoBundle 't9md/vim-textmanip'
" NeoBundle 't9md/vim-quickhl'
NeoBundleLazy 'thinca/vim-fontzoom'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-scouter'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-unite-history'
if !has('gui_running') || s:is_windows
  NeoBundle 'tsukkee/lingr-vim'
else
  NeoBundleLazy 'tsukkee/lingr-vim'
endif
NeoBundle 'Shougo/unite-help'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/eskk.vim',
NeoBundleLazy 'tyru/open-browser.vim'
NeoBundleLazy 'tyru/operator-html-escape.vim'
NeoBundle 'tyru/restart.vim'
" NeoBundle 'tyru/skk.vim'
NeoBundle 'tyru/vim-altercmd'
NeoBundle 'tyru/winmove.vim'
NeoBundleLazy 'ujihisa/neco-ghc',
NeoBundle 'ujihisa/neco-look'
NeoBundleLazy 'ujihisa/unite-colorscheme'
NeoBundleLazy 'ujihisa/unite-locate.git'
NeoBundle 'ujihisa/vimshell-ssh.git'
NeoBundle 'vim-jp/vimdoc-ja.git'
NeoBundle 'vim-scripts/netrw.vim.git'
NeoBundleLazy 'vim-ruby/vim-ruby.git'
" NeoBundleLazy 'Markdown'
NeoBundleLazy 'yuratomo/w3m.vim'
NeoBundle 'pasela/unite-webcolorname'
" NeoBundle 'hrsh7th/vim-unite-vcs'
NeoBundle 'deris/vim-loadafterft'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'osyo-manga/unite-filetype'
"NeoBundle 'taglist.vim'
NeoBundle 'rbtnn/hexript.vim', {'external_commands' : 'xxd'}
NeoBundle 'vim-jp/vital.vim'
NeoBundleLazy 'tpope/vim-endwise'
NeoBundleLazy 'Rip-Rip/clang_complete'
NeoBundle 'kana/vim-tabpagecd'
NeoBundle 'rhysd/accelerated-jk'
" NeoBundle 'gmarik/vundle'
NeoBundle 'davidhalter/jedi-vim.git'

" From vim.org
NeoBundleLazy 'CSApprox'
NeoBundleLazy 'guicolorscheme.vim'
NeoBundle 'sudo.vim'
NeoBundle 'repeat.vim'
NeoBundle 'autodate.vim'
NeoBundle 'matchit.zip'
NeoBundle 'autofmt'
" NeoBundle 'perl-mauke.vim'
NeoBundle 'DirDiff.vim'
" NeoBundle 'taichouchou2/alpaca_complete.git'

" NeoBundle 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim',
"       \ {'script_type' : 'plugin'}

" nosync test.
" NeoBundleLazy 'yanktmp', {
"       \ 'type' : 'nosync', 'base' : '~/.vim/bundle'
"       \ }

" Test.
" NeoBundleLazy 'tpope/vim-fugitive'
" NeoBundleLazy 'masudaK/vim-python'
" NeoBundleLazy 'klen/python-mode'
" autocmd MyAutoCmd FileType python* NeoBundleSource python-mode vim-python
"}}}

filetype plugin indent on

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  " finish
endif

" altercommand.vim
call altercmd#load()
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
elseif s:is_windows
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
function! AU_ReCheck_FENC() "{{{
  if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
    let &fileencoding=&encoding
  endif
endfunction"}}}

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
command! -bang -bar -complete=file -nargs=? Dos edit<bang> ++fileformat=dos <args>
command! -bang -bar -complete=file -nargs=? Mac edit<bang> ++fileformat=mac <args>
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos write<bang> ++fileformat=dos <args> | edit <args>
command! -bang -complete=file -nargs=? WMac write<bang> ++fileformat=mac <args> | edit <args>
"}}}

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif
"}}}

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
set hlsearch

" Searches wrap around the end of the file.
set wrapscan
"}}}

"---------------------------------------------------------------------------
" Edit:"{{{
"

" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" Substitute <Tab> with blanks.
"set tabstop=8
" Spaces instead <Tab>.
"set softtabstop=4
" Autoindent width.
"set shiftwidth=4
" Round indent by shiftwidth.
set shiftround

" Enable modeline.
set modeline

" Use clipboard register.
if has('unnamedplus')
  set clipboard& clipboard+=unnamedplus
else
  set clipboard& clipboard+=unnamed
endif

" Disable auto wrap.
autocmd MyAutoCmd FileType *
      \ if &l:textwidth != 70 && &filetype !=# 'help' |
      \    setlocal textwidth=0 |
      \ endif

" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" Highlight parenthesis.
set showmatch
" Highlight when CursorMoved.
set cpoptions-=m
set matchtime=3
" Highlight <>.
set matchpairs+=<:>

" Display another buffer when current buffer isn't saved.
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
" set foldmethod=expr
set foldmethod=marker
" Show folding level.
set foldcolumn=3
set foldcolumn=3
set fillchars=vert:\|
set commentstring=%s

if exists('*FoldCCtext')
  " Use FoldCCtext().
  set foldtext=FoldCCtext()
  autocmd MyAutoCmd FileType *
        \               if &filetype !=# 'help'
        \             |   setlocal foldtext=FoldCCtext()
        \             | endif
endif

" augroup foldmethod-expr
"   autocmd!
"   autocmd InsertEnter * if &l:foldmethod ==# 'expr'
"   \                   |   let b:foldinfo = [&l:foldmethod, &l:foldexpr]
"   \                   |   setlocal foldmethod=manual foldexpr=0
"   \                   | endif
"   autocmd InsertLeave * if exists('b:foldmethod')
"   \                   |   let [&l:foldmethod, &l:foldexpr] = b:foldinfo
"   \                   | endif
" augroup END

" Use vimgrep.
"set grepprg=internal
" Use grep.
set grepprg=grep\ -nH

" Exclude = from isfilename.
set isfname-==

" Reload .vimrc and .gvimrc automatically.
if !has('gui_running') && !s:is_windows
  autocmd MyAutoCmd BufWritePost .vimrc nested source $MYVIMRC | echo "source $MYVIMRC"
else
  autocmd MyAutoCmd BufWritePost .vimrc source $MYVIMRC |
        \ if has('gui_running') | source $MYGVIMRC | echo "source $MYVIMRC"
  autocmd MyAutoCmd BufWritePost .gvimrc if has('gui_running') | source $MYGVIMRC | echo "source $MYGVIMRC"
endif

" Keymapping timeout.
set timeout timeoutlen=3000 ttimeoutlen=100

" CursorHold time.
set updatetime=1000

" Set swap directory.
set directory-=.

if v:version >= 703
  " Set undofile.
  set undofile
  let &undodir=&directory
endif

" Set tags file.
" Don't search tags file in current directory. And search upward.
set tags& tags-=tags tags+=./tags;
if v:version < 7.3 || (v:version == 7.3 && !has('patch336'))
  " Vim's bug.
  set notagbsearch
endif

" Enable virtualedit in visual block mode.
set virtualedit=block

" Set keyword help.
set keywordprg=:help

" Check timestamp more for 'autoread'.
autocmd MyAutoCmd WinEnter * checktime

" Disable paste.
autocmd MyAutoCmd InsertLeave * if &paste | set nopaste | endif

" Use autofmt.
set formatexpr=autofmt#japanese#formatexpr()
"}}}

"---------------------------------------------------------------------------
" View:"{{{
"
" Show line number.
"set number
" Show <TAB> and <CR>
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<
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
let &titlestring="%{(&filetype ==# 'lingr-messages' && lingr#unread_count() > 0 )?"
      \ . " '('.lingr#unread_count().')' : ''}%{expand('%:p:.:~')}%(%m%r%w%)"
      \ . " \ %<\(%{SnipMid(fnamemodify(&filetype ==# 'vimfiler' ?"
      \ . "substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),"
      \ . "80-len(expand('%:p:.')),'...')}\) - VIM"

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''

  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears

    let no = (i <= 10 ? i : '#')  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '

    " Use gettabvar().
    let title = exists('*gettabvar') && gettabvar(i, 'title') != '' ?
          \ gettabvar(i, 'title') : 'No Name'

    let title = '[' . title . ']'

    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor

  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2

" Set statusline.
let &statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
      \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
      \ . "%{expand('%:p:.')}"
      \ . "%{".s:SID_PREFIX()."get_twitter_len()}"
      \ . "\ %=%m%y%{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}"
      \ . "%{printf(' %5d/%d',line('.'),line('$'))}"

function! s:get_twitter_len()
  return &filetype !=# 'int-earthquake' || mode() !=# 'i' ? '' :
        \ '(rest:' . (140 - len(substitute(vimshell#get_cur_text(),'.','x','g'))) . ')'
endfunction

" Turn down a long line appointed in 'breakat'
set linebreak
set showbreak=>\
set breakat=\ \	;:,!?

" Do not display greetings message at the time of Vim start.
set shortmess=aTI

" Don't create backup.
set nowritebackup
set nobackup
set backupdir-=.

" Disable bell.
set vb t_vb=
set novisualbell

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
set completeopt=menuone
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
set winwidth=30
" Set minimal height for current window.
" set winheight=20
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways

" Adjust window size of preview and help.
set previewheight=10
set helpheight=12

" Don't redraw while macro executing.
set lazyredraw

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
"set display+=uhex

" Disable automatically insert comment.
autocmd MyAutoCmd FileType * setl formatoptions-=ro | setl formatoptions+=mM
let g:execcmd_after_ftplugin = {
  \    '_': [
  \        'setlocal fo-=t fo-=c fo-=r fo-=o',
  \    ],
  \    'c': [
  \        'setlocal fo-=t fo-=c fo-=r fo-=o',
  \    ],
  \    'perl': [
  \        'setlocal fo-=t fo-=c fo-=r fo-=o',
  \    ],
  \}
let g:execcmd_after_indent = {
  \    '_': [
  \        'setlocal fo-=t fo-=c fo-=r fo-=o',
  \    ],
  \    'php': [
  \        'setlocal fo-=t fo-=c fo-=r fo-=o',
  \    ],
  \}

" Enable multibyte format.
set formatoptions+=mM

if v:version >= 703
  " For conceal.
  set conceallevel=2 concealcursor=iv

  set colorcolumn=85
endif

" Restore view.
set viewdir=~/.vim/view viewoptions-=options viewoptions+=slash,unix
augroup MyAutoCmd
  autocmd BufLeave * if expand('%') !=# '' && &buftype ==# ''
  \                |   mkview
  \                | endif
  autocmd BufReadPost * if !exists('b:view_loaded') &&
  \                         expand('%') !=# '' && &buftype ==# ''
  \                   |   silent! loadview
  \                   |   let b:view_loaded = 1
  \                   | endif
  autocmd VimLeave * call map(split(glob(&viewdir . '/*'), "\n"),
  \                           'delete(v:val)')
augroup END
"}}}

"---------------------------------------------------------------------------
" Syntax:"{{{
"
" Enable smart indent.
set autoindent smartindent

augroup MyAutoCmd
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
  autocmd FileType help,git-status,git-log,qf,gitcommit,quickrun,qfreplace,ref,simpletap-summary,vcs-commit,vcs-status,vim-hacks
        \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif

  " Close help and git window by pressing q.
  autocmd FileType ref nnoremap <buffer> <TAB> <C-w>w

  autocmd FileType c setlocal foldmethod=syntax

  autocmd FileType c,cpp NeoBundleSource clang_complete

  " Enable omni completion.
  autocmd FileType ada setlocal omnifunc=adacomplete#Complete
  autocmd FileType c setlocal omnifunc=ccomplete#Complete
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  "autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  "autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  autocmd FileType python setlocal foldmethod=indent

  " Update filetype.
  autocmd BufWritePost
  \ * if &l:filetype ==# '' || exists('b:ftdetect')
  \ |   unlet! b:ftdetect
  \ |   filetype detect
  \ | endif
augroup END

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

" Bash
let g:is_bash = 1

" Syntax highlight for user commands.
augroup syntax-highlight-extends
  autocmd!
  autocmd Syntax vim call s:set_syntax_of_user_defined_commands()
augroup END

function! s:set_syntax_of_user_defined_commands()
  redir => _
  silent! command
  redir END

  let command_names = map(split(_, '\n')[1:],
        \ "matchstr(v:val, '^[!\"b]*\s\+\zs\u\w*\ze')")

  if empty(command_names) | return | endif

  execute 'syntax keyword vimCommand contained ' . join(command_names)
endfunction

"}}}

"---------------------------------------------------------------------------
" Plugin:"{{{
"

" yanktmp.vim"{{{
" Because I don't use it that much, I demote it to Ty.
nnoremap    [yanktmp]   <Nop>
xnoremap    [yanktmp]   <Nop>
nmap    T [yanktmp]
xmap    T [yanktmp]
nmap <silent> [yanktmp]y    <Plug>(yanktmp_yank)
xmap <silent> [yanktmp]y    <Plug>(yanktmp_yank)
nmap <silent> [yanktmp]p    <Plug>(yanktmp_paste_p)
xmap <silent> [yanktmp]p    <Plug>(yanktmp_paste_p)
nmap <silent> [yanktmp]P    <Plug>(yanktmp_paste_P)
xmap <silent> [yanktmp]P    <Plug>(yanktmp_paste_P)
"}}}

" neocomplcache.vim"{{{
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 0
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 0
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 0
" Use fuzzy completion.
let g:neocomplcache_enable_fuzzy_completion = 1
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
let g:neocomplcache_enable_prefetch = 0

if !exists('g:neocomplcache_wildcard_characters')
  let g:neocomplcache_wildcard_characters = {}
endif
let g:neocomplcache_wildcard_characters._ = '-'

" For auto select.
let g:neocomplcache_enable_auto_select = 1

let g:neocomplcache_enable_auto_delimiter = 1
"let g:neocomplcache_disable_caching_buffer_name_pattern = '[\[*]\%(unite\)[\]*]'
let g:neocomplcache_disable_auto_select_buffer_name_pattern = '\[Command Line\]'
" let g:neocomplcache_lock_buffer_name_pattern = '\.txt'
"let g:neocomplcache_disable_auto_complete = 0
let g:neocomplcache_max_list = 100
let g:neocomplcache_force_overwrite_completefunc = 1
if $USER ==# 'root'
  let g:neocomplcache_temporary_dir = '/root/.neocon'
endif
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif

" For clang_complete.
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_force_omni_patterns.c =
      \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_use_library   = 1

" For jedi-vim.
let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0
let g:jedi#rename_command = '<leader>R'
autocmd MyAutoCmd FileType python let b:did_ftplugin = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'scheme' : expand('~/.gosh_completions'),
      \ 'scala' : expand('$DOTVIM/dict/scala.dict'),
      \ 'ruby' : expand('$DOTVIM/dict/ruby.dict'),
      \ 'int-termtter' : expand('~/.vimshell/int-history/int-termtter'),
      \ 'hoge' : expand('~/work/test.dic'),
      \ }

let g:neocomplcache_omni_functions = {
      \ 'ruby' : 'rubycomplete#Complete',
      \ }

" Define keyword pattern.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
" let g:neocomplcache_keyword_patterns.default = '\h\w*'
let g:neocomplcache_keyword_patterns['default'] = '[0-9a-zA-Z:#_]\+'
let g:neocomplcache_keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

let g:neocomplcache_snippets_dir = $HOME . '/snippets'

if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.mail = '^\s*\w\+'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_caching_limit_file_size = 500000

if !exists('g:neocomplcache_same_filetype_lists')
  let g:neocomplcache_same_filetype_lists = {}
endif
"let g:neocomplcache_same_filetype_lists.perl = 'ref'

" let g:neocomplcache_source_look_dictionary_path = $HOME . '/words'
let g:neocomplcache_source_look_dictionary_path = ''

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
if !exists('g:neocomplcache_source_completion_length')
  let g:neocomplcache_source_completion_length = {
        \ 'look' : 4,
        \ }
endif

" Plugin key-mappings."{{{
imap <silent>L     <Plug>(neocomplcache_snippets_expand)
smap <silent>L     <Plug>(neocomplcache_snippets_jump)
imap <silent>G     <Plug>(neocomplcache_snippets_force_expand)
imap <silent>S     <Plug>(neosnippet_start_unite_snippet)
" imap <silent>J     <Plug>(neocomplcache_snippets_jump)

inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()
"}}}

" Test."{{{
"let g:neocomplcache_auto_completion_start_length = 1
"let g:neocomplcache_plugin_completion_length = {
"\ 'snippets_complete' : 1,
"\ 'buffer_complete' : 2,
"\ 'syntax_complete' : 2,
"\ 'tags_complete' : 3,
"\ 'vim_complete' : 4,
"\ }
let g:neocomplcache_source_disable = {
      \ 'tags_complete' : 1,
      \}
"}}}
" let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'

" For neocomplcache."{{{
" <C-f>, <C-b>: page move.
inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   : "\<Left>"
" <C-y>: paste.
inoremap <expr><C-y>  pumvisible() ? neocomplcache#close_popup() :  "\<C-r>\""
" <C-e>: close popup.
inoremap <expr><C-e>  pumvisible() ? neocomplcache#cancel_popup() : "\<End>"
" <C-k>: unite completion.
imap <C-k>  <Plug>(neocomplcache_start_unite_complete)
" - unite quick match.
" imap <expr> -  pumvisible() ?
"       \ "\<Plug>(neocomplcache_start_unite_quick_match)" : '-'
inoremap <expr> O  &filetype == 'vim' ? "\<C-x>\<C-v>" : "\<C-x>\<C-o>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" <C-n>: neocomplcache.
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
" <C-p>: keyword completion.
inoremap <expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
inoremap <expr>'  pumvisible() ? neocomplcache#close_popup() : "'"

inoremap <expr><C-x><C-f>  neocomplcache#manual_filename_complete()

imap <C-s>  <Plug>(neocomplcache_start_unite_snippet)

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ neocomplcache#start_manual_complete()
function! s:check_back_space()"{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

" For cursor moving in insert mode(Not recommended)
inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
"}}}

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
"}}}

" echodoc.vim"{{{
let g:echodoc_enable_at_startup = 1
"}}}

" vimshell.vim"{{{
" let g:vimshell_user_prompt = "3\ngetcwd()"
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
"let g:vimshell_user_prompt = 'printf("%s  %50s", fnamemodify(getcwd(), ":~"), vimshell#vcs#info("(%s)-[%b]"))'
" let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
let g:vimshell_prompt = '% '
"let g:vimshell_environment_term = 'xterm'
let g:vimshell_split_command = ''

if s:is_windows
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


autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings()
  imap <buffer><silent> &  <C-o>:call vimshell#mappings#push_and_execute('cd ..')<CR>

  inoremap <buffer><expr>'  pumvisible() ? "\<C-y>" : "'"
  imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-h>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-k>  <Plug>(vimshell_zsh_complete)

  nnoremap <silent><buffer> J
        \ <C-u>:Unite -buffer-name=files -default-action=lcd directory_mru<CR>

  call vimshell#altercmd#define('g', 'git')
  call vimshell#altercmd#define('i', 'iexe')
  call vimshell#altercmd#define('t', 'texe')
  call vimshell#set_alias('l.', 'ls -d .*')
  call vimshell#set_alias('gvim', 'gexe gvim')
  call vimshell#set_galias('L', 'ls -l')
  call vimshell#set_galias('time', 'exe time -p')
  call vimshell#hook#add('chpwd', 'my_chpwd', s:vimshell_hooks.chpwd)
  call vimshell#hook#add('emptycmd', 'my_emptycmd', s:vimshell_hooks.emptycmd)
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
  inoremap <silent><buffer><expr> <Plug>(vimshell_term_send_semicolon) vimshell#term_mappings#send_key(';')
  inoremap <silent><buffer><expr> j<Space> vimshell#term_mappings#send_key('j')
  "inoremap <silent><buffer><expr> <Up> vimshell#term_mappings#send_keys("\<ESC>[A")

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
        \"\<ESC>" : "\<ESC>", "\<Space>" : "\<Plug>(vimshell_term_send_semicolon)", "\<CR>" : ";\<CR>"
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
  endif
endfunction
function! s:vimshell_hooks.emptycmd(cmdline, context)
  call vimshell#set_prompt_command('ls')
  return 'ls'
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

" Plugin key-mappings."{{{
" <C-Space>: switch to vimshell.
nmap <C-@>  <Plug>(vimshell_switch)
nnoremap !  q:VimShellExecute<Space>
nnoremap [Space]i  q:VimShellInteractive<Space>
nnoremap [Space]t  q:VimShellTerminal<Space>

nnoremap <silent> [Space];  <C-u>:VimShellPop<CR>
"}}}
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

" vinarise.vim"{{{
let g:vinarise_enable_auto_detect = 1
"}}}

" errormarker.vim"{{{
let errormarker_errortext      = '!!'
let errormarker_warningtext    = '??'
let g:errormarker_errorgroup   = 'Error'
let g:errormarker_warninggroup = 'Todo'
let g:errormarker_erroricon    = $DOTVIM . '/signs/err.'
      \ . (s:is_windows ? 'bmp' : 'png')
let g:errormarker_warningicon  = $DOTVIM . '/signs/warn.'
      \ . (s:is_windows ? 'bmp' : 'png')
"}}}

" git.vim{{{
let g:git_no_default_mappings = 1
let g:git_use_vimproc = 1
let g:git_command_edit = 'rightbelow vnew'
nnoremap <silent> [Space]gd :<C-u>GitDiff --cached<CR>
nnoremap <silent> [Space]gD :<C-u>GitDiff<CR>
" nnoremap <silent> [Space]gs :<C-u>GitStatus<CR>
nnoremap <silent> [Space]gl :<C-u>GitLog<CR>
nnoremap <silent> [Space]gL :<C-u>GitLog -u \| head -10000<CR>
nnoremap <silent> [Space]ga :<C-u>GitAdd<CR>
nnoremap <silent> [Space]gA :<C-u>GitAdd <cfile><CR>
" nnoremap <silent> [Space]gc :<C-u>GitCommit<CR>
nnoremap <silent> [Space]gp q:Git push<Space>
nnoremap <silent> [Space]gt q:Git tag<Space>
"}}}

" vcs.vim{{{
nnoremap <silent> [Space]gc :<C-u>Vcs commit<CR>
nnoremap <silent> [Space]gC :<C-u>Vcs commit --amend<CR>
nnoremap <silent> [Space]gs :<C-u>Vcs status<CR>
"}}}

" unite.vim"{{{
" The prefix key.
nnoremap    [unite]   <Nop>
xnoremap    [unite]   <Nop>
nmap    ;u [unite]
xmap    ;u [unite]

AlterCommand <cmdwin> u[nite] Unite

nnoremap [unite]u  q:Unite<Space>
" nnoremap <silent> :  :<C-u>Unite history/command command<CR>
nnoremap <expr><silent> ;b  <SID>unite_build()
function! s:unite_build()
  return ":\<C-u>Unite -buffer-name=build". tabpagenr() ." -no-quit build\<CR>"
endfunction
nnoremap <silent> ;o
      \ :<C-u>Unite outline -start-insert<CR>
nnoremap  [unite]f  :<C-u>Unite source<CR>
nnoremap <silent> ;t
      \ :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
xnoremap <silent> ;r
      \ d:<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> ;w
      \ :<C-u>UniteWithCursorWord -buffer-name=register
      \ buffer file_mru bookmark file<CR>
nnoremap <silent> <C-k>
      \ :<C-u>Unite change jump<CR>
nnoremap <silent> ;g
      \ :<C-u>Unite grep -buffer-name=search -no-quit<CR>
nnoremap <silent> ;r
      \ :<C-u>Unite -buffer-name=register register history/yank<CR>
inoremap <silent><expr> <C-z>
      \ unite#start_complete('register', { 'input': unite#get_cur_text() })

" <C-t>: Tab pages
nnoremap <silent> <C-t>       :<C-u>Unite tab<CR>
"}}}


if s:is_windows
  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line
        \ jump_point file_point buffer_tab
        \ file_rec:! file file/new file_mru<CR>
else
  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line
        \ jump_point file_point buffer_tab
        \ file_rec/async:! file file/new file_mru<CR>
endif
nnoremap <silent> [Window]t
      \ :<C-u>Unite -buffer-name=files tab<CR>
nnoremap <silent> [Window]w
      \ :<C-u>Unite window<CR>
nnoremap <silent> [Space]b
      \ :<C-u>UniteBookmarkAdd<CR>

" t: tags-and-searches "{{{
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Jump.
" nnoremap [Tag]t  <C-]>
nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "\<C-]>" :
      \ ":\<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include\<CR>"
" Jump next.
nnoremap <silent> [Tag]n  :<C-u>tag<CR>
" Jump previous.
" nnoremap <silent> [Tag]p  :<C-u>pop<CR>
nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
      \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
"}}}

" Execute help.
" nnoremap <C-h>  :<C-u>help<Space>
" nnoremap <C-h>  :<C-u>UniteWithInput help<CR>
nnoremap <silent> <C-h>  :<C-u>Unite -buffer-name=help help<CR>

" Execute help by cursor keyword.
" nnoremap <silent> g<C-h>  :<C-u>help<Space><C-r><C-w><CR>
nnoremap <silent> g<C-h>  :<C-u>UniteWithInput help<CR>

" Search.
" nnoremap <expr> /  <SID>smart_search_expr('/',
nnoremap <expr><silent> /  <SID>smart_search_expr(
      \ ":\<C-u>Unite -buffer-name=search -no-split -start-insert line/fast\<CR>",
      \ ":\<C-u>Unite -buffer-name=search -start-insert line\<CR>")
nnoremap <expr> g/  <SID>smart_search_expr('g/',
      \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>")
nnoremap [Alt]/  g/
nnoremap <silent><expr> ? <SID>smart_search_expr('?',
      \ ":\<C-u>Unite mapping\<CR>")
" nnoremap <silent><expr> * <SID>smart_search_expr('*',
nnoremap <silent><expr> * <SID>smart_search_expr(
      \ ":\<C-u>UniteWithCursorWord -buffer-name=search line/fast\<CR>",
      \ ":\<C-u>UniteWithCursorWord -buffer-name=search line\<CR>")

function! s:smart_search_expr(expr1, expr2)
  return line('$') > 5000 ?  a:expr1 : a:expr2
endfunction

nnoremap <silent> n
      \ :<C-u>UniteResume search -no-start-insert<CR>

let g:unite_enable_split_vertically = 0

let g:unite_source_history_yank_enable = 1

let g:unite_winheight = 20

autocmd MyAutoCmd FileType unite call s:unite_my_settings()

" Directory partial match.
" call unite#set_substitute_pattern('files',
"      \'\%([~.*]\+\)\@<!/', '*/*', 100)
" call unite#set_substitute_pattern('files', '^\\',
"      \ substitute(substitute($HOME, '\\', '/', 'g'), ' ', '\\ ', 'g') . '/*', -100)
" Test.
" call unite#set_substitute_pattern('files', '^\.v/',
"      \ unite#util#substitute_path_separator($HOME).'/.vim/', 1000)
call unite#set_substitute_pattern('files', '^\.v/',
      \ [expand('~/.vim/'), unite#util#substitute_path_separator($HOME)
      \ . '/.bundle/*/'], 1000)
call unite#set_substitute_pattern('files', '\.', '*.', 1000)
call unite#custom_alias('file', 'h', 'left')
call unite#custom_default_action('directory', 'narrow')
" call unite#custom_default_action('file', 'my_tabopen')
call unite#set_substitute_pattern('file', '[^~.]\zs/', '*/*', 20)

call unite#set_profile('action', 'context', {'start_insert' : 1})

" migemo.
call unite#custom_filters('line_migemo',
      \ ['matcher_migemo', 'sorter_default', 'converter_default'])
" call unite#custom_filters('file_rec',
"       \ ['matcher_default', 'sorter_rank', 'converter_default'])

" Custom actions."{{{
let my_tabopen = {
      \ 'description' : 'my tabopen items',
      \ 'is_selectable' : 1,
      \ }
function! my_tabopen.func(candidates)"{{{
  call unite#take_action('tabopen', a:candidates)

  let dir = isdirectory(a:candidates[0].word) ?
        \ a:candidates[0].word : fnamemodify(a:candidates[0].word, ':p:h')
  execute g:unite_kind_openable_lcd_command '`=dir`'
endfunction"}}}
call unite#custom_action('file,buffer', 'tabopen', my_tabopen)
unlet my_tabopen
"}}}

" Custom filters."{{{
" call unite#custom_filters('file,buffer,file_rec',
"       \ ['converter_relative_word', 'matcher_fuzzy', 'sorter_default'])
" call unite#custom_filters('file,file_rec,file_rec/async',
"       \ ['converter_relative_word', 'matcher_default', 'sorter_length'])
"}}}

let g:unite_enable_start_insert = 0
let g:unite_enable_short_source_names = 1

function! s:unite_my_settings()"{{{
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
  imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  nmap <silent><buffer> <Tab>     :call <SID>NextWindow()<CR>
  nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))

  let unite = unite#get_current_unite()
  if unite.buffer_name =~# '^search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
        \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])
endfunction"}}}

" Original source."{{{
let source = {
        \ 'name' : 'buffer_lines',
        \ 'description' : 'candidates from current buffer lines',
        \ 'action_table' : {},
        \ 'max_candidates' : 30,
        \ 'hooks' : {},
        \ }
call unite#define_source(source)

function! source.hooks.on_init(args, context)"{{{
  let a:context.source__lines = getbufline(bufnr('%'), 1, '$')
  let a:context.source__bufname = bufname('%')
endfunction"}}}
function! source.gather_candidates(args, context)"{{{
  let candidates = []
  let linenr = 1
  for line in a:context.source__lines
    call add(candidates, {
        \ 'word' : line,
        \ 'kind' : 'jump_list',
        \ 'action__line' : linenr,
        \ 'action__path' : a:context.source__bufname,
        \ })

    let linenr += 1
  endfor

  return candidates
endfunction"}}}

unlet source
"}}}

let g:unite_cursor_line_highlight = 'TabLineSel'
" let g:unite_abbr_highlight = 'TabLine'
" let g:unite_source_file_mru_time_format = ''
let g:unite_source_file_mru_filename_format = ':~:.'
let g:unite_source_file_mru_limit = 300
" let g:unite_source_directory_mru_time_format = ''
let g:unite_source_directory_mru_limit = 300

if executable('jvgrep')
  " For jvgrep.
  let g:unite_source_grep_command = 'jvgrep'
  let g:unite_source_grep_default_opts = '--exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = '-R'
endif

" For ack.
if executable('ack-grep')
  " let g:unite_source_grep_command = 'ack-grep'
  " let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  " let g:unite_source_grep_recursive_opt = ''
endif

let g:unite_quick_match_table = {
      \ 'a' : 1, 's' : 2, 'd' : 3, 'f' : 4, 'g' : 5,
      \ 'h' : 6, 'k' : 7, 'l' : 8, ';' : 9,
      \ 'q' : 10, 'w' : 11, 'e' : 12, 'r' : 13, 't' : 14,
      \ 'y' : 15, 'u' : 16, 'i' : 17, 'o' : 18, 'p' : 19,
      \ '1' : 20, '2' : 21, '3' : 22, '4' : 23, '5' : 24,
      \ '6' : 25, '7' : 26, '8' : 27, '9' : 28, '0' : 29,
      \}

" call unite#custom_default_action('directory', 'cd')

" For unite-alias.
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.test = {
      \ 'source' : 'file_rec',
      \ 'args'   : '~/',
      \ }
let g:unite_source_alias_aliases.line_migemo = {
      \ 'source' : 'line',
      \ }


let g:unite_source_alias_aliases.sow_moveentry_entry = {
\ 'source': 'sow_gatherentry',
\ }
let sow_moveto_entry ={'description': 'action :move entry to ...',}
function! sow_moveto_entry.func(candidates)
  echo "test"
endfunction
call unite#custom_action(
      \ 'source/sow_moveentry_entry/*', 'sow_moveto_entry', sow_moveto_entry)
call unite#custom_default_action(
      \ 'source/sow_moveentry_entry/*', 'sow_moveto_entry')

" For unite-menu.
let g:unite_source_menu_menus = {}

let g:unite_source_menu_menus.enc = {
      \     'description' : 'Open with a specific character code again.',
      \ }
let g:unite_source_menu_menus.enc.command_candidates = {
      \       'utf8'      : 'Utf8',
      \       'iso2022jp'    : 'Iso2022jp',
      \       'cp932' : 'Cp932',
      \       'euc' : 'Euc',
      \       'utf16' : 'Utf16',
      \       'utf16-be' : 'Utf16be',
      \       'jis' : 'Jis',
      \       'sjis' : 'Sjis',
      \       'unicode' : 'Unicode',
      \     }
nnoremap <silent> ;e :<C-u>Unite menu:enc<CR>

let g:unite_source_menu_menus.fenc = {
      \     'description' : 'Change file fenc option.',
      \ }
let g:unite_source_menu_menus.fenc.command_candidates = {
      \       'utf8'      : 'WUtf8',
      \       'iso2022jp'    : 'WIso2022jp',
      \       'cp932' : 'WCp932',
      \       'euc' : 'WEuc',
      \       'utf16' : 'WUtf16',
      \       'utf16-be' : 'WUtf16be',
      \       'jis' : 'WJis',
      \       'sjis' : 'WSjis',
      \       'unicode' : 'WUnicode',
      \     }
nnoremap <silent> ;f :<C-u>Unite menu:fenc<CR>

let g:unite_source_menu_menus.ff = {
      \     'description' : 'Change file format option.',
      \ }
let g:unite_source_menu_menus.ff.command_candidates = {
      \       'unix'      : 'WUnix',
      \       'dos' : 'WDos',
      \       'mac'    : 'WMac',
      \     }
nnoremap <silent> ;w :<C-u>Unite menu:ff<CR>

let g:unite_source_menu_menus.unite = {
      \     'description' : 'Start unite sources',
      \ }
let g:unite_source_menu_menus.unite.command_candidates = {
      \       'history'      : 'Unite history/command',
      \       'quickfix' : 'Unite qflist -no-quit',
      \       'resume'    : 'Unite -buffer-name=resume resume',
      \       'directory'    : 'Unite -buffer-name=files '.
      \             '-default-action=lcd directory_mru',
      \       'mapping'    : 'Unite mapping',
      \       'message'    : 'Unite output:message',
      \     }
nnoremap <silent> ;u :<C-u>Unite menu:unite<CR>

let g:unite_build_error_icon    = $DOTVIM . '/signs/err.'
      \ . (s:is_windows ? 'bmp' : 'png')
let g:unite_build_warning_icon  = $DOTVIM . '/signs/warn.'
      \ . (s:is_windows ? 'bmp' : 'png')

" For unite-session.
" Save session automatically.
let g:unite_source_session_enable_auto_save = 1
" autocmd MyAutoCmd VimEnter * UniteSessionLoad
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
        \   '*': {'runmode': 'async:vimproc'},
        \ }

  if s:is_windows
    function! TexEncoding()
      if &fileencoding ==# 'utf-8'
        let arg = 'utf8 '
      elseif &fileencoding =~# '^euc-\%(jp\|jisx0213\)$'
        let arg = 'euc '
      elseif &fileencoding =~# '^iso-2022-jp'
        let arg = 'jis '
      else " cp932
        let arg = 'sjis '
      endif

      return arg
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

" fakeclip.vim"{{{
let g:fakeclip_no_default_key_mappings = 1

for _ in ['+', '*']
  execute 'silent! nmap "'._.'y  <Plug>(fakeclip-y)'
  execute 'silent! nmap "'._.'Y  <Plug>(fakeclip-Y)'
  execute 'silent! nmap "'._.'yy  <Plug>(fakeclip-Y)'
  execute 'silent! vmap "'._.'y  <Plug>(fakeclip-y)'
  execute 'silent! vmap "'._.'Y  <Plug>(fakeclip-Y)'

  execute 'silent! nmap "'._.'p  <Plug>(fakeclip-p)'
  execute 'silent! nmap "'._.'P  <Plug>(fakeclip-P)'
  execute 'silent! nmap "'._.'gp  <Plug>(fakeclip-gp)'
  execute 'silent! nmap "'._.'gP  <Plug>(fakeclip-gP)'
  execute 'silent! nmap "'._.']p  <Plug>(fakeclip-]p)'
  execute 'silent! nmap "'._.']P  <Plug>(fakeclip-]P)'
  execute 'silent! nmap "'._.'[p  <Plug>(fakeclip-[p)'
  execute 'silent! nmap "'._.'[P  <Plug>(fakeclip-[P)'
  execute 'silent! vmap "'._.'p  <Plug>(fakeclip-p)'
  execute 'silent! vmap "'._.'P  <Plug>(fakeclip-P)'
  execute 'silent! vmap "'._.'gp  <Plug>(fakeclip-gp)'
  execute 'silent! vmap "'._.'gP  <Plug>(fakeclip-gP)'
  execute 'silent! vmap "'._.']p  <Plug>(fakeclip-]p)'
  execute 'silent! vmap "'._.']P  <Plug>(fakeclip-]P)'
  execute 'silent! vmap "'._.'[p  <Plug>(fakeclip-[p)'
  execute 'silent! vmap "'._.'[P  <Plug>(fakeclip-[P)'

  "execute 'silent! map! <C-r>'._.'  <Plug>(fakeclip-insert)'
  "execute 'silent! map! <C-r><C-r>'._.'  <Plug>(fakeclip-insert-r)'
  "execute 'silent! map! <C-r><C-o>'._.'  <Plug>(fakeclip-insert-o)'
  "execute 'silent! imap <C-r><C-p>'._.'  <Plug>(fakeclip-insert-p)'
endfor
"}}}

" ref.vim"{{{
let g:ref_use_vimproc = 1
if s:is_windows
  let g:ref_refe_encoding = 'cp932'
else
  let g:ref_refe_encoding = 'euc-jp'
endif

" ref-lynx.
if s:is_windows
  let s:lynx = 'C:/lynx/lynx.exe'
  let s:cfg  = 'C:/lynx/lynx.cfg'
  let g:ref_lynx_cmd = s:lynx.' -cfg='.s:cfg.' -dump -nonumbers %s'
  let g:ref_alc_cmd = s:lynx.' -cfg='.s:cfg.' -dump %s'
  unlet s:lynx
  unlet s:cfg
endif

let g:ref_lynx_use_cache = 1
let g:ref_lynx_start_linenumber = 0 " Skip.
let g:ref_lynx_hide_url_number = 0

autocmd MyAutoCmd FileType ref call s:ref_my_settings()
function! s:ref_my_settings()"{{{
  " Overwrite settings.
  nmap <buffer> [Tag]t  <Plug>(ref-keyword)
  nmap <buffer> [Tag]p  <Plug>(ref-back)
endfunction"}}}
"}}}

" vimfiler.vim"{{{

" Alter commands.
AlterCommand <cmdwin> e[dit] Edit
AlterCommand <cmdwin> r[ead] Read
AlterCommand <cmdwin> s[ource] Source
AlterCommand <cmdwin> w[rite] Write

"nmap    [Space]v   <Plug>(vimfiler_switch)
nnoremap <silent>   [Space]v   :<C-u>VimFiler<CR>
nnoremap    [Space]ff   :<C-u>VimFilerExplorer<CR>

call vimfiler#set_execute_file('vim', ['vim', 'notepad'])
call vimfiler#set_execute_file('txt', 'vim')

let g:vimfiler_enable_clipboard = 0
let g:vimfiler_safe_mode_by_default = 0

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_detect_drives = s:is_windows ? [
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

if s:is_windows
  " Use trashbox.
  let g:unite_kind_file_use_trashbox = 1
else
  " Like Textmate icons.
  let g:vimfiler_tree_leaf_icon = ' '
  let g:vimfiler_tree_opened_icon = '▾'
  let g:vimfiler_tree_closed_icon = '▸'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_marked_file_icon = '*'
endif
" let g:vimfiler_readonly_file_icon = '[O]'

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()"{{{
  " Overwrite settings.
  nnoremap <silent><buffer> J
        \ <C-u>:Unite -buffer-name=files -default-action=lcd directory_mru<CR>
  " Call sendto.
  " nnoremap <buffer> - <C-u>:Unite sendto<CR>
  " setlocal cursorline

  nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)

  " Migemo search.
  if !empty(unite#get_filters('matcher_migemo'))
    nnoremap <silent><buffer><expr> /  line('$') > 10000 ?  'g/' :
          \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>"
  endif
endfunction"}}}
"}}}

" eskk.vim"{{{
if !exists('g:eskk#disable') || !g:eskk#disable
  " Disable skk.vim
  let g:plugin_skk_disable = 1

  let g:eskk#disable = 0

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

  "let g:eskk#dictionary = {
        "\   'path': expand('~/.skk-eskk-jisyo'),
        "\   'sorted': 0,
        "\   'encoding': 'utf-8',
        "\}
  let g:eskk#large_dictionary = {
        \   'path': expand('~/SKK-JISYO.L'),
        \   'sorted': 1,
        \   'encoding': 'euc-jp',
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
endif
"}}}

" lingr-vim"{{{
let g:lingr_vim_sidebar_width = 30

" Keymappings.
autocmd MyAutoCmd FileType lingr-messages call s:lingr_messages_my_settings()
autocmd MyAutoCmd FileType lingr-say call s:lingr_say_my_settings()
autocmd MyAutoCmd FileType lingr-rooms call s:lingr_looms_my_settings()

function! s:lingr_messages_my_settings()"{{{
  nmap <buffer> o <Plug>(lingr-messages-show-say-buffer)
  nunmap <buffer> s

  if s:is_windows
    " Dirty shellslash hack.
    set noshellslash

    augroup MyAutoCmd
      autocmd WinEnter,BufWinEnter <buffer> set noshellslash
      autocmd WinLeave,BufWinLeave <buffer> set shellslash
    augroup END
  endif
endfunction"}}}
function! s:lingr_say_my_settings()"{{{
  imap <buffer> <CR> <Plug>(lingr-say-insert-mode-say)
  nmap <buffer> q <Plug>(lingr-say-close)
endfunction"}}}
function! s:lingr_looms_my_settings()"{{{
  nmap <buffer> l <Plug>(lingr-rooms-select-room)
endfunction"}}}

if !s:is_windows
  command! Suicide call system('kill -KILL ' . getpid())
endif
"}}}

" rsense.vim"{{{
let g:rsenseHome = 'c:/rsense'
let g:rsenseUseOmniFunc = 1
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

" simpletap.vim"{{{
" Easily test.
nnoremap [Space]te :<C-u>SimpleTapRun ./test<CR>
"}}}

" open-browser.vim"{{{
nnoremap gs :<C-u>call <SID>www_search()<CR>
function! s:www_search()
  let search_word = input('Please input search word: ', '', 'customlist,wwwsearch#cmd_Wwwsearch_complete')
  if search_word != ''
    execute 'OpenBrowserSearch' escape(search_word, '"')
  endif
endfunction
"}}}

" caw.vim"{{{
nmap gc <Plug>(caw:prefix)
xmap gc <Plug>(caw:prefix)
nmap gcc <Plug>(caw:i:toggle)
xmap gcc <Plug>(caw:i:toggle)
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

" textmanip.vim"{{{
" Move selected region.
xmap <C-j> <Plug>(Textmanip.move_selection_down)
xmap <C-k> <Plug>(Textmanip.move_selection_up)
xmap <C-h> <Plug>(Textmanip.move_selection_left)
xmap <C-l> <Plug>(Textmanip.move_selection_right)

" Duplicate selected window.
xmap <C-d> <Plug>(Textmanip.duplicate_selection_v)
nmap <C-d> <Plug>(Textmanip.duplicate_selection_n)
"}}}

" surround_custom_mappings.vim"{{{
let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
            \ 'p':  "<pre> \r </pre>",
            \ 'w':  "%w(\r)",
            \ }
let g:surround_custom_mapping.help = {
            \ 'p':  "> \r <",
            \ }
let g:surround_custom_mapping.ruby = {
            \ '-':  "<% \r %>",
            \ '=':  "<%= \r %>",
            \ '9':  "(\r)",
            \ '5':  "%(\r)",
            \ '%':  "%(\r)",
            \ 'w':  "%w(\r)",
            \ '#':  "#{\r}",
            \ '3':  "#{\r}",
            \ 'e':  "begin \r end",
            \ 'E':  "<<EOS \r EOS",
            \ 'i':  "if \1if\1 \r end",
            \ 'u':  "unless \1unless\1 \r end",
            \ 'c':  "class \1class\1 \r end",
            \ 'm':  "module \1module\1 \r end",
            \ 'd':  "def \1def\1\2args\r..*\r(&)\2 \r end",
            \ 'p':  "\1method\1 do \2args\r..*\r|&| \2\r end",
            \ 'P':  "\1method\1 {\2args\r..*\r|&|\2 \r }",
            \ }
let g:surround_custom_mapping.javascript = {
            \ 'f':  "function(){ \r }"
            \ }
let g:surround_custom_mapping.lua = {
            \ 'f':  "function(){ \r }"
            \ }
let g:surround_custom_mapping.python = {
            \ 'p':  "print( \r)",
            \ '[':  "[\r]",
            \ }
let g:surround_custom_mapping.vim= {
            \'f':  "function! \r endfunction"
            \ }
"}}}

" vim-presen.vim"{{{
autocmd MyAutoCmd FileType presen call s:my_presen_settings()
function! s:my_presen_settings()
  nnoremap <buffer><silent><CR> :<C-u>call vimproc#open(expand('<cfile>'))<CR>
endfunction"}}}

" Gundo.vim
nnoremap U      :<C-u>GundoToggle<CR>

" w3m.vim
nnoremap W      :<C-u>W3m<Space>

" TweetVim
" Start TweetVim.
nnoremap <silent> [unite]w :<C-u>Unite tweetvim<CR>
autocmd MyAutoCmd FileType tweetvim call s:tweetvim_my_settings()
function! s:tweetvim_my_settings()"{{{
  " Open say buffer.
  nnoremap <silent><buffer> o :TweetVimSay<CR>
  nnoremap <silent><buffer> s :TweetVimSay<CR>
  nnoremap <silent><buffer> q :close<CR>
endfunction"}}}

" Complete by neocomplcache.
let g:neocomplcache_dictionary_filetype_lists.tweetvim_say =
      \ expand('~/.tweetvim/screen_name')

nmap R <Plug>(operator-replace)
xmap R <Plug>(operator-replace)
xmap p <Plug>(operator-replace)

" Taglist.
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1

" restart.vim {{{
let g:restart_save_window_values = 0
"}}}

" accelerated-jk
nmap <silent>j <Plug>(accelerated_jk_gj)
nmap gj j
nmap <silent>k <Plug>(accelerated_jk_gk)
nmap gk k
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
  let save_ve = &l:virtualedit
  setlocal virtualedit=all
  if a:is_reverse
    let cur_text = getline('.')[virtcol('.')-1 : ]
  else
    let cur_text = getline('.')[: virtcol('.')-2]
  endif
  let &l:virtualedit = save_ve

  let pattern = '\d\+\|\u\+\ze\%(\u\l\|\d\)\|\u\l\+\|\%(\a\|\d\)\+\ze_\|\%(\k\@!\S\)\+\|\%(_\@!\k\)\+\>\|[_]\|\s\+'

  if a:is_reverse
    let cur_cnt = len(matchstr(cur_text, '^\%('.pattern.'\)'))
  else
    let cur_cnt = len(matchstr(cur_text, '\%('.pattern.'\)$'))
  endif

  let del = a:is_reverse ? "\<Del>" : "\<BS>"

  return (pumvisible() ? neocomplcache#smart_close_popup() : '') . repeat(del, cur_cnt)
endfunction
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

nmap ;;  <sid>(command-line-enter)
xmap ;;  <sid>(command-line-enter)

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
autocmd MyAutoCmd CmdwinLeave * let g:neocomplcache_enable_auto_select = 1

function! s:init_cmdwin()
  let g:neocomplcache_enable_auto_select = 0
  let b:neocomplcache_sources_list = ['vim_complete']

  nnoremap <buffer><silent> q :<C-u>quit<CR>
  nnoremap <buffer><silent> <TAB> :<C-u>quit<CR>
  nnoremap <buffer> ; :
  xnoremap <buffer> ; :
  inoremap <buffer><expr><CR> neocomplcache#close_popup()."\<CR>"
  inoremap <buffer><expr><C-h> col('.') == 1 ? "\<ESC>:quit\<CR>" : neocomplcache#cancel_popup()."\<C-h>"
  inoremap <buffer><expr><BS> col('.') == 1 ? "\<ESC>:quit\<CR>" : neocomplcache#cancel_popup()."\<C-h>"

  " Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : "\<C-x>\<C-u>\<C-p>"

  startinsert!
endfunction"}}}

" [Space]: Other useful commands "{{{
" Smart space mapping.
" Notice: when starting other <Space> mappings in noremap, disappeared [Space].
nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>

" Toggle relativenumber.
nnoremap <silent> [Space].
      \ :<C-u>call ToggleOption('relativenumber')<CR>
" Toggle highlight.
nnoremap <silent> [Space]/
      \ :<C-u>call ToggleOption('hlsearch')<CR>
" Toggle cursorline.
nnoremap <silent> [Space]cl
      \ :<C-u>call ToggleOption('cursorline')<CR>
" Set autoread.
nnoremap [Space]ar
      \ :<C-u>setlocal autoread<CR>
" Output encoding information.
nnoremap <silent> [Space]en
      \ :<C-u>setlocal encoding? termencoding? fenc? fencs?<CR>
" Set spell check.
nnoremap [Space]sp
      \ :<C-u>call ToggleOption('spell')<CR>
" Echo syntax name.
nnoremap [Space]sy
      \ :<C-u>echo synIDattr(synID(line('.'), col('.'), 1), "name")<CR>

" Easily edit .vimrc and .gvimrc "{{{
nnoremap <silent> [Space]ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> [Space]eg  :<C-u>edit $MYGVIMRC<CR>
" Load .gvimrc after .vimrc edited at GVim.
nnoremap <silent> [Space]rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif \| echo "source $MYVIMRC"<CR>
nnoremap <silent> [Space]rg :<C-u>source $MYGVIMRC \| echo "source $MYGVIMRC"<CR>
"}}}

" Easily edit snippets file
nnoremap [Space]er  q:NeoComplCacheEditRuntimeSnippets<Space>
nnoremap [Space]es  q:NeoComplCacheEditSnippets<Space>

" Easily check registers and marks.
nnoremap <silent> [Space]mk  :<C-u>marks<CR>
nnoremap <silent> [Space]re  :<C-u>registers<CR>

" Useful save mappings."{{{
nnoremap <silent> [Space]w  :<C-u>update<CR>
nnoremap <silent> [Space]fw  :<C-u>write!<CR>
nnoremap <silent> [Space]q  :<C-u>quit<CR>
nnoremap <silent> [Space]aq  :<C-u>quitall<CR>
nnoremap <silent> [Space]fq  :<C-u>quitall!<CR>
nnoremap <Leader><Leader> :<C-u>update<CR>
"}}}

" Change current directory.
nnoremap <silent> [Space]cd :<C-u>call <SID>cd_buffer_dir()<CR>
function! s:cd_buffer_dir()"{{{
  let filetype = getbufvar(bufnr('%'), '&filetype')
  if filetype ==# 'vimfiler'
    let dir = getbufvar(bufnr('%'), 'vimfiler').current_dir
  elseif filetype ==# 'vimshell'
    let dir = getbufvar(bufnr('%'), 'vimshell').save_dir
  else
    let dir = isdirectory(bufname('%')) ? bufname('%') : fnamemodify(bufname('%'), ':p:h')
  endif

  cd `=dir`
endfunction"}}}

" Delete windows ^M codes.
nnoremap <silent> [Space]<C-m> mmHmt:<C-u>%s/<C-v><CR>$//ge<CR>'tzt'm

" Delete spaces before newline.
nnoremap <silent> [Space]ss mmHmt:<C-u>%s/<Space>$//ge<CR>`tzt`m

" Easily syntax change."{{{
" Detect syntax
nnoremap [Space]$ :filetype detect<CR>
nnoremap <silent> [Space]ft :<C-u>Unite -start-insert filetype<CR>
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

" Change tab width. "{{{
nnoremap <silent> [Space]t2 :<C-u>setl shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> [Space]t4 :<C-u>setl shiftwidth=4 softtabstop=4<CR>
nnoremap <silent> [Space]t8 :<C-u>setl shiftwidth=8 softtabstop=8<CR>
"}}}

" Easily ctags command."{{{
nnoremap <silent> [Space]tr :<C-u>VimShellExecute ctags -R<CR>
" Easily helptags command.
if !exists('g:loaded_vimrc_local')
  nnoremap <silent> [Space]td :<C-u>helptags $VIMRUNTIME/doc<CR>:<C-u>call pathogen#helptags()<CR>
else
  nnoremap <silent> [Space]td :<C-u>helptags $VIMRUNTIME/doc<CR>:<C-u>helptags $HOME/.vim/doc<CR>
endif
"}}}

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

" s: Windows and buffers(High priority) "{{{
" The prefix key.
nnoremap    [Window]   <Nop>
nmap    s [Window]
nnoremap <silent> [Window]p  :<C-u>call <SID>split_nicely()<CR>
nnoremap <silent> [Window]v  :<C-u>vsplit<CR>
nnoremap <silent> [Window]c  :<C-u>call <sid>smart_close()<CR>
nnoremap <silent> -  :<C-u>call <sid>smart_close()<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>

" A .vimrc snippet that allows you to move around windows beyond tabs
nnoremap <silent> <Tab> :call <SID>NextWindow()<CR>
nnoremap <silent> <S-Tab> :call <SID>PreviousWindowOrTab()<CR>
nnoremap <silent> [Space]<Space> :<C-u>buffer #<CR>

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

function! s:NextWindow()
  if winnr('$') == 1
    silent! normal! ``z.
  else
    wincmd w
  endif
endfunction

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
  let prev_name = winnr()
  silent! wincmd p
  if prev_name == winnr()
    silent! wincmd w
  endif
endfunction
" If window isn't splited, split buffer.
function! s:ToggleSplit()
  let prev_name = winnr()
  silent! wincmd w
  if prev_name == winnr()
    split
  else
    call s:smart_close()
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
" Force delete current buffer.
nnoremap <silent> [Window]D  :<C-u>call <SID>CustomBufferDelete(1)<CR>
function! s:CustomBufferDelete(is_force)
  let current = bufnr('%')

  call unite#util#alternate_buffer()

  if a:is_force
    silent! execute 'bdelete! ' . current
  else
    silent! execute 'bdelete ' . current
  endif
endfunction
"}}}
" JunkFile
nnoremap <silent> [Window]e  :<C-u>JunkFile<CR>

" Scroll other window.
" nnoremap <silent> <C-y> :<C-u>call <SID>ScrollOtherWindow(1)<CR>
" inoremap <silent> <A-y> <C-o>:<C-u>call <SID>ScrollOtherWindow(1)<CR>
" nnoremap <silent> <C-u> :<C-u>call <SID>ScrollOtherWindow(0)<CR>
" inoremap <silent> <A-u> <C-o>:<C-u>call <SID>ScrollOtherWindow(0)<CR>

function! s:ScrollOtherWindow(direction)
  execute 'wincmd' (winnr('#') == 0 ? 'w' : 'p')
  execute (a:direction ? "normal! \<C-d>" : "normal! \<C-u>")
  wincmd p
endfunction
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

nnoremap [Argument]<Space>  q:args<Space>
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

" For quickfix list  "{{{
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
nnoremap [Quickfix]M  q:make<Space>
nnoremap [Quickfix]g  q:grep<Space>
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
"}}}

" For location list (mnemonic: Quickfix list for the current Window)  "{{{
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
nnoremap [Quickfix]wM  q:lmake<Space>
nnoremap [Quickfix]w<Space>  q:lmake<Space>
nnoremap [Quickfix]wg  q:lgrep<Space>
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
" Useless command.
nnoremap M  m
"}}}

" Don't calc octal.
set nrformats-=octal

" Smart <C-f>, <C-b>.
nnoremap <silent> <C-f> <C-f>
nnoremap <silent> <C-b> <C-b>

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
  let moved = MoveCursor("H")
  if !moved && line('.') != 1
    execute "normal! " . "\<pageup>H"
  endif
endfunction
function! LContext()
  let moved = MoveCursor("L")

  if !moved && line('.') != line('$')
    execute "normal! " . "\<pagedown>L"
  endif
endfunction
function! MoveCursor(key)
  let cnum = col('.')
  let lnum = line('.')
  let wline = winline()

  execute "normal! " . v:count . a:key
  let moved =  cnum != col('.') || lnum != line('.') || wline != winline()

  return moved
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
  let curcol = col('.')

  if &wrap
    normal! g^
  else
    normal! ^
  endif
  if col('.') == curcol
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
  let curcol = col('.')
  let lastcol = a:mode ==# 'i' ? col('$') : col('$') - 1

  " Gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif

  if curcol < lastcol
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
nnoremap <silent> g{ :<C-u>call search('^' . matchstr(getline(line('.') + 1), '\(\s*\)') .'\S', 'b')<CR>^
nnoremap <silent> g} :<C-u>call search('^' . matchstr(getline(line('.')), '\(\s*\)') .'\S')<CR>^
"}}}

" Select rectangle.
xnoremap r <C-v>
" Select until end of current line in visual mode.
xnoremap v $h

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
noremap [Space]j zj
noremap [Space]k zk
noremap [Space]n ]z
noremap [Space]p [z
noremap [Space]h zc
noremap [Space]l zo
noremap [Space]a za
noremap [Space]m zM
noremap [Space]i zMzv
noremap [Space]rr zR
noremap [Space]f zf
noremap [Space]d zd
noremap [Space]u :<C-u>Unite outline:foldings<CR>
noremap [Space]gg :<C-u>echo FoldCCnavi()<CR>
"}}}

" Search a parenthesis.
onoremap <silent> q /["',.{}()[\]<>]<CR>

" Auto escape / substitute.
xnoremap s y:%s/<C-r>=substitute(@0, '/', '\\/', 'g')<Return>//g<Left><Left>

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
  let sticky_table = {
        \',' : '<', '.' : '>', '/' : '?',
        \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')', '-' : '_', '=' : '+',
        \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
        \}
  let special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
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
"}}}

" Easy escape."{{{
inoremap jj           <ESC>
" inoremap <expr> j       getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'
cnoremap <expr> j       getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
onoremap jj           <ESC>

inoremap j<Space>     j
onoremap j<Space>     j
"}}}

" Smart word search."{{{
" Search cursor word by word unit.
" nnoremap <silent> *  :<C-u>call <SID>SetSearch('""yiw', 'word')<CR>
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

" Easy home directory."{{{
function! HomedirOrBackslash()
  if getcmdtype() == ':' && (getcmdline() =~# '^e\%[dit] ' || getcmdline() =~? '^r\%[ead]\?!' || getcmdline() =~? '^cd ')
    return '~/'
  else
    return '\'
  endif
endfunction
" cnoremap <expr> <Bslash> HomedirOrBackslash()
"}}}

" Move to top/center/bottom.
noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ? 'zt' : (winline() == 1)? 'zb' : 'zz'

" Move window position {{{
nmap [Space]<C-n> <Plug>swap_window_next
nmap [Space]<C-p> <Plug>swap_window_prev
nmap [Space]<C-j> <Plug>swap_window_j
nmap [Space]<C-k> <Plug>swap_window_k
nmap [Space]<C-h> <Plug>swap_window_h
nmap [Space]<C-l> <Plug>swap_window_l
" nmap [Space]<C-t> <Plug>swap_window_t
" nmap [Space]<C-b> <Plug>swap_window_b

nnoremap <silent> <Plug>swap_window_next :<C-u>call <SID>swap_window(v:count1)<CR>
nnoremap <silent> <Plug>swap_window_prev :<C-u>call <SID>swap_window(-v:count1)<CR>
nnoremap <silent> <Plug>swap_window_j :<C-u>call <SID>swap_window_dir(v:count1, 'j')<CR>
nnoremap <silent> <Plug>swap_window_k :<C-u>call <SID>swap_window_dir(v:count1, 'k')<CR>
nnoremap <silent> <Plug>swap_window_h :<C-u>call <SID>swap_window_dir(v:count1, 'h')<CR>
nnoremap <silent> <Plug>swap_window_l :<C-u>call <SID>swap_window_dir(v:count1, 'l')<CR>
nnoremap <silent> <Plug>swap_window_t :<C-u>call <SID>swap_window_dir(v:count1, 't')<CR>
nnoremap <silent> <Plug>swap_window_b :<C-u>call <SID>swap_window_dir(v:count1, 'b')<CR>

function! s:modulo(n, m) "{{{
  let d = a:n * a:m < 0 ? 1 : 0
  return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
endfunction "}}}

function! s:swap_window(n) "{{{
  let curbuf = bufnr('%')
  let target = s:modulo(winnr() + a:n - 1, winnr('$')) + 1
  execute 'hide' winbufnr(target) . 'buffer'
  execute target 'wincmd w'
  execute curbuf 'buffer'
endfunction "}}}

function! s:swap_window_dir(n, dir) "{{{
  let curbuf = bufnr('%')
  execute a:n 'wincmd ' . a:dir
  let target = winnr()
  let targetbuf = bufnr('%')
  if curbuf != targetbuf
    wincmd p
    execute 'hide' targetbuf . 'buffer'
    execute target 'wincmd w'
    execute curbuf 'buffer'
  endif
endfunction "}}}
" }}}

" Capitalize.
nnoremap gu <ESC>gUiw`]
inoremap <C-q> <ESC>gUiw`]a

" Clear highlight.
nnoremap <ESC><ESC> :nohlsearch<CR>

" operator-html-escape.vim
nmap <Leader>h <Plug>(operator-html-escape)
xmap <Leader>h <Plug>(operator-html-escape)

onoremap ) t)
onoremap ( t(
xnoremap ) t)
xnoremap ( t(

" Easily macro.
nnoremap @@ @a

" Improved visual selection.{{{
" http://labs.timedia.co.jp/2012/10/vim-more-useful-blockwise-insertion.html
xnoremap <expr> I  <SID>force_blockwise_visual('I')
xnoremap <expr> A  <SID>force_blockwise_visual('A')

function! s:force_blockwise_visual(next_key)"{{{
  if mode() ==# 'v'
    return "\<C-v>" . a:next_key
  elseif mode() ==# 'V'
    return "\<C-v>0o$" . a:next_key
  else  " mode() ==# "\<C-v>"
    return a:next_key
  endif
endfunction}}}
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
command! -nargs=1 Hg call s:new_help_grep('<args>')
function! s:new_help_grep(arg)
  " Convert helpgrep argments.
  exec ':helpgrep ' . iconv(a:arg, 'cp932', 'utf-8')
endfunction
"}}}

" Display diff with the file.
command! -nargs=1 -complete=file Diff vertical diffsplit <args>
" Display diff from last save.
command! DiffOrig vert new | setlocal bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" Disable diff mode.
command! -nargs=0 Undiff setlocal nodiff noscrollbind wrap

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

function! s:Batch() range"{{{
  " read vimscript from selected area.
  let selected = getline(a:firstline, a:lastline)
  " get temp file.
  let tempfile = tempname()
  " try-finally
  try
    " write vimscript to temp file.
    call writefile(selected, tempfile)
    try
      " execute temp file.
      execute 'source ' . tempfile
    catch
      " catch exception
      echohl WarningMsg |
            \ echo 'EXCEPTION :' v:exception |
            \ echo 'THROWPOINT:' v:throwpoint |
            \ echohl None
    endtry
  finally
    " delete temp file.
    if filewritable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction"}}}
" Range source.
command! -range -narg=0 Batch :<line1>,<line2>call s:Batch()

" Substitute indent.
command! -range=% LeadUnderscores <line1>,<line2>s/^\s*/\=repeat('_', strlen(submatch(0)))/g
nnoremap <silent> [Space]U        :LeadUnderscores<CR>
xnoremap <silent> [Space]U        :LeadUnderscores<CR>

" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(junk_dir)
    call mkdir(junk_dir, 'p')
  endif

  let filename = input('Junk Code: ', junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if filename != ''
    execute 'edit ' . filename
  endif
endfunction"}}}

command! -nargs=1 -bang -bar -complete=file Rename saveas<bang> <args> | call delete(expand('#:p'))

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
" xnoremap [Space]h q:HighlightWith<Space>

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

" For git update.
command! GitPullAll call s:git_pull_all()
function! s:git_pull_all()
  let current_dir = getcwd()
  let cnt = 1
  let dirs = map(split(glob('*/.git'), '\n'), 'fnamemodify(v:val, ":p:h:h")')
  let max = len(dirs)
  for dir in dirs
    lcd `=dir`
    redraw
    echo printf('%d/%d git pull origin master %s', cnt, max, dir)
    let output = vimproc#system('git pull origin master')
    if vimproc#get_last_status()
      echohl WarningMsg | echomsg output | echohl None
    endif

    let cnt += 1
  endfor

  echo 'Done!'

  lcd `=current_dir`
endfunction

"}}}

"---------------------------------------------------------------------------
" Functions:"{{{
"

" LevenShtein argorithm."{{{
function! CalcLeven(str1, str2)
  let [p1, p2, l1, l2] = [[], [], len(a:str1), len(a:str2)]

  for i in range(l2+1)
    call add(p1, i)
  endfor
  for i in range(l2+1)
    call add(p2, 0)
  endfor

  for i in range(l1)
    let p2[0] = p1[0] + 1
    for j in range(l2)
      let p2[j+1] = min([p1[j] + ((a:str1[i] == a:str2[j]) ? 0 : 1),
            \p1[j+1] + 1, p2[j]+1])
    endfor
    let [p1, p2] = [p2, p1]
  endfor

  return p1[l2]
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

" SnipNest('std::vector<std::vector<int>>', '<', '>', 1)
"  => std::vector<<>>
function! SnipNest(str, start, end, max)"{{{
  let _ = ''
  let nest_level = 0
  for c in split(a:str, '\zs')
    if c ==# a:start
      let nest_level += 1
      let _ .= c
    elseif c ==# a:end
      let nest_level -= 1
      let _ .= c
    elseif nest_level <= a:max
      let _ .= c
    endif
  endfor

  return _
endfunction"}}}

" Search match pair."{{{
function! MatchPair(string, start_pattern, end_pattern, start_cnt)
  let end = -1
  let start_pattern = '\%(' . a:start_pattern . '\)'
  let end_pattern = '\%(' . a:end_pattern . '\)'

  let i = a:start_cnt
  let max = len(a:string)
  let nest_level = 0
  while i < max
    if match(a:string, start_pattern, i) >= 0
      let i = matchend(a:string, start_pattern, i)
      let nest_level += 1
    elseif match(a:string, end_pattern, i) >= 0
      let end = match(a:string, end_pattern, i)
      let nest_level -= 1

      if nest_level == 0
        return end
      endif

      let i = matchend(a:string, end_pattern, i)
    else
      break
    endif
  endwhile

  if nest_level != 0
    return -1
  else
    return end
  endif
endfunction"}}}

" For snipMate.
function! Filename(...)
  let filename = expand('%:t:r')
  if filename == ''
    return a:0 == 2 ? a:2 : ''
  elseif a:0 == 0 || a:1 == ''
    return filename
  else
    return substitute(a:1, '$1', filename, 'g')
  endif
endfunction

function! s:expand(path)
  return expand(escape(a:path, '*?[]"={}'))
endfunction
"}}}

"---------------------------------------------------------------------------
" Platform depends:"{{{
"
if s:is_windows
  " For Windows"{{{

  " In Windows, can't find exe, when $PATH isn't contained $VIM.
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

  " Popup color.
  hi Pmenu ctermbg=8
  hi PmenuSel ctermbg=1
  hi PmenuSbar ctermbg=0
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
    if !exists('$TMUX')
      set t_Co=256

      " For screen."{{{
      if &term =~ '^screen'
        augroup MyAutoCmd
          " Show filename on screen statusline.
          " But invalid 'another' screen buffer.
          autocmd BufEnter * if $WINDOW != 0 &&  bufname("") !~ "[A-Za-z0-9\]*://"
                \ | silent! exe '!echo -n "kv:%:t\\"' | endif
          " When 'mouse' isn't empty, Vim will freeze. Why?
          autocmd VimLeave * :set mouse=
        augroup END

        " For Vim inside screen.
        set ttymouse=xterm2
      endif

      " For prevent bug.
      autocmd MyAutoCmd VimLeave * set term=screen
      "}}}
    endif

    if has('gui')
      " Use CSApprox.vim
      NeoBundleSource CSApprox

      " Convert colorscheme in Konsole.
      let g:CSApprox_konsole = 1
      let g:CSApprox_attr_map = {
            \ 'bold' : 'bold',
            \ 'italic' : '', 'sp' : ''
            \ }
      if !exists('g:colors_name')
        colorscheme candy
      endif
    else
      " Use guicolorscheme.vim
      NeoBundleSource guicolorscheme.vim

      autocmd MyAutoCmd VimEnter,BufAdd *
            \ if !exists('g:colors_name') | GuiColorScheme candy

      " Disable error messages.
      let g:CSApprox_verbose_level = 0
    endif

    " Change cursor shape.
    if &term =~ "xterm"
      let &t_SI = "\<Esc>]12;lightgreen\x7"
      let &t_EI = "\<Esc>]12;white\x7"
    endif
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
let t:cwd = getcwd()

" For snipMate.
let g:snips_author = 'Shougo'
"}}}

set secure
