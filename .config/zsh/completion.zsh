# Safe compinit wrapper + zstyle

# safer compaudit check
if type compaudit >/dev/null 2>&1; then
  insecure_dirs="$(compaudit 2>/dev/null)"
  if [ -n "$insecure_dirs" ]; then
    echo "compinit: insecure directories detected. Run: compaudit | xargs chmod g-w"
    # try to use cached init if possible
    compinit -C 2>/dev/null || true
  else
    compinit -C 2>/dev/null || compinit 2>/dev/null || true
  fi
else
  compinit -C 2>/dev/null || compinit 2>/dev/null || true
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
