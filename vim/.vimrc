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
command! Wutf8 setlocal fenc=utf-8
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
" Initialize:"{{{
"
" 文字化けするので、インターフェースに英語を使用する
if has('win32') || has('win64')
    " For Windows.
    language en
else
    " For Linux.
    language mes C
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

    " Searches when input Japanese.
    noremap       ・     /
    noremap       ？     ?
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
"set autoread

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
    autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
    autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
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

" Completion setting.
set completeopt=menuone,preview
" Don't complete from unload buffer.
set complete=.,w,b
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
set winwidth=40
" Set minimal height for current window.
set winheight=20

" Adjust window size of preview and help.
set previewheight=3
set helpheight=14

if has('win32') || has('win64')
    " Don't redraw while macro executing.
    set lazyredraw
else
    set nolazyredraw
endif

" Store window size as a session.
set sessionoptions+=resize

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

    " Enable gauche syntax.
    autocmd FileType scheme nested let b:is_gauche=1 | setlocal lispwords=define | 
                \let b:current_syntax='' | syntax enable

    " Easily load VimScript.
    autocmd FileType vim nnoremap <silent> <LocalLeader>r :write \| source %<CR>
    autocmd FileType vim noremap <silent> <LocalLeader>R :Source<CR>

    " Auto reload VimScript.
    autocmd BufWritePost,FileWritePost *.vim if &autoread | source <afile> | endif

    " Dのコメントとオーバーロードの色分けを有効にする
    autocmd FileType d let d_comment_strings = 1 | let d_hl_operator_overload = 1

    " netrwでは<C-h>で上のディレクトリへ移動
    autocmd FileType netrw nmap <buffer> <C-h> -

    " Manage long Rakefile easily
    autocmd BufNewfile,BufRead Rakefile foldmethod=syntax foldnestmax=1

    " Enable omni completion."{{{
    autocmd FileType ada setlocal omnifunc=adacomplete#Complete
    "autocmd FileType c setlocal omnifunc=ccomplete#Complete
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    " default omnifunc.
    autocmd Filetype * if &l:omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    "}}}

augroup END
"}}}

"}}}"}}}

"---------------------------------------------------------------------------
" Plugin:"{{{
"

" yanktmp.vim"{{{
" Because I don't use it that much, I demote it to Sy.
noremap S    <Nop>
map <silent> Sy    <Plug>(yanktmp_yank)
map <silent> Sp    <Plug>(yanktmp_paste_p)
map <silent> SP    <Plug>(yanktmp_paste_P)
"}}}

" FuzzyFinder.vim"{{{
" Key-mappings.
nnoremap <silent> <Leader>fa  :<C-u>FuzzyFinderAddBookmark<CR>
nnoremap <silent> <Leader>fb  :<C-u>FuzzyFinderBuffer<CR>
nnoremap <silent> <Leader>fd  :<C-u>FuzzyFinderDir<CR>
nnoremap <silent> <Leader>fe  :<C-u>FuzzyFinderEditInfo<CR>
nnoremap <silent> <Leader>ff  :<C-u>FuzzyFinderFile<CR>
nnoremap <silent> <Leader>fg  :<C-u>FuzzyFinderTaggedFile<CR>
nnoremap <silent> <Leader>fk  :<C-u>FuzzyFinderBookmark<CR>
nnoremap <silent> <Leader>fm :<C-u>FuzzyFinderMruFile<CR>
nnoremap <silent> <Leader>fr  :<C-u>FuzzyFinderRemoveCache<CR>
nnoremap <silent> <Leader>ft  :<C-u>FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
nnoremap <silent> <Leader>f]  :<C-u>FuzzyFinderTag!<CR>
" Disable MRU command mode.
"nnoremap <silent> fmc :<C-u>FuzzyFinderMruCmd<CR>

" Setting options.
let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
" Break off the indication of the candidate supplement here.
let g:FuzzyFinderOptions.Base.enumerating_limit = 100
" Ignore case by the supplement of the buffer.
let g:FuzzyFinderOptions.Base.ignore_case = 1
let g:FuzzyFinderOptions.MruFile.max_item = 150
"}}}

" bufstatus.vim"{{{
" <C-l>: redraw statusline.
nmap <silent> <C-l> <Plug>(bufstatus_redraw)
"}}}

" neocomplcache.vim"{{{
" Don't use autocomplpop.
let g:AutoComplPop_NotEnableAtStartup = 1
" Use neocomplcache.
let g:NeoComplCache_EnableAtStartup = 1
" Use smartcase.
let g:NeoComplCache_SmartCase = 1
" Use mfu.
let g:NeoComplCache_EnableMFU = 1
" Use previous keyword completion.
let g:NeoComplCache_PreviousKeywordCompletion = 1
" Use similar match.
let g:NeoComplCache_SimilarMatch = 1
" Use tags auto update.
let g:NeoComplCache_TagsAutoUpdate = 1
" Try keyword completion.
let g:NeoComplCache_TryKeywordCompletion = 1
" Use preview window.
let g:NeoComplCache_EnableInfo = 1
" Delete keyword when rank is 0.
let g:NeoComplCache_DeleteRank0 = 0

" Define dictionary.
let g:NeoComplCache_DictionaryFileTypeLists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
let g:NeoComplCache_KeywordPatterns = {}
let g:NeoComplCache_KeywordPatterns['default'] = '\h\w*'
"}}}

" NERD_comments.vim"{{{
let NERDSpaceDelims = 0
let NERDShutUp = 1
" Disable <C-c>.
nnoremap <C-c> <C-c>
nunmap <C-c>
"}}}

" vimshell.vim"{{{
" 
if has('win32') || has('win64') 
    " Display user name on Windows.
    let g:VimShell_Prompt = $USERNAME."% "

    " Use ckw.
    let g:VimShell_UseCkw = 1
else
    " Display user name on Linux.
    let g:VimShell_Prompt = $USER."% "
endif
" Use smartcase.
let g:VimShell_SmartCase = 1
"}}}

" scratch_buffer.vim"{{{
"}}}

" netrw.vim"{{{
let g:netrw_list_hide= '*.swp'
nnoremap <silent> <BS> :<C-u>Explore<CR>
" Change default directory.
set browsedir=current
"}}}

" ZoomWin.vim
nnoremap <silent> [Window]z :<C-u>ZoomWin<CR>

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

" QFixGrep"{{{
" Set external grep.
if has('win32') || has('win64')
    let mygrepprg = 'yagrep'
    let MyGrep_ShellEncoding = 'cp932'
else
    let mygrepprg = 'grep'
    let MyGrep_ShellEncoding = 'utf-8'
endif
" Exclude pattern.
let MyGrep_ExcludeReg =
            \'[~#]$\|\.bak$\|\.swp$\.o$\|\.obj$\|\.exe$\|\.dll$\|\.pdf$\|\.doc$\|\.xls$\|[/\\]tags$\|.cvs[/\\]\|.git[/\\]\|.svn[/\\]'

" Key-mappings.
" Grep cursor word.
nnoremap grw  :<C-u>EGrep! <C-r><C-w><CR>
" Execute fast grep.
nnoremap grf  :<C-u>FGrep!<Space>
" Execute vim grep.
nnoremap grv  :<C-u>VGrep!<Space>
" Execute grep from buffer.
nnoremap grv  :<C-u>VGrep!<Space>
" Normal grep.
nnoremap g/  :<C-u>Grep!<CR>
nnoremap [Space]/  :<C-u>Bgrep<Space>

" Execute grep from yanked string.
nnoremap gyf :<C-u>execute 'FGrep! '. expand(@0)<CR>
nnoremap gyv :<C-u>execute 'VGrep! '. expand(@0)<CR>
" Execute grep from selected string.
vmap grf  vgvygyf
vmap grv  vgvygyv

" Quickfix window.
nnoremap [Quickfix]f<Space>       :<C-u>ToggleQFixWin<CR>
nnoremap [Quickfix]ff             :<C-u>MoveToQFixWin<CR>

"}}}

" project.vim ------------------------------------------------ {{{
" カレントディレクトリにプロジェクトを作成する
nnoremap <silent> <Leader>pr  :<C-u>Project .vimprojects<CR>
" デフォルトでは短すぎる
let g:proj_window_width = 30
"}}}

" taglist.vim ------------------------------------------------- {{{
" Show only current file.
let g:Tlist_Show_One_File = 1
" Exit Vim when taglist's window is last window.
let g:Tlist_Exit_OnlyWindow = 1
" Show taglist window in right.
let g:Tlist_Use_Right_Window = 1
" Display method and class in JavaScript.
let g:tlist_javascript_settings = 'javascript;c:class;m:method;f:function'
" Shortcut key.
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
nnoremap <silent> <Leader>kk  :<C-u>call ku#restart()<CR>
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
nmap [Alt]e  <Plug>(smartword-e)
nmap ge  <Plug>(smartword-ge)
vmap w  <Plug>(smartword-w)
vmap b  <Plug>(smartword-b)
vmap ee  <Plug>(smartword-e)
vmap ge  <Plug>(smartword-ge)
" Operator pending mode.
omap <Leader>w  <Plug>(smartword-w)
omap <Leader>b  <Plug>(smartword-b)
omap <Leader>e  <Plug>(smartword-e)
omap <Leader>ge  <Plug>(smartword-ge)
"}}}

" vicle.vim"{{{
let g:vicle_session_name    = 'normal_session_name' 
let g:vicle_session_window  = 'normal_session_window' 

"let g:vicle_hcs             = '~~~your_command_separator~~~'
""}}}

" camlcasemotion.vim"{{{
map <silent> > <Plug>CamelCaseMotion_w
map <silent> < <Plug>CamelCaseMotion_b
""}}}

" AutoProtectFile.vim
let g:autoprotectfile_readonly_paths = "$VIMRUNTIME/*,~/important"
let g:autoprotectfile_nomodifiable_paths = "$VIMRUNTIME/*,~/important"

"}}}

"---------------------------------------------------------------------------
" Key-mappings: "{{{
"

" Use <C-Space>.
map <C-Space>  <C-@>

"
" Insert mode keymappings: "{{{
" <C-t>: inset tab.
inoremap <C-t>  <C-v><TAB>
" <C-d>: delete char.
inoremap <C-d>  <Del>
" <C-a>: move to head.
inoremap <silent><C-a>  <C-o>^
" <C-f>, <C-b>: page move.
inoremap <C-f>  <PageDown>
inoremap <C-b>  <PageUp>
" <A-b>: previous word.
inoremap <A-b>  <S-Left>
" <A-f>: next word.
inoremap <A-f>  <S-Right>
" Enable undo <C-w> and <C-u>.
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>
" <C-Space>: Elegant <ESC>
inoremap <C-@>  <ESC>

" Change movement whether a pop-up menu opens."{{{
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-e>: move to end.
inoremap <expr><silent><C-e>  pumvisible() ? "\<C-e>" : "\<C-o>$"
" <C-y>: paste.
inoremap <expr><C-y>  pumvisible() ? "\<C-y>" : "\<C-r>*"
" <C-v>: toggle preview window.
inoremap <silent><C-v>  <C-o>:<C-u>call<SID>preview_window_toggle()<CR>
" <C-j>: omni completion.
inoremap <expr> <C-j>  &filetype == 'vim' ? "\<C-x>\<C-v>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
" <C-k>: delete to end.
inoremap <C-k>  <C-o>D
" <C-h>: close popup and delete backword char.
inoremap <expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
" <C-n>: neocomplcache.
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" <C-p>: keyword completion.
inoremap <expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" <C-x>: neocomplcache.
inoremap <expr><C-x>  pumvisible() ? "\<C-x>\<C-u>\<C-p>" : "\<C-x>"
" <Enter>: close popup and save indent.
inoremap <expr><CR> pumvisible() ? "\<C-y>\<CR>X\<BS>" : "\<CR>X\<BS>"
"}}}
"}}}

" Command-line mode keymappings:"{{{
" <C-a>: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-k>: delete to end.
cnoremap <C-k>          <C-f>d$<C-c><End>
" <C-y>: paste.
cnoremap <C-y>          <C-r>"
" <C-s>: view history.
cnoremap <C-s>          <C-f>
" <C-l>: view completion list.
cnoremap <C-l>          <C-d>
" <A-b>: move to previous word.
cnoremap <A-b>          <S-Left>
" <A-f>: move to next word.
cnoremap <A-f>          <S-Right>
" <C-j>, <C-o>: move to next/previous candidate.
" High-speed than ring TAB repeatedly.
cnoremap <C-j>          <C-n>
cnoremap <C-o>          <C-p>
" <C-g>: decide candidate.
cnoremap <C-g>          <Space><C-h>
" <C-t>: insert space.
cnoremap <C-t>          <Space>
" <C-space>: Elegant <ESC>
cnoremap <C-@>  <C-c>
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
noremap <silent> [Space]w  :<C-u>update<CR>
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
" Save and make current file only.
noremap <silent> [Space]mo    :wall \| call <SID>UpdateQuickFix("", 1, 1)<CR>
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

" Easily ctags command."{{{
noremap <silent> [Space]tt :<C-u>NeoCompleCacheCreateTags<CR>
noremap <silent> [Space]tr :<C-u>silent !ctags -R<CR>
" Easily helptags command.
noremap <silent> [Space]td :<C-u>helptags $DOTVIM/doc<CR>
"}}}

"}}}

" t: tags-and-searches "{{{
" The prefix key.
noremap    [Tag]   <Nop>
nmap    t [Tag]
nmap    T [Tag]
" 飛ぶ
noremap [Tag]t  <C-]>
" 進む
nnoremap <silent> [Tag]n  :<C-u>tag<CR>
" 戻る
nnoremap <silent> [Tag]p  :<C-u>pop<CR>
" 履歴一覧
nnoremap <silent> [Tag]l  :<C-u>tags<CR>
" タグのリストを表示し、選択する
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
vnoremap [Tag]'t  <C-w>}
nnoremap <silent> [Tag]'n  :<C-u>ptnext<CR>
nnoremap <silent> [Tag]'p  :<C-u>ptprevious<CR>
nnoremap <silent> [Tag]'P  :<C-u>ptfirst<CR>
nnoremap <silent> [Tag]'N  :<C-u>ptlast<CR>
" プレビューウインドウを閉じる
nnoremap <silent> [Tag]'c  :<C-u>pclose<CR>
" 分割して飛ぶ
nnoremap [Tag]]  <C-w>]
"}}}

" s: Windows and buffers(High priority) "{{{
" The prefix key.
nnoremap    [Window]   <Nop>
nmap    s [Window]
noremap C         s
nnoremap <silent> [Window]c  :<C-u>close<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]j  <C-w>j
nnoremap <silent> [Window]k  <C-w>k
nnoremap <silent> [Window]h  <C-w>h
nnoremap <silent> [Window]t  <C-w>t
nnoremap <silent> [Window]b  <C-w>b
nnoremap <silent> [Window]w  <C-w>w
nnoremap <silent> <Tab> :<C-u>call <SID>CustomWincmdW()<CR>
" If window isn't splited, switch alternate buffer.
function! s:CustomWincmdW()
    let l:prev_name = winnr()
    silent! wincmd w
    if l:prev_name == winnr()
        call s:CustomAlternateBuffer()
    endif
endfunction
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
" sdで現在のバッファを閉じる"{{{
nnoremap <silent> [Window]d  :<C-u>call <SID>CustomBufferDelete(0)<CR>
function! s:CustomBufferDelete(is_force)
    let current = bufnr('%')

    call s:CustomAlternateBuffer()

    if a:is_force
        execute 'bdelete! ' . current
    else
        execute 'bdelete ' . current
    endif
endfunction
"}}}
"sDで指定したバッファを閉じる"{{{
nnoremap <silent> [Window]D  :<C-u>call <SID>InputBufferDelete(0)<CR>
function! s:InputBufferDelete(is_force)
    ls
    let l:in = input('Select delete buffer: ', '', 'buffer')
    if empty(l:in)
        " Cancel.
        return
    endif
    if !bufexists(l:in)
        echo "\nDon't exists buffer number " . l:in
        return
    endif

    call s:CustomAlternateBuffer()

    if a:is_force
        execute 'bdelete!' . l:in
    else
        execute 'bdelete' . l:in
    endif
endfunction
"}}}
" sfdで現在のバッファを強制的に閉じる
nnoremap <silent> [Window]fd  :<C-u>call <SID>CustomBufferDelete(1)<CR>
" sfDで指定したバッファを強制的に閉じる
nnoremap <silent> [Window]fD  :<C-u>call <SID>InputBufferDelete(1)<CR>
" Buffer move.
nnoremap <silent> [Window][  :<C-u>bfirst<CR>
nnoremap <silent> [Window]<C-a>  :<C-u>bfirst<CR>
nnoremap <silent> [Window]]  :<C-u>blast<CR>
nnoremap <silent> [Window]<C-e>  :<C-u>blast<CR>
nnoremap <silent> [Window]p  :<C-u>bprevious<CR>
nnoremap <silent> [Window]n  :<C-u>bnext<CR>
nnoremap <silent> [Window];  :<C-u>bnext<CR>
nnoremap <silent> [Window],  :<C-u>bprevious<CR>
nnoremap <silent> <C-s>  :<C-u>bnext<CR>
nnoremap <silent> <C-d>  :<C-u>bprevious<CR>
" Fast buffer switch."{{{
nnoremap <silent> [Window]<Space>  :<C-u>call <SID>CustomAlternateBuffer()<CR>
nnoremap <silent> [Space]<Space>  :<C-u>call <SID>CustomAlternateBuffer()<CR>
function! s:CustomAlternateBuffer()
    if bufnr('%') != bufnr('#') && buflisted(bufnr('#'))
        buffer # 
    else
        let l:cnt = 0
        let l:pos = 1
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
nnoremap <silent> [Window]d  :<C-u>call <SID>CustomBufferDelete(0)<CR>
" Move to other buffer numbering from left."{{{
for i in range(0, 9)
  execute 'nnoremap <silent>' ('[Window]'.i)  (':<C-u>call '.s:SID_PREFIX().'MoveBufferFromLeft('.i.')<CR>')
endfor"}}}
" Move with count."{{{
for i in range(1, 9)
    execute 'nnoremap <silent>' (i.'[Window]n')  (':'. i . 'bnext<CR>')
    execute 'nnoremap <silent>' (i.'[Window];')  (':'. i . 'bnext<CR>')
    execute 'nnoremap <silent>' (i.'[Window],')  (':'. i . 'bprevious<CR>')
    execute 'nnoremap <silent>' (i.'[Window]p')  (':'. i . 'bprevious<CR>')
endfor
unlet i
function! s:MoveBufferFromLeft(num)
    let l:cnt = 0
    let l:pos = 1
    while l:pos <= bufnr('$')
        if buflisted(l:pos)
            if l:cnt >= a:num
                execute 'buffer' . l:pos
                return
            endif

            let l:cnt += 1
        endif

        let l:pos += 1
    endwhile
endfunction"}}}
" Move to input buffer numbering from left."{{{
nnoremap <silent> [Window].  :<C-u>call <SID>MoveInputBufferFromLeft()<CR>
function! s:MoveInputBufferFromLeft()
    call s:ViewBufferList()
    let l:in = input('Select the buffer from left position: ', '', 'buffer')
    if l:in !~ '^\d\+$'
        " Search buffer.
        execute 'buffer ' . l:in
        return
    else
        call s:MoveBufferFromLeft(l:in)
    endif
endfunction"}}}
" Move to medium buffer numbering from left."{{{
nnoremap <silent> [Window]/  :<C-u>call <SID>MoveBufferMedium()<CR>
function! s:MoveBufferMedium()
    let l:pos = 1
    let l:buf = []
    while l:pos <= bufnr('$')
        if buflisted(l:pos)
            call add(l:buf, l:pos)
        endif
        let l:pos += 1
    endwhile

    execute 'buffer' . l:buf[len(l:buf)/2]
endfunction"}}}
" Edit"{{{
nnoremap [Window]b  :<C-u>edit<Space>
nnoremap <silent> [Window]en  :<C-u>new<CR>
nnoremap <silent> [Window]ee  :<C-u>enew<CR>
nnoremap <silent> [Window]ej  :<C-u>JunkFile<CR>
noremap <silent> [Window]es  :<C-u>call scratch_buffer#open(bufnr('%'), '')<CR>
inoremap <silent> <C-z> <C-o>:<C-u>call scratch_buffer#open(bufnr('%'), '')<CR>
"}}}
" View buffer list."{{{
nnoremap <silent> [Window]l  :<C-u>call <SID>ViewBufferList()<CR>
function! s:ViewBufferList()
    let [l:pos, l:cnt] = [1, 0]
    while l:pos <= bufnr('$')
        if buflisted(l:pos)
            if l:pos == bufnr('%')
                let l:flags = '%'
            elseif l:pos == bufnr('#')
                let l:flags = '#'
            else
                let l:flags = ' '
            endif

            if getbufvar(l:pos, '&modified')
                let l:flags .= '!'
            elseif getbufvar(l:pos, '&modifiable') == 0
                let l:flags .= '-'
            endif

            echo printf('%3d %3s   %s', l:cnt, l:flags, fnamemodify(bufname(l:pos), ':.'))
            let l:cnt += 1
        endif
        let l:pos += 1
    endwhile
endfunction"}}}

" ss: Windows and buffers(Low priority) "{{{
" bを潰すのはあんまりなので、ssに間借りする。
nnoremap [Window]s  <NOP>
nnoremap <silent> [Window]sp  :<C-u>split<CR>
nnoremap <silent> [Window]sv  :<C-u>vsplit<CR>
nmap <silent> [Window]st  <F8>
nnoremap <silent> [Window]sa  :<C-u>args<CR>
nnoremap <silent> [Window]sv  :<C-u>vnew<CR>
nnoremap <silent> [Window]sn  :<C-u>new<CR>
nnoremap <silent> [Window]sl  :<C-u>ls<CR>
nnoremap <silent> [Window]sm  :<C-u>bmodified<CR>
"}}}
"}}}

" e: Change basic commands "{{{
" The prefix key.
noremap [Alt]   <Nop>
nmap    e  [Alt]

" Emacs run.
nnoremap <silent> [Alt]!  :<C-u>Run2<CR>
" Indent paste.
"nnoremap [Alt]p pm``[=`]``
"nnoremap [Alt]P Pm``[=`]``
nnoremap <silent> [Alt]p o<ESC>:call <SID>chomp_register()<CR>pm``[=`]``^
nnoremap <silent> [Alt]P O<ESC>:call <SID>chomp_register()<CR>Pm``[=`]``^
" Insert blank line.
nnoremap [Alt]o o<ESC>
nnoremap [Alt]O O<ESC>
" Yank to end line.
nmap [Alt]y y$
" Delete first character.
nnoremap [Alt]x ^x
nnoremap X ^x
" Line selection <C-v>.
nnoremap [Alt]V 0<C-v>$h
" Folding close.
noremap [Alt]h  zc

" Useless commands
noremap [Alt];  ;
noremap [Alt],  ,

" eregex.vim commands."{{{
" Don't allow M/ region.
noremap [Alt]/ :<C-u>M/
" S, G, V target whole current buffer.
nnoremap [Alt]s :%S/
vnoremap [Alt]s :S/
nnoremap [Alt]g :%G/
vnoremap [Alt]g :G/
nnoremap [Alt]v :%V/
vnoremap [Alt]v :V/
"}}}

"}}}

" <C-g>: Argument list  "{{{
"
" The prefix key.
noremap [Argument]   <Nop>
nmap    <C-g>  [Argument]
 
noremap [Argument]<Space>  :<C-u>args<Space>
noremap <silent> [Argument]l  :<C-u>args<CR>
noremap <silent> [Argument]n  :<C-u>next<CR>
noremap <silent> [Argument]p  :<C-u>previous<CR>
noremap <silent> [Argument]P  :<C-u>first<CR>
noremap <silent> [Argument]N  :<C-u>last<CR>
noremap <silent> [Argument]wp :<C-u>wnext<CR>
noremap <silent> [Argument]wn :<C-u>wprevious<CR>
"}}}

" <C-t>: Tab pages"{{{
"
" The prefix key.
noremap [Tabbed]   <Nop>
nmap    <C-t>  [Tabbed]
" Create tab page.
noremap <silent> [Tabbed]c  :<C-u>tabnew<CR>
noremap <silent> [Tabbed]d  :<C-u>tabclose<CR>
noremap <silent> [Tabbed]o  :<C-u>tabonly<CR>
noremap <silent> [Tabbed]i  :<C-u>tabs<CR>
nmap [Tabbed]<C-n>  [Tabbed]n
nmap [Tabbed]<C-c>  [Tabbed]c
nmap [Tabbed]<C-o>  [Tabbed]o
nmap [Tabbed]<C-i>  [Tabbed]i
" Move to other tab page.
noremap <silent> [Tabbed]j
            \ :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
noremap <silent> [Tabbed]k  :<C-u>tabprevious<CR>
noremap <silent> [Tabbed]K  :<C-u>tabfirst<CR>
noremap <silent> [Tabbed]J  :<C-u>tablast<CR>
noremap <silent> [Tabbed]l
            \ :<C-u>execute 'tabmove' min([tabpagenr() + v:count1 - 1, tabpagenr('$')])<CR>
noremap <silent> [Tabbed]h
            \ :<C-u>execute 'tabmove' max([tabpagenr() - v:count1 - 1, 0])<CR>
noremap <silent> [Tabbed]L  :<C-u>tabmove<CR>
noremap <silent> [Tabbed]H  :<C-u>tabmove 0<CR>
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
endfor
unlet i
"}}}

" q: Quickfix  "{{{
 
" The prefix key.
noremap [Quickfix]   <Nop>
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

" f: FuzzyFinder, FuzzyJump "{{{
" The prefix key.
noremap [Fuzzy]   <Nop>
nmap    f  [Fuzzy]

" FuzzyJump
map [Fuzzy]j  <Plug>(fuzzyjump-prefix)

" FuzzyFinder
nmap [Fuzzy]a <Leader>fa
nmap [Fuzzy]b <Leader>fb
nmap [Fuzzy]d <Leader>fd
nmap [Fuzzy]e <Leader>fe
nmap [Fuzzy]f <Leader>ff
nmap [Fuzzy]g <Leader>fg
nmap [Fuzzy]k <Leader>fk
nmap [Fuzzy]m <Leader>fm
nmap [Fuzzy]t <Leader>ft
nmap [Fuzzy]] <Leader>f]
"}}}

" 0: Preview window "{{{
" The prefix key.
noremap [Preview]   <Nop>
nmap    0  [Preview]

" Toggle preview window."{{{
nnoremap <silent> [Preview]0  :<C-u>call<SID>preview_window_toggle()<CR>
function! s:preview_window_toggle()
    silent! wincmd P
    if &previewwindow
        pclose
    elseif !empty(expand('%'))
        mkview
        silent! pedit
        silent loadview
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

" Jump history.
noremap <silent> <C-k> <C-o>
noremap <silent> <C-j> <C-i>

" Finish with having left a screen of vim.
nnoremap <silent> gZZ :<C-u>set t_te= t_ti= \| quit \| set t_te& t_ti&<CR>
" Start a shell with having left a screen of vim.
nnoremap <silent> gsh :<C-u>set t_te= t_ti= \| sh \| set t_te& t_ti&<CR>

" Move search word to middle screen."{{{
noremap n  nzz 
noremap N  Nzz 
noremap *  *zz 
noremap #  #zz 
noremap g*  g*zz 
noremap g#  g#zz
"}}}

" Smart <C-f>, <C-b>.
noremap <silent> <C-f> z<CR><C-f>z.
noremap <silent> <C-b> z-<C-b>z.

" Execute help."{{{
nnoremap <C-h>  :<C-u>help<Space>
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>help<Space><C-r><C-w><CR>
" Grep in help.
nnoremap grh  :<C-u>Hg<Space>
"}}}

" Disable ZZ.
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
" Paste next line.
nnoremap <silent> gp o<ESC>:call <SID>chomp_register()<CR>p^
nnoremap <silent> gP O<ESC>:call <SID>chomp_register()<CR>p^
function! s:chomp_register()
    if @* =~ '\n$'
        let @* = @*[:-2]
    endif
endfunction

" Paste and indent line.
nnoremap ]p p`[=`]^
nnoremap ]P P`[=`]^

" Like YankRing paste."{{{
for i in range(0, 9)
    execute 'nnoremap ' ('y'.i)  ('"'.i.'gp')
endfor
unlet i
nnoremap y+  "+gp
nnoremap y*  "*gp
noremap <silent> Y   y$:CpR0toR1<CR>
vnoremap <silent> Y   y$:CpR0toR1<CR>
vnoremap <silent> y   y:CpR0toR1<CR>
onoremap <silent> y   y:CpR0toR1<CR>
command! CpR0toR1 if @0 =~ "\<NL>"|let @9=@8|let @8=@7|let @7=@6|let @6=@5|let @5=@4|let @4=@3|let @3=@2|let @2=@1|let @1=@0|endif
"}}}

"Return Redraw
nnoremap <silent> <C-l>    :<C-u>redraw!<CR>

" Elegant <ESC>
noremap <C-@>   <ESC>

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
"}}}

" Fast search pair.
map [Space]p    %

" Search a parenthesis.
onoremap <silent> q /["',.{}()[\]<>]<CR>

" Fast substitute.
vnoremap s y:%s/\<<C-R>"\>//g<Left><Left>

" Delete until underbar."{{{
if has('gui_running') && has('xim')
    " Linux ATOK X3.
    "inoremap <silent><C-a>    <C-o>d?[^[:alpha:]]<CR>
    inoremap <silent><C-a>    <C-r>=<SID>delete_underbar()<CR><C-o>:set iminsert=0<CR>
    inoremap <silent><C-q>    <C-r>=<SID>delete_underbar()<CR><C-o>:set iminsert=0<CR>
else
    inoremap <silent><C-a>    <C-r>=<SID>delete_underbar()<CR>
    inoremap <silent><C-q>    <C-r>=<SID>delete_underbar()<CR>
endif
function! s:delete_underbar()
    " Get cursor word.
    let l:len = len(matchstr(strpart(getline('.'), 0, col('.') - 1), '\a\+$'))
    if l:len > 0
        for a in range(l:len-1)
            if pumvisible()
                call feedkeys("\<C-y>\<C-h>", 'n')
            else
                call feedkeys("\<C-h>", 'n')
            endif
        endfor
    endif

    if pumvisible()
        return "\<C-y>\<C-h>"
    else
        return "\<C-h>"
    endif
endfunction"}}}

" Paste yanked text."{{{
vnoremap <silent> p :<C-u>call <SID>YankPaste()<CR>
vnoremap <silent> P :<C-u>call <SID>YankPaste()<CR>
function! s:YankPaste()
    let a = @*
    normal! gvp
    let @* = a
endfunction

" Exchange cursor word to yanked word.
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
" Paste yanked character.
nnoremap gy "0P

"}}}

" Move last modified text.
noremap gb `.zz
noremap g, g;
noremap g; g,

" Repeat previous command.
noremap #   @:

" Recording commands."{{{
noremap <silent> <CR>       :<C-u>call <SID>recording_commands()<CR>
function! s:recording_commands()
    let l:prev_command = substitute(@z, "\<CR>", '', 'g')
    let l:input = input('Input command: ', l:prev_command, 'mapping')
    if !empty(l:input)
        let @z = substitute(l:input, '<CR>', "\<CR>", 'g')
    endif
endfunction
" Execute macro.
noremap <silent> '   @z
noremap <silent> -          :<C-u>call <SID>recording_macro()<CR>
let s:recording = 0
function! s:recording_macro()
    if s:recording
        let s:recording = 0
        normal! q
        " Delete last '-'.
        let @z = substitute(@z, '-$', '', '')
    else
        let s:recording = 1
        normal! qz
    endif
endfunction
"}}}

" Change the height of the current window to match the visual selection and scroll 
" the text so that all of the selection is visible.
vmap <C-w><C-_>  <C-w>_ 
vnoremap <silent> <C-w>_  :<C-u><C-r>=line("'>") - line("'<") + 1<CR>wincmd _<CR>`<zt

" }}}

"---------------------------------------------------------------------------
" Commands:"{{{
"
" Search in selecting text."{{{
" 'n' and 'N' become only the range properly, too.
function! RangeSearch(direction)
endfunction
command! -nargs=0 -range RangeSearch call RangeSearch('/')|if strlen(g:srchstr) > 0|exe '/'.g:srchstr|endif
command! -nargs=0 -range RangeSearchBackward call RangeSearch('?')|if strlen(g:srchstr) > 0|exe '?'.g:srchstr|endif
"}}}

" 指定した名前を持つバッファが既に存在するならそこにカーソルを移動。 "{{{
" 存在しないなら作成。
function! SingletonBuffer(name, split)
    " 文字をエスケープ :h file-pattern
    let name=escape(a:name, '*?,\')
    if bufexists(a:name) " bufexists にはエスケープ必要ない
        let bufnr = bufnr(name)
        let winlist = WindowContains(bufnr)
        if empty(winlist)
            if a:split 
                split 
            endif
            exe "buffer " . bufnr
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
    nnoremap <buffer><silent> qq :close<CR>
    normal! gg"_dG
    echo a:cmd
    exe a:cmd
endfunction"}}}

function! GUExec(cmd, bufname, getError, isExpand)"{{{
    if a:isExpand
        let cmd = exists("g:GUExec_cmd") ? g:GUExec_cmd : a:cmd." ".expand("%")
    else
        let cmd = exists("g:GUExec_cmd") ? g:GUExec_cmd : a:cmd
    endif
    call GUExecCmdWin('silent read!' . cmd, a:bufname)
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
    call GUExec(cmd, '[Shell Output]', 0, a:isExpand)
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

command! -nargs=? -bar -bang Make call s:UpdateQuickFix("<args>", len('<bang>'), 0)

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
noremap <silent> [Space]u        :LeadUnderscores<CR>

" Interactive run.
command! -nargs=1 Async call interactive#run(<q-args>)

" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
    let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
    if !isdirectory(l:junk_dir)
        call mkdir(l:junk_dir, 'p')
    endif

    let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
    if !empty(l:filename)
        execute 'edit ' . l:filename
    endif
endfunction"}}}

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
    set shellcmdflag=-e
    set shellpipe=\|&\ tee
    set shellredir=>%s\ 2>&1
    set shellxquote=\"

    " Use bash.
    "set shell=bash.exe
    "set shellcmdflag=-c
    "set shellpipe=2>&1\|\ tee
    "set shellredir=>%s\ 2>&1
    "set shellxquote=\"

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
    hi Pmenu ctermbg=8
    hi PmenuSel ctermbg=1
    hi PmenuSbar ctermbg=0

    " Display the directory of the baing current buffer in afx.
    noremap <silent> <F1> :execute '!start runafx.bat' '-s "-p%:p"'<cr>
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
        let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
        if !exists('g:colors_name')
            colorscheme candy
        endif

        augroup MyLinuxConsole
            autocmd!
            " For prevent bug.
            autocmd VimLeave * set term=screen
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
