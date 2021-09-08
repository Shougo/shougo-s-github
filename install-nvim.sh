#!/bin/sh

make install

# Remove default plugins
if [ -d /usr/local/share/nvim/runtime/plugin ]; then
    rm /usr/local/share/nvim/runtime/plugin/gzip.vim
    rm /usr/local/share/nvim/runtime/plugin/health.vim
    rm /usr/local/share/nvim/runtime/plugin/man.vim
    rm /usr/local/share/nvim/runtime/plugin/matchit.vim
    rm /usr/local/share/nvim/runtime/plugin/matchparen.vim
    rm /usr/local/share/nvim/runtime/plugin/netrwPlugin.vim
    rm /usr/local/share/nvim/runtime/plugin/shada.vim
    rm /usr/local/share/nvim/runtime/plugin/spellfile.vim
    rm /usr/local/share/nvim/runtime/plugin/tarPlugin.vim
    rm /usr/local/share/nvim/runtime/plugin/tohtml.vim
    rm /usr/local/share/nvim/runtime/plugin/tutor.vim
    rm /usr/local/share/nvim/runtime/plugin/zipPlugin.vim
fi
if [ -f /usr/local/share/nvim/runtime/ftplugin.vim ]; then
    rm /usr/local/share/nvim/runtime/ftplugin.vim
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
