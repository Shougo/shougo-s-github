PLUGIN_DIR="${HOME}/.zsh"

# zsh-autosuggestions
if [ -d "${PLUGIN_DIR}/zsh-autosuggestions" ]; then
  source "${PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,bg=#2c2c2c"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# fast-syntax-highlighting
if [ -d "${PLUGIN_DIR}/fast-syntax-highlighting" ]; then
  source "${PLUGIN_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fi

# git-prompt.zsh
if [ -d "${PLUGIN_DIR}/git-prompt.zsh" ]; then
  source "${PLUGIN_DIR}/git-prompt.zsh/git-prompt.zsh"
fi
