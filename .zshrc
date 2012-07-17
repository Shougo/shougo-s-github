#####################################################################
# environment
#####################################################################

# 環境変数の設定
export EDITOR=vim
export LANG=ja_JP.UTF-8
# ATOKを使うために必要
export GTK_IM_MODULE=iiimf

# umaskは022が良いらしい。
umask 022

# 単語の区切りとみなさない記号を指定する
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# コアを吐かせるときはコメントを解除
#unlimit
#limit core 0
#limit -s
# コアファイルを吐かないようにする
#limit coredumpsize  0

# ~/.zshrc.mineファイルの内容を読み込んで実行する
# .zshrc.mineには実験的な設定を書き込む。
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

# lessのオプションを環境変数で指定する
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS'

# Disable CapsLock key.
#setxkbmap -option ctrl:nocaps

#####################################################################
# completions
#####################################################################

# 補完を有効にする
# .zsh/compフォルダがあれば、ユーザ補完関数も読み込む
if [ -d ~/.zsh/comp ]; then
        fpath=(~/.zsh/comp $fpath)
        autoload -U ~/.zsh/comp/*(:t)

        # 補完関数のリロード（デバッグ用）
        r() {
                local f
                f=(~/.zsh/comp/*(.))
                unfunction $f:t 2> /dev/null
                autoload -U $f:t
        }
fi

zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
# 一部のコマンドライン定義は、展開時に時間のかかる処理を行う
# apt-get, dpkg (Debian), rpm (Redhat), urpmi (Mandrake), perlの-Mオプション, 
# bogofilter (zsh 4.2.1以降), fink, mac_apps (MacOS X)(zsh 4.2.2以降)
zstyle ':completion:*' use-cache true
# 補完候補を ←↓↑→ で選択 (補完候補が色分け表示される)
zstyle ':completion:*:default' menu select=1
# 補完の時に大文字小文字を区別しない (但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list \
        '' \
        'm:{a-z}={A-Z}' \
        'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'
# sudo cmd で補完したいけど補完が効かない…、という場合
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
        /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' menu select
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored \
    _approximate _list _history

autoload -U compinit; compinit -d ~/.zcompdump

# 独自の補完関数
compdef '_files -g "*.hs"' runhaskell
# manの補完関数をw3mmanにも適用させる
compdef _man w3mman
# TeXの補完関数をplatexにも適用させる
compdef _tex platex

# カレントディレクトリ中にサブディレクトリが無い場合に cd が検索するディレクトリのリスト
cdpath=($HOME)
# zsh関数のサーチパス
#fpath=($fpath ~/zsh/.zfunc)

#####################################################################
# colors
#####################################################################

if [ $TERM = "dumb" ]; then
        # GVimから実行する場合、色分けは無効
        alias ls="ls -F --show-control-chars"
        alias la='ls -aF --show-control-chars'
        alias ll='ls -lF --show-control-chars'
        alias l.='ls -dF .[a-zA-Z]*'
else
        # zsh補完候補一覧をカラー表示する
        # lsもカラーにして、それと整合性を取る
        alias ls='ls -F --show-control-chars --color=always'
        alias la='ls -aF --show-control-chars --color=always'
        alias ll='ls -lF --show-control-chars --color=always'
        alias l.='ls -dF .[a-zA-Z]* --color=always'
        export LSCOLORS=ExFxCxdxBxegedabagacad
        export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
fi

#prompt の色指定を簡便に … $fg[blue] で可能になる.
autoload -U colors
colors

if [ $TERM = "dumb" ]; then
        # GVimから実行する場合、色分けできないのでシンプルなプロンプトにする
        PROMPT='%n%# '
else
        PROMPT='%{[$[31+$RANDOM % 7]m%}%U%B%n%#'"%b%{[m%}%u "

        if [ ${VIMSHELL_TERM:-""} = "terminal" ] \
                || [ ${VIMSHELL_TERM:-""} = "" ]; then
                RPROMPT="%{[33m%}[%35<..<%~]%{[m%}"
        else
                PROMPT='%{[$[31+$RANDOM % 7]m%}%B%n%#'"%b%{[m%}%u "

                # For test
                # PROMPT="%{$fg[green]%}%B%~$%b%{${reset_color}%} "
        fi

        # vcs_infoを使う
        #autoload -Uz vcs_info
        #zstyle ':vcs_info:*' formats '(%s)-[%b]'
        #zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
        #RPROMPT="%{[33m%}[%~]%{[m%} %1(v|%F{green}%1v%f|)"
fi

if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] ; then
        PROMPT="%{^[[37m%}${HOST%%.*} ${PROMPT}"
fi

if [ $UID = "0" ]; then
    PROMPT="%B%{^[[31m%}%/#%{^[[m%}%b "
    PROMPT2="%B%{^[[31m%}%_#%{^[[m%}%b "
fi

# 複数行入力時のプロンプト
PROMPT2="%_%% "
# 入力ミス確認時のプロンプト
SPROMPT="correct> %R -> %r [n,y,a,e]? "


# sudo cmd で補完したいけど補完が効かない……、という場合に有効
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
        /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

#####################################################################
# options
######################################################################
#{{{
# サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
setopt auto_resume
# C-dを押してもログアウトしない
setopt ignore_eof
# ビープ音を鳴らさないようにする
setopt no_beep
# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
# コマンドのスペルチェックをする
setopt correct
# 入力したコマンドすべてに対してスペルチェックをする
#setopt correct_all
# =command を command のパス名に展開する
setopt equals
# C-s/C-q によるフロー制御を使わないようにする
setopt no_flow_control
# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# コマンド行の余分な空白を詰めてヒストリに入れる
setopt hist_reduce_blanks
# コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space
# 履歴を :開始時刻:経過時間:コマンド の形で保存する。
setopt extended_history
# ヒストリを呼び出してから実行する間に一旦編集可能を止める
unsetopt hist_verify
# 補完時にヒストリを自動的に展開
setopt hist_expand
# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
# 補完候補が複数ある時、一覧表示 (auto_list) せず、すぐに最初の候補を補完する
# vimshell 上で邪魔なので無効化。
setopt no_menu_complete
# 補完候補の表示を水平方向にする
setopt list_rows_first
# TABでグロブを展開する
setopt glob_complete
# 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
setopt multios
# コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
setopt path_dirs
# 8 ビット目を通すようになり、日本語のファイル名などを見れるようになる
setopt print_eightbit
# 戻り値が 0 以外の場合終了コードを表示する
setopt print_exit_value
# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups
# pushd,popdの度にディレクトリスタックの中身を表示しない
setopt pushd_silent
# for, repeat, select, if, function などで簡略文法が使えるようになる
setopt short_loops
# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
# コピペの時rpromptを非表示する
setopt transient_rprompt
# 改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr
# サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume
# 各コマンドが実行されるときにパスをハッシュに入れる
setopt hash_cmds
# 数字を数値と解釈してソートする
setopt numeric_glob_sort
# コマンド入力中にコメントを入れる
setopt interactive_comments
# ファイルの一括削除時に１０秒間停止する
setopt rm_star_wait
# 拡張グロブ指定（^, #など）を有効にする
setopt extended_glob
# 未定義変数の使用禁止
# これをやるとエラーになるスクリプトが多数
# setopt no_unset
# 環境変数をプロンプトに展開する
setopt prompt_subst
if [[ ${VIMSHELL_TERM:-""} != "" ]]; then
        # カーソル位置は保持したままファイル名一覧を順次その場で表示
        setopt no_always_last_prompt
else
        setopt always_last_prompt
fi
# ^Iで補完可能な一覧を表示する(補完候補が複数ある時に、一覧表示)
setopt auto_list
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# カッコの対応などを自動的に補完
setopt auto_param_keys
# 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt list_types
# コンパクトに補完リストを表示
setopt list_packed
# ディレクトリ名で移動
setopt auto_cd
# 普通に cd するときにもディレクトリスタックにそのディレクトリを入れる
setopt auto_pushd
setopt pushd_minus
# ディレクトリスタックに重複する物は古い方を削除
setopt pushd_ignore_dups
# 補完される前にオリジナルのコマンドまで展開してチェックされる 
setopt complete_aliases
# }}}

#####################################################################
# alias
######################################################################
# Global aliases {{{
alias -g A="| awk"
alias -g G="| grep"
alias -g GV="| grep -v"
alias -g H="| head"
alias -g L="| $PAGER"
alias -g P=' --help | less'
alias -g R="| ruby -e"
alias -g S="| sed"
alias -g T="| tail"
alias -g V="| vim -R -"
alias -g U=' --help | head'
alias -g W="| wc"
# }}}

# 拡張子毎にコマンドを自動実行# {{{
alias -s zip=zipinfo
alias -s tgz=gzcat
alias -s gz=gzcat
alias -s tbz=bzcat
alias -s bz2=bzcat
alias -s java=vim
alias -s c=vim
alias -s h=vim
alias -s C=vim
alias -s cpp=vim
alias -s txt=vim
alias -s xml=vim
alias -s html=opera
alias -s xhtml=opera
alias -s gif=display
alias -s jpg=display
alias -s jpeg=display
alias -s png=display
alias -s bmp=display
alias -s mp3=amarok
alias -s m4a=amarok
alias -s ogg=amarok
# }}}

# pushd, popd, cd ..を簡単にする
alias pd=pushd
alias po="popd"
alias ..='cd ..'

# lvできちんと表示されるようにする
alias lv='lv -c -T8192'

# mv, cp, mkdirなど、新しくファイルを作成するコマンドではファイル名生成を行わない
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'

# コンソールモードのemacsを256色対応で起動する
alias emacsnw="env TERM=xterm-256color emacs -nw"

# これでemacsclientをしたときにemacsを起動していなかったとしても、
# 自動的に起動してくれる。
alias emacsclient="emacsclient -a emacs"

# rlwrapを使用するaliasを定義する。
if [ -x '/usr/bin/rlwrap' -o  -x '/usr/local/bin/rlwrap' ]; then
        alias irb='rlwrap irb'
        alias ghci='rlwrap ghci'
        alias clisp="rlwrap -b '(){}[],#\";| ' clisp"
        alias gcl="rlwrap -b '(){}[],#\";| ' gcl"
        alias gosh="rlwrap -b '(){}[],#\";| ' gosh"
fi

# 前に行ったディレクトリに移る
alias gd='dirs -v; echo -n "select number: "; read newdir; cd -"$newdir"'

# grep 行数, 再帰的, ファイル名表示, 行数表示, バイナリファイルは処理しない
alias grep='grep -i -r -H -n -I'

# development
alias py='python'
alias rb='ruby'
alias gdb='gdb -silent'
alias gpp='g++'

# du, dfを使いやすくする
alias du="du -h"
alias df="df -h"

# odを自動的に16進表記にする
alias od='od -Ax -tx1z'
# 16進ダンプのエイリアスも定義する
alias hexdump='hexdump -C'
alias hexd=hexdump

# whereの置き換え
alias where="command -v"

alias j="jobs -l"

# sshで接続後scrrを打つとリモートでscreenを呼び出す
# scrrを再度打つとローカルに戻ることができる。次回ssh接続時にscrrと打てば作業の続きができる。
alias scrr='screen -U -D -RR'
# s vim **/*.pyのように頭にsをつけてコマンドを打つと、別のスクリーンで開く
#alias s='screen -U'

