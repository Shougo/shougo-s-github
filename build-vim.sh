#!/bin/sh

./configure \
--with-features=huge \
--with-compiledby="Shougo" \
--enable-multibyte \
--enable-gui=gtk3 \
--enable-python3interp \
--enable-luainterp \
--with-lua-prefix=/usr --with-luajit \
--enable-gpm \
--enable-cscope \
--enable-fontset \
--enable-terminal \
--enable-fail-if-missing
