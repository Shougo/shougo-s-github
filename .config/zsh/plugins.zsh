PLUGIN_DIR="${HOME}/.zsh"

# zsh-autosuggestions (loaded immediately: affects typing experience)
if [ -d "${PLUGIN_DIR}/zsh-autosuggestions" ]; then
  source "${PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,bg=#2c2c2c"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# Delay heavy plugins until just before the first prompt is drawn.
# This keeps startup fast while ensuring plugins are ready for interactive use.
_load_heavy_plugins() {
  # Remove this hook so it only runs once.
  add-zsh-hook -d precmd _load_heavy_plugins

  # fast-syntax-highlighting
  if [ -d "${PLUGIN_DIR}/fast-syntax-highlighting" ]; then
    source "${PLUGIN_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  fi

  # git-prompt.zsh
  if [ -d "${PLUGIN_DIR}/git-prompt.zsh" ]; then
    source "${PLUGIN_DIR}/git-prompt.zsh/git-prompt.zsh"
  fi
}

add-zsh-hook precmd _load_heavy_plugins
