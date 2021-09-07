#!/bin/sh

make install

# Remove default plugins
if [ -d /usr/local/share/nvim/runtime/plugin ]; then
    rm -Rf /usr/local/share/nvim/runtime/plugin
fi
if [ -d /usr/share/vim/vimfiles/plugin ]; then
    rm -Rf /usr/share/vim/vimfiles/plugin
fi
if [ -f /etc/xdg/nvim/sysinit.vim ]; then
    rm /etc/xdg/nvim/sysinit.vim
fi
if [ -f /usr/share/nvim/archlinux.vim ]; then
    rm /usr/share/nvim/archlinux.vim
fi
