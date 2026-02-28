# emacs keybinds
bindkey -e

# History completion
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# Like bash
bindkey "^u" backward-kill-line

# Use clipboard for yank
x-yank () {
    CUTBUFFER=$(xclip -selection clipboard -o -b </dev/null)
    zle yank
}
zle -N x-yank
bindkey "^y" x-yank

# Edit command line by the editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
