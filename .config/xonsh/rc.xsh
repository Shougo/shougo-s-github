$VI_MODE = False
$COMPLETIONS_CONFIRM = False
$IGNOREEOF = True
$INDENT = "    "
$CASE_SENSITIVE_COMPLETIONS = False
$HISTCONTROL = "ignoredups"
$XONSH_AUTOPAIR = True
$AUTO_CD = True
$AUTO_PUSHD = True
$SUPPRESS_BRANCH_TIMEOUT_MESSAGE = True

# Note: Too slow
$UPDATE_COMPLETIONS_ON_KEYPRESS = False

$XONSH_COLOR_STYLE = 'default'
$PTK_STYLE_OVERRIDES['auto-suggestion'] = 'ansigray'
$PTK_STYLE_OVERRIDES['completion-menu'] = 'bg:ansigray ansiblack'
$PROMPT = "{INTENSE_RED}{user}{INTENSE_GREEN}@{INTENSE_BLUE}{hostname}{INTENSE_YELLOW} [ {cwd} ] {branch_color}{curr_branch}\n{WHITE}% "
$LS_COLORS="di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30"

from xonsh.prompt.vc import git_dirty_working_directory
$PROMPT_FIELDS['branch_color'] = (
    lambda: '{BOLD_INTENSE_RED}'
    if git_dirty_working_directory(include_untracked=True)
    else '{BOLD_INTENSE_GREEN}')

# pip3 install --user xontrib-readable-traceback
xontrib load readable-traceback
$READABLE_TRACE_STRIP_PATH_ENV = True
$READABLE_TRACE_REVERSE = True
$XONSH_SHOW_TRACEBACK = True
