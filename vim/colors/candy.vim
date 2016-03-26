"=============================================================================
" FILE: candy.vim
" Maintainer: Tiza
"             Shougo Matsushita
" This color scheme uses a dark background.
"=============================================================================

set background=dark
highlight clear

if exists('syntax_on')
  syntax reset
endif

let colors_name = 'candy'

highlight Normal       term=NONE cterm=NONE ctermbg=236 ctermfg=253
      \ gui=NONE guibg=#2c2c2c guifg=#dfdfdf

" Search
highlight IncSearch    term=reverse cterm=underline ctermbg=32 ctermfg=159
      \ gui=underline guibg=#0060c0 guifg=#80ffff
highlight Search       term=reverse cterm=NONE ctermbg=32 ctermfg=231
      \ gui=NONE guibg=#0060c0 guifg=#f0f0f8

" Messages
highlight ErrorMsg     term=NONE cterm=bold ctermbg=236 ctermfg=219
      \ gui=bold guibg=#2c2c2c guifg=#ffa0ff
highlight WarningMsg   term=NONE cterm=bold ctermbg=236 ctermfg=219
      \ gui=bold guibg=#2c2c2c guifg=#ffa0ff
highlight ModeMsg      term=bold cterm=bold ctermbg=236 ctermfg=86
      \ gui=bold guibg=#2c2c2c guifg=#40f0d0
highlight MoreMsg      term=bold cterm=bold ctermbg=236 ctermfg=51
      \ gui=bold guibg=#2c2c2c guifg=#00ffff
highlight Question     term=NONE cterm=bold ctermbg=236 ctermfg=226
      \ gui=bold guibg=#2c2c2c guifg=#e8e800

" Split area
highlight StatusLine   term=bold,reverse cterm=bold ctermbg=188 ctermfg=16
      \ gui=bold guibg=#c8c8d8 guifg=#151505
highlight StatusLineNC term=reverse cterm=reverse ctermbg=16 ctermfg=188
      \ gui=reverse guibg=#c8c8d8 guifg=#151505
highlight VertSplit    term=reverse cterm=NONE ctermbg=235 ctermfg=235
      \ gui=NONE guibg=#1c1c1c guifg=#1c1c1c
highlight WildMenu     term=NONE cterm=NONE ctermbg=147 ctermfg=235
      \ gui=NONE guibg=#a0a0ff guifg=#252525

" Diff
highlight DiffAdd      term=bold cterm=NONE ctermbg=25 ctermfg=153
      \ gui=NONE guibg=#0020a0 guifg=#a0d0ff
highlight DiffChange   term=bold cterm=NONE ctermbg=53 ctermfg=168
      \ gui=NONE guibg=#401830 guifg=#e03870
highlight DiffDelete   term=bold cterm=NONE ctermbg=25 ctermfg=153
      \ gui=NONE guibg=#0020a0 guifg=#a0d0ff
highlight DiffText     term=reverse cterm=NONE ctermbg=132 ctermfg=213
      \ gui=NONE guibg=#802860 guifg=#ff78f0

" Cursor
highlight Cursor       term=NONE cterm=NONE ctermbg=241 ctermfg=fg
      \ gui=NONE guibg=#606060 guifg=fg
highlight CursorLine   term=underline cterm=NONE ctermbg=238 ctermfg=fg
      \ gui=NONE guibg=#444444 guifg=fg
highlight lCursor      term=NONE cterm=NONE ctermbg=131 ctermfg=fg
      \ gui=NONE guibg=#80403f guifg=fg
highlight CursorIM     term=NONE cterm=NONE ctermbg=163 ctermfg=fg
      \ gui=NONE guibg=#bb00aa guifg=fg

" Fold
highlight Folded       term=NONE cterm=NONE ctermbg=31 ctermfg=87
      \ gui=NONE guibg=#106090 guifg=#40f0f0
highlight FoldColumn   term=NONE cterm=NONE ctermbg=236 ctermfg=81
      \ gui=NONE guibg=#2c2c2c guifg=#40c0ff

" Syntax group
highlight Comment      term=NONE cterm=NONE ctermbg=236 ctermfg=189
      \ gui=NONE guibg=#2c2c2c guifg=#c7c7f9
highlight Constant     term=NONE cterm=NONE ctermbg=236 ctermfg=153
      \ gui=NONE guibg=#2c2c2c guifg=#90d0ff
highlight Error        term=NONE cterm=bold ctermbg=236 ctermfg=217
      \ gui=bold guibg=#2c2c2c guifg=#ffa0af
highlight Identifier   gui=NONE guifg=#40f0f0 guibg=#2c2c2c
highlight Ignore       term=NONE cterm=NONE ctermbg=236 ctermfg=236
      \ gui=NONE guibg=#2c2c2c guifg=#2c2c2c
highlight PreProc      term=NONE cterm=NONE ctermbg=236 ctermfg=85
      \ gui=NONE guibg=#2c2c2c guifg=#40f0a0
highlight Special      term=NONE cterm=NONE ctermbg=236 ctermfg=187
      \ gui=NONE guibg=#2c2c2c guifg=#e0e080
highlight Statement    term=NONE cterm=NONE ctermbg=236 ctermfg=219
      \ gui=NONE guibg=#2c2c2c guifg=#ffa0ff
highlight Todo         term=NONE cterm=bold,underline ctermbg=236 ctermfg=217
      \ gui=bold,underline guibg=#2c2c2c guifg=#ffa0a0
