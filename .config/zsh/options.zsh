# ============================================================================
# ZSH Options Configuration
# ============================================================================

# Interaction & Safety
# ─────────────────────────────────────────────────────────────────────────
setopt auto_resume                # Resume suspended jobs
setopt ignore_eof                 # Ignore <C-d> logout
setopt no_beep                    # Disable beeps and bells
setopt no_flow_control            # Disable flow control (Ctrl+S/Q)
setopt rm_star_wait               # Confirm before 'rm *'

# Correction & Features
# ─────────────────────────────────────────────────────────────────────────
setopt correct                    # Enable spellcheck for commands
setopt equals                     # Enable "=command" feature
setopt interactive_comments       # Allow comments in interactive shell

# Expansion
# ─────────────────────────────────────────────────────────────────────────
setopt brace_ccl                  # {a-c} expands to a b c
setopt extended_glob              # Enable extended glob patterns (**, (, |, etc.)
setopt hist_expand                # Expand history substitutions
setopt prompt_subst               # Enable prompt substitution

# History Management
# ─────────────────────────────────────────────────────────────────────────
setopt extended_history           # Save timestamp and duration
setopt hist_ignore_dups           # Ignore consecutive duplicates
setopt hist_ignore_space          # Ignore commands starting with space
setopt hist_reduce_blanks         # Remove superfluous blanks
setopt hist_no_store              # Don't store 'fc' command itself
setopt inc_append_history         # Append to history immediately
unsetopt hist_verify              # Don't verify history expansion

# Directory Navigation
# ─────────────────────────────────────────────────────────────────────────
setopt auto_cd                    # cd into directory without 'cd' command
setopt auto_pushd                 # Push old directory to stack on cd
setopt pushd_minus                # Use - instead of + for pushd
setopt pushd_ignore_dups          # Don't duplicate entries in stack
setopt pushd_silent               # Don't print directory stack

# Completion Behavior
# ─────────────────────────────────────────────────────────────────────────
setopt auto_list                  # Show completion list automatically
setopt auto_param_slash           # Add / to completed directory names
setopt auto_param_keys            # Use parameterized key sequences
setopt complete_in_word           # Enable completion in the middle of word
setopt complete_aliases           # Expand aliases during completion
setopt no_menu_complete           # Disable menu-style completion
setopt glob_complete              # Expand globs during completion
setopt list_rows_first            # List completions row-wise
setopt list_types                 # List files with type indicators (ls -F)
setopt list_packed                # Compact completion list display
setopt mark_dirs                  # Add / to completed directory names

# Globbing & Path
# ─────────────────────────────────────────────────────────────────────────
setopt magic_equal_subst          # Enable completion in --option=arg
setopt path_dirs                  # Search subdirectories in $PATH
setopt numeric_glob_sort          # Sort numeric names numerically
setopt multios                    # Enable multi IO redirection

# Miscellaneous
# ─────────────────────────────────────────────────────────────────────────
setopt long_list_jobs             # Show full job info with 'jobs'
setopt short_loops                # Compact for/repeat/select syntax
setopt print_eightbit             # Print 8-bit characters
setopt print_exit_value           # Show non-zero exit codes
setopt always_last_prompt         # Redraw prompt after completion
setopt hash_cmds                  # Hash command paths
unsetopt promptcr                 # Don't print carriage return before prompt

# ============================================================================
# History Configuration
# ============================================================================

HISTFILE=$HOME/.zsh-history
HISTSIZE=3000
SAVEHIST=8000

# Commands to exclude from history
export HISTORY_IGNORE="(cd|pwd|ls|la|ll|rm|mv|shutdown|exit|rmdir)"

# ============================================================================
# Modules & Extensions
# ============================================================================

# Enable math functions
zmodload zsh/mathfunc
