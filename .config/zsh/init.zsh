[[ -o interactive ]] || return

XDG_ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
PLUGIN_DIR="${HOME}/.zsh"   # keep external plugins here

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
  [ -f "${XDG_ZSH}/${f}.zsh" ] && source "${XDG_ZSH}/${f}.zsh"
done
