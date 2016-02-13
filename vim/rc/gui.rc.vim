"---------------------------------------------------------------------------
" GUI:
"

"---------------------------------------------------------------------------
" Fonts: "{{{
SetFixer set ambiwidth=double

if has('win32') || has('win64')
  " For Windows.

  "SetFixer set guifontwide=VL\ Gothic:h11
  SetFixer set guifontwide=Ricty:h12

  SetFixer set guifont=Ricty:h12
  "SetFixer set guifont=Anonymous\ Pro:h11
  "SetFixer set guifont=Courier\ New:h11
  "SetFixer set guifont=MS\ Gothic:h11
  "SetFixer set guifont=VL\ Gothic:h11
  "SetFixer set guifont=Consolas:h12
  "SetFixer set guifont=Bitstream\ Vera\ Sans\ Mono:h11
  "SetFixer set guifont=Inconsolata:h12
  "SetFixer set guifont=Terminal:h10:cSHIFTJIS

  " Number of pixel lines inserted between characters.
  SetFixer set linespace=2

  if has('patch-7.4.394')
    " Use DirectWrite
    SetFixer set renderoptions=type:directx,gammma:2.2,mode:3
  endif

  if has('kaoriya')
    " For Kaoriya only.
    SetFixer set ambiwidth=auto
  endif
elseif has('mac')
  " For Mac.
  SetFixer set guifont=Osaka－等幅:h14
else
  " For Linux.
  SetFixer set guifontwide=VL\ Gothic\ 13
  SetFixer set guifont=Courier\ 10\ Pitch\ 14
endif"}}}

"---------------------------------------------------------------------------
" Window:"{{{
"
if has('win32') || has('win64')
  " Width of window.
  SetFixer set columns=230
  " Height of window.
  SetFixer set lines=55

  " Set transparency.
  "autocmd GuiEnter * set transparency=221
  " Toggle font setting.
  command! TransparencyToggle let &transparency =
        \ (&transparency != 255 && &transparency != 0)? 255 : 221
  nnoremap TT     :<C-u>TransparencyToggle<CR>
else
  if &columns < 170
    " Width of window.
    SetFixer set columns=170
  endif
  if &lines < 40
    " Height of window.
    SetFixer set lines=40
  endif
endif

" Don't override colorscheme.
if !exists('g:colors_name')
  execute 'colorscheme' globpath(&runtimepath,
        \ 'colors/candy.vim') != '' ? 'candy' : 'desert'
endif
"}}}

"---------------------------------------------------------------------------
" Input Japanese:"{{{
" For Linux
if (has('multi_byte_ime') || has('xim')) && has('GUI_GTK')
  " Disable uim when use skk.vim.
  let &imdisable=1

  " To use uim-anthy.
  "let $GTK_IM_MODULE='uim-anthy'
  "set imactivatekey=C-space

  " To use ibus-mozc/fcitx.
  let $GTK_IM_MODULE='xim'
endif
"}}}

"---------------------------------------------------------------------------
" Mouse:"{{{
"
SetFixer set mouse=
SetFixer set mousemodel=

" Don't focus the window when the mouse pointer is moved.
SetFixer set nomousefocus
" Hide mouse pointer on insert mode.
SetFixer set mousehide
"}}}

"---------------------------------------------------------------------------
" Menu:"{{{
"

" Hide toolbar and menus.
SetFixer set guioptions-=Tt
SetFixer set guioptions-=m
" Scrollbar is always off.
SetFixer set guioptions-=rL
" Not guitablabel.
SetFixer set guioptions-=e

" Confirm without window.
SetFixer set guioptions+=c
"}}}

"---------------------------------------------------------------------------
" Views:"{{{
"
" Don't highlight search result.
SetFixer set nohlsearch

" Don't flick cursor.
SetFixer set guicursor&
SetFixer set guicursor+=a:blinkon0
"}}}

" vim: foldmethod=marker
