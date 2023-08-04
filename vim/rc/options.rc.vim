"---------------------------------------------------------------------------
" Base:
"

" Build encodings.
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,euc-jp,cp932

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif

set packpath=


"---------------------------------------------------------------------------
" Search:
"

" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
set incsearch
" Don't highlight search result.
set nohlsearch

" Searches wrap around the end of the file.
set wrapscan


"---------------------------------------------------------------------------
" Edit:
"

" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" Substitute <Tab> with blanks.
" set tabstop=8
" Spaces instead <Tab>.
" set softtabstop=4
" Autoindent width.
set shiftwidth=4
" Round indent by shiftwidth.
set shiftround

" Enable smart indent.
set autoindent smartindent

" Disable modeline.
set modelines=2
set nomodeline

" Enable backspace delete indent and newline.
set backspace=indent,eol,nostop

" Highlight <>.
set matchpairs+=<:>

" Display another buffer when current buffer isn't saved.
set hidden

" Disable folding.
set nofoldenable
set foldmethod=manual
" Show folding level.
if has('nvim')
  set foldcolumn=auto:1
else
  set foldcolumn=1
endif
set fillchars=vert:\|
set commentstring=%s

" Use vimgrep.
" set grepprg=internal
" Use grep.
set grepprg=grep\ -inH

set isfname-==
set isfname+=@-@

" Better for <C-w> deletion
autocmd MyAutoCmd CmdlineEnter *
      \ : let s:save_iskeyword = &l:iskeyword
      \ | setlocal iskeyword+=.
      \ | setlocal iskeyword+=-
autocmd MyAutoCmd CmdlineLeave *
      \ let &l:iskeyword = s:save_iskeyword

" Keymapping timeout.
set timeout timeoutlen=500 ttimeoutlen=100

" CursorHold time.
set updatetime=1000

" Set swap directory.
set directory-=.

" Set undofile.
set undofile
let &g:undodir = &directory

" Enable virtualedit in visual block mode.
set virtualedit=block

" Set keyword help.
set keywordprg=:help

" Disable paste.
autocmd MyAutoCmd InsertLeave *
      \ : if &paste
      \ |   setlocal nopaste
      \ |   echo 'nopaste'
      \ | endif
      \ | if &l:diff
      \ |   diffupdate
      \ | endif

" Update diff.
autocmd MyAutoCmd InsertLeave *
      \ : if &l:diff
      \ |   diffupdate
      \ | endif

set diffopt=internal,algorithm:patience,indent-heuristic

" Make directory automatically.
autocmd MyAutoCmd BufWritePre *
      \ call s:mkdir_as_necessary('<afile>:p:h'->expand(), v:cmdbang)
function s:mkdir_as_necessary(dir, force) abort
  if a:dir->isdirectory() || &l:buftype !=# ''
    return
  endif

  const message = printf('"%s" does not exist. Create? [y/N] ', a:dir)
  if a:force || message->input() =~? '^y\%[es]$'
    call mkdir(a:dir->iconv(&encoding, &termencoding), 'p')
  endif
endfunction

" Use autofmt.
set formatexpr=autofmt#japanese#formatexpr()

" If true Vim master, use English help file.
set helplang& helplang=en,ja

set spelllang+=cjk
set spelloptions+=camel

" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac

" Disable editorconfig
let g:editorconfig = v:false


"---------------------------------------------------------------------------
" View:
"

" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

" Show <TAB> and <CR>
set list
if has('win32')
   set listchars=tab:>-,trail:-,precedes:<
else
   set listchars=tab:▸\ ,trail:-,precedes:«,nbsp:%
endif

" Disable statusline when command line
"autocmd MyAutoCmd CmdlineEnter * set laststatus=0 | redrawstatus
"autocmd MyAutoCmd CmdlineLeave * set laststatus=2

" Does not report lines
set report=1000

" Disable statusline.
set statusline=%{'─'->repeat(winwidth(0))}

" NOTE: wrap option is very slow!
set nowrap
" Turn down a long line appointed in 'breakat'
set linebreak
set showbreak=\
set breakat=\ \	;:,!?
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
set breakindent

" Don't create backup.
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

" Disable bell.
set t_vb=
set novisualbell
set belloff=all

" Display candidates by popup menu.
set wildmenu
set wildmode=full
if has('patch-8.2.4463')
  set wildoptions+=fuzzy
endif
" Use default command line completion by <C-t>
set wildchar=<C-t>
set wildcharm=<C-t>

" Display candidates by list.
"set nowildmenu
"set wildmode=list:longest,full

" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
" Can supplement a tag in a command-line.
set wildoptions+=tagfile
" Complete all candidates
set wildignorecase

" Increase history amount.
set history=200
if has('nvim')
  set shada='100,<20,s10,h,r/tmp/,rterm:
else
  set viminfo='100,<20,s10,h,r/tmp/
endif

" Disable menu
let g:did_install_default_menus = v:true

" Completion setting.
set completeopt=menuone
if '+completepopup'->exists()
  set completeopt+=popup
  set completepopup=height:4,width:60,highlight:InfoPopup
endif
" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=5
" Set popup menu min width.
set pumwidth=0
" Use "/" for path completion
set completeslash=slash

" Use nvim-lsp as omnifunc
if has('nvim')
  set omnifunc=v:lua.vim.lsp.omnifunc
endif

" Maintain a current line at the time of movement as much as possible.
set nostartofline

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
" set winheight=20
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways
if '+splitscroll'->exists()
  " Disable scroll when split
  set nosplitscroll
endif

" Adjust window size of preview and help.
set previewheight=8
set helpheight=12

set ttyfast

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
set display+=uhex

" For conceal.
set conceallevel=2

set colorcolumn=79

if '+previewpopup'->exists()
  set previewpopup=height:10,width:60
endif

" Disable signcolumn
set signcolumn=no

" Command line window
"set cedit=
exe "set cedit=\<C-s>"

set redrawtime=0

" I use <C-w> in terminal mode
if '+termwinkey'->exists()
  set termwinkey=<C-L>
endif

if '+smoothscroll'->exists()
  set smoothscroll
endif

" Disable builtin message pager
set nomore
