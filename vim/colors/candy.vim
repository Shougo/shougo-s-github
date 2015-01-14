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

highlight Normal       gui=NONE guifg=#dfdfdf guibg=#2c2c2c

" Search
highlight IncSearch    gui=UNDERLINE guifg=#80ffff guibg=#0060c0
highlight Search       gui=NONE guifg=#f0f0f8 guibg=#0060c0

" Messages
highlight ErrorMsg     gui=BOLD guifg=#ffa0ff guibg=#2c2c2c
highlight WarningMsg   gui=BOLD guifg=#ffa0ff guibg=#2c2c2c
highlight ModeMsg      gui=BOLD guifg=#40f0d0 guibg=#2c2c2c
highlight MoreMsg      gui=BOLD guifg=#00ffff guibg=#2c2c2c
highlight Question     gui=BOLD guifg=#e8e800 guibg=#2c2c2c

" Split area
highlight StatusLine   gui=BOLD guifg=#151505 guibg=#c8c8d8
highlight StatusLineNC gui=REVERSE guifg=#151505 guibg=#c8c8d8
highlight VertSplit    gui=NONE guifg=#606080 guibg=#2c2c2c
highlight WildMenu     gui=NONE guifg=#252525 guibg=#a0a0ff

" Diff
highlight DiffText     gui=NONE guifg=#ff78f0 guibg=#802860
highlight DiffChange   gui=NONE guifg=#e03870 guibg=#401830
highlight DiffDelete   gui=NONE guifg=#a0d0ff guibg=#0020a0
highlight DiffAdd      gui=NONE guifg=#a0d0ff guibg=#0020a0

" Cursor
highlight Cursor       gui=NONE guifg=NONE guibg=#606060
highlight CursorLine   gui=NONE guifg=NONE guibg=#444444
highlight lCursor      gui=NONE guifg=NONE guibg=#80403f
highlight CursorIM     gui=NONE guifg=NONE guibg=#bb00aa

" Fold
highlight Folded       gui=NONE guifg=#40f0f0 guibg=#106090
highlight FoldColumn   gui=NONE guifg=#40c0ff guibg=#2c2c2c

" Other
highlight Directory    gui=NONE guifg=#40f0d0 guibg=#2c2c2c
highlight LineNr       gui=NONE guifg=#a0b0c0 guibg=#2c2c2c
highlight NonText      gui=BOLD guifg=#4080ff guibg=#2c2c2c
highlight SpecialKey   gui=BOLD guifg=#8080ff guibg=#2c2c2c
highlight Title        gui=BOLD guifg=#f0f0f8 guibg=#2c2c2c
highlight Visual       gui=NONE guifg=#e0e0f0 guibg=#707080
highlight ColorColumn  gui=NONE guifg=NONE    guibg=#444444
highlight SignColumn   gui=NONE guifg=NONE    guibg=#2c2c2c

" Syntax group
highlight Comment      gui=NONE guifg=#c7c7f9 guibg=#2c2c2c
highlight Constant     gui=NONE guifg=#90d0ff guibg=#2c2c2c
highlight Error        gui=BOLD guifg=#ffa0af guibg=#2c2c2c
highlight Identifier   gui=NONE guifg=#40f0f0 guibg=#2c2c2c
highlight Ignore       gui=NONE guifg=#2c2c2c guibg=#2c2c2c
highlight PreProc      gui=NONE guifg=#40f0a0 guibg=#2c2c2c
highlight Special      gui=NONE guifg=#e0e080 guibg=#2c2c2c
highlight Statement    gui=NONE guifg=#ffa0ff guibg=#2c2c2c
highlight Todo         gui=BOLD,UNDERLINE guifg=#ffa0a0 guibg=#2c2c2c
highlight Type         gui=NONE guifg=#ffc864 guibg=#2c2c2c
highlight Underlined   gui=UNDERLINE guifg=#f0f0f8 guibg=#2c2c2c

" HTML
highlight htmlLink                 gui=UNDERLINE
highlight htmlBold                 gui=BOLD
highlight htmlBoldItalic           gui=BOLD,ITALIC
highlight htmlBoldUnderline        gui=BOLD,UNDERLINE
highlight htmlBoldUnderlineItalic  gui=BOLD,UNDERLINE,ITALIC
highlight htmlItalic               gui=ITALIC
highlight htmlUnderline            gui=UNDERLINE
highlight htmlUnderlineItalic      gui=UNDERLINE,ITALIC

" Menu
highlight Pmenu                    guibg=#606060
highlight PmenuSel                 guifg=#dddd00 guibg=#1f82cd
highlight PmenuSbar                guibg=#d6d6d6
highlight PmenuThumb               guifg=#3cac3c

" Tab
highlight TablineSel               gui=NONE guifg=#f0f0f8 guibg=#0060c0
highlight Tabline                  gui=NONE guifg=#252525 guibg=#c8c8d8
highlight TablineFill              gui=NONE guifg=#252525 guibg=#c8c8d8
