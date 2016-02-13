"---------------------------------------------------------------------------
" Edit:
"

" Smart insert tab setting.
SetFixer set smarttab
" Exchange tab to spaces.
SetFixer set expandtab
" Substitute <Tab> with blanks.
"SetFixer set tabstop=8
" Spaces instead <Tab>.
"SetFixer set softtabstop=4
" Autoindent width.
"SetFixer set shiftwidth=4
" Round indent by shiftwidth.
SetFixer set shiftround

" Enable modeline.
SetFixer set modeline

" Use clipboard register.
if has('unnamedplus')
  SetFixer set clipboard& clipboard+=unnamedplus
else
  SetFixer set clipboard& clipboard+=unnamed
endif

" Enable backspace delete indent and newline.
SetFixer set backspace=indent,eol,start

" Highlight parenthesis.
SetFixer set showmatch
" Highlight when CursorMoved.
SetFixer set cpoptions-=m
SetFixer set matchtime=1
" Highlight <>.
SetFixer set matchpairs+=<:>

" Display another buffer when current buffer isn't saved.
SetFixer set hidden

" Auto reload if file is changed.
"SetFixer set autoread

" Ignore case on insert completion.
SetFixer set infercase

" Search home directory path on cd.
" But can't complete.
" SetFixer set cdpath+=~

" Enable folding.
SetFixer set foldenable
" set foldmethod=expr
SetFixer set foldmethod=marker
" Show folding level.
SetFixer set foldcolumn=1
SetFixer set fillchars=vert:\|
SetFixer set commentstring=%s

if exists('*FoldCCtext')
  " Use FoldCCtext().
  SetFixer set foldtext=FoldCCtext()
endif

" Use vimgrep.
"SetFixer set grepprg=internal
" Use grep.
SetFixer set grepprg=grep\ -inH

" Exclude = from isfilename.
SetFixer set isfname-==

" Keymapping timeout.
SetFixer set timeout timeoutlen=3000 ttimeoutlen=100

" CursorHold time.
SetFixer set updatetime=1000

" Set swap directory.
SetFixer set directory-=.

if v:version >= 703
  " Set undofile.
  SetFixer set undofile
  let &g:undodir=&directory
endif

if v:version < 703 || (v:version == 7.3 && !has('patch336'))
  " Vim's bug.
  SetFixer set notagbsearch
endif

" Enable virtualedit in visual block mode.
SetFixer set virtualedit=block

" Set keyword help.
SetFixer set keywordprg=:help

" Check timestamp more for 'autoread'.
autocmd MyAutoCmd WinEnter * checktime

" Disable paste.
autocmd MyAutoCmd InsertLeave *
      \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
      \ if &l:diff | diffupdate | endif

" Update diff.
autocmd MyAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" Make directory automatically.
" --------------------------------------
" http://vim-users.jp/2011/02/hack202/

autocmd MyAutoCmd BufWritePre *
      \ call s:mkdir_as_necessary(expand('<afile>:p:h'), v:cmdbang)
function! s:mkdir_as_necessary(dir, force) abort
  if !isdirectory(a:dir) && &l:buftype == '' &&
        \ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
        \              a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

" Use autofmt.
SetFixer set formatexpr=autofmt#japanese#formatexpr()

" Use blowfish2
" https://dgl.cx/2014/10/vim-blowfish
if has('cryptv')
  " It seems 15ms overhead.
  " SetFixer set cryptmethod=blowfish2
endif
