# Color settings for zsh complete candidates

alias ls='ls -F --show-control-chars --color=always'
alias la='ls -aF --show-control-chars --color=always'
alias ll='ls -lF --show-control-chars --color=always'
export LSCOLORS=ExFxCxdxBxegedabagacad
LS_COLORS_ENTRIES=(
  'di=01;34'
  'ln=01;35'
  'so=01;32'
  'ex=01;31'
  'bd=46;34'
  'cd=43;34'
  'su=41;30'
  'sg=46;30'
  'tw=42;30'
  'ow=43;30'
)
LS_COLORS="$(printf '%s:' "${LS_COLORS_ENTRIES[@]}")"
LS_COLORS="${LS_COLORS%:}"
export LS_COLORS
zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
