#!/bin/sh

./configure \
--with-features=huge \
--with-compiledby="Shougo" \
--enable-autoservername \
--enable-multibyte \
--enable-gui=gtk4 \
--enable-python3interp \
--enable-gpm \
--enable-cscope \
--enable-terminal \
--enable-fail-if-missing
