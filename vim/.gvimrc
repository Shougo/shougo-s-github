"---------------------------------------------------------------------------
" Fonts:"{{{
"
if has('win32') || has('win64')
  " For Windows.

  "set guifontwide=VL\ Gothic:h11
  "set guifontwide=MigMix\ 1M:h11
  set guifontwide=Ricty:h12

  set guifont=Ricty:h12
  "set guifont=Anonymous\ Pro:h11
  "set guifont=Courier\ New:h11
  "set guifont=MS\ Gothic:h11
  "set guifont=VL\ Gothic:h11
  "set guifont=Consolas:h12
  "set guifont=Bitstream\ Vera\ Sans\ Mono:h11
  "set guifont=Inconsolata:h12
  "set guifont=Terminal:h10:cSHIFTJIS

  " Number of pixel lines inserted between characters.
  set linespace=2

  " Toggle font setting.
  function! FontToggle()
    if &guifont=~ '^VL Gothic:'
      set guifont=Courier\ New:h11
      set guifontwide=VL\ Gothic:h11

      " Width of window.
      set columns=155
      " Height of window.
      set lines=50
    else
      set guifont=VL\ Gothic:h11.5
      set guifontwide=

      " Width of window.
      set columns=200
      " Height of window.
      set lines=43
    endif
  endfunction

  nnoremap TF     :<C-u>call FontToggle()<CR>

  if has('kaoriya')
    " For Kaoriya only.
    set ambiwidth=auto
  endif
elseif has('mac')
  " For Mac.
  set guifont=Osaka－等幅:h14
else
  " For Linux.
  set guifontwide=VL\ Gothic\ 11
  set guifont=Courier\ 10\ Pitch\ 11
endif
"}}}

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
  command! TransparencyToggle let &transparency = (&transparency != 255 && &transparency != 0)? 255 : 221
  nnoremap TT     :<C-u>TransparencyToggle<CR>
else
  " Width of window.
  set columns=151
  " Height of window.
  set lines=41
endif

" Save the setting of window.
let g:save_window_file = expand('~/.vimwinpos')
augroup SaveWindow
  autocmd!
  autocmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let options = [
          \ 'set columns=' . &columns,
          \ 'set lines=' . &lines,
          \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
          \ ]
    call writefile(options, g:save_window_file)
  endfunction
augroup END

if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif

" Setting of colorscheme.
" Don't override colorscheme.
if !exists('g:colors_name')
  colorscheme candy
endif
"}}}

"---------------------------------------------------------------------------
" Input Japanese:"{{{
" For Linux
if (has('multi_byte_ime') || has('xim')) && has('GUI_GTK')
  " To use ATOK X3.
  "let $GTK_IM_MODULE='xim'
  "set imactivatekey=S-space

  " Disable uim when use skk.vim.
  " let &imdisable=1

  " To use uim-anthy.
  "let $GTK_IM_MODULE='uim-anthy'
  "set imactivatekey=C-space

  " To use ibus-mozc.
  " let $GTK_IM_MODULE='xim'
  " set imactivatekey=S-space
endif
"}}}

"---------------------------------------------------------------------------
" Mouse:"{{{
"
" Show popup menu if right click.
set mousemodel=popup

" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide

"}}}

"---------------------------------------------------------------------------
" Menu:"{{{
"

" Hide toolbar and menus.
set guioptions-=T
set guioptions-=m
" Scrollbar is always off.
set guioptions-=rL
" Not guitablabel.
set guioptions-=e

" fullscreen
"-----------------------------------------------------------
nnoremap <silent> <F11> :<C-u>call <SID>toggle_full_secreen()<CR>
function! s:toggle_full_secreen()
  if &guioptions =~# 'C'
    set guioptions-=C
    if exists('s:go_temp')
      if s:go_temp =~# 'm'
        set guioptions+=m
      endif
      if s:go_temp =~# 'T'
        set guioptions+=T
      endif
    endif
    if has('win32') || has('win64')
      simalt ~r
    endif

    let [&lines, &columns] = [s:lines_save, s:columns_save]
  else
    let s:go_temp = &guioptions
    set guioptions+=C
    set guioptions-=m
    set guioptions-=T
    if has('win32') || has('win64')
      simalt ~x
    endif

    let [s:lines_save, s:columns_save] = [&lines, &columns]

    set columns=999
    set lines=999
  endif
endfunction

" Confirm without window.
set guioptions+=c

if has('kaoriya')
  " For Kaoriya only.
  "set guioptions+=C
endif
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

"---------------------------------------------------------------------------
" Platform depends:"{{{
"
if has('win32') || has('win64') 
  " For Windows
else
  " For Linux

  "set shell=/bin/bash
  " Use zsh.
  set shell=zsh
endif
"}}}

"---------------------------------------------------------------------------
" Others::
"

