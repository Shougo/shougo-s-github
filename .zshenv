#---- 環境変数 ------------#
export EDITOR=vim
export FCEDIT=vim
export PAGER=less
export LESS='-RQM' # R = そのままの制御文字を出力 + 可能なら表示を正しく維持
                   # Q = 完全に quite
                   # M = 詳細なパーセント表示のプロンプト
export GZIP='-v9N'
export SHELL=zsh
export SCALA_HOME="$HOME/src/scala-2.9.1.final"
export PATH="$HOME/bin:/usr/local/bin:$SCALA_HOME/bin:$PATH"

#---- CVS -----------------#
export CVSROOT="$HOME/cvsroot"
#---- SVN -----------------#
export SVN_EDITOR="vim"

#---- ruby -----------------#
export RUBYOPT=-Ke

#---- accept-line-with-url ---#
export WWW_BROWSER="w3m"
export DOWNLOADER="wget -S"

eval $(dircolors -b ~/.dir_colors)

export WORKON_HOME=$HOME/.virtualenvs

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi

## Python pip -> virtualenv only
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
