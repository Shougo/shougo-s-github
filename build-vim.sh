#!/bin/sh

#CFLAGS='-g -O0' CPPFLAGS='-I/usr/include/python3.3m -I/usr/include/i386-linux-gnu/python3.3m' \
#CPPFLAGS='-I/usr/include/python3.3m -I/usr/include/i386-linux-gnu/python3.3m' \
./configure \
--with-features=huge \
--with-compiledby="Shougo" \
--enable-multibyte \
--enable-gui=gtk2 \
--enable-rubyinterp \
--enable-python3interp \
--with-python3-config-dir=/usr/lib/python3.3/config-3.3m-i386-linux-gnu \
--enable-luainterp \
--with-lua-prefix=/usr --with-luajit \
--enable-gpm \
--enable-cscope \
--enable-fontset \
--enable-termtruecolor \
--enable-fail-if-missing
