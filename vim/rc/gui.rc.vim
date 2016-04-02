"---------------------------------------------------------------------------
" GUI:
"

"---------------------------------------------------------------------------
" Fonts: "{{{
set ambiwidth=double

if has('win32') || has('win64')
  " For Windows.

  " set guifontwide=VL\ Gothic:h11
   set guifontwide=Ricty:h12

   set guifont=Ricty:h12
  " set guifont=Anonymous\ Pro:h11
  " set guifont=Courier\ New:h11
  " set guifont=MS\ Gothic:h11
  " set guifont=VL\ Gothic:h11
  " set guifont=Consolas:h12
  " set guifont=Bitstream\ Vera\ Sans\ Mono:h11
  " set guifont=Inconsolata:h12
  " set guifont=Terminal:h10:cSHIFTJIS

  " Number of pixel lines inserted between characters.
   set linespace=2

  if has('patch-7.4.394')
    " Use DirectWrite
     "set renderoptions=type:directx
  endif

  if has('kaoriya')
    " For Kaoriya only.
     set ambiwidth=auto
  endif
elseif has('mac')
  " For Mac.
   set guifont=Osaka－等幅:h14
else
  " For Linux.
   set guifontwide=VL\ Gothic\ 13
   set guifont=Courier\ 10\ Pitch\ 14
endif"}}}

"---------------------------------------------------------------------------
" Window:"{{{
"
if has('win32') || has('win64')
  " Width of window.
   set columns=230
  " Height of window.
   set lines=55

  " Set transparency.
  "autocmd GuiEnter * set transparency=221
  " Toggle font setting.
  command! TransparencyToggle let &transparency =
        \ (&transparency != 255 && &transparency != 0)? 255 : 221
  nnoremap TT     :<C-u>TransparencyToggle<CR>
else
  if &columns < 170
    " Width of window.
     set columns=170
  endif
  if &lines < 40
    " Height of window.
     set lines=40
  endif
endif

" Don't override colorscheme.
if !exists('g:colors_name')
  colorscheme candy
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
set mouse=
set mousemodel=

" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide
"}}}

"---------------------------------------------------------------------------
" Menu:"{{{
"

" Hide toolbar and menus.
set guioptions-=Tt
set guioptions-=m
" Scrollbar is always off.
set guioptions-=rL
" Not guitablabel.
set guioptions-=e

" Confirm without window.
set guioptions+=c
"}}}

"---------------------------------------------------------------------------
" Views:"{{{
"
" Don't highlight search result.
set nohlsearch

" Don't flick cursor.
set guicursor&
set guicursor+=a:blinkon0
"}}}

" vim: foldmethod=marker
