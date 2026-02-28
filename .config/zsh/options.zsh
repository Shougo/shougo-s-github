setopt auto_resume

# Ignore <C-d> logout
setopt ignore_eof

# Disable beeps
setopt no_beep

# {a-c} -> a b c
setopt brace_ccl

# Enable spellcheck
setopt correct

# Enable "=command" feature
setopt equals

# Disable flow control
setopt no_flow_control

# Ignore dups
setopt hist_ignore_dups

# Reduce spaces
setopt hist_reduce_blanks

# Ignore add history if space
setopt hist_ignore_space

# Save time stamp
setopt extended_history

# Expand history
setopt hist_expand

# Better jobs
setopt long_list_jobs

# Enable completion in "--option=arg"
setopt magic_equal_subst

# Add "/" if completes directory
setopt mark_dirs

# Disable menu complete for vimshell
setopt no_menu_complete

setopt list_rows_first

# Expand globs when completion
setopt glob_complete

# Enable multi io redirection
setopt multios

# Can search subdirectory in $PATH
setopt path_dirs

# For multi byte
setopt print_eightbit

# Print exit value if return code is non-zero
setopt print_exit_value

setopt pushd_ignore_dups

setopt pushd_silent

# Short statements in for, repeat, select, if, function
setopt short_loops

# Ignore history (fc -l) command in history
setopt hist_no_store

unsetopt promptcr

setopt hash_cmds

setopt numeric_glob_sort

# Enable comment string
setopt interactive_comments

# Improve rm *
setopt rm_star_wait

# Enable extended glob
setopt extended_glob

# Note: It is a lot of errors in script
# setopt no_unset

# Prompt substitution
setopt prompt_subst

setopt always_last_prompt

# List completion
setopt auto_list

setopt auto_param_slash

setopt auto_param_keys

# List like "ls -F"
setopt list_types

# Compact completion
setopt list_packed

setopt auto_cd

setopt auto_pushd
setopt pushd_minus
setopt pushd_ignore_dups

# Check original command in alias completion
setopt complete_aliases

unsetopt hist_verify

# Enable suffix completion
setopt complete_in_word

# Histories
HISTFILE=$HOME/.zsh-history
HISTSIZE=3000
SAVEHIST=8000
setopt inc_append_history

# Ignore some command histories
export HISTORY_IGNORE="(cd|pwd|l[sal]|rm|mv|shutdown|exit|rmdir)"

# Enable math functions
zmodload zsh/mathfunc
