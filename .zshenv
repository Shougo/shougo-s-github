#---- Environment variables ------------#
export EDITOR=nvim
export FCEDIT=nvim
export PAGER=less
export LESS='-RQM'
export BROWSER='firefox'
export SHELL=zsh
export MANPAGER='nvim --clean +Man\!'
export UNZIP='-I utf8 -O cp932'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[7m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;32m'
export LESS_TERMCAP_ue=$'\e[0m'

PATH_ENTRIES=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$GOPATH/bin"
  "$HOME/.cargo/bin"
  "$HOME/.deno/bin"
  "/usr/local/bin"
  "$PATH"
)
IFS=":" PATH="${PATH_ENTRIES[*]}" IFS=" "
export PATH

export GOPATH="$HOME/.go"
export XDG_CONFIG_HOME=$HOME/.config

export NEXTWORD_DATA_PATH=$HOME/Downloads/nextword-data-large
export MOCWORD_DATA=$HOME/Downloads/mocword.sqlite
