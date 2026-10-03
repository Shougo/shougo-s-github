# emacs keybinds
bindkey -e

autoload -Uz history-search-end edit-command-line

# History completion
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# Like bash
bindkey "^u" backward-kill-line

# Edit command line by the editor
zle -N edit-command-line
bindkey '^x^e' edit-command-line
