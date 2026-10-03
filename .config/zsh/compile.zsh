# Manual compile helper for your own config files

XDG_ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

zsh_compile_myconfig() {
  local f zwc compiled=0 failed=0

  if [ ! -d "$XDG_ZSH" ]; then
    echo "ERROR: ZSH config directory not found: $XDG_ZSH" >&2
    return 1
  fi

  for f in "${XDG_ZSH}"/*.zsh; do
    [ -f "$f" ] || continue

    # Skip init.zsh
    [ "$(basename "$f")" = "init.zsh" ] && continue

    zwc="${f}c"

    # Check if compilation is needed
    if [ ! -f "$zwc" ] || [ "$f" -nt "$zwc" ]; then
      printf "Compiling: %-30s ... " "$(basename "$f")"
      if zcompile "$f" 2>/dev/null && [ -f "$zwc" ]; then
        echo "OK"
        ((compiled++))
      else
        echo "FAILED" >&2
        ((failed++))
      fi
    else
      printf "Skipping:  %-30s (already compiled)\n" "$(basename "$f")"
    fi
  done

  echo ""
  echo "zcompile: completed ($compiled compiled, $failed failed)"
  [ $failed -eq 0 ]
}
# usage: zsh_compile_myconfig
