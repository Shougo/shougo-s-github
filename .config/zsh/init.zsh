[[ -o interactive ]] || return

XDG_ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZSH_CACHE_DIR="${HOME}/.cache/zsh"
PLUGIN_DIR="${HOME}/.zsh"   # keep external plugins here

# Ensure cache directory exists
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

autoload -Uz add-zsh-hook

# Profile.
#zmodload zsh/zprof && zprof
#zmodload zsh/datetime
#setopt promptsubst
#PS4='+$EPOCHREALTIME %N:%i> '
#exec 3>&2 2>/tmp/zsh_profile.$$
#setopt xtrace prompt_subst

for f in \
    env completion plugins options history aliases \
    keybinds functions colors prompt others compile local \
    ; do
  if [[ -f "${XDG_ZSH}/${f}.zsh.zwc" && "${XDG_ZSH}/${f}.zsh.zwc" -nt "${XDG_ZSH}/${f}.zsh" ]]; then
    source "${XDG_ZSH}/${f}.zsh.zwc"
  elif [[ -f "${XDG_ZSH}/${f}.zsh" ]]; then
    source "${XDG_ZSH}/${f}.zsh"
  fi
done
