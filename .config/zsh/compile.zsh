# Manual compile helper for your own config files

XDG_ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

zsh_compile_myconfig() {
  local f zwc
  for f in "${XDG_ZSH}"/*.zsh; do
    [ -f "$f" ] || continue
    zwc="${f}c"
    if [ ! -f "$zwc" ] || [ "$f" -nt "$zwc" ]; then
      echo "zcompile: compiling $f"
      zcompile "$f" || echo "zcompile failed for $f"
    fi
  done
}
# usage: zsh_compile_myconfig
