"---------------------------------------------------------------------------
" View:
"

" Anywhere SID.
function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Show line number.
"set number
" Show <TAB> and <CR>
SetFixer set list
if IsWindows()
  SetFixer set listchars=tab:>-,trail:-,extends:>,precedes:<
else
  SetFixer set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
endif
" Always display statusline.
SetFixer set laststatus=2
" Height of command line.
SetFixer set cmdheight=2
" Not show command on statusline.
SetFixer set noshowcmd
" Show title.
SetFixer set title
" Title length.
SetFixer set titlelen=95
" Title string.
let &g:titlestring="
      \ %{expand('%:p:~:.')}%(%m%r%w%)
      \ %<\(%{".s:SID_PREFIX()."strwidthpart(
      \ fnamemodify(&filetype ==# 'vimfiler' ?
      \ substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),
      \ &columns-len(expand('%:p:.:~')))}\) - VIM"
" Disable tabline.
SetFixer set showtabline=0

" Set statusline.
let &g:statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
      \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
      \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
      \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?
      \ '['.(&filetype!=''?&filetype.',':'')"
      \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
      \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"

" Turn down a long line appointed in 'breakat'
SetFixer set linebreak
SetFixer set showbreak=\
SetFixer set breakat=\ \	;:,!?
" Wrap conditions.
SetFixer set whichwrap+=h,l,<,>,[,],b,s,~
if exists('+breakindent')
  SetFixer set breakindent
  SetFixer set wrap
else
  SetFixer set nowrap
endif

" Do not display greetings message at the time of Vim start.
SetFixer set shortmess=aTI

" Don't create backup.
SetFixer set nowritebackup
SetFixer set nobackup
SetFixer set noswapfile
SetFixer set backupdir-=.

" Disable bell.
SetFixer set t_vb=
SetFixer set novisualbell

" Display candidate supplement.
SetFixer set nowildmenu
SetFixer set wildmode=list:longest,full
" Increase history amount.
SetFixer set history=1000
" Display all the information of the tag by the supplement of the Insert mode.
SetFixer set showfulltag
" Can supplement a tag in a command-line.
SetFixer set wildoptions=tagfile

" Disable menu
let g:did_install_default_menus = 1

if !&verbose
  " Enable spell check.
  SetFixer set spelllang=en_us
  " Enable CJK support.
  SetFixer set spelllang+=cjk
endif

" Completion setting.
SetFixer set completeopt=menuone
" Don't complete from other buffer.
SetFixer set complete=.
"set complete=.,w,b,i,t
" Set popup menu max height.
SetFixer set pumheight=20

" Report changes.
SetFixer set report=0

" Maintain a current line at the time of movement as much as possible.
SetFixer set nostartofline

" Splitting a window will put the new window below the current one.
SetFixer set splitbelow
" Splitting a window will put the new window right the current one.
SetFixer set splitright
" Set minimal width for current window.
SetFixer set winwidth=30
" Set minimal height for current window.
" set winheight=20
SetFixer set winheight=1
" Set maximam maximam command line window.
SetFixer set cmdwinheight=5
" No equal window size.
SetFixer set noequalalways

" Adjust window size of preview and help.
SetFixer set previewheight=8
SetFixer set helpheight=12

SetFixer set ttyfast

" When a line is long, do not omit it in @.
SetFixer set display=lastline
" Display an invisible letter with hex format.
"set display+=uhex

" View setting.
SetFixer set viewdir=$CACHE/vim_view viewoptions-=options viewoptions+=slash,unix

function! s:strwidthpart(str, width) abort "{{{
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = s:wcswidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= s:wcswidth(char)
  endwhile

  return ret
endfunction"}}}

if v:version >= 703
  " For conceal.
  SetFixer set conceallevel=2 concealcursor=niv

  SetFixer set colorcolumn=79

  " Use builtin function.
  function! s:wcswidth(str) abort
    return strwidth(a:str)
  endfunction
else
  function! s:wcswidth(str) abort
    return len(a:str)
  endfunction
endif
