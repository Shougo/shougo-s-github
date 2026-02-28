x-yank () {
    CUTBUFFER=$(xclip -selection clipboard -o -b </dev/null)
    zle yank
}
zle -N x-yank
bindkey "^y" x-yank