#####################################################################
# keybinds
######################################################################

# emacsのキーバインドにする
bindkey -e
# viのキーバインドはこちら
#bindkey -v
# vi のキーバインドでも初期状態をコマンドモードにする
#zle-line-init() { zle -K vicmd; } ; zle -N zle-line-init
# 文字の途中でカーソルの右を無視して補完
bindkey '^t' expand-or-complete-prefix

# 履歴検索機能のショートカット設定
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# コマンド履歴の検索機能はC-pとC-nに割り当てる
# 引数も検索に利用しつつ、カーソル位置は行末にする。
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# C-xC-wでリージョンをカットできるようにする
bindkey "^x^w" kill-region

# bashと同様に、C-uでカーソル位置から行頭までの文字を消す
bindkey "^u" backward-kill-line

# コマンド入力中にマニュアルを表示できるrun-help(ESC-H)を有効にする
[ -n "`alias run-help`" ] && unalias run-help
autoload run-help
# C-xhをrun-helpにする。
bindkey "^xh" run-help

# コマンドの予測入力を有効にする
#autoload -U predict-on
#zle -N predict-on
#zle -N predict-off
#bindkey "^xp" predict-on
#bindkey "^x^p" predict-off

# C-] で一つ前のコマンドの最後の単語を挿入。
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
        '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey '^]' insert-last-word

