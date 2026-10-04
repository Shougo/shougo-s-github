# ============================================================================
# Terminal Title Configuration
# ============================================================================

# Set terminal title (works with modern terminals and multiplexers)
case "${TERM}" in
  kterm*|xterm*|st*|rxvt*|alacritty|screen*|tmux*)
    precmd() {
      printf '\033]0;%s@%s:%s\007' "${USER:-unknown}" "${HOST%%.*}" "${PWD:-.}"
    }
    ;;
esac

# ============================================================================
# Mise Version Manager
# ============================================================================

# https://github.com/jdxcode/mise
if [ -x "$HOME/.local/bin/mise" ]; then
    local mise_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise.cache"
    local mise_bin="$HOME/.local/bin/mise"

    # Create cache directory
    mkdir -p "$(dirname "$mise_cache")" 2>/dev/null

    # Regenerate cache if missing or mise binary is newer
    if [ ! -f "$mise_cache" ] || [ "$mise_bin" -nt "$mise_cache" ]; then
        if "$mise_bin" activate zsh > "$mise_cache" 2>/dev/null; then
            zcompile "$mise_cache" 2>/dev/null || true
        else
            echo "Warning: mise activation failed" >&2
        fi
    fi

    # Load cache if available
    if [ -f "$mise_cache" ]; then
        source "$mise_cache"
    fi
fi

# ============================================================================
# Profiling (enable in init.zsh with: zmodload zsh/zprof)
# ============================================================================

# Display profiling results if profiling is enabled
if (( ${+functions[zprof]} )); then
    zprof
fi
