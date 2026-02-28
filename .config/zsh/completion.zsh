# Safe compinit wrapper + zstyle

if [ -d "${HOME}/.zsh/comp" ]; then
  fpath=( "${HOME}/.zsh/comp" $fpath )
  autoload -Uz compinit
  # warn if insecure, prefer user fix
  if compaudit 2>/dev/null | read; then
    echo "compinit: insecure directories detected. Run: compaudit | xargs chmod g-w"
    compinit -C 2>/dev/null || true
  else
    compinit -C 2>/dev/null || compinit 2>/dev/null || true
  fi
fi

zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' menu select
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer \
    _oldlist _complete _match _ignored _approximate _list _history

zstyle ':completion:*' matcher-list '' \
    'm:{a-z}={A-Z}' 'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'
zstyle ':completion:*:processes' command \
    "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# Use cache completion
# apt-get, dpkg (Debian), rpm (Redhat), urpmi (Mandrake), perl -M,
# bogofilter (zsh 4.2.1 >=), fink, mac_apps...
# zstyle ':completion:*' use-cache true
