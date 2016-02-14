"---------------------------------------------------------------------------
" Initialize:
"

if exists('&regexpengine')
  " Use old regexp engine.
  " SetFixer set regexpengine=1
endif

" Use English interface.
if IsWindows()
  " For Windows.
  language message en
else
  " For Linux.
  language message C
endif

" Use ',' instead of '\'.
" Use <Leader> in global plugin.
let g:mapleader = ','
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = 'm'

" Release keymappings for plug-in.
nnoremap ;  <Nop>
xnoremap ;  <Nop>
nnoremap m  <Nop>
xnoremap m  <Nop>
nnoremap ,  <Nop>
xnoremap ,  <Nop>

if IsWindows()
  " Exchange path separator.
  SetFixer set shellslash
endif

let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

if filereadable(expand('~/.secret_vimrc'))
  execute 'source' expand('~/.secret_vimrc')
endif

" Set runtimepath."{{{
if IsWindows()
  let &runtimepath = join([
        \ expand('~/.vim'),
        \ expand('$VIM/runtime'),
        \ expand('~/.vim/after')], ',')
endif

" Load dein.
let s:dein_dir = finddir('dein.vim', '.;')
if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
  if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
    let s:dein_dir = expand('$CACHE/dein').'/dein.vim'

    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif

  execute 'SetFixer set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
endif

"profile start profile.txt
"profile func dein#*
"}}}


"---------------------------------------------------------------------------
" Disable default plugins

" Disable menu.vim
if has('gui_running')
  SetFixer set guioptions=Mc
endif

let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_matchparen = 1
