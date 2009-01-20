"---------------------------------------------------------------------------
" Shougo's .gvimrc
"---------------------------------------------------------------------------
" フォント設定:"{{{
"
if has('win32') || has('win64')
    " Windows用
    "set guifont=Terminal:h10:cSHIFTJIS
    " フォントファイル名に空白を使うためには\でエスケープする必要がある
    set guifont=UmePlus\ Gothic:h12
    "set guifont=NFモトヤシータ゛1等幅:h11
    " 行間隔の設定
    set linespace=1
    " 一部のUCS文字の幅を自動計測して決める
    if has('kaoriya')
        set ambiwidth=auto
    endif
elseif has('mac')
    set guifont=Osaka－等幅:h14
else
    " GTK2用
    " Linuxでは太字にしないと見にくかったが、最近のLinuxでは問題ない。
    "set guifont=UmePlus\ Gothic\ bold\ 12
    set guifont=UmePlus\ Gothic\ 13
endif
"}}}

"---------------------------------------------------------------------------
" ウインドウに関する設定:"{{{
"
if has('win32') || has('win64')
    " ウインドウの幅
    set columns=150
    " ウインドウの高さ
    set lines=45
else
    " ウインドウの幅
    set columns=140
    " ウインドウの高さ
    set lines=45
endif
" コマンドラインの高さ(GUI使用時)
set cmdheight=2
" 画面を黒地に白にする
colorscheme candy " (GUI使用時)
"}}}

"---------------------------------------------------------------------------
" 日本語入力に関する設定:"{{{
" Linux用の独自設定
if (has('multi_byte_ime') || has('xim')) && has('GUI_GTK')
    " ATOKが誤動作するので、autocomplpopを無効にする。
    let g:AutoComplPop_NotEnableAtStartup = 1

    " 代わりに、自作したAutoComplPopの代替品を使う
    let g:AltAutoComplPop_EnableAtStartup = 1
endif
"}}}

"---------------------------------------------------------------------------
" マウスに関する設定:"{{{
"
" マウス右クリックでポップアップメニューを表示する
" Win32ではデフォルトで有効
set mousemodel=popup

" マウスの移動でフォーカスを自動的に切り替えない
set nomousefocus
" 入力時にマウスポインタを隠す
set mousehide

"}}}

"---------------------------------------------------------------------------
" メニューに関する設定:"{{{
"
" "M"オプションが指定されたときはメニュー("m")・ツールバー("T")供に登録され
" ないので、自動的にそれらの領域を削除する
if &guioptions =~# 'M'
    let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif

" あまり使わないので、ツールバーとメニューの非表示
set guioptions-=T
set guioptions-=m
" F2キーでメニューの表示・非表示を切り替える
noremap <silent> <F2> :<C-u>if &guioptions =~# 'm' <Bar>
            \set guioptions-=m <Bar>
            \else <Bar>
            \set guioptions+=m <Bar>
            \endif <CR>
" Scrollbar is always off.
set guioptions-=rL
" Not guitablabel.
set guioptions-=e
"}}}

"---------------------------------------------------------------------------
" その他、見栄えに関する設定:"{{{
"
" 検索文字列をハイライトしない(vimrcではなくgvimrcで設定する必要がある)
set nohlsearch

" ベルを無効にする
" .gvimrcにも書かないと、GUI起動時にリセットされる
set vb t_vb=

" カーソルを点滅させない
set guicursor=a:blinkon0

"}}}

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定"{{{
"
if has('win32') || has('win64') 
    " Windows用

    " シェルはckwを使う
    " コマンド引数がうまく渡せないのが難点。
    " Shell.vimもうまく使えない。
    "set shell=ckw.exe\ -e\ nyacus.exe
    "set shellcmdflag=
else
    " Linux用

    "set shell=/bin/sh
    " zshでも大丈夫なように.zshrcを書き換えた
    set shell=zsh
endif
"}}}

"---------------------------------------------------------------------------
" その他に関する設定:
"