typeset -A abbreviations
abbreviations=(
"L"    "| $PAGER"
"G"    "| grep"

"HEAD^"     "HEAD\\^"
"HEAD^^"    "HEAD\\^\\^"
"HEAD^^^"   "HEAD\\^\\^\\^"
"HEAD^^^^"  "HEAD\\^\\^\\^\\^\\^"
"HEAD^^^^^" "HEAD\\^\\^\\^\\^\\^"
)

#####################################################################
# functions
######################################################################

# ファイルの削除にrmを使わずゴミ箱を使う
TRASHDIR=~/.trash
del () {
        local path
        for path in "$@"; do
                # ignore any arguments
                if [[ "$path" = -* ]]; then
                        echo "del doesn't understand any arguments. Should use /bin/rm."
                        return
                else
                        # create trash if necessary
                        if [ ! -d $TRASHDIR ]; then
                                /bin/mkdir -p $TRASHDIR
                        fi

                        local dst=${path##*/}
                        # append the time if necessary
                        while [ -e $TRASHDIR"/$dst" ]; do
                                dst="$dst "$(date +%H-%M-%S)
                        done
                        /bin/mv "$path" $TRASHDIR/"$dst"
                fi
        done
}
# 危険なのでrmは使わない
alias rm="del"

# ゴミ箱を空にする
alias trash-look="ls -al $TRASHDIR/ 2> /dev/null"
alias trash-clean="/bin/rm -R -f $TRASHDIR/*"
alias clean=trash-clean

# lessの代わりにvimをlessとして利用する。
# syntax highlightも有効なので便利。
vless () {
        if test $# = 0; then
                vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' -
        else
                vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@"
        fi
}

# 環境変数を簡単に設定する
setenv () { export $1="$@[2,-1]" }

#-------------------------------------------------------
# history
function history-all { history -E 1 } # 全履歴の一覧を出力する

#-------------------------------------------------------
# 引数のファイルを euc-LF や sjis-CR+LF に変換
function euc() {
for i in $@; do;
        nkf -e -Lu $i >! /tmp/euc.$$ # -Lu :改行を LF にする
        mv -f /tmp/euc.$$ $i
done;
}
function sjis() {
for i in $@; do;
        nkf -s -Lw $i >! /tmp/euc.$$ # -Lu :改行を CR+LF にする
        mv -f /tmp/euc.$$ $i
done;
}

#####################################################################
# others
######################################################################

echo $TERM | grep screen > /tmp/screen-test
if [ -s /tmp/screen-test ]; then
        # 実行中のプログラムを表示する（screenを使用中の時のみ）
        # ただし、suspend用のウインドウはタイトルを変化させない
        preexec() {
                if [ $WINDOW -ne 0 ]; then
                        # see [zsh-workers:13180]
                        # http://www.zsh.org/mla/workers/2000/msg03993.html
                        emulate -L zsh
                        local -a cmd; cmd=(${(z)2})
                        echo -n "k$cmd[1]:t\\"
                else
                        echo -n "kanother\\"
                fi
        }
        precmd() {
                if [ $WINDOW -eq 0 ]; then
                        echo -n "kanother\\"
                elif [ $PWD = $HOME ]; then
                        echo -n "k[~]\\"
                else
                        echo -n "k[`basename $PWD`]\\"
                fi

                # For vcs_info.
                #psvar=()
                #LANG=en_US.UTF-8 vcs_info
                #[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
        }

        # C-l s alphaとすれば、指定した1文字がプレフィックスであるようなタイトルをサーチ
        # 見つからなかった場合は次のウィンドウへ進む。
        screen -X bind s command -c prefix
        screen -X bind -c prefix ^a command
        for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do 
                screen -X bind -c prefix $i eval "next" "next" "prev" "select $i"
        done
else
        # ターミナルのタイトルに「ユーザ@ホスト:カレントディレクトリ」を表示させる
        case "${TERM}" in
                kterm*|xterm*|vt100)
                        precmd() {
                                echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
                        }
                        ;;
        esac
fi

# zshの履歴を共有する設定
HISTFILE=$HOME/.zsh-history         # 履歴の保存先
HISTSIZE=10000                      # メモリに展開する履歴の数
SAVEHIST=50000                      # 保存する履歴の数
setopt inc_append_history           # 複数のzshで実行したコマンドをヒストリに保存する
setopt share_history                # 同一ホストで動いているzshで履歴 を共有

# 数学関数（sin(), cos(), tan(), exp()など）を有効にする
zmodload zsh/mathfunc

# パターンを利用したファイル移動コマンドzmvを有効にする
autoload -U zmv
# コピーとリンクに使う派生コマンドも定義する
alias zcp='zmv -C'
alias zln='zmv -L'
# ワイルドカードの省略入力を有効にする
alias mmv='noglob zmv -W'
alias mcp='mmv -C'
alias mln='mmv -L'

# for z.sh
# ディレクトリ移動履歴を取る
_Z_CMD=j
source ~/.zsh/z.sh
precmd() {
  _z --add "$(pwd -P)"
}

## Python virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi

## Python pip -> virtualenv only
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
