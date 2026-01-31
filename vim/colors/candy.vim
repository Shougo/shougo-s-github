"=============================================================================
" FILE: candy.vim
" Maintainer: Tiza
"             Shougo Matsushita
" This color scheme uses a dark background.
"=============================================================================

" Based on https://www.vim.org/scripts/script.php?script_id=282

if !has('vim_starting')
  set background=dark
  highlight clear
  if 'syntax_on'->exists()
    syntax reset
  endif
endif

let colors_name = 'candy'

highlight Normal        gui=NONE guibg=#2c2c2c guifg=#dfdfdf

" Search
highlight IncSearch     gui=underline guibg=#0060c0 guifg=#80ffff
highlight Search        gui=NONE guibg=#0060c0 guifg=#f0f0f8
" NOTE: Cursor movement is slow when CurSearch highlight group is set
" https://github.com/neovim/neovim/issues/23590
highlight! link CurSearch Search

" Messages
highlight ErrorMsg      gui=bold guibg=NONE guifg=#ff6f61
highlight WarningMsg    gui=bold guibg=NONE guifg=#ffa0ff
highlight StderrMsg     gui=bold guibg=NONE guifg=#a020f0
highlight StdoutMsg     gui=bold guibg=NONE guifg=#00aaff
highlight ModeMsg       gui=bold guibg=NONE guifg=#40f0d0
highlight MoreMsg       gui=bold guibg=NONE guifg=#00ffff
highlight Question      gui=bold guibg=NONE guifg=#e8e800

" Split area
highlight StatusLine    gui=underline guibg=#2c2c2c guifg=#c8c8d8
highlight StatusLineNC  gui=underline guibg=#2c2c2c guifg=#c8c8d8
highlight VertSplit     gui=underline guibg=#2c2c2c guifg=#c8c8d8
highlight WinSeparator  gui=NONE guibg=#1c1c1c guifg=#1c1c1c
highlight WildMenu      gui=NONE guibg=#a0a0ff guifg=#252525
highlight FloatBorder   gui=NONE guibg=#1c1c1c guifg=#a0d0ff

" Diff
highlight DiffAdd       gui=NONE guibg=#0020a0 guifg=#a0d0ff
highlight DiffChange    gui=NONE guibg=#401830 guifg=#e03870
highlight DiffDelete    gui=NONE guibg=#0020a0 guifg=#a0d0ff
highlight DiffText      gui=NONE guibg=#802860 guifg=#ff78f0

" Cursor
highlight Cursor        gui=NONE guibg=#606060 guifg=fg
highlight CmdlineCursor gui=NONE guibg=#606060 guifg=fg
highlight CursorLine    gui=NONE guibg=#444444 guifg=fg
highlight lCursor       gui=NONE guibg=#80403f guifg=fg
highlight CursorIM      gui=NONE guibg=#bb00aa guifg=fg
highlight CursorColumn  gui=NONE guibg=#666666 guifg=fg
highlight CursorLineNr  gui=bold guibg=NONE guifg=#ffff00

" Fold
highlight Folded        gui=NONE guibg=#106090 guifg=#40f0f0
highlight FoldColumn    gui=NONE guibg=NONE guifg=#40c0ff

" Syntax group
highlight Comment       gui=NONE guibg=NONE guifg=#c7c7f9
highlight Constant      gui=NONE guibg=NONE guifg=#90d0ff
highlight Error         gui=bold guibg=NONE guifg=#ffa0af
highlight Identifier    gui=NONE guibg=NONE guifg=#40f0f0
highlight Ignore        gui=NONE guibg=NONE guifg=#2c2c2c
highlight PreProc       gui=NONE guibg=NONE guifg=#40f0a0
highlight Special       gui=NONE guibg=NONE guifg=#e0e080
highlight Statement     gui=NONE guibg=NONE guifg=#ffa0ff
highlight Todo          gui=bold,underline guibg=NONE guifg=#ffa0a0
highlight Type          gui=NONE guibg=NONE guifg=#ffc864
highlight Underlined    gui=underline guibg=NONE guifg=#f0f0f8

" HTML
highlight htmlLink      gui=underline guibg=NONE guifg=fg
highlight htmlBold      gui=bold guibg=NONE guifg=fg
highlight htmlBoldItalic gui=bold,italic guibg=NONE guifg=fg
highlight htmlBoldUnderline gui=bold,underline guibg=NONE guifg=fg
highlight htmlBoldUnderlineItalic gui=bold,italic,underline guibg=NONE guifg=fg
highlight htmlItalic    gui=italic guibg=NONE guifg=fg
highlight htmlUnderline gui=underline guibg=NONE guifg=fg
highlight htmlUnderlineItalic gui=italic,underline guibg=NONE guifg=fg

" Menu
highlight Pmenu         gui=NONE guibg=#606060 guifg=fg
highlight PmenuSel      gui=NONE guibg=#1f82cd guifg=#dddd00
highlight PmenuSbar     gui=NONE guibg=#d6d6d6 guifg=fg
highlight PmenuThumb    gui=NONE guibg=#ffffff guifg=#3cac3c
highlight PmenuMatch    gui=bold guibg=NONE guifg=fg
highlight PmenuMatchLead gui=NONE guibg=NONE guifg=#f8404c
highlight ComplMatchIns gui=NONE guibg=NONE guifg=#4080cc

