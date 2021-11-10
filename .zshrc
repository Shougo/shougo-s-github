#####################################################################
# init
#####################################################################

# zmodload zsh/zprof && zprof
# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2>/tmp/zsh_profile.$$
# setopt xtrace prompt_subst

if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
    zcompile ~/.zshrc

    # Compile all zsh plugins
    if [ -d ~/.zsh ]; then
        for f in $(find ~/.zsh -type f -name "*.zsh"); do zcompile $f; done
    fi
fi

source ~/.zshenv


#####################################################################
# environment
#####################################################################

export EDITOR=nvim
export LANG=en_US.UTF-8

# Better umask
umask 022

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# improved less option
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS'

# Print core files?
#unlimit
#limit core 0
#limit -s
#limit coredumpsize  0


#####################################################################
# completions
#####################################################################

# Enable completions
if [ -d ~/.zsh/comp ]; then
    fpath=(~/.zsh/comp $fpath)
    autoload -U ~/.zsh/comp/*(:t)
fi

zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
# Use cache completion
# apt-get, dpkg (Debian), rpm (Redhat), urpmi (Mandrake), perl -M,
# bogofilter (zsh 4.2.1 >=), fink, mac_apps...
# zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-z}={A-Z}' \
    'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'
# sudo completions
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' menu select
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored \
    _approximate _list _history

autoload -Uz compinit && compinit -C

zstyle ':completion:*:processes' command \
    "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# Enable auto-suggestion
# https://github.com/zsh-users/zsh-autosuggestions
if [ -d ~/.zsh/zsh-autosuggestions ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,bg=#2c2c2c"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi


#####################################################################
# colors
#####################################################################

# Color settings for zsh complete candidates
alias ls='ls -F --show-control-chars --color=always'
alias la='ls -aF --show-control-chars --color=always'
alias ll='ls -lF --show-control-chars --color=always'
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS=\
    'di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'

# Use prompt colors feature
autoload -U colors
colors

# Use git-prompt.zsh instead of vcs_info
# https://github.com/woefe/git-prompt.zsh
if [ -d ~/.zsh/git-prompt.zsh ]; then
    source ~/.zsh/git-prompt.zsh/git-prompt.zsh
fi

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
    PROMPT="%B%{[31m%}%/#%{^[[m%}%b "
    PROMPT2="%B%{[31m%}%_#%{^[[m%}%b "
elif [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] ; then
    PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
else;
    PROMPT='%{[33m%}[%35<..<%~]%{[m%}$(gitprompt)'
    PROMPT+='%(?.%(!.%F{white}%F{yellow}%F{red}.%F{green})%f.%F{red}%f)
%{[$[31+$RANDOM % 7]m%}%U%B%#'"%b%{%}%u "
    #PROMPT='%{[33m%}[%35<..<%~]%{[m%}${vcs_info_msg_0_}
#%{[$[31+$RANDOM % 7]m%}%U%B%#'"%b%{%}%u "
fi

# Multi line prompt
PROMPT2="%_%% "
# Spell miss prompt
SPROMPT="correct> %R -> %r [n,y,a,e]? "

# Enable syntax highlight
# https://github.com/zdharma/fast-syntax-highlighting
if [ -d ~/.zsh/fast-syntax-highlighting ]; then
    source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi


#####################################################################
# options
######################################################################

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

# Histories
HISTFILE=$HOME/.zsh-history
HISTSIZE=3000
SAVEHIST=8000
setopt inc_append_history

# Ignore some command histories
export HISTORY_IGNORE="(cd|pwd|l[sal]|rm|mv|shutdown|exit|rmdir)"

# Enable math functions
zmodload zsh/mathfunc


#####################################################################
# alias
######################################################################

# Better mv, cp, mkdir
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'

# Improve du, df
alias du='du -h'
alias df='df -h'

# Improve od for hexdump
alias od='od -Ax -tx1z'
alias hexdump='hexdump -C'

alias vim='TERM=xterm-256color nvim'
#alias goneovim='~/Downloads/goneovim/goneovim &>/dev/null &'
#alias gn=goneovim
alias nvui='nvui --ext_cmdline'


#####################################################################
# keybinds
######################################################################

# emacs keybinds
bindkey -e

# History completion
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# Like bash
bindkey "^u" backward-kill-line

# Sticky shift
# https://github.com/4513ECHO/zsh-sticky-shift
if [ -d ~/.zsh/zsh-sticky-shift ]; then
    source ~/.zsh/zsh-sticky-shift/sticky-shift.plugin.zsh
    export STICKY_TABLE=us
    export STICKY_DELAY=0.7
fi


#####################################################################
# others
######################################################################

# Improve terminal title
case "${TERM}" in
    kterm*|xterm*|vt100|st*|rxvt*|alacritty)
        precmd() {
            echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
        }
        ;;
esac

# Use dtach or abduco instead screen/tmux
# C-\ is detach
# dtach command, dtach -A command, dtach -a session
# adbuco -c session,abduco -c session command, abduco -a command

if ( which zprof > /dev/null ); then
    zprof | less
fi
