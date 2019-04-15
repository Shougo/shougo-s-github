GuiFont Courier\ 10\ Pitch:h14

" For neovim-gtk
" https://github.com/daa84/neovim-gtk
if exists('g:GtkGuiLoaded')
  " Disable external tabline
  call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
  " Enable external cmdline
  call rpcnotify(1, 'Gui', 'Option', 'Cmdline', 1)

  " Enable transparency
  NGTransparency 1.0
endif

" For gonvim
set pumblend=30
