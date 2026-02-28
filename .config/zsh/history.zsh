HISTFILE=$HOME/.zsh-history
HISTSIZE=3000
SAVEHIST=8000
setopt inc_append_history

export HISTORY_IGNORE="(cd|pwd|l[sal]|rm|mv|shutdown|exit|rmdir)"
