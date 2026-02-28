autoload -U colors && colors

# git prompt variables and PROMPT body (migrate from original)
ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}X"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}O"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

if [ $UID = "0" ]; then
    PROMPT=$'%B%{\e[31m%}%/#%{\e[m%}%b '
else
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
      PROMPT=$'%{\e[37m%}${HOST%%.*} '
    else
      PROMPT=""
    fi
    PROMPT+=$'%{\e[33m%}[%35<..<%~]%{\e[m%}$(gitprompt)'
    PROMPT+=$'%(?.%(!.%F{white}%F{yellow}%F{red}.%F{green})%f.%F{red}%f)\n'
    PROMPT+=$'%{\e[$[31+$RANDOM % 7]m%}%U%B%#'"%b%{%}%u "
fi

PROMPT2="%_%% "
SPROMPT="correct> %R -> %r [n,y,a,e]? "

# Enable OSC 133
# https://zenn.dev/ymotongpoo/articles/20220802-osc-133-zsh
_prompt_executing=""
function __prompt_precmd() {
    local ret="$?"

    if test "$_prompt_executing" != "0"
    then
      _PROMPT_SAVE_PS1="$PS1"
      _PROMPT_SAVE_PS2="$PS2"
      PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
      PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi

    if test "$_prompt_executing" != ""
    then
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

#preexec_functions+=(__prompt_preexec)
#precmd_functions+=(__prompt_precmd)
