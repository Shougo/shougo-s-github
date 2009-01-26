"---------------------------------------------------------------------------
" Shougo's .vimrc
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
        if $ENV_ACCESS ==# 'cygwin'
            set termencoding=cp932
        elseif $ENV_ACCESS ==# 'linux'
            set termencoding=euc-jp
        elseif $ENV_ACCESS ==# 'colinux'
            set termencoding=utf-8
        else  " fallback
            set termencoding=  " same as 'encoding'
        endif
    endif
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

" When do not include Japanese, use encoding for fileencoding.
function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
        let &fileencoding=&encoding
    endif
endfunction

augroup MyJapanese
    autocmd!
    autocmd BufReadPost * call AU_ReCheck_FENC()
augroup END

" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
" A fullwidth character is displayed in vim properly.
set ambiwidth=double

" 特定の文字コードで開き直すコマンド群"{{{
" 特に、ターミナルで文字化けする時に有効。
" UTF-8で開き直す
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
" iso-2022-jpで開き直す
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
" Shift_JISで開き直す
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
" EUC-jpで開き直す
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
" UTF-16で開き直す
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
" UTF-16BEで開き直す
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>

" aliases
command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
"}}}

" ファイル書き込み版も作ってみた"{{{
" 失敗すると危険なので、保存はしない。
command! Wutf8 setlocal fenc=utf-8
command! WIso2022jp setlocal fenc=iso-2022-jp
command! WCp932 setlocal fenc=cp932
command! WEuc setlocal fenc=euc-jp
command! WUtf16 setlocal fenc=ucs-2le
command! WUtf16be setlocal fenc=ucs-2
" aliases
command! WJis  WIso2022jp
command! WSjis  WCp932
command! WUnicode WUtf16
"}}}

" Handle it in nkf and open.
command! Nkf !nkf -g %

" 改行文字を指定する"{{{
command! -bang -bar -complete=file -nargs=? Unix edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac edit<bang> ++fileformat=mac <args>
command! -bang -bar -complete=file -nargs=? Dos edit<bang> ++fileformat=dos <args>
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WMac write<bang> ++fileformat=mac <args> | edit <args>
command! -bang -complete=file -nargs=? WDos write<bang> ++fileformat=dos <args> | edit <args>
"}}}"}}}

"---------------------------------------------------------------------------
" Initialize:"{{{
"
" 文字化けするので、インターフェースに英語を使用する
if has('win32') || has('win64')
    language en
endif

" \の代わりに'm'を使えるようにする
" ','より押しやすい。
" プラグイン用設定の前に設定しないとうまくマッピングされない。
let mapleader = 'm'
" グローバルプラグインでは <Leader> を使用
let g:mapleader = 'm'
" ファイルタイププラグインでは <LocalLeader> を使用
" 'm'の隣だから','を使用する。
let g:maplocalleader = ','

" plug-inのためにキーマップを解放する
noremap ;  <Nop>
noremap m  <Nop>
noremap ,  <Nop>

" Windows/Linuxにおいて、.vimと$VIM/vimfilesの違いを吸収する
if has('win32') || has('win64')
    let $DOTVIM = $VIM."/vimfiles"
else
    let $DOTVIM = $HOME."/.vim"
endif

" コンソールでは$MYGVIMRCに値がセットされていないのでセットする
if !exists($MYGVIMRC)
    if has('win32') || has('win64')
        let $MYGVIMRC = $VIM."/.gvimrc"
    else
        let $MYGVIMRC = $HOME."/.gvimrc"
    endif
endif

" Anywhere SID.
function! s:SID_PREFIX()
 return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

" 最初に処理して、設定を上書きする
filetype plugin on
filetype indent on 
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
    " Don't save ime condition.
    inoremap <silent> <ESC> <ESC>:<C-u>set iminsert=0 imsearch=0<CR>
    noremap / :<C-u>set imsearch=0<CR>/
    noremap ? :<C-u>set imsearch=0<CR>?
endif

if has('xim')
    " To use ATOK X3.
    let $GTK_IM_MODULE='xim'
    set imactivatekey=S-space

    " To use uim-anthy.
    "let $GTK_IM_MODULE='uim-anthy'
    "set imactivatekey=C-space
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
set tabstop=8
" <Tab>の代わりに挿入する空白の数
set softtabstop=4
" 自動インデントに使われる空白の数
set shiftwidth=4
" インデントをshiftwidthの倍数に丸める
set shiftround

" Enable modeline.
set modeline

" Use clipboard register.
set clipboard& clipboard+=unnamed

" Disable auto wrap.
autocmd FileType * set textwidth=0

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
set autoread

" Ignore case on insert completion.
set infercase

" Search home directory path on cd.
" But can't complete.
set cdpath+=~

" Save fold settings.
" 無名バッファを開くときにエラーになる問題に対応。
" *.*と違って、拡張子がないファイルにも対応した。
augroup MyView
    autocmd!
    autocmd BufWinLeave * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
    autocmd BufWinEnter * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
augroup END
" Don't save options.
set viewoptions-=options

" Enable folding.
set foldenable
" 折りたたみ方法は分かりやすいマーカーにする。
set foldmethod=marker
" Show folding level.
set foldcolumn=4

" GrepをVim標準のGrepにする
set grepprg=internal

" = をファイル名の一部と認識しない
set isfname-==

" 編集したら、自動的に.vimrc, .gvimrcをリロードする
" GUIの場合、.vimrcを編集したら.gvimrcもロードする。
if !has('gui_running') && !(has('win32') || has('win64'))
    augroup MyVimRCReload
        " .vimrcの再読込時にも色が変化するようにする
        autocmd! BufWritePost .vimrc nested source $MYVIMRC
    augroup END
else
    augroup MyVimRCReload
        autocmd!
        " .vimrcの再読込時にも色が変化するようにする
        autocmd BufWritePost .vimrc source $MYVIMRC | 
                    \if has('gui_running') | source $MYGVIMRC  
        autocmd BufWritePost .gvimrc if has('gui_running') | source $MYGVIMRC
    augroup END
endif

" キーマッピング時やキーコード解釈の遅延時間を設定
set timeout timeoutlen=2500 ttimeoutlen=50

" 何も操作していないときにCursorHoldが呼ばれる時間
set updatetime=3000

"}}}

"---------------------------------------------------------------------------
" View:"{{{
"
" Show line number.
set number
" Show cursor position.
set ruler
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
set titlestring=%f%(\ %M%)%(\ (%{getcwd()})%)%(\ %a%)

" Set tabline.
function! s:my_tabline()  "{{{
      let l:s = ''
       
      for l:i in range(1, tabpagenr('$'))
          let l:bufnrs = tabpagebuflist(i)
          let l:curbufnr = l:bufnrs[tabpagewinnr(l:i) - 1]  " first window, first appears

          let l:no = (l:i <= 10 ? l:i-1 : '#')  " display 0-origin tabpagenr.
          let l:mod = len(filter(l:bufnrs, 'getbufvar(v:val, "&modified")')) ? '!' : ' '
          let l:title = gettabwinvar(l:i, tabpagewinnr(l:i), 'title')
          if empty(l:title)
              let l:title = fnamemodify(gettabwinvar(l:i, tabpagewinnr(l:i), 'cwd'), ':t')
              if empty(l:title)
                  let l:title = fnamemodify(bufname(l:curbufnr),':t')
                  if empty(l:title)
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

" 画面に収まりきる最後の文字ではなく、オプション 'breakat'
" に指定された文字のところで、長い行を折り返す
set linebreak
set showbreak="> "
set breakat=" 	;:,!?"

" 省略表示を行う
" Vim起動時に挨拶メッセージを表示しない
set shortmess& shortmess+=Ia

" Don't create backup.
set nowritebackup
set nobackup

" Disable bell.
set visualbell
set vb t_vb=

" 補完候補を表示する
set nowildmenu
set wildmode=list:longest,full
" Increase history.
set history=200
" Insertモードの補完でタグの情報をすべて表示する
set showfulltag
" コマンドラインでタグを補完できるように
set wildoptions=tagfile

" Completion setting.
set completeopt=menuone,preview
" Enable dictionary completion.
set complete+=k
" Set popup menu max height.
set pumheight=20

" Report changes.
set report=0

" 移動時にできるだけ現在の列を保持する
set nostartofline

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=40
" Set minimal height for current window.
set winheight=20

" Adjust window size of preview and help.
set previewheight=5
set helpheight=14

if has('win32') || has('win64')
    " Don't redraw while macro executing.
    set lazyredraw
else
    set nolazyredraw
endif

" セッションとしてウインドウサイズを保存する
set sessionoptions+=resize

" Enable menu in console.
if !has('gui_running')
    source $VIMRUNTIME/menu.vim
    set cpo-=<
    set wcm=<C-z>
    noremap <F2> :emenu <C-z>
endif

" 一行が長いときに@で省略しない
set display=lastline

"}}}

"---------------------------------------------------------------------------
" Syntax:"{{{
"
" syntaxに応じたカラー表示を有効にする
syntax enable

" 賢いインデントを有効に
set autoindent smartindent

augroup MySyntax"{{{
    autocmd!

    " syntaxの自動判別"{{{
    " Nemerle
    autocmd BufNewfile,BufRead *.n setf nemerle
    " Perl6
    autocmd BufNewfile,BufRead *.p6 setf perl6 
    " Perl5
    autocmd BufNewfile,BufRead *.p5 setf perl
    " TeXEruby
    autocmd BufRead,BufNewFile *.tex.erb setfiletype tex.eruby
    "}}}

    " gauche用シンタックスを有効にする。
    autocmd FileType scheme nested let b:is_gauche=1 | setlocal lispwords=define | 
                \let b:current_syntax='' | syntax enable

    " Rubyの時だけインデントを２文字にする
    autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

    " Easily load VimScript.
    autocmd FileType vim nnoremap <silent> <LocalLeader>r :write \| source %<CR>
    autocmd FileType vim noremap <silent> <LocalLeader>R :Source<CR>
    " Emacsのように改行して結果も挿入する
    "autocmd FileType vim inoremap <buffer><silent> <C-j>    <C-o>"ayy<CR>" => <C-o>:let @a=eval("<C-r>a<C-h>")<CR><C-o>"ap

    " Dのコメントとオーバーロードの色分けを有効にする
    autocmd FileType d let d_comment_strings = 1 | let d_hl_operator_overload = 1

    " netrwでは<C-h>で上のディレクトリへ移動
    autocmd FileType netrw nmap <buffer> <C-h> -

    " Manage long Rakefile easily
    autocmd BufNewfile,BufRead Rakefile foldmethod=syntax foldnestmax=1

    " Omni補完を有効にする"{{{
    autocmd FileType ada setlocal omnifunc=adacomplete#Complete
    autocmd FileType c setlocal omnifunc=ccomplete#Complete
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    "}}}

    " 何もない場合はsyntaxの補完"{{{
    autocmd Filetype *
                \	if &omnifunc == "" |
                \		setlocal omnifunc=syntaxcomplete#Complete |
                \	endif
    "}}}
augroup END
"}}}

"}}}"}}}

"---------------------------------------------------------------------------
" Plugin:"{{{
"

" yanktmp.vim"{{{
" それほど使わないのでSyに格下げ
map <silent> Sy    <Plug>(yanktmp_yank)
map <silent> Sp    <Plug>(yanktmp_paste_p)
map <silent> SP    <Plug>(yanktmp_paste_P)
"}}}

" FuzzyFinder.vim"{{{
" Setting options.
let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
" 補完候補の表示をここで打ち切る
let g:FuzzyFinderOptions.Base.enumerating_limit = 100
" バッファの補完で大文字小文字を区別しない
let g:FuzzyFinderOptions.Base.ignore_case = 1
let g:FuzzyFinderOptions.MruFile.max_item = 150
"}}}

" bufstatus.vim"{{{
" C-lではステータスラインも再描画する
nmap <silent> <C-l> <Plug>(bufstatus_redraw)
"}}}

" neocomplcache.vim"{{{
" autocomplpopを起動時に無効に
let g:AutoComplPop_NotEnableAtStartup = 1
" せっかく作ったので常用してみる
let g:NeoComplCache_EnableAtStartup = 1
" <C-e>でトグル
nnoremap <silent> <C-e> :<C-u>NeoComplCacheToggle<CR>

" Define dictionary.
let g:NeoComplCache_DictionaryFileTypeLists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }
"}}}

" NERD_comments.vim"{{{
let NERDSpaceDelims = 0
let NERDShutUp = 1
" NERD_commentsを入れると、C-cが変なコマンドにマッピングされるので、
" それを元に戻す。
nnoremap <C-c> <C-c>
nunmap <C-c>
"}}}

" vimshell.vim"{{{
" 
if has('win32') || has('win64') 
    " Display user name on Windows
    let g:VimShell_Prompt = $USERNAME."% "

    " Use ckw
    let g:VimShell_UseCkw = 1
else
    " Display user name on Linux
    let g:VimShell_Prompt = $USER."% "
endif
"}}}

" scratch.vim"{{{
" scratchバッファのバックアップファイルを設定
let g:scratchBackupFile=$HOME . "/scratch.txt"
"}}}

" netrw.vim"{{{
let g:netrw_list_hide= '*.swp'
nnoremap <silent> <BS> :<C-u>Explore<CR>
" Change default directory.
set browsedir=current
"}}}

" markbrowser.vim
nnoremap <silent> <Leader>mb :<C-u>MarksBrowser<CR>

" ZoomWin.vim
nnoremap <silent> sz :<C-u>ZoomWin<CR>

" eregex.vim"{{{
" &と~を文字そのものとして置換する
" Vimの意味にするには\&と\~を使う。
let eregex_replacement = 2
"}}}

" VTreeExplorer.vim"{{{
let g:treeExplVertical=1
nnoremap <silent> <Leader>vt :<C-u>VTreeExplore<CR>
nnoremap <silent> <Leader>vs :<C-u>VSTreeExplore<CR>
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
"}}}

" grep.vim"{{{
if has('win32') || has('win64')
    let Grep_Path = 'grep.exe'
    let Fgrep_Path = 'grep.exe -F'
    let Egrep_Path = 'grep.exe -E'
    let Grep_Find_Path = 'find.exe'
    let Grep_Xargs_Path = 'xargs.exe'
    let Grep_Shell_Quote_Char = '"'
else
    let Grep_Path = 'grep'
    let Fgrep_Path = 'fgrep'
    let Egrep_Path = 'egrep'
    let Grep_Find_Path = 'find'
    let Grep_Xargs_Path = 'xargs'
    "let Grep_Shell_Quote_Char = '"'
endif
" 検索対象から除外するディレクトリ、ファイルなどの指定
let Grep_Skip_Dirs = '.svn .git .cvs'
let Grep_Skip_Files = '*.bak *~ *.swp'
"}}}

" project.vim ------------------------------------------------ {{{
" カレントディレクトリにプロジェクトを作成する
nnoremap <silent> <Leader>pr  :<C-u>Project .vimprojects<CR>
" デフォルトでは短すぎる
let g:proj_window_width = 30
"}}}

" taglist.vim ------------------------------------------------- {{{
let g:Tlist_Show_One_File = 1                         " 現在編集中のソースのタグしか表示しない
let g:Tlist_Exit_OnlyWindow = 1                      " taglistのウィンドーが最後のウィンドーならばVimを閉じる
let g:Tlist_Use_Right_Window = 1                  " 右側でtaglistのウィンドーを表示
"taglistを開くショットカットキー
nnoremap <silent> <leader>tl :<C-u>TlistToggle<CR>
"}}}

" git.vim ----------------------------------------------------- {{{
nnoremap [Space]gad :CD! \| GitAdd<Space>
nnoremap [Space]gac :CD! \| GitAdd <C-r>=expand("%:t")<CR><CR>
nnoremap [Space]gd :CD! \| GitDiff<Space> 
nnoremap [Space]gco :CD! \| GitCommit<Space>
nnoremap [Space]gca :CD! \| GitCommit -a<CR>
nnoremap [Space]gcc :CD! \| GitCommit <C-r>=expand("%:t")<CR><CR>
nnoremap [Space]gl :CD! \| GitLog<CR>
nnoremap [Space]gs :CD! \| GitStatus<CR>
"}}}

" ku.vim"{{{
nnoremap <Leader>ku  :<C-u>Ku<Space>
nnoremap <silent> <Leader>ka  :<C-u>Ku args<CR>
nnoremap <silent> <Leader>kb  :<C-u>Ku buffer<CR>
nnoremap <silent> <Leader>kf  :<C-u>Ku file<CR>
nnoremap <silent> <Leader>kg  :<C-u>Ku metarw-git<CR>
nnoremap <silent> <Leader>kh  :<C-u>Ku history<CR>
nnoremap <silent> <Leader>kk  :<C-u>call ku#restart()
nnoremap <silent> <Leader>km  :<C-u>Ku file_mru<CR>
" p is for packages.
nnoremap <silent> <Leader>kp  :<C-u>Ku bundle<CR>
nnoremap <silent> <Leader>kq  :<C-u>Ku quickfix<CR>
nnoremap <silent> <Leader>ks  :<C-u>Ku source<CR>
" w is for ~/working.
nnoremap <silent> <Leader>kw  :<C-u>Ku myproject<CR>
augroup KuAutoCmd
    autocmd!
    autocmd FileType ku
                \   call ku#default_key_mappings(1)
                \ | call ku#custom_action('bundle', 'default', 'bundle', 'args')
                \ | call ku#custom_action('common', 'cd', s:SID_PREFIX() . 'ku_common_action_my_cd')
                \ | call ku#custom_action('myproject', 'default', 'common', 'tab-Right')
                \
                \ | call ku#custom_prefix('common', 'HOME', $HOME)
                \ | call ku#custom_prefix('common', '~', $HOME)
                \ | call ku#custom_prefix('common', '.vim', $HOME.'/.vim')
                \ | call ku#custom_prefix('common', '.v', $HOME.'/.vim')
                \ | call ku#custom_prefix('common', 'VIM', $VIMRUNTIME)
augroup END

function! s:ku_common_action_my_cd(item)
    if isdirectory(a:item.word)
        execute 'CD' a:item.word
    else  " treat a:item as a file name
        execute 'CD' fnamemodify(a:item.word, ':h')
    endif
endfunction

" metarw.vim
" Define wrapper commands.
call metarw#define_wrapper_commands(1)

"}}}

" smartword.vim"{{{
" Replace w and others with smartword-mappings
nmap w  <Plug>(smartword-w)
nmap b  <Plug>(smartword-b)
nmap E  <Plug>(smartword-e)
nmap ge  <Plug>(smartword-ge)
vmap w  <Plug>(smartword-w)
vmap b  <Plug>(smartword-b)
vmap E  <Plug>(smartword-e)
vmap ge  <Plug>(smartword-ge)
" Operator pending mode.
omap <Leader>w  <Plug>(smartword-w)
omap <Leader>b  <Plug>(smartword-b)
omap <Leader>e  <Plug>(smartword-e)
omap <Leader>ge  <Plug>(smartword-ge)
"}}}

"}}}

"---------------------------------------------------------------------------
" Key-mappings: "{{{
"
" Insert mode keymappings: "{{{
" C-tを押すと強制的にタブを挿入
inoremap <C-t>  <C-v><TAB>
" C-dを押すと削除
inoremap <C-d>  <Del>
" C-aで行頭に
inoremap <silent><C-a>  <C-o>^
" C-f, C-bで補完候補をページ移動
inoremap <C-f>  <PageDown>
inoremap <C-b>  <PageUp>
" A-bで1単語戻る
inoremap <A-b>  <S-Left>
" A-fで1単語進む
inoremap <A-f>  <S-Right>
" Enable undo <C-w> and <C-u>.
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>
" <C-Space>: Elegant <ESC>
inoremap <C-Space>  <ESC>

" ポップアップメニューが開いているかによって動作を変える"{{{
" <TAB> completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" C-eで行末に
inoremap <expr><silent><C-e>  pumvisible() ? "\<C-e>" : "\<C-o>$"
" C-yを押すとヤンクレジスタの内容を貼り付け
inoremap <expr><C-y>  pumvisible() ? "\<C-y>" : "\<C-r>*"
" C-jでオムニ補完
inoremap <expr><C-j>  pumvisible() ? "\<Down>" : "\<C-x>\<C-o>\<C-p>"
" C-kを押すと行末まで削除
inoremap <expr><C-k>  pumvisible() ? "\<Up>" : "\<C-o>D"
" C-hで補完を続行しない
inoremap <expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
" C-nでaltautocomplpop補完
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 途中でEnterしたとき、ポップアップを消して改行し、
" 改行を連続して入力してもインデント部を保持する
inoremap <expr><CR> pumvisible() ? "\<C-y>\<CR>X\<BS>" : "\<CR>X\<BS>"
"}}}
"}}}

" Command-line mode keymappings:"{{{
" C-aで行頭へ移動
cnoremap <C-a>          <Home>
" C-bで一文字戻る
cnoremap <C-b>          <Left>
" C-dでカーソルの下の文字を削除
cnoremap <C-d>          <Del>
" C-eで行末へ移動
cnoremap <C-e>          <End>
" C-fで一文字進む
cnoremap <C-f>          <Right>
" C-nでコマンドライン履歴を一つ進む
cnoremap <C-n>          <Down>
" C-pでコマンドライン履歴を一つ戻る
cnoremap <C-p>          <Up>
" C-kで行末まで削除
cnoremap <C-k>          <C-f>d$<C-c><End>
" C-yでペースト
cnoremap <C-y>          <C-r>"
" C-sでヒストリを出す
cnoremap <C-s>          <C-f>
" C-lで補完リストを出す
cnoremap <C-l>          <C-d>
" A-bで1単語戻る
cnoremap <A-b>          <S-Left>
" A-fで1単語進む
cnoremap <A-f>          <S-Right>
" C-j, C-oで補完候補を移動する
" TABを連打するより高速。
cnoremap <C-j>          <C-n>
cnoremap <C-o>          <C-p>
" C-gで補完を決定
cnoremap <C-g>          <Space><C-h>
" C-tでスペース挿入
cnoremap <C-t>          <Space>
" <C-space>: Elegant <ESC>
cnoremap <C-Space>  <C-c>
"}}}

" [Space]: Other useful commands "{{{
" スペースキーのマッピングを見やすくする
" noremapに<Space>で始まるものを使うと[Space]が表示されなくなるので注意！
map  <Space>   [Space]
noremap  [Space]   <Nop>

" Toggle highlight.
nnoremap <silent> [Space]/  :<C-u>call ToggleOption('hlsearch')<CR>
" Toggle cursorline.
nnoremap <silent> [Space]cl  :<C-u>call ToggleOption('cursorline')<CR>
" Output encoding information.
nnoremap <silent> [Space]en  :<C-u>setlocal encoding? termencoding? fenc? fencs?<CR>
" Set fileencoding.
nnoremap [Space]fe  :<C-u>set fileencoding=

" Useless commands
noremap e;  ;
noremap e,  ,

" Easily edit .vimrc and .gvimrc "{{{
nnoremap <silent> [Space]ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> [Space]eg  :<C-u>edit $MYGVIMRC<CR>
" Load .gvimrc after .vimrc edited at GVim.
nnoremap <silent> [Space]rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <silent> [Space]rg :<C-u>source $MYGVIMRC<CR>
"}}}

" Easily check registers and marks.
nnoremap <silent> [Space]mk  :<C-u>marks<CR>
nnoremap <silent> [Space]re  :<C-u>registers<CR>

" Easily check key-mappings.
nnoremap [Space]mpn  :<C-u>nnoremap<Space>
nnoremap [Space]mpi  :<C-u>inoremap<Space>
nnoremap [Space]mpc  :<C-u>cnoremap<Space>

" Saves "{{{
" :wはよく使うので<Space>wにマッピングする
noremap <silent> [Space]w  :<C-u>write<CR>
" :w!はよく使うので<Space>fwにマッピングする
noremap <silent> [Space]fw  :<C-u>write!<CR>
" :qはよく使うので<Space>qにマッピングする
noremap <silent> [Space]q  :<C-u>quit<CR>
" :qaは<Space>aqにマッピングする
noremap <silent> [Space]aq  :<C-u>quitall<CR>
" :q!はよく使うので<Space>fqにマッピングする
noremap <silent> [Space]fq  :<C-u>quitall!<CR>
" <Leader><Leader>で変更があれば保存
noremap <Leader><Leader> :<C-u>update<CR>
"}}}

" Change current directory.
nnoremap <silent> [Space]cd :<C-u>CD<CR>

" Delete windows ^M codes.
noremap <silent> [Space]<C-m> mmHmt:<C-u>%s/<C-v><CR>$//ge<CR>'tzt'm

" Easily syntax change."{{{
nnoremap [Space]0 :setl syntax=<CR>
nnoremap [Space]1 :setl syntax=xhtml<CR>
nnoremap [Space]2 :setl syntax=php<CR>
nnoremap [Space]3 :setl syntax=python<CR>
nnoremap [Space]4 :setl syntax=ruby<CR>
nnoremap [Space]5 :setl ft=javascript<CR>
" Detect syntax
nnoremap [Space]$ :filetype detect<cr>
nnoremap [Space]ft  :<C-u>setfiletype<Space>
"}}}

" Save and make. "{{{
noremap <silent> [Space]ma    :wall \| Make!<CR>
" Save and make test.
noremap <silent> [Space]mt    :wall \| echo system('make -s test')<CR>
" Toggle automatically make.
noremap <silent> [Space]mm :call <SID>EnableFlyMake()<CR>
"}}}

" Exchange gj and gk to j and k. "{{{
command! -nargs=? -bar -bang ToggleGJK call s:ToggleGJK()
noremap <silent> [Space]gj :<C-u>ToggleGJK<CR>
let g:enable_mapping_gjk = 0
function! s:ToggleGJK()
    if g:enable_mapping_gjk
        let g:enable_mapping_gjk = 0
        noremap j j
        noremap k k
        noremap gj gj
        noremap gk gk
    else
        let g:enable_mapping_gjk = 1
        noremap j gj
        noremap k gk
        noremap gj j
        noremap gk k
    endif
endfunction"}}}

" Screen evaluation "{{{
if &term =~ "^screen"
    nnoremap <silent> [Space]se :<C-u>call ScreenEval(getline('.'))<CR>
    vnoremap <silent> [Space]se "zy:<C-u>call ScreenEval(@z)<CR>
endif"}}}

" Change tab width. "{{{
nnoremap <silent> [Space]t2 :<C-u>setl shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> [Space]t4 :<C-u>setl shiftwidth=4 softtabstop=4<CR>
nnoremap <silent> [Space]t8 :<C-u>setl shiftwidth=8 softtabstop=8<CR>
"}}}

"}}}

" t: tags-and-searches "{{{
" 副作用により、:helpが快適に。
" 誤作動の原因となるので、tは潰す。
" 混乱するのでTも潰す。
noremap t  <Nop>
noremap T  <Nop>
" 飛ぶ
noremap tt  <C-]>
" 進む
nnoremap <silent> tn  :<C-u>tag<CR>
" 戻る
nnoremap <silent> tp  :<C-u>pop<CR>
" 履歴一覧
nnoremap <silent> tl  :<C-u>tags<CR>
" タグのリストを表示し、選択する
nnoremap <silent> ts  :<C-u>tselect<CR>
" 現在の候補を表示
nnoremap <silent> ti  :<C-u>0tnext<CR>
" 次の候補へ
nnoremap <silent> tN  :<C-u>tnext<CR>
" 前の候補へ
nnoremap <silent> tP  :<C-u>tprevious<CR>
" 最初の候補へ
nnoremap <silent> tF  :<C-u>tfirst<CR>
" 前の候補へ
nnoremap <silent> tL  :<C-u>tlast<CR>
" タグを指定してジャンプする
nnoremap tf  :<C-u>tag<Space>
" プレビューウインドウで飛ぶ
nnoremap t't  <C-w>}
vnoremap t't  <C-w>}
nnoremap <silent> t'n  :<C-u>ptnext<CR>
nnoremap <silent> t'p  :<C-u>ptprevious<CR>
nnoremap <silent> t'P  :<C-u>ptfirst<CR>
nnoremap <silent> t'N  :<C-u>ptlast<CR>
" プレビューウインドウを閉じる
nnoremap <silent> t'c  :<C-u>pclose<CR>
" 分割して飛ぶ
nnoremap t]  <C-w>]
"}}}

" s: Windows and buffers(High priority) "{{{
nnoremap s  <NOP>
nnoremap <silent> sc  :<C-u>close<CR>
nnoremap <silent> so  :<C-u>only<CR>
nnoremap <silent> sj  <C-w>j
nnoremap <silent> sk  <C-w>k
nnoremap <silent> sh  <C-w>h
nnoremap <silent> sl  <C-w>l
nnoremap <silent> st  <C-w>t
nnoremap <silent> sb  <C-w>b
nnoremap <silent> sw  <C-w>w
nnoremap <silent> <Tab> <C-w>w
" ウインドウサイズに応じてsplit"{{{
command! SplitNicely call s:split_nicely()
function! s:split_nicely()
    if 80*2 * 15/16 <= winwidth(0) " FIXME: threshold customization
        vsplit
    else
        split
    endif
endfunction
"}}}
" sdで現在のバッファを閉じる
nnoremap <silent> sd  :<C-u>bdelete<CR>
"sDで指定したバッファを閉じる"{{{
function! s:InputBufferDelete()
    ls
    let l:in = input('Select delete buffer: ', '', 'buffer')
    execute 'bdelete' . l:in
endfunction
nnoremap <silent> sD  :<C-u>call <SID>InputBufferDelete()<CR>
"}}}
" sfdで現在のバッファを強制的に閉じる"{{{
function! s:CustomBufferForceDelete()
    bdelete!
endfunction
nnoremap <silent> sfd  :<C-u>call <SID>CustomBufferForceDelete()<CR>
"}}}
"sfDで指定したバッファを強制的に閉じる"{{{
function! s:InputBufferForceDelete()
    ls
    let l:in = input('Select force delete buffer: ', '', 'buffer')
    execute 'bdelete!' . l:in
endfunction
nnoremap <silent> sfD  :<C-u>call <SID>InputBufferForceDelete()<CR>
"}}}
" Buffer move.
nnoremap <silent> sP  :<C-u>bfirst<CR>
nnoremap <silent> sN  :<C-u>blast<CR>
nnoremap <silent> sp  :<C-u>bprevious<CR>
nnoremap <silent> sn  :<C-u>bnext<CR>
nnoremap <silent> s;  :<C-u>bnext<CR>
nnoremap <silent> s,  :<C-u>bprevious<CR>
" Fast buffer switch.
nnoremap <silent> s<Space>  <C-^>
" Move to other buffer numbering from left.
for i in range(0, 9)
  execute 'nnoremap <silent>' ('s'.i)  (':<C-u>call '.s:SID_PREFIX().'MoveBufferFromLeft('.i.')<CR>')
endfor
unlet i
function! s:MoveBufferFromLeft(num)
    let l:cnt = -1
    let l:pos = 0
    while l:cnt < a:num
        let l:pos += 1

        if l:pos > bufnr('$')
            echo 'Not found buffer.'
            return
        endif

        if buflisted(l:pos)
            let l:cnt += 1
        endif
    endwhile

    execute 'buffer' . l:pos
endfunction
" Move to input buffer numbering from left.
nnoremap <silent> s.  :<C-u>call <SID>MoveInputBufferFromLeft()<CR>
function! s:MoveInputBufferFromLeft()
    let l:in = input('Select the buffer from left position: ')
    if l:in =~ '^\d\+$'
        call s:MoveBufferFromLeft(l:in)
    else
        echo 'Not a number.'
    endif
endfunction

" ss: Windows and buffers(Low priority) "{{{
" bを潰すのはあんまりなので、ssに間借りする。
nnoremap ss  <NOP>
nnoremap <silent> ssp  :<C-u>split<CR>
nnoremap <silent> ssv  :<C-u>vsplit<CR>
nnoremap <silent> ses  :<C-u>new<CR>
nnoremap <silent> sen  :<C-u>enew<CR>
nmap <silent> sst  <F8>
nnoremap <silent> ssa  :<C-u>args<CR>
nnoremap <silent> ssv  :<C-u>vnew<CR>
nnoremap <silent> ssn  :<C-u>new<CR>
nnoremap <silent> ssl  :<C-u>ls<CR>
nnoremap <silent> ssm  :<C-u>bmodified<CR>
" Move to other buffer like screen.
for i in range(1, 9)
  execute 'nnoremap <silent>' ('ss'.i)  (':<C-u>buffer '.i.'<CR>')
endfor
unlet i
" Move to input buffer number.
nnoremap <silent> ss0  :<C-u>call <SID>InputBuffer()<CR>
nnoremap <silent> ss.  :<C-u>call <SID>InputBuffer()<CR>
function! s:InputBuffer()
    ls
    let l:in = input('Select the buffer: ', '', 'buffer')
    execute 'buffer' . l:in
endfunction
"}}}
"}}}

" e: Change basic commands "{{{
" Exchange e to E.
nnoremap e <NOP>
nnoremap E e

" Emacs run.
nnoremap <silent> e!  :<C-u>Run2<CR>
" Indent paste.
nnoremap ep p=`]
nnoremap eP P=`]
" Insert blank line.
nnoremap eo o<ESC>
nnoremap eO O<ESC>
" Yank to end line.
nmap ey y$
" Delete first character.
nnoremap ex ^x
nnoremap X ^x
" Line selection <C-v>.
nnoremap eV 0<C-v>$h

" eregex.vim commands."{{{
" Don't allow M/ region.
noremap e/ :<C-u>M/
" S, G, V target whole current buffer.
nnoremap es :%S/
vnoremap es :S/
nnoremap eg :%G/
vnoremap eg :G/
nnoremap ev :%V/
vnoremap ev :V/
"}}}

"}}}

" <C-g>: Argument list  "{{{

" the prefix key.
" <C-g>はg<C-g>で代用できるので、間違いなく使わない。
nnoremap <C-g>  <Nop>
 
noremap <C-g><Space>  :<C-u>args<Space>
noremap <silent> <C-g>l  :<C-u>args<CR>
noremap <silent> <C-g>n  :<C-u>next<CR>
noremap <silent> <C-g>p  :<C-u>previous<CR>
noremap <silent> <C-g>P  :<C-u>first<CR>
noremap <silent> <C-g>N  :<C-u>last<CR>
noremap <silent> <C-g>wp :<C-u>wnext<CR>
noremap <silent> <C-g>wn :<C-u>wprevious<CR>
 
nmap <C-g><C-l>  <C-g>l
nmap <C-g><C-p>  <C-g>p
nmap <C-g><C-n>  <C-g>n
nmap <C-g><C-w><C-p>  <C-g>wp
nmap <C-g><C-w><C-n>  <C-g>wn
"}}}

" <C-t>: Tab pages"{{{
" 元のC-tはtpで代用できるので潰す。
nnoremap <C-t>  <Nop>
" タブの生成
noremap <silent> <C-t>n  :<C-u>tabnew<CR>
noremap <silent> <C-t>c  :<C-u>tabclose<CR>
noremap <silent> <C-t>o  :<C-u>tabonly<CR>
noremap <silent> <C-t>i  :<C-u>tabs<CR>
nmap <C-t><C-n>  <C-t>n
nmap <C-t><C-c>  <C-t>c
nmap <C-t><C-o>  <C-t>o
nmap <C-t><C-i>  <C-t>i
" タブの移動
noremap <silent> <C-t>j
            \ :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
noremap <silent> <C-t>k  :<C-u>tabprevious<CR>
noremap <silent> <C-t>K  :<C-u>tabfirst<CR>
noremap <silent> <C-t>J  :<C-u>tablast<CR>
noremap <silent> <C-t>l
            \ :<C-u>execute 'tabmove' min([tabpagenr() + v:count1 - 1, tabpagenr('$')])<CR>
noremap <silent> <C-t>h
            \ :<C-u>execute 'tabmove' max([tabpagenr() - v:count1 - 1, 0])<CR>
noremap <silent> <C-t>L  :<C-u>tabmove<CR>
noremap <silent> <C-t>H  :<C-u>tabmove 0<CR>
nmap <C-t><C-j>  <C-t>j
nmap <C-t><C-k>  <C-t>k
nmap <C-t><C-t>  <C-t>j
nmap <C-t><C-l>  <C-t>l
nmap <C-t><C-h>  <C-t>h
" C-nで次のタブを表示
nmap <silent> <C-n>   <C-t>j
" C-pで前のタブを表示
nmap <silent> <C-p>   <C-t>k

" Change current tab like GNU screen.
" Note that the numbers in {lhs}s are 0-origin.  See also 'tabline'.
for i in range(10)
  execute 'nnoremap <silent>' ('<C-t>'.(i))  ((i+1).'gt')
endfor
unlet i
"}}}

" q: Quickfix  "{{{
 
" the prefix key.
nnoremap q  <Nop>
" Ex-modeを潰して、マクロ記録と置き換え
nnoremap Q  q
 
" For quickfix list  "{{{3
nnoremap <silent> qn  :<C-u>cnext<CR>
nnoremap <silent> qp  :<C-u>cprevious<CR>
nnoremap <silent> qr  :<C-u>crewind<CR>
nnoremap <silent> qN  :<C-u>cfirst<CR>
nnoremap <silent> qP  :<C-u>clast<CR>
nnoremap <silent> qfn :<C-u>cnfile<CR>
nnoremap <silent> qfp :<C-u>cpfile<CR>
nnoremap <silent> ql  :<C-u>clist<CR>
nnoremap <silent> qq  :<C-u>cc<CR>
nnoremap <silent> qo  :<C-u>copen<CR>
nnoremap <silent> qc  :<C-u>cclose<CR>
nnoremap <silent> qen :<C-u>cnewer<CR>
nnoremap <silent> qep :<C-u>colder<CR>
nnoremap <silent> qm  :<C-u>make<CR>
nnoremap qM  :<C-u>make<Space>
nnoremap qg  :<C-u>grep<Space>
" Toggle quickfix window.
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction
nnoremap <silent> q<Space> :<C-u>call <SID>toggle_quickfix_window()<CR>

" For location list (mnemonic: Quickfix list for the current Window)  "{{{3
nnoremap <silent> qwn  :<C-u>lnext<CR>
nnoremap <silent> qwp  :<C-u>lprevious<CR>
nnoremap <silent> qwr  :<C-u>lrewind<CR>
nnoremap <silent> qwP  :<C-u>lfirst<CR>
nnoremap <silent> qwN  :<C-u>llast<CR>
nnoremap <silent> qwfn :<C-u>lnfile<CR>
nnoremap <silent> qwfp :<C-u>lpfile<CR>
nnoremap <silent> qwl  :<C-u>llist<CR>
nnoremap <silent> qwq  :<C-u>ll<CR>
nnoremap <silent> qwo  :<C-u>lopen<CR>
nnoremap <silent> qwc  :<C-u>lclose<CR>
nnoremap <silent> qwep :<C-u>lolder<CR>
nnoremap <silent> qwen :<C-u>lnewer<CR>
nnoremap <silent> qwm  :<C-u>lmake<CR>
nnoremap qwM  :<C-u>lmake<Space>
nnoremap qw<Space>  :<C-u>lmake<Space>
nnoremap qwg  :<C-u>lgrep<Space>
"}}}

"}}}

" f: FuzzyFinder, FuzzyJump "{{{
" The prefix key.
nnoremap f  <NOP>
nnoremap F  f

" FuzzyJump
map '  <Plug>(fuzzyjump-prefix)
map fj  <Plug>(fuzzyjump-prefix)

" FuzzyFinder
nnoremap <silent> fb  :<C-u>FuzzyFinderBuffer<CR>
nnoremap <silent> ff  :<C-u>FuzzyFinderFile<CR>
nnoremap <silent> fd  :<C-u>FuzzyFinderDir<CR>
noremap <silent> ft  :<C-u>FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
nnoremap <silent> f]  :<C-u>FuzzyFinderTag!<CR>
nnoremap <silent> fk  :<C-u>FuzzyFinderBookmark<CR>
nnoremap <silent> fa  :<C-u>FuzzyFinderAddBookmark<CR>
nnoremap <silent> fr  :<C-u>FuzzyFinderRemoveCache<CR>
nnoremap <silent> fe  :<C-u>FuzzyFinderEditInfo<CR>
nnoremap <silent> fg  :<C-u>FuzzyFinderTaggedFile<CR>
nnoremap <silent> fm :<C-u>FuzzyFinderMruFile<CR>
" Disable MRU command mode.
"nnoremap <silent> fmc :<C-u>FuzzyFinderMruCmd<CR>
"}}}

" Jump mark can restore column."{{{
" あまり使わないので\に降格
nnoremap \  `
" mもMに降格
nnoremap M  m
"}}}

" Don't calc octal.
set nrformats-=octal

" Jump history.
noremap <silent> <C-k> <C-o>
noremap <silent> <C-j> <C-i>

" vimの画面を残したまま終了
nnoremap <silent> gZZ :<C-u>set t_te= t_ti= \| quit \| set t_te& t_ti&<CR>
" vimの画面を残したままシェルを起動
nnoremap <silent> gsh :<C-u>set t_te= t_ti= \| sh \| set t_te& t_ti&<CR>

" Move search word to middle screen."{{{
noremap n  nzz 
noremap N  Nzz 
noremap *  *zz 
noremap #  #zz 
noremap g*  g*zz 
noremap g#  g#zz
"}}}

" Smart C-f, C-b.
noremap <silent> <C-f> z<CR><C-f>z.
noremap <silent> <C-b> z-<C-b>z.

" Execute help."{{{
nnoremap <C-h>  :<C-u>help<Space>
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>help<Space><C-r><C-w><CR>
" Grep in help.
nnoremap grh  :<C-u>Hg<Space>
" Grep cursor word.
nnoremap grw  :<C-u>Egrep <C-r><C-w><CR>
" Execute grep.
nnoremap grp  :<C-u>Egrep<Space>
"}}}

" Ignore ZZ.
nnoremap ZZ  <Nop>

" Exchange ';' to ':'.
noremap ;  :

" Like gv, but select the last changed text.
nnoremap gc  `[v`]
" Specify the last changed text as {motion}.
onoremap <silent> gc  :<C-u>normal! gc<CR>

" Auto escape / and ? in search command.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Smart }."{{{
nnoremap <silent> } :<C-u>call ForwardParagraph()<CR>
onoremap <silent> } :<C-u>call ForwardParagraph()<CR>
vnoremap <silent> } <Esc>:<C-u>call ForwardParagraph()<CR>mzgv`z
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
vnoremap <silent> H <ESC>:<C-u>call HContext()<CR>mzgv`z
vnoremap <silent> L <ESC>:<C-u>call LContext()<CR>mzgv`z
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
vnoremap <silent> gh  <ESC>:<C-u>call SmartHome("v")<CR>
vnoremap <silent> gl  <ESC>:<C-u>call SmartEnd("v")<CR>
" Mappings normal commands.
nnoremap <silent> ^  :<C-u>call SmartHome("n")<CR>
nnoremap <silent> _  :<C-u>call SmartHome("n")<CR>
vnoremap <silent> ^  <ESC>:<C-u>call SmartHome("v")<CR>
vnoremap <silent> _  <ESC>:<C-u>call SmartHome("v")<CR>
" Mapping 0 to g0.
noremap 0  g0
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

" 現在行と同じインデントの前後の行へジャンプ"{{{
" Python なんかで便利。
nnoremap <silent> g{ :<C-u>call search("^" . matchstr(getline(line(".") + 1), '\(\s*\)') ."\\S", 'b')<CR>^
nnoremap <silent> g} :<C-u>call search("^" . matchstr(getline(line(".")), '\(\s*\)') ."\\S")<CR>^
"}}}

" Select block for example 'for, while, ...'
nnoremap vb /{<CR>%v%0

" Search for selecting text.
" ^@ などキー入力が困難なコントロール文字を検索（もしくは置換）対象にするときに重宝する。
vnoremap g* y/\V<C-R>=substitute(escape(@",'/'),"\n","\\\\n","g")<CR>/<CR>

" Insert buffer directory in command line."{{{
cnoremap <C-x> <C-r>=<SID>GetBufferDirectory()<CR>/
function! s:GetBufferDirectory()
  let l:path = expand('%:p:h')
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

" v select until end of current line in visual mode.
vnoremap v $h

" Paste current line.
nnoremap cp Pjdd

" Paste and indent line.
nnoremap ]p p`[=`]
nnoremap ]P P`[=`]

" Yank until end line.
nnoremap Y y$

" Like YankRing paste."{{{
for i in range(0, 9)
    execute 'nnoremap ' ('y'.i)  ('"'.i.'gp')
endfor
unlet i
nnoremap y+  "+gp
nnoremap y*  "*gp
"}}}

" Redraw
nnoremap <silent> <C-l>    :<C-u>redraw!<CR>

" Elegant <ESC>
noremap <C-Space>   <ESC>

" Folding."{{{
" If press h on head, fold close.
"nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press h on head, range fold close.
"vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" If press l on fold, range fold open.
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'
" Useful command.
noremap z<Space>   za
noremap eh  zc
"}}}

" Fast search pair.
map [Space]p    %

" Search a parenthesis.
onoremap <silent> q /["',.{}()[\]<>]<CR>

" Fast substitute.
vnoremap s y:%s/\<<C-R>"\>//g<Left><Left>

"}}}

"---------------------------------------------------------------------------
" Commands:"{{{
"

" Search in selecting text."{{{
" ちゃんと n や N もその範囲内だけになる
function! RangeSearch(direction)
endfunction
command! -nargs=0 -range RangeSearch call RangeSearch('/')|if strlen(g:srchstr) > 0|exe '/'.g:srchstr|endif
command! -nargs=0 -range RangeSearchBackward call RangeSearch('?')|if strlen(g:srchstr) > 0|exe '?'.g:srchstr|endif
"}}}

" 指定した名前を持つバッファが既に存在するならそこにカーソルを移動。 "{{{
" 存在しないなら作成。
function! SingletonBuffer(name, split)
    " 文字をエスケープ :h file-pattern
    let name=escape(a:name, '[]*?,\')
    if bufexists(a:name) " bufexists にはエスケープ必要ない
        let bufnr = bufnr(name)
        let winlist = WindowContains(bufnr)
        if empty(winlist)
            if a:split 
                split 
            endif
            exe "b " . bufnr
        else
            exe winlist[0] . "wincmd w"
        endif
    else
        if a:split
            exe "silent new " . escape(name, ' ')
        else
            exe "silent edit " . escape(name, ' ')
        endif
    endif
endfunction
"}}}

" 指定したバッファを含んでいるウィンドウ番号のリストを返す。"{{{
function! WindowContains(bufnr)
    return filter(range(1, winnr("$")), 'winbufnr(v:val)==' . a:bufnr)
endfunction"}}}
" ウインドウの高さを指定する"{{{
function! AdjustWindowHeight(maxheight)
    exe min([line("$") + 1, a:maxheight]) . "wincmd _"
endfunction"}}}

function! GUExecCmdWin(cmd, bufname)"{{{
    call SingletonBuffer(a:bufname, 1)
    lcd #:p:h
    setlocal buftype=nofile noswf 
    nnoremap <buffer><silent> q :close<CR>
    normal! gg"_dG
    echo a:cmd
    exe a:cmd
endfunction"}}}

function! GUExec(cmd, bufname, getError, isExpand)"{{{
    if a:isExpand != 0
        let cmd = exists("g:GUExec_cmd") ? g:GUExec_cmd : a:cmd." ".expand("%")
    else
        let cmd = exists("g:GUExec_cmd") ? g:GUExec_cmd : a:cmd
    endif
    call GUExecCmdWin('silent .!'.cmd, a:bufname)
    if line("$") < 4
        4wincmd _
        normal! gg
    endif 
    call AdjustWindowHeight(12)
    if a:getError
        cgetbuffer
        cw
    endif
endfunction"}}}

function! GUExecSetCmd(ft)"{{{
    let cmd = exists("g:GUExec_cmd") ? g:GUExec_cmd : " ".expand("%")
    let in = input("cmd: ", cmd, 'shellcmd')
    let g:GUExec_cmd = in
endfunction"}}}

function! EmacsRun(defaultcmd, isExpand)"{{{
    if !exists("g:run2_default_cmd") | let g:run2_default_cmd = "" | endif
    let cmd = input("run:" . substitute(getcwd(), g:home, '~', '') . "$ ", g:run2_default_cmd, "shellcmd")
    if cmd == ""
        return -1
    endif
    call GUExec(cmd, '[Shell output]', 0, a:isExpand)
    setlocal buftype=nofile buflisted
    normal! z-
    let g:run2_default_cmd = cmd
    if line("$") == 1
        echo getline(".")
        close
    endif
endfunction"}}}
" Emacs の M-! にかなり近いシェル実行コマンド"{{{
" バッファに出力できるので便利。
command! Run2 call EmacsRun("", 0)
" Run3は現在のバッファ名を引数に渡す。
command! Run3 call EmacsRun("", 1)"}}}

" Toggle options. "{{{
function! ToggleOption(option_name)
  execute 'setlocal' a:option_name.'!'
  execute 'setlocal' a:option_name.'?'
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
function! s:UpdateQuickFix(command, jump)
    " Rubyではruby -wcで文法チェックを行う
    if &ft == 'ruby'
        let lines = filter(split(system('ruby -wc '. shellescape(expand('%'))), "\n"), 'v:val != "Syntax OK"')
        cgetexpr lines
    elseif filereadable("Makefile")
        let lines = split(system('make -s'), "\n")
        cgetexpr lines
    elseif &ft == 'tex'
        " Because make error if no filename.
        call s:ChangeCurrentDir('', '!')
        if empty(a:command)
            silent make %<
        else
            execute "silent make " . a:command
        endif

        " remove deadwoods
        call delete(expand('%:r') . '.aux')
        call delete(expand('%:r') . '.log')
    else
        " Do ':make'
        if empty(a:command)
            silent make
        else
            execute "silent make " . a:command
        endif
    endif

    let n_error = len(filter(getqflist(), 'v:val.valid'))
    if n_error == 0
        cclose
        redraw!
        echo "QuickFix: no error.  :)"
    else
        " Have problem on bufstatus.
        "copen
        "setlocal nowrap
        "setlocal whichwrap=b,s

        if a:jump && n_error
            cc
            normal! zv
        else
            wincmd p
        endif
        redraw!
        echo printf('QuickFix: %d errors.', n_error)
    endif
    " for errormarker.vim
    silent doautocmd QuickFixCmdPost make
endfunction"}}}

command! -nargs=? -bar -bang Make call s:UpdateQuickFix("<args>", len('<bang>'))

" arg: 1->enable / 0->disable / omitted->toggle"{{{
function! s:EnableFlyMake(...)
    if a:0
        let s:flymake_enabled = a:1
    else
        let s:flymake_enabled = (!exists('s:flymake_enabled') || !s:flymake_enabled)
    endif
    redraw
    augroup flymake
        autocmd!
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
    if empty(a:directory)
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if empty(a:bang)
        pwd
    endif
endfunction"}}}

" Range source.
command! -range=% Source split `=tempname()` | call append(0, getbufline('#', <line1>, <line2>)) | write | source % | bdelete

" Substitute indent.
command! -range=% LeadUnderscores <line1>,<line2>s/^\s*/\=repeat('_', strlen(submatch(0)))/g
noremap <silent> [Space]u        :LeadUnderscores<CR>

"}}}
  
"---------------------------------------------------------------------------
" Platform depends:"{{{
"
if has('win32') || has('win64') 
    " For Windows"{{{

    " WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
    if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
        let $PATH = $VIM . ';' . $PATH
    endif

    " Shell settings.
    " Use NYACUS.
    set shell=nyacus.exe
    " Set parameters.
    set shellcmdflag=-e
    set shellpipe=\|&\ tee
    set shellredir=>%s\ 2>&1
    set shellxquote=\"
    " Exchange path separator.
    set shellslash

    " Change colorscheme.
    " Don't override colorscheme.
    if !exists('g:colors_name')
        colorscheme darkblue 
    endif
    " Disable error messages.
    let g:CSApprox_verbose_level = 0

    " そこそこ見れる補完リストにする
    hi Pmenu ctermbg=1
    hi PmenuSel ctermbg=8
    hi PmenuSbar ctermbg=0
    "}}}
else
    " For Linux"{{{

    " Use zsh.
    set shell=zsh

    " For non GVim.
    if !has('gui_running')
        " Enable 256 color terminal.
        set t_Co=256

        " Convert colorscheme in Konsole.
        let g:CSApprox_konsole = 1
        if !exists('g:colors_name')
            colorscheme candy
        endif

        augroup MyLinuxConsole
            autocmd!
            " For prevent bug.
            autocmd VimLeave * :set term=screen
        augroup END

        " For screen."{{{
        if &term =~ "^screen"
            augroup MyLinuxScreen
                autocmd!
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

" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
    " tagsファイルの重複防止
    set tags=./tags,tags
endif

"}}}

"---------------------------------------------------------------------------
" Others:"{{{
"
" Enable mouse support.
set mouse=a

" If true Vim master, use English help file.
"set helplang=ja
set helplang=en

" Default home directory.
let g:home = getcwd()

" Each tab has current directory."{{{
command! -nargs=? TabCD
      \   execute 'cd' fnameescape(<q-args>)
      \ | let t:cwd = getcwd()
augroup MyTab
    autocmd!
    autocmd TabEnter *
                \   if !exists('t:cwd')
                \ |   let t:cwd = getcwd()
                \ | endif
            \ | execute 'cd' fnameescape(t:cwd)
augroup END
" Exchange ':cd' to ':TabCD'.
cnoreabbrev <expr> lhs (getcmdtype() == ':' && getcmdline() ==# 'cd') ? 'TabCD' : 'cd'
"}}}

"}}}
"
" vim: foldmethod=marker
