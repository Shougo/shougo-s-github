# ============================================================================
# Zsh Prompt Configuration
# ============================================================================

# Load color definitions
autoload -U colors && colors

# ============================================================================
# Git Prompt Configuration
# ============================================================================

# Basic settings
ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"

# Prefix/Suffix formatting
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"

# Branch and detached state
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"

# Upstream tracking
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"

# Repository status indicators
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}X"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}O"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

# ============================================================================
# Prompt Construction
# ============================================================================

# Determine if running as root
if (( EUID == 0 )); then
    # Root prompt
    PROMPT=$'%B%F{red}%/#%f%b '
else
    # Regular user prompt

    # Show hostname for SSH sessions
    if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
      PROMPT=$'%F{white}${HOST%%.*}%f '
    else
      PROMPT=""
    fi

    # Path with git prompt
    PROMPT+=$'%F{yellow}[%35<..<%~]%f$(gitprompt)'

    # Exit status indicator and command prompt
    PROMPT+=$'%(?.%F{green}.%F{red})%f\n'

    # User input prompt with color variation
    PROMPT+=$'%{\e[$[31+$RANDOM % 7]m%}%U%B%#'"%b%{%}%u "
fi

# ============================================================================
# Secondary and Spell-check Prompts
# ============================================================================

# Continuation prompt (when a line is incomplete)
PROMPT2="%_%% "

# Spell-check prompt
SPROMPT=$'%F{red}correct:%f %R %F{yellow}->%f %r %F{blue}[n,y,a,e]?%f '

# ============================================================================
# OSC 133 Integration (Shell Integration)
# ============================================================================
# Enables better prompt handling in compatible terminals
# References:
#   - https://zenn.dev/ymotongpoo/articles/20220802-osc-133-zsh
#   - https://github.com/dlvhdr/dotfiles

_prompt_executing=""

function __prompt_precmd() {
    local ret="$?"

    if test "$_prompt_executing" != "0"; then
      _PROMPT_SAVE_PS1="$PS1"
      _PROMPT_SAVE_PS2="$PS2"
      PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
      PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi

    if test "$_prompt_executing" != ""; then
       printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi

    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    _prompt_executing=0
}

function __prompt_preexec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf "\033]133;C;\007"
    _prompt_executing=1
}

# Enable OSC 133 support (uncomment to enable)
# Requires compatible terminal (VS Code, iTerm2, kitty, WezTerm, etc.)
# export ENABLE_OSC133=1
if [ "${ENABLE_OSC133:-0}" = "1" ]; then
  preexec_functions+=(__prompt_preexec)
  precmd_functions+=(__prompt_precmd)
fi