highlight Type         term=NONE cterm=NONE ctermbg=236 ctermfg=222
      \ gui=NONE guibg=#2c2c2c guifg=#ffc864
highlight Underlined   term=NONE cterm=underline ctermbg=236 ctermfg=231
      \ gui=underline guibg=#2c2c2c guifg=#f0f0f8
highlight CursorColumn term=reverse cterm=NONE ctermbg=102 ctermfg=fg
      \ gui=NONE guibg=#666666 guifg=fg
highlight CursorLineNr term=bold cterm=bold ctermbg=bg ctermfg=226
      \ gui=bold guibg=bg guifg=#ffff00

" HTML
highlight htmlLink
      \ term=NONE cterm=underline ctermbg=bg ctermfg=fg
      \ gui=underline guibg=bg guifg=fg
highlight htmlBold
      \ term=NONE cterm=bold ctermbg=bg ctermfg=fg
      \ gui=bold guibg=bg guifg=fg
highlight htmlBoldItalic
      \ term=NONE cterm=bold ctermbg=bg ctermfg=fg
      \ gui=bold,italic guibg=bg guifg=fg
highlight htmlBoldUnderline
      \ term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg
      \ gui=bold,underline guibg=bg guifg=fg
highlight htmlBoldUnderlineItalic
      \ term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg
      \ gui=bold,italic,underline guibg=bg guifg=fg
highlight htmlItalic
      \ term=NONE cterm=NONE ctermbg=bg ctermfg=fg
      \ gui=italic guibg=bg guifg=fg
highlight htmlUnderline
      \ term=NONE cterm=underline ctermbg=bg ctermfg=fg
      \ gui=underline guibg=bg guifg=fg
highlight htmlUnderlineItalic
      \ term=NONE cterm=underline ctermbg=bg ctermfg=fg
      \ gui=italic,underline guibg=bg guifg=fg

" Menu
highlight Pmenu             term=NONE cterm=NONE ctermbg=241 ctermfg=fg
      \ gui=NONE guibg=#606060 guifg=fg
highlight PmenuSel          term=NONE cterm=NONE ctermbg=74 ctermfg=184
      \ gui=NONE guibg=#1f82cd guifg=#dddd00
highlight PmenuSbar         term=NONE cterm=NONE ctermbg=253 ctermfg=fg
      \ gui=NONE guibg=#d6d6d6 guifg=fg
highlight PmenuThumb term=NONE cterm=NONE ctermbg=231 ctermfg=71
      \ gui=NONE guibg=#ffffff guifg=#3cac3c

" Tab
highlight TablineSel        term=bold cterm=NONE ctermbg=32 ctermfg=231
      \ gui=NONE guibg=#0060c0 guifg=#f0f0f8
highlight Tabline           term=underline cterm=NONE ctermbg=188 ctermfg=235
      \ gui=NONE guibg=#c8c8d8 guifg=#252525
highlight TablineFill       term=reverse cterm=NONE ctermbg=188 ctermfg=235
      \ gui=NONE guibg=#c8c8d8 guifg=#252525

" Others
highlight Directory    term=bold cterm=NONE ctermbg=236 ctermfg=86
      \ gui=NONE guibg=#2c2c2c guifg=#40f0d0
highlight LineNr       term=underline cterm=NONE ctermbg=236 ctermfg=146
      \ gui=NONE guibg=#2c2c2c guifg=#a0b0c0
highlight NonText      term=bold cterm=bold ctermbg=236 ctermfg=75
      \ gui=bold guibg=#2c2c2c guifg=#4080ff
highlight SpecialKey   term=bold cterm=bold ctermbg=236 ctermfg=147
      \ gui=bold guibg=#2c2c2c guifg=#8080ff
highlight Title        term=bold cterm=bold ctermbg=236 ctermfg=231
      \ gui=bold guibg=#2c2c2c guifg=#f0f0f8
highlight Visual       term=reverse cterm=NONE ctermbg=103 ctermfg=189
      \ gui=NONE guibg=#707080 guifg=#e0e0f0
highlight VisualNOS
      \ term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg
      \ gui=bold,underline guibg=bg guifg=fg
highlight ColorColumn  term=reverse cterm=NONE ctermbg=238 ctermfg=fg
      \ gui=NONE guibg=#444444 guifg=fg
highlight SignColumn   term=NONE cterm=NONE ctermbg=236 ctermfg=fg
      \ gui=NONE guibg=#2c2c2c guifg=fg
highlight MatchParen   term=reverse cterm=NONE ctermbg=37 ctermfg=fg
      \ gui=NONE guibg=#008b8b guifg=fg
highlight SpellBad     term=reverse cterm=undercurl ctermbg=bg ctermfg=fg
      \ gui=undercurl guibg=bg guifg=fg guisp=#ff0000
highlight SpellCap     term=reverse cterm=undercurl ctermbg=bg ctermfg=fg
      \ gui=undercurl guibg=bg guifg=fg guisp=#0000ff
highlight SpellRare    term=reverse cterm=undercurl ctermbg=bg ctermfg=fg
      \ gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
highlight SpellLocal   term=underline cterm=undercurl ctermbg=bg ctermfg=fg
      \ gui=undercurl guibg=bg guifg=fg guisp=#00ffff
highlight Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252
      \ gui=NONE guibg=#a9a9a9 guifg=#d3d3d3

if has('nvim')
  highlight EndOfBuffer            gui=NONE guifg=#101010
  highlight TermCursor             gui=NONE guibg=#cc22a0
  highlight TermCursorNC           gui=NONE guibg=#666666
endif

