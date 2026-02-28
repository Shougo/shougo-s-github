# Improved terminal title.
case "${TERM}" in
  kterm*|xterm*|vt100|st*|rxvt*|alacritty)
    precmd() {
      echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# Use mise
# https://github.com/jdxcode/mise
if [ -x ~/.local/bin/mise ]; then
    if ! [ -f /tmp/mise.cache ]; then
        ~/.local/bin/mise activate zsh > /tmp/mise.cache
        zcompile /tmp/mise.cache
    fi
    source /tmp/mise.cache
fi

if ( which zprof > /dev/null ); then
    zprof | less
fi
