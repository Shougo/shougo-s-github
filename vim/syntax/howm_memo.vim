"
" Vim syntax file
"
" Language:howm
" Maintainer:
" Last Change:

scriptencoding cp932

if &background == 'dark'
  hi howmTodo     ctermfg=Yellow      guifg=Yellow
  hi howmTodoUD   ctermfg=Magenta     guifg=LightRed
  hi howmSchedule ctermfg=Green       guifg=Green
  hi howmReminder ctermfg=Cyan        guifg=Cyan
  hi howmFinished ctermfg=DarkGrey    guifg=DarkGrey
else
  hi howmTodo     ctermfg=DarkYellow  guifg=DarkYellow
  hi howmTodoUD   ctermfg=DarkMagenta guifg=DarkMagenta
  hi howmSchedule ctermfg=DarkGreen   guifg=DarkGreen
  hi howmReminder ctermfg=Blue        guifg=Blue
  hi howmFinished ctermfg=DarkGrey    guifg=Grey
endif
hi howmDeadline ctermfg=Red     guifg=Red
hi howmHoliday  ctermfg=Magenta guifg=Magenta
hi howmSpecial  ctermfg=Red     guifg=Red

hi def link txtUrl                      Underlined
hi def link txtFile                     Underlined
hi def link outlineTitle                Type
hi def link actionlockDate              Underlined
hi def link actionlockTime              Constant
hi def link actionlockLink              Underlined
hi def link actionlockKeyword           Underlined
hi def link actionlockMacroAction       Underlined
hi def link actionlockMacroActionDefine howmFinished
hi def link actionlockList              Type
hi def link recentmodeDate              howmFinished
hi def link howmTitle                   Title
hi def link howmTitleDesc               Special
hi def link howmCategory                Label
hi def link howmEntrySeparator          Special

syntax match actionlockList display "{[- *_]}"

if exists('g:QFixHowm_Date')
  exec 'syntax match actionlockDate display "'.g:QFixHowm_Date.'"'
else
  syntax match actionlockDate display "\d\{4}-\d\{2}-\d\{2}"
endif
syntax match actionlockTime display " \zs\d\d:\d\d\(:\d\d\)\?\ze]"
"if exists('g:QFixHowm_RecentMode') && (g:QFixHowm_RecentMode >= 3)
  syntax match recentmodeDate display "(\d\{12})"
"endif

syntax match txtUrl  display "\(https\|http\|ftp\|file\):[-{}!#%&+,./0-9:;=?@A-Za-z_~]\+"
syntax match txtFile display '\([A-Za-z]:[/\\]\|\~\/\)[-!#%&+,./0-9:;=?@A-Za-z_~\\]\+'

if exists('g:QFixHowm_Title') && exists('g:QFixHowm_EscapeTitle')
  let s:QFixHowm_Title = escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle)
  exe 'syn region howmTitle start="^'.s:QFixHowm_Title.'" end="$" contains=ALL'
  exe 'syn match howmTitleDesc contained "^'.s:QFixHowm_Title.'"'
  syn match howmCategory +\(\[.\{-}\]\)\++ contained
  exec 'syntax match outlineTitle display "^'.s:QFixHowm_Title.'\{2,}"'
endif
if exists('g:QFixHowm_MergeEntrySeparator')
  exe 'syntax match howmEntrySeparator display ' . '"^'.g:QFixHowm_MergeEntrySeparator.'"'
endif
if exists('g:QFixHowm_Link')
  exe 'syntax match actionlockLink display ' . '"'.g:QFixHowm_Link.'.*$"'
endif
if exists('g:QFixHowm_keyword') && g:QFixHowm_keyword != ''
  exe 'syntax match actionlockKeyword display "\V\%('.g:QFixHowm_keyword.'\)"'
endif
if exists('g:QFixHowm_MacroActionKey') && exists('g:QFixHowm_MacroActionPattern')
  if g:QFixHowm_MacroActionKey != '' && g:QFixHowm_MacroActionPattern != ''
    exe 'syntax match actionlockMacroAction display "^.*'.g:QFixHowm_MacroActionPattern.'.*$" contains=actionlockMacroActionDefine'
    exe 'syntax match actionlockMacroActionDefine display "'.g:QFixHowm_MacroActionPattern.'.*$"'
  endif
endif

let s:pattern = '^\s*\[\d\{4}-\d\{2}-\d\{2}\( \d\{2}:\d\{2}\)\?]'
if exists('g:QFixHowm_Date')
  let s:pattern = '^\s*\['.g:QFixHowm_Date.'\( \d\{2}:\d\{2}\)\?]'
endif
let s:epat = '\{1,3}\((\([0-9]\+\)\?\([-+*]\?\c\(Sun\|Mon\|Tue\|Wed\|Thu\|Fri\|Sat\)\?\))\)\?[0-9]*'
exe 'syntax match howmSchedule display "'.s:pattern.'@' . s:epat .'" contains=actionlockDate,actionlockTime'
exe 'syntax match howmDeadline display "'.s:pattern.'!' . s:epat .'" contains=actionlockDate,actionlockTime'
exe 'syntax match howmTodo     display "'.s:pattern.'+' . s:epat .'" contains=actionlockDate,actionlockTime'
exe 'syntax match howmReminder display "'.s:pattern.'-' . s:epat .'" contains=actionlockDate,actionlockTime'
exe 'syntax match howmTodoUD   display "'.s:pattern.'\~'. s:epat .'" contains=actionlockDate,actionlockTime'
exe 'syntax match howmFinished display "'.s:pattern.'\."'
let s:pattern = '&\[\d\{4}-\d\{2}-\d\{2}\( \d\{2}:\d\{2}\)\?]\.'
if exists('g:QFixHowm_Date')
  let s:pattern = '&\['.g:QFixHowm_Date.'\( \d\{2}:\d\{2}\)\?]\.'
endif
exe 'syntax match howmFinished display "'.s:pattern.'"'

