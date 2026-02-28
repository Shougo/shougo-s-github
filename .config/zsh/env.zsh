# Environment variables

# Load .zshenv
[ -f "${HOME}/.zshenv" ] && source "${HOME}/.zshenv"

export EDITOR=nvim
export LANG=en_US.UTF-8
umask 022

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export WORDCHARS

# Improved less option
LESS_OPTS=(
  --tabs=4
  --no-init
  --LONG-PROMPT
  --quit-if-one-screen
  --RAW-CONTROL-CHARS
)
: "${LESS:=${(j: :)LESS_OPTS}}"
export LESS

# Print core files?
#unlimit
#limit core 0
#limit -s
#limit coredumpsize  0
