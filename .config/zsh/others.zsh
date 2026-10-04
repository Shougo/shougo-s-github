# Improved terminal title.
case "${TERM}" in
  kterm*|xterm*|st*|rxvt*|alacritty|screen*|tmux*)
    # Modern terminals and multiplexers
    precmd() {
      printf '\033]0;%s@%s:%s\007' "$USER" "${HOST%%.*}" "$PWD"
    }
    ;;
  linux|dumb)
    # No title support for console/dumb terminals
    ;;
esac

# Use mise
# https://github.com/jdxcode/mise
if [ -x ~/.local/bin/mise ]; then
    local mise_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise.cache"
    local mise_bin="$HOME/.local/bin/mise"

    mkdir -p "$(dirname "$mise_cache")"

    if [ ! -f "$mise_cache" ] || [ "$mise_bin" -nt "$mise_cache" ]; then
        echo "Updating mise cache..." >&2
        if "$mise_bin" activate zsh > "$mise_cache" 2>/dev/null; then
            zcompile "$mise_cache" 2>/dev/null || true
        else
            echo "Warning: mise activation failed" >&2
        fi
    fi

    if [ -f "$mise_cache" ]; then
        source "$mise_cache"
    fi
fi

if (( ${+functions[zprof]} )); then
    zprof
fi
