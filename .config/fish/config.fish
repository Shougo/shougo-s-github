# Suppress the intro messages
function fish_greeting
end

function cd
  builtin cd $argv; and ls
end

set pure_symbol_prompt '~>'

# Color theme

set pure_color_blue (set_color '1e95fd')
set pure_color_cyan \e\[36m
set pure_color_gray \e\[38\;5\;247m
set pure_color_green \e\[32m
set pure_color_normal \e\[30m\e\(B\e\[m
set pure_color_red \e\[31m
set pure_color_yellow \e\[33m

set fish_color_autosuggestion '1bc8c8'  'yellow'
set fish_color_command 'f820ff'  'purple'
set fish_color_comment 'cc6666' 'red'
set fish_color_cwd 'ff13ff' 'yellow'
set fish_color_cwd_root 'ff6666' 'red'
set fish_color_end '66ff66' 'green'
set fish_color_error 'red'  '--bold'
set fish_color_escape '1e95fd' 'cyan'
set fish_color_history_current '1e95fd' 'cyan'
set fish_color_host 'c0c0c0' 'normal'
set fish_color_match '1e95fd' 'cyan'
set fish_color_normal '6c6c6c' 'normal'
set fish_color_operator '1e95fd' 'cyan'
set fish_color_param '00afff' 'cyan'
set fish_color_quote 'f820ff' 'brown'
set fish_color_redirection '6c6c6c' 'normal'
set fish_color_search_match --background=purple
set fish_color_selection --background=purple
set fish_color_user '66ff66' 'green'
set fish_color_valid_path --underline
set fish_pager_color_completion '6c6c6c' 'normal'
set fish_pager_color_description '555'  'yellow'
set fish_pager_color_prefix '00afff'  'cyan'
set fish_pager_color_progress '00afff'  'cyan'


alias vim='nvim'
#alias nvim-qt='nvim-qt --geometry 1800x1200'
alias gonvim='~/Downloads/gonvim/gonvim.sh'
alias lock='i3exit lock'
