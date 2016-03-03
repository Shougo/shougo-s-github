" This scheme was created by CSApproxSnapshot
" on Fri, 04 Mar 2016

hi clear
if exists("syntax_on")
    syntax reset
endif

if v:version < 700
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" substitute(substitute(<q-args>, "undercurl", "underline", "g"), "guisp\\S\\+", "", "g")
else
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" <q-args>
endif

function! s:old_kde()
  " Konsole only used its own palette up til KDE 4.2.0
  if executable('kde4-config') && system('kde4-config --kde-version') =~ '^4.[10].'
    return 1
  elseif executable('kde-config') && system('kde-config --version') =~# 'KDE: 3.'
    return 1
  else
    return 0
  endif
endfunction

if 0
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
    CSAHi Normal term=NONE cterm=NONE ctermbg=236 ctermfg=253 gui=NONE guibg=#2c2c2c guifg=#dfdfdf
    CSAHi Identifier term=NONE cterm=NONE ctermbg=236 ctermfg=87 gui=NONE guibg=#2c2c2c guifg=#40f0f0
    CSAHi Ignore term=NONE cterm=NONE ctermbg=236 ctermfg=236 gui=NONE guibg=#2c2c2c guifg=#2c2c2c
    CSAHi PreProc term=NONE cterm=NONE ctermbg=236 ctermfg=85 gui=NONE guibg=#2c2c2c guifg=#40f0a0
    CSAHi Special term=NONE cterm=NONE ctermbg=236 ctermfg=187 gui=NONE guibg=#2c2c2c guifg=#e0e080
    CSAHi Statement term=NONE cterm=NONE ctermbg=236 ctermfg=219 gui=NONE guibg=#2c2c2c guifg=#ffa0ff
    CSAHi Todo term=NONE cterm=bold,underline ctermbg=236 ctermfg=217 gui=bold,underline guibg=#2c2c2c guifg=#ffa0a0
    CSAHi Type term=NONE cterm=NONE ctermbg=236 ctermfg=222 gui=NONE guibg=#2c2c2c guifg=#ffc864
    CSAHi Underlined term=NONE cterm=underline ctermbg=236 ctermfg=231 gui=underline guibg=#2c2c2c guifg=#f0f0f8
    CSAHi htmlLink term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlBold term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi SpecialKey term=bold cterm=bold ctermbg=236 ctermfg=147 gui=bold guibg=#2c2c2c guifg=#8080ff
    CSAHi NonText term=bold cterm=bold ctermbg=236 ctermfg=75 gui=bold guibg=#2c2c2c guifg=#4080ff
    CSAHi Directory term=bold cterm=NONE ctermbg=236 ctermfg=86 gui=NONE guibg=#2c2c2c guifg=#40f0d0
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=236 ctermfg=219 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi IncSearch term=reverse cterm=underline ctermbg=32 ctermfg=159 gui=underline guibg=#0060c0 guifg=#80ffff
    CSAHi Search term=reverse cterm=NONE ctermbg=32 ctermfg=231 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi MoreMsg term=bold cterm=bold ctermbg=236 ctermfg=51 gui=bold guibg=#2c2c2c guifg=#00ffff
    CSAHi ModeMsg term=bold cterm=bold ctermbg=236 ctermfg=86 gui=bold guibg=#2c2c2c guifg=#40f0d0
    CSAHi LineNr term=underline cterm=NONE ctermbg=236 ctermfg=146 gui=NONE guibg=#2c2c2c guifg=#a0b0c0
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=74 ctermfg=184 gui=NONE guibg=#1f82cd guifg=#dddd00
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=253 ctermfg=fg gui=NONE guibg=#d6d6d6 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=231 ctermfg=71 gui=NONE guibg=#ffffff guifg=#3cac3c
    CSAHi TabLine term=underline cterm=NONE ctermbg=188 ctermfg=235 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi TabLineSel term=bold cterm=NONE ctermbg=32 ctermfg=231 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=188 ctermfg=235 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=102 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi htmlBoldItalic term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold,italic guibg=bg guifg=fg
    CSAHi htmlBoldUnderline term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi htmlBoldUnderlineItalic term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,italic,underline guibg=bg guifg=fg
    CSAHi htmlItalic term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=italic guibg=bg guifg=fg
    CSAHi htmlUnderline term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlUnderlineItalic term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=italic,underline guibg=bg guifg=fg
    CSAHi CursorLineNr term=bold cterm=bold ctermbg=bg ctermfg=226 gui=bold guibg=bg guifg=#ffff00
    CSAHi Question term=NONE cterm=bold ctermbg=236 ctermfg=226 gui=bold guibg=#2c2c2c guifg=#e8e800
    CSAHi StatusLine term=bold,reverse cterm=bold ctermbg=188 ctermfg=16 gui=bold guibg=#c8c8d8 guifg=#151505
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=16 ctermfg=188 gui=reverse guibg=#c8c8d8 guifg=#151505
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=236 ctermfg=103 gui=NONE guibg=#2c2c2c guifg=#606080
    CSAHi Title term=bold cterm=bold ctermbg=236 ctermfg=231 gui=bold guibg=#2c2c2c guifg=#f0f0f8
    CSAHi Visual term=reverse cterm=NONE ctermbg=103 ctermfg=189 gui=NONE guibg=#707080 guifg=#e0e0f0
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=236 ctermfg=219 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=147 ctermfg=235 gui=NONE guibg=#a0a0ff guifg=#252525
    CSAHi CursorLine term=underline cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=131 ctermfg=fg gui=NONE guibg=#80403f guifg=fg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=163 ctermfg=fg gui=NONE guibg=#bb00aa guifg=fg
    CSAHi Comment term=NONE cterm=NONE ctermbg=236 ctermfg=189 gui=NONE guibg=#2c2c2c guifg=#c7c7f9
    CSAHi Constant term=NONE cterm=NONE ctermbg=236 ctermfg=153 gui=NONE guibg=#2c2c2c guifg=#90d0ff
    CSAHi Error term=NONE cterm=bold ctermbg=236 ctermfg=217 gui=bold guibg=#2c2c2c guifg=#ffa0af
    CSAHi Folded term=NONE cterm=NONE ctermbg=31 ctermfg=87 gui=NONE guibg=#106090 guifg=#40f0f0
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=81 gui=NONE guibg=#2c2c2c guifg=#40c0ff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=25 ctermfg=153 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffChange term=bold cterm=NONE ctermbg=53 ctermfg=168 gui=NONE guibg=#401830 guifg=#e03870
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=25 ctermfg=153 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffText term=reverse cterm=NONE ctermbg=132 ctermfg=213 gui=NONE guibg=#802860 guifg=#ff78f0
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2c2c2c guifg=fg
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#0000ff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=59 ctermfg=253 gui=NONE guibg=#2c2c2c guifg=#dfdfdf
    CSAHi Identifier term=NONE cterm=NONE ctermbg=59 ctermfg=123 gui=NONE guibg=#2c2c2c guifg=#40f0f0
    CSAHi Ignore term=NONE cterm=NONE ctermbg=59 ctermfg=59 gui=NONE guibg=#2c2c2c guifg=#2c2c2c
    CSAHi PreProc term=NONE cterm=NONE ctermbg=59 ctermfg=122 gui=NONE guibg=#2c2c2c guifg=#40f0a0
    CSAHi Special term=NONE cterm=NONE ctermbg=59 ctermfg=229 gui=NONE guibg=#2c2c2c guifg=#e0e080
    CSAHi Statement term=NONE cterm=NONE ctermbg=59 ctermfg=225 gui=NONE guibg=#2c2c2c guifg=#ffa0ff
    CSAHi Todo term=NONE cterm=bold,underline ctermbg=59 ctermfg=224 gui=bold,underline guibg=#2c2c2c guifg=#ffa0a0
    CSAHi Type term=NONE cterm=NONE ctermbg=59 ctermfg=228 gui=NONE guibg=#2c2c2c guifg=#ffc864
    CSAHi Underlined term=NONE cterm=underline ctermbg=59 ctermfg=255 gui=underline guibg=#2c2c2c guifg=#f0f0f8
    CSAHi htmlLink term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlBold term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi SpecialKey term=bold cterm=bold ctermbg=59 ctermfg=147 gui=bold guibg=#2c2c2c guifg=#8080ff
    CSAHi NonText term=bold cterm=bold ctermbg=59 ctermfg=111 gui=bold guibg=#2c2c2c guifg=#4080ff
    CSAHi Directory term=bold cterm=NONE ctermbg=59 ctermfg=123 gui=NONE guibg=#2c2c2c guifg=#40f0d0
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=59 ctermfg=225 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi IncSearch term=reverse cterm=underline ctermbg=33 ctermfg=159 gui=underline guibg=#0060c0 guifg=#80ffff
    CSAHi Search term=reverse cterm=NONE ctermbg=33 ctermfg=255 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi MoreMsg term=bold cterm=bold ctermbg=59 ctermfg=51 gui=bold guibg=#2c2c2c guifg=#00ffff
    CSAHi ModeMsg term=bold cterm=bold ctermbg=59 ctermfg=123 gui=bold guibg=#2c2c2c guifg=#40f0d0
    CSAHi LineNr term=underline cterm=NONE ctermbg=59 ctermfg=189 gui=NONE guibg=#2c2c2c guifg=#a0b0c0
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=75 ctermfg=226 gui=NONE guibg=#1f82cd guifg=#dddd00
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=231 ctermfg=fg gui=NONE guibg=#d6d6d6 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=255 ctermfg=77 gui=NONE guibg=#ffffff guifg=#3cac3c
    CSAHi TabLine term=underline cterm=NONE ctermbg=231 ctermfg=235 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi TabLineSel term=bold cterm=NONE ctermbg=33 ctermfg=255 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=231 ctermfg=235 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi htmlBoldItalic term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold,italic guibg=bg guifg=fg
    CSAHi htmlBoldUnderline term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi htmlBoldUnderlineItalic term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,italic,underline guibg=bg guifg=fg
    CSAHi htmlItalic term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=italic guibg=bg guifg=fg
    CSAHi htmlUnderline term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlUnderlineItalic term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=italic,underline guibg=bg guifg=fg
    CSAHi CursorLineNr term=bold cterm=bold ctermbg=bg ctermfg=226 gui=bold guibg=bg guifg=#ffff00
    CSAHi Question term=NONE cterm=bold ctermbg=59 ctermfg=226 gui=bold guibg=#2c2c2c guifg=#e8e800
    CSAHi StatusLine term=bold,reverse cterm=bold ctermbg=231 ctermfg=16 gui=bold guibg=#c8c8d8 guifg=#151505
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=16 ctermfg=231 gui=reverse guibg=#c8c8d8 guifg=#151505
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=59 ctermfg=103 gui=NONE guibg=#2c2c2c guifg=#606080
    CSAHi Title term=bold cterm=bold ctermbg=59 ctermfg=255 gui=bold guibg=#2c2c2c guifg=#f0f0f8
    CSAHi Visual term=reverse cterm=NONE ctermbg=145 ctermfg=231 gui=NONE guibg=#707080 guifg=#e0e0f0
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=59 ctermfg=225 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=189 ctermfg=235 gui=NONE guibg=#a0a0ff guifg=#252525
    CSAHi CursorLine term=underline cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=137 ctermfg=fg gui=NONE guibg=#80403f guifg=fg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=164 ctermfg=fg gui=NONE guibg=#bb00aa guifg=fg
    CSAHi Comment term=NONE cterm=NONE ctermbg=59 ctermfg=231 gui=NONE guibg=#2c2c2c guifg=#c7c7f9
    CSAHi Constant term=NONE cterm=NONE ctermbg=59 ctermfg=159 gui=NONE guibg=#2c2c2c guifg=#90d0ff
    CSAHi Error term=NONE cterm=bold ctermbg=59 ctermfg=224 gui=bold guibg=#2c2c2c guifg=#ffa0af
    CSAHi Folded term=NONE cterm=NONE ctermbg=31 ctermfg=123 gui=NONE guibg=#106090 guifg=#40f0f0
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=59 ctermfg=123 gui=NONE guibg=#2c2c2c guifg=#40c0ff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=26 ctermfg=195 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffChange term=bold cterm=NONE ctermbg=95 ctermfg=205 gui=NONE guibg=#401830 guifg=#e03870
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=26 ctermfg=195 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffText term=reverse cterm=NONE ctermbg=132 ctermfg=219 gui=NONE guibg=#802860 guifg=#ff78f0
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=59 ctermfg=fg gui=NONE guibg=#2c2c2c guifg=fg
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=231 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#0000ff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=236 ctermfg=253 gui=NONE guibg=#2c2c2c guifg=#dfdfdf
    CSAHi Identifier term=NONE cterm=NONE ctermbg=236 ctermfg=87 gui=NONE guibg=#2c2c2c guifg=#40f0f0
    CSAHi Ignore term=NONE cterm=NONE ctermbg=236 ctermfg=236 gui=NONE guibg=#2c2c2c guifg=#2c2c2c
    CSAHi PreProc term=NONE cterm=NONE ctermbg=236 ctermfg=85 gui=NONE guibg=#2c2c2c guifg=#40f0a0
    CSAHi Special term=NONE cterm=NONE ctermbg=236 ctermfg=186 gui=NONE guibg=#2c2c2c guifg=#e0e080
    CSAHi Statement term=NONE cterm=NONE ctermbg=236 ctermfg=219 gui=NONE guibg=#2c2c2c guifg=#ffa0ff
    CSAHi Todo term=NONE cterm=bold,underline ctermbg=236 ctermfg=217 gui=bold,underline guibg=#2c2c2c guifg=#ffa0a0
    CSAHi Type term=NONE cterm=NONE ctermbg=236 ctermfg=221 gui=NONE guibg=#2c2c2c guifg=#ffc864
    CSAHi Underlined term=NONE cterm=underline ctermbg=236 ctermfg=231 gui=underline guibg=#2c2c2c guifg=#f0f0f8
    CSAHi htmlLink term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlBold term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi SpecialKey term=bold cterm=bold ctermbg=236 ctermfg=105 gui=bold guibg=#2c2c2c guifg=#8080ff
    CSAHi NonText term=bold cterm=bold ctermbg=236 ctermfg=69 gui=bold guibg=#2c2c2c guifg=#4080ff
    CSAHi Directory term=bold cterm=NONE ctermbg=236 ctermfg=86 gui=NONE guibg=#2c2c2c guifg=#40f0d0
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=236 ctermfg=219 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi IncSearch term=reverse cterm=underline ctermbg=25 ctermfg=123 gui=underline guibg=#0060c0 guifg=#80ffff
    CSAHi Search term=reverse cterm=NONE ctermbg=25 ctermfg=231 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi MoreMsg term=bold cterm=bold ctermbg=236 ctermfg=51 gui=bold guibg=#2c2c2c guifg=#00ffff
    CSAHi ModeMsg term=bold cterm=bold ctermbg=236 ctermfg=86 gui=bold guibg=#2c2c2c guifg=#40f0d0
    CSAHi LineNr term=underline cterm=NONE ctermbg=236 ctermfg=145 gui=NONE guibg=#2c2c2c guifg=#a0b0c0
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=59 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=32 ctermfg=184 gui=NONE guibg=#1f82cd guifg=#dddd00
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=188 ctermfg=fg gui=NONE guibg=#d6d6d6 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=231 ctermfg=71 gui=NONE guibg=#ffffff guifg=#3cac3c
    CSAHi TabLine term=underline cterm=NONE ctermbg=188 ctermfg=235 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi TabLineSel term=bold cterm=NONE ctermbg=25 ctermfg=231 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=188 ctermfg=235 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi htmlBoldItalic term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold,italic guibg=bg guifg=fg
    CSAHi htmlBoldUnderline term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi htmlBoldUnderlineItalic term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,italic,underline guibg=bg guifg=fg
    CSAHi htmlItalic term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=italic guibg=bg guifg=fg
    CSAHi htmlUnderline term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlUnderlineItalic term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=italic,underline guibg=bg guifg=fg
    CSAHi CursorLineNr term=bold cterm=bold ctermbg=bg ctermfg=226 gui=bold guibg=bg guifg=#ffff00
    CSAHi Question term=NONE cterm=bold ctermbg=236 ctermfg=184 gui=bold guibg=#2c2c2c guifg=#e8e800
    CSAHi StatusLine term=bold,reverse cterm=bold ctermbg=188 ctermfg=16 gui=bold guibg=#c8c8d8 guifg=#151505
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=16 ctermfg=188 gui=reverse guibg=#c8c8d8 guifg=#151505
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=236 ctermfg=60 gui=NONE guibg=#2c2c2c guifg=#606080
    CSAHi Title term=bold cterm=bold ctermbg=236 ctermfg=231 gui=bold guibg=#2c2c2c guifg=#f0f0f8
    CSAHi Visual term=reverse cterm=NONE ctermbg=60 ctermfg=189 gui=NONE guibg=#707080 guifg=#e0e0f0
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=236 ctermfg=219 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=147 ctermfg=235 gui=NONE guibg=#a0a0ff guifg=#252525
    CSAHi CursorLine term=underline cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=59 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=95 ctermfg=fg gui=NONE guibg=#80403f guifg=fg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=127 ctermfg=fg gui=NONE guibg=#bb00aa guifg=fg
    CSAHi Comment term=NONE cterm=NONE ctermbg=236 ctermfg=189 gui=NONE guibg=#2c2c2c guifg=#c7c7f9
    CSAHi Constant term=NONE cterm=NONE ctermbg=236 ctermfg=117 gui=NONE guibg=#2c2c2c guifg=#90d0ff
    CSAHi Error term=NONE cterm=bold ctermbg=236 ctermfg=217 gui=bold guibg=#2c2c2c guifg=#ffa0af
    CSAHi Folded term=NONE cterm=NONE ctermbg=24 ctermfg=87 gui=NONE guibg=#106090 guifg=#40f0f0
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=75 gui=NONE guibg=#2c2c2c guifg=#40c0ff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=19 ctermfg=153 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffChange term=bold cterm=NONE ctermbg=53 ctermfg=167 gui=NONE guibg=#401830 guifg=#e03870
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=19 ctermfg=153 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffText term=reverse cterm=NONE ctermbg=89 ctermfg=213 gui=NONE guibg=#802860 guifg=#ff78f0
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2c2c2c guifg=fg
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#0000ff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=80 ctermfg=87 gui=NONE guibg=#2c2c2c guifg=#dfdfdf
    CSAHi Identifier term=NONE cterm=NONE ctermbg=80 ctermfg=31 gui=NONE guibg=#2c2c2c guifg=#40f0f0
    CSAHi Ignore term=NONE cterm=NONE ctermbg=80 ctermfg=80 gui=NONE guibg=#2c2c2c guifg=#2c2c2c
    CSAHi PreProc term=NONE cterm=NONE ctermbg=80 ctermfg=29 gui=NONE guibg=#2c2c2c guifg=#40f0a0
    CSAHi Special term=NONE cterm=NONE ctermbg=80 ctermfg=57 gui=NONE guibg=#2c2c2c guifg=#e0e080
    CSAHi Statement term=NONE cterm=NONE ctermbg=80 ctermfg=71 gui=NONE guibg=#2c2c2c guifg=#ffa0ff
    CSAHi Todo term=NONE cterm=bold,underline ctermbg=80 ctermfg=69 gui=bold,underline guibg=#2c2c2c guifg=#ffa0a0
    CSAHi Type term=NONE cterm=NONE ctermbg=80 ctermfg=73 gui=NONE guibg=#2c2c2c guifg=#ffc864
    CSAHi Underlined term=NONE cterm=underline ctermbg=80 ctermfg=79 gui=underline guibg=#2c2c2c guifg=#f0f0f8
    CSAHi htmlLink term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlBold term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi SpecialKey term=bold cterm=bold ctermbg=80 ctermfg=39 gui=bold guibg=#2c2c2c guifg=#8080ff
    CSAHi NonText term=bold cterm=bold ctermbg=80 ctermfg=23 gui=bold guibg=#2c2c2c guifg=#4080ff
    CSAHi Directory term=bold cterm=NONE ctermbg=80 ctermfg=30 gui=NONE guibg=#2c2c2c guifg=#40f0d0
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=80 ctermfg=71 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi IncSearch term=reverse cterm=underline ctermbg=22 ctermfg=47 gui=underline guibg=#0060c0 guifg=#80ffff
    CSAHi Search term=reverse cterm=NONE ctermbg=22 ctermfg=79 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi MoreMsg term=bold cterm=bold ctermbg=80 ctermfg=31 gui=bold guibg=#2c2c2c guifg=#00ffff
    CSAHi ModeMsg term=bold cterm=bold ctermbg=80 ctermfg=30 gui=bold guibg=#2c2c2c guifg=#40f0d0
    CSAHi LineNr term=underline cterm=NONE ctermbg=80 ctermfg=42 gui=NONE guibg=#2c2c2c guifg=#a0b0c0
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=22 ctermfg=56 gui=NONE guibg=#1f82cd guifg=#dddd00
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=86 ctermfg=fg gui=NONE guibg=#d6d6d6 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=79 ctermfg=20 gui=NONE guibg=#ffffff guifg=#3cac3c
    CSAHi TabLine term=underline cterm=NONE ctermbg=58 ctermfg=80 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi TabLineSel term=bold cterm=NONE ctermbg=22 ctermfg=79 gui=NONE guibg=#0060c0 guifg=#f0f0f8
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=58 ctermfg=80 gui=NONE guibg=#c8c8d8 guifg=#252525
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi htmlBoldItalic term=NONE cterm=bold ctermbg=bg ctermfg=fg gui=bold,italic guibg=bg guifg=fg
    CSAHi htmlBoldUnderline term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi htmlBoldUnderlineItalic term=NONE cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,italic,underline guibg=bg guifg=fg
    CSAHi htmlItalic term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=italic guibg=bg guifg=fg
    CSAHi htmlUnderline term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=underline guibg=bg guifg=fg
    CSAHi htmlUnderlineItalic term=NONE cterm=underline ctermbg=bg ctermfg=fg gui=italic,underline guibg=bg guifg=fg
    CSAHi CursorLineNr term=bold cterm=bold ctermbg=bg ctermfg=76 gui=bold guibg=bg guifg=#ffff00
    CSAHi Question term=NONE cterm=bold ctermbg=80 ctermfg=76 gui=bold guibg=#2c2c2c guifg=#e8e800
    CSAHi StatusLine term=bold,reverse cterm=bold ctermbg=58 ctermfg=16 gui=bold guibg=#c8c8d8 guifg=#151505
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=16 ctermfg=58 gui=reverse guibg=#c8c8d8 guifg=#151505
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=80 ctermfg=37 gui=NONE guibg=#2c2c2c guifg=#606080
    CSAHi Title term=bold cterm=bold ctermbg=80 ctermfg=79 gui=bold guibg=#2c2c2c guifg=#f0f0f8
    CSAHi Visual term=reverse cterm=NONE ctermbg=37 ctermfg=87 gui=NONE guibg=#707080 guifg=#e0e0f0
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=80 ctermfg=71 gui=bold guibg=#2c2c2c guifg=#ffa0ff
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=39 ctermfg=80 gui=NONE guibg=#a0a0ff guifg=#252525
    CSAHi CursorLine term=underline cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#606060 guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=32 ctermfg=fg gui=NONE guibg=#80403f guifg=fg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=21 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=49 ctermfg=fg gui=NONE guibg=#bb00aa guifg=fg
    CSAHi Comment term=NONE cterm=NONE ctermbg=80 ctermfg=59 gui=NONE guibg=#2c2c2c guifg=#c7c7f9
    CSAHi Constant term=NONE cterm=NONE ctermbg=80 ctermfg=43 gui=NONE guibg=#2c2c2c guifg=#90d0ff
    CSAHi Error term=NONE cterm=bold ctermbg=80 ctermfg=70 gui=bold guibg=#2c2c2c guifg=#ffa0af
    CSAHi Folded term=NONE cterm=NONE ctermbg=21 ctermfg=31 gui=NONE guibg=#106090 guifg=#40f0f0
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=80 ctermfg=27 gui=NONE guibg=#2c2c2c guifg=#40c0ff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=17 ctermfg=43 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffChange term=bold cterm=NONE ctermbg=80 ctermfg=49 gui=NONE guibg=#401830 guifg=#e03870
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=17 ctermfg=43 gui=NONE guibg=#0020a0 guifg=#a0d0ff
    CSAHi DiffText term=reverse cterm=NONE ctermbg=33 ctermfg=71 gui=NONE guibg=#802860 guifg=#ff78f0
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#2c2c2c guifg=fg
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg guisp=#0000ff
endif

if 1
    delcommand CSAHi
endif
