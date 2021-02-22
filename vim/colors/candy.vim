"=============================================================================
" FILE: candy.vim
" Maintainer: Tiza
"             Shougo Matsushita
" This color scheme uses a dark background.
"=============================================================================

if !has('vim_starting')
  set background=dark
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let colors_name = 'candy'

highlight Normal        gui=NONE guibg=#2c2c2c guifg=#dfdfdf

" Search
highlight IncSearch     gui=underline guibg=#0060c0 guifg=#80ffff
highlight Search        gui=NONE guibg=#0060c0 guifg=#f0f0f8

" Messages
highlight ErrorMsg      gui=bold guibg=#2c2c2c guifg=#ffa0ff
highlight WarningMsg    gui=bold guibg=#2c2c2c guifg=#ffa0ff
highlight ModeMsg       gui=bold guibg=#2c2c2c guifg=#40f0d0
highlight MoreMsg       gui=bold guibg=#2c2c2c guifg=#00ffff
highlight Question      gui=bold guibg=#2c2c2c guifg=#e8e800

" Split area
if &laststatus == 0
  " Disable StatusLine highlights
  highlight StatusLine    gui=NONE guibg=#1c1c1c guifg=#aaaaaa
  highlight StatusLineNC  gui=NONE guibg=#1c1c1c guifg=#1c1c1c
else
  highlight StatusLine    gui=bold guibg=#c8c8d8 guifg=#151505
  highlight StatusLineNC  gui=reverse guibg=#c8c8d8 guifg=#151505
endif
highlight VertSplit     gui=NONE guibg=#1c1c1c guifg=#1c1c1c
highlight WildMenu      gui=NONE guibg=#a0a0ff guifg=#252525

" Diff
highlight DiffAdd       gui=NONE guibg=#0020a0 guifg=#a0d0ff
highlight DiffChange    gui=NONE guibg=#401830 guifg=#e03870
highlight DiffDelete    gui=NONE guibg=#0020a0 guifg=#a0d0ff
highlight DiffText      gui=NONE guibg=#802860 guifg=#ff78f0

" Cursor
highlight Cursor        gui=NONE guibg=#606060 guifg=fg
highlight CursorLine    gui=NONE guibg=#444444 guifg=fg
highlight lCursor       gui=NONE guibg=#80403f guifg=fg
highlight CursorIM      gui=NONE guibg=#bb00aa guifg=fg

" Fold
highlight Folded        gui=NONE guibg=#106090 guifg=#40f0f0
highlight FoldColumn    gui=NONE guibg=#2c2c2c guifg=#40c0ff

" Syntax group
highlight Comment       gui=NONE guibg=#2c2c2c guifg=#c7c7f9
highlight Constant      gui=NONE guibg=#2c2c2c guifg=#90d0ff
highlight Error         gui=bold guibg=#2c2c2c guifg=#ffa0af
highlight Identifier    gui=NONE guifg=#40f0f0 guibg=#2c2c2c
highlight Ignore        gui=NONE guibg=#2c2c2c guifg=#2c2c2c
highlight PreProc       gui=NONE guibg=#2c2c2c guifg=#40f0a0
highlight Special       gui=NONE guibg=#2c2c2c guifg=#e0e080
highlight Statement     gui=NONE guibg=#2c2c2c guifg=#ffa0ff
highlight Todo          gui=bold,underline guibg=#2c2c2c guifg=#ffa0a0
highlight Type          gui=NONE guibg=#2c2c2c guifg=#ffc864
highlight Underlined    gui=underline guibg=#2c2c2c guifg=#f0f0f8
highlight CursorColumn  gui=NONE guibg=#666666 guifg=fg
highlight CursorLineNr  gui=bold guibg=bg guifg=#ffff00

" HTML
highlight htmlLink      gui=underline guibg=bg guifg=fg
highlight htmlBold      gui=bold guibg=bg guifg=fg
highlight htmlBoldItalic gui=bold,italic guibg=bg guifg=fg
highlight htmlBoldUnderline gui=bold,underline guibg=bg guifg=fg
highlight htmlBoldUnderlineItalic gui=bold,italic,underline guibg=bg guifg=fg
highlight htmlItalic gui=italic guibg=bg guifg=fg
highlight htmlUnderline gui=underline guibg=bg guifg=fg
highlight htmlUnderlineItalic gui=italic,underline guibg=bg guifg=fg

" Menu
highlight Pmenu         gui=NONE guibg=#606060 guifg=fg
highlight PmenuSel      gui=NONE guibg=#1f82cd guifg=#dddd00
highlight PmenuSbar     gui=NONE guibg=#d6d6d6 guifg=fg
highlight PmenuThumb    gui=NONE guibg=#ffffff guifg=#3cac3c

" Tab
highlight TablineSel    gui=NONE guibg=#0060c0 guifg=#f0f0f8
highlight Tabline       gui=NONE guibg=#c8c8d8 guifg=#252525
highlight TablineFill   gui=NONE guibg=#c8c8d8 guifg=#252525

" Others
highlight Directory     gui=NONE guibg=#2c2c2c guifg=#40f0d0
highlight LineNr        gui=NONE guibg=#2c2c2c guifg=#a0b0c0
highlight NonText       gui=bold guibg=#2c2c2c guifg=#4080ff
highlight SpecialKey    gui=bold guibg=#2c2c2c guifg=#8080ff
highlight Title         gui=bold guibg=#2c2c2c guifg=#f0f0f8
highlight Visual        gui=NONE guibg=#707080 guifg=#e0e0f0
highlight VisualNOS     gui=bold,underline guibg=bg guifg=fg
highlight ColorColumn   gui=NONE guibg=#444444 guifg=fg
highlight SignColumn    gui=NONE guibg=#2c2c2c guifg=fg
highlight MatchParen    gui=NONE guibg=#008b8b guifg=fg
highlight SpellBad      gui=undercurl guibg=bg guifg=fg guisp=#ff0000
highlight SpellCap      gui=undercurl guibg=bg guifg=fg guisp=#0000ff
highlight SpellRare     gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
highlight SpellLocal    gui=undercurl guibg=bg guifg=fg guisp=#00ffff
highlight Conceal       gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
highlight EndOfBuffer   gui=NONE guifg=#101010

if has('nvim')
  highlight TermCursor   gui=NONE guibg=#cc22a0
  highlight TermCursorNC gui=NONE guibg=#666666
  highlight NormalNC     gui=NONE guibg=#2c2c2c guifg=#bfbfbf
  highlight WhiteSpace   gui=NONE guifg=#999999
endif
