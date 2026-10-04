# ============================================================================
# Zsh Plugin Manager
# ============================================================================

# Ensure PLUGIN_DIR is available (exported from init.zsh)
: "${PLUGIN_DIR:=$HOME/.zsh}"

# ============================================================================
# Plugin Loading Functions
# ============================================================================

# Helper function to safely load plugins
load_plugin() {
  local plugin_name="$1"
  local plugin_file="$2"

  if [ ! -f "$plugin_file" ]; then
    echo "Warning: Plugin not found: $plugin_name ($plugin_file)" >&2
    return 1
  fi

  if ! source "$plugin_file" 2>/dev/null; then
    echo "Warning: Failed to load plugin: $plugin_name" >&2
    return 1
  fi

  echo "Loaded: $plugin_name" >&2
}

# ============================================================================
# Plugins
# ============================================================================

# --- fast-syntax-highlighting ---
# Provides syntax highlighting for commands
if [ -f "${PLUGIN_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
  source "${PLUGIN_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 2>/dev/null || {
    echo "Warning: Failed to load fast-syntax-highlighting" >&2
  }
fi

# --- git-prompt.zsh ---
# Provides git status information for prompt
if [ -f "${PLUGIN_DIR}/git-prompt.zsh/git-prompt.zsh" ]; then
  if source "${PLUGIN_DIR}/git-prompt.zsh/git-prompt.zsh" 2>/dev/null; then
    # Optional: Configure git prompt appearance
    # export ZSH_THEME_GIT_PROMPT_PREFIX=" %B%F{blue}["
    # export ZSH_THEME_GIT_PROMPT_SUFFIX="]%f%b"
    # export ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}●%f"
    # export ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}✓%f"
  else
    echo "Warning: Failed to load git-prompt.zsh" >&2
  fi
fi

# --- zsh-autosuggestions ---
# Provides command suggestions based on history
if [ -f "${PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  if source "${PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null; then
    # Verify function exists
    if (( ${+functions[_zsh_autosuggest_start]} )); then
      # Configuration: highlight style (terminal dependent)
      : "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:=fg=#666666,bg=#2c2c2c}"
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE

      # Strategy: use history first, then completion
      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    else
      echo "Warning: zsh-autosuggestions functions not loaded" >&2
    fi
  else
    echo "Warning: Failed to load zsh-autosuggestions" >&2
  fi
fi

# ============================================================================
# Plugin Management Notes
# ============================================================================

# Manual installation:
#   git clone https://github.com/zsh-users/zsh-autosuggestions \
#     ~/.zsh/zsh-autosuggestions
#   git clone https://github.com/zdharma-continuum/fast-syntax-highlighting \
#     ~/.zsh/fast-syntax-highlighting
#   git clone https://github.com/olivierverdier/zsh-git-prompt \
#     ~/.zsh/git-prompt.zsh
#
# Update plugins:
#   for plugin in ~/.zsh/*/; do
#     (cd "$plugin" && git pull)
#   done
