"=============================================================================
" FILE: candy.vim
" Maintainer: Tiza
" Changed: Shougo Matsushita
" Last Change: 14 Jul 2011.
"     version: 2.3
" This color scheme uses a dark background.
"-----------------------------------------------------------------------------
" ChangeLog: "{{{
"   2.4:
"     - Improved cursor line.
"     - Improved tabline.
"
"   2.3:
"     - Documentation revised.
"     - Changed diff color.
""}}}
"=============================================================================

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name="candy"

hi Normal       guifg=#dfdfdf guibg=#2c2c2c

" Search
hi IncSearch    gui=UNDERLINE guifg=#80ffff guibg=#0060c0
hi Search       gui=NONE guifg=#f0f0f8 guibg=#0060c0

" Messages
hi ErrorMsg     gui=BOLD guifg=#ffa0ff guibg=#2c2c2c
hi WarningMsg   gui=BOLD guifg=#ffa0ff guibg=#2c2c2c
hi ModeMsg      gui=BOLD guifg=#40f0d0 guibg=#2c2c2c
hi MoreMsg      gui=BOLD guifg=#00ffff guibg=#2c2c2c
hi Question     gui=BOLD guifg=#e8e800 guibg=#2c2c2c

" Split area
hi StatusLine   gui=BOLD guifg=#151505 guibg=#c8c8d8
"hi StatusLineNC gui=NONE guifg=#808090 guibg=#c8c8d8
hi StatusLineNC gui=REVERSE guifg=#151505 guibg=#c8c8d8
hi VertSplit    gui=NONE guifg=#606080 guibg=#c8c8d8
hi WildMenu     gui=NONE guifg=#252525 guibg=#a0a0ff

" Diff
hi DiffText     gui=NONE guifg=#ff78f0 guibg=#802860
hi DiffChange   gui=NONE guifg=#e03870 guibg=#401830
hi DiffDelete   gui=NONE guifg=#a0d0ff guibg=#0020a0
hi DiffAdd      gui=NONE guifg=#a0d0ff guibg=#0020a0

" Cursor
hi Cursor       gui=NONE guifg=#00ffff guibg=#008070
hi CursorLine   gui=NONE guifg=NONE    guibg=#555555
hi lCursor      gui=NONE guifg=NONE guibg=#80403f
hi CursorIM     gui=NONE guifg=NONE guibg=#bb00aa

" Fold
hi Folded       gui=NONE guifg=#40f0f0 guibg=#106090
hi FoldColumn   gui=NONE guifg=#40c0ff guibg=#10406c

" Other
hi Directory    gui=NONE guifg=#40f0d0 guibg=#2c2c2c
hi LineNr       gui=NONE guifg=#c0c0c0 guibg=#2c2c2c
hi NonText      gui=BOLD guifg=#4080ff guibg=#2c2c2c
hi SpecialKey   gui=BOLD guifg=#8080ff guibg=#2c2c2c
hi Title        gui=BOLD guifg=#f0f0f8 guibg=#2c2c2c
hi Visual       gui=NONE guifg=#e0e0f0 guibg=#707080

" Syntax group
hi Comment      gui=NONE guifg=#c7c7f9 guibg=#2c2c2c
hi Constant     gui=NONE guifg=#90d0ff guibg=#2c2c2c
hi Error        gui=BOLD guifg=#ffa0af guibg=#2c2c2c
hi Identifier   gui=NONE guifg=#40f0f0 guibg=#2c2c2c
hi Ignore       gui=NONE guifg=#2c2c2c guibg=#2c2c2c
hi PreProc      gui=NONE guifg=#40f0a0 guibg=#2c2c2c
hi Special      gui=NONE guifg=#e0e080 guibg=#2c2c2c
hi Statement    gui=NONE guifg=#ffa0ff guibg=#2c2c2c
hi Todo         gui=BOLD,UNDERLINE guifg=#ffa0a0 guibg=#2c2c2c
hi Type         gui=NONE guifg=#ffc864 guibg=#2c2c2c
hi Underlined   gui=UNDERLINE guifg=#f0f0f8 guibg=#2c2c2c
hi ColorColumn  gui=NONE guifg=NONE guibg=#444444

" HTML
hi htmlLink                 gui=UNDERLINE
hi htmlBold                 gui=BOLD
hi htmlBoldItalic           gui=BOLD,ITALIC
hi htmlBoldUnderline        gui=BOLD,UNDERLINE
hi htmlBoldUnderlineItalic  gui=BOLD,UNDERLINE,ITALIC
hi htmlItalic               gui=ITALIC
hi htmlUnderline            gui=UNDERLINE
hi htmlUnderlineItalic      gui=UNDERLINE,ITALIC

" Menu
hi Pmenu                    guibg=#606060
hi PmenuSel                 guifg=#dddd00 guibg=#1f82cd
hi PmenuSbar                guibg=#d6d6d6
hi PmenuThumb               guifg=#3cac3c

" Tab
hi TablineSel               gui=NONE guifg=#f0f0f8 guibg=#0060c0
hi Tabline                  gui=NONE guifg=#252525 guibg=#c8c8d8
hi TablineFill              gui=NONE guifg=#252525 guibg=#c8c8d8
