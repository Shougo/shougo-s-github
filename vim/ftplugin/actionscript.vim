" Vim filetype plugin file
" Language:	ActionScript
" Maintainer: Phil Peron (pperon AT gmail DOT com)
" Last Change: July 20, 2007

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

if exists('&ofu')
  setlocal ofu=actionscriptcomplete#Complete
endif
