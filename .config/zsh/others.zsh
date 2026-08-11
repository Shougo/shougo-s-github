# Improved terminal title.
_set_terminal_title() {
  echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
}
case "${TERM}" in
  kterm*|xterm*|vt100|st*|rxvt*|alacritty)
    add-zsh-hook precmd _set_terminal_title
    ;;
esac

# Use mise
# https://github.com/jdxcode/mise
_ZSH_MISE_CACHE="${ZSH_CACHE_DIR:-${HOME}/.cache/zsh}/mise.zsh"
if [ -x ~/.local/bin/mise ]; then
    if ! [ -f "$_ZSH_MISE_CACHE" ]; then
        ~/.local/bin/mise activate zsh > "$_ZSH_MISE_CACHE"
        zcompile "$_ZSH_MISE_CACHE"
    fi
    source "$_ZSH_MISE_CACHE"
fi
unset _ZSH_MISE_CACHE

# zprof: set ZSH_PROF=1 before starting zsh to enable profiling output
if [[ -n "$ZSH_PROF" ]] && ( which zprof > /dev/null ); then
    zprof | less
fi
