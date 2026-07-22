# Manual compile helper for your own config files

zsh_compile_myconfig() {
  emulate -L zsh
  local cache_dir="${ZSH_CACHE_DIR:-${HOME}/.cache/zsh}"
  local xdg_zsh="${XDG_CONFIG_HOME:-${HOME}/.config}/zsh"
  local f zwc

  [[ -d "$cache_dir" ]] || mkdir -p "$cache_dir"

  for f in "${xdg_zsh}"/*.zsh; do
    [[ -f "$f" ]] || continue
    zwc="${f}.zwc"
    if [[ ! -f "$zwc" || "$f" -nt "$zwc" ]]; then
      echo "zcompile: compiling $f"
      zcompile "$f" || echo "zcompile failed for $f"
    fi
  done
}
# usage: zsh_compile_myconfig
