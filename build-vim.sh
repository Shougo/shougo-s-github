#!/bin/sh

./configure \
--with-features=huge \
--with-compiledby="Shougo" \
--enable-multibyte \
--enable-gui=gtk3 \
--enable-python3interp \
--enable-gpm \
--enable-cscope \
--enable-fontset \
--enable-terminal \
--enable-fail-if-missing
