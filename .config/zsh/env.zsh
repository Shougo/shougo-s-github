# Environment variables

# Load .zshenv
local zshenv_file="${ZDOTDIR:-$HOME}/.zshenv"
[ -f "$zshenv_file" ] && source "$zshenv_file"

if type nvim >/dev/null 2>&1; then
  export EDITOR=nvim
elif type vim >/dev/null 2>&1; then
  export EDITOR=vim
elif type vi >/dev/null 2>&1; then
  export EDITOR=vi
else
  export EDITOR=nano
fi

if locale -a | grep -q en_US.utf8; then
  export LANG=en_US.UTF-8
elif locale -a | grep -q C.UTF-8; then
  export LANG=C.UTF-8
else
  export LANG=C
fi

umask 022

WORDCHARS='_-.[]~&!#$%^(){}<>'
export WORDCHARS


# Improved less option
export LESS=(
  '--tabs=4'
  '--no-init'
  '--LONG-PROMPT'
  '--quit-if-one-screen'
  '--RAW-CONTROL-CHARS'
)

# Print core files?
#unlimit
#limit core 0
#limit -s
#limit coredumpsize  0