" Tab
highlight TablineSel    gui=NONE guibg=#0060c0 guifg=#f0f0f8
highlight Tabline       gui=NONE guibg=#c8c8d8 guifg=#252525
highlight TablineFill   gui=NONE guibg=#c8c8d8 guifg=#252525

" Others
highlight Directory     gui=NONE guibg=NONE guifg=#40f0d0
highlight LineNr        gui=NONE guibg=NONE guifg=#a0b0c0
highlight NonText       gui=bold guibg=NONE guifg=#8080cc
highlight SpecialKey    gui=bold guibg=NONE guifg=#8080ff
highlight Title         gui=bold guibg=NONE guifg=#f0f0f8
highlight Visual        gui=NONE guibg=#707080 guifg=#e0e0f0
highlight VisualNOS     gui=bold,underline guibg=NONE guifg=fg
highlight Bold          gui=bold guibg=NONE guifg=fg
highlight Italic        gui=italic guibg=NONE guifg=fg
highlight ColorColumn   gui=NONE guibg=#444444 guifg=fg
highlight SignColumn    gui=NONE guibg=#2c2c2c guifg=fg
highlight MatchParen    gui=NONE guibg=#008b8b guifg=fg
highlight SpellBad      gui=undercurl guibg=NONE guifg=fg guisp=#ff0000
highlight SpellCap      gui=undercurl guibg=NONE guifg=fg guisp=#0000ff
highlight SpellRare     gui=undercurl guibg=NONE guifg=fg guisp=#ff00ff
highlight SpellLocal    gui=undercurl guibg=NONE guifg=fg guisp=#00ffff
highlight Conceal       gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
highlight EndOfBuffer   gui=NONE guifg=#101010

if has('nvim')
  highlight NormalNC     gui=NONE guibg=#2c2c2c guifg=#bfbfbf
  highlight WhiteSpace   gui=NONE guifg=#999999
  highlight WinSeparator gui=NONE guibg=#2c2c2c guifg=#c8c8d8
endif

" Terminal colors
highlight TerminalBG0     gui=NONE guibg=#383838 guifg=NONE
highlight TerminalBG1     gui=NONE guibg=#ff4444 guifg=NONE
highlight TerminalBG2     gui=NONE guibg=#44ff44 guifg=NONE
highlight TerminalBG3     gui=NONE guibg=#ffb30a guifg=NONE
highlight TerminalBG4     gui=NONE guibg=#6699ff guifg=NONE
highlight TerminalBG5     gui=NONE guibg=#f820ff guifg=NONE
highlight TerminalBG6     gui=NONE guibg=#4ae2e2 guifg=NONE
highlight TerminalBG7     gui=NONE guibg=#fdf6e3 guifg=NONE
highlight TerminalBG8     gui=NONE guibg=#585858 guifg=NONE
highlight TerminalBG9     gui=NONE guibg=#ff4444 guifg=NONE
highlight TerminalBG10    gui=NONE guibg=#44ff44 guifg=NONE
highlight TerminalBG11    gui=NONE guibg=#ffb30a guifg=NONE
highlight TerminalBG12    gui=NONE guibg=#6699ff guifg=NONE
highlight TerminalBG13    gui=NONE guibg=#f820ff guifg=NONE
highlight TerminalBG14    gui=NONE guibg=#4ae2e2 guifg=NONE
highlight TerminalBG15    gui=NONE guibg=#fdf6e3 guifg=NONE

highlight TerminalFG0     gui=NONE guibg=NONE guifg=#383838
highlight TerminalFG1     gui=NONE guibg=NONE guifg=#ff4444
highlight TerminalFG2     gui=NONE guibg=NONE guifg=#44ff44
highlight TerminalFG3     gui=NONE guibg=NONE guifg=#ffb30a
highlight TerminalFG4     gui=NONE guibg=NONE guifg=#6699ff
highlight TerminalFG5     gui=NONE guibg=NONE guifg=#f820ff
highlight TerminalFG6     gui=NONE guibg=NONE guifg=#4ae2e2
highlight TerminalFG7     gui=NONE guibg=NONE guifg=#fdf6e3
highlight TerminalFG8     gui=NONE guibg=NONE guifg=#585858
highlight TerminalFG9     gui=NONE guibg=NONE guifg=#ff4444
highlight TerminalFG10    gui=NONE guibg=NONE guifg=#44ff44
highlight TerminalFG11    gui=NONE guibg=NONE guifg=#ffb30a
highlight TerminalFG12    gui=NONE guibg=NONE guifg=#6699ff
highlight TerminalFG13    gui=NONE guibg=NONE guifg=#f820ff
highlight TerminalFG14    gui=NONE guibg=NONE guifg=#4ae2e2
highlight TerminalFG15    gui=NONE guibg=NONE guifg=#fdf6e3
