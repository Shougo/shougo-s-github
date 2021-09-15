if exists('g:fvim_loaded')
  " For fvim
  " https://github.com/yatli/fvim
  if g:fvim_os == 'windows' || g:fvim_render_scale > 1.0
    set guifont=Iosevka\ Slab:h14
  else
    set guifont=VL\ Gothic:h20
  endif

  " Font tweaks
  FVimFontAntialias v:true
  FVimFontAutohint v:true
  FVimFontHintLevel 'full'
  FVimFontLigature v:true
  FVimFontLineHeight '+1.0' " can be 'default', '14.0', '-1.0' etc.
  FVimFontSubpixel v:true
else
  GuiFont! Courier\ 10\ Pitch:h14
endif

" For neovim-gtk
" https://github.com/daa84/neovim-gtk
if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
  call rpcnotify(1, 'Gui', 'Option', 'Cmdline', 0)
  call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)

  " Enable transparency
  NGTransparency 1.0

  call rpcnotify(1, 'Gui', 'Font', 'DejaVu Sans Mono 15')
endif
