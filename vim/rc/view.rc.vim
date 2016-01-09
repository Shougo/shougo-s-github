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
setglobal list
if IsWindows()
  setglobal listchars=tab:>-,trail:-,extends:>,precedes:<
else
  setglobal listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
endif
" Always display statusline.
setglobal laststatus=2
" Height of command line.
setglobal cmdheight=2
" Not show command on statusline.
setglobal noshowcmd
" Show title.
setglobal title
" Title length.
setglobal titlelen=95
" Title string.
let &g:titlestring="
      \ %{expand('%:p:~:.')}%(%m%r%w%)
      \ %<\(%{".s:SID_PREFIX()."strwidthpart(
      \ fnamemodify(&filetype ==# 'vimfiler' ?
      \ substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),
      \ &columns-len(expand('%:p:.:~')))}\) - VIM"
" Disable tabline.
setglobal showtabline=0

" Set statusline.
let &g:statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
      \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
      \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
      \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?
      \ '['.(&filetype!=''?&filetype.',':'')"
      \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
      \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"

" Turn down a long line appointed in 'breakat'
setglobal linebreak
setglobal showbreak=\
setglobal breakat=\ \	;:,!?
" Wrap conditions.
setglobal whichwrap+=h,l,<,>,[,],b,s,~
if exists('+breakindent')
  setglobal breakindent
  setglobal wrap
else
  setglobal nowrap
endif

" Do not display greetings message at the time of Vim start.
setglobal shortmess=aTI

" Don't create backup.
setglobal nowritebackup
setglobal nobackup
setglobal noswapfile
setglobal backupdir-=.

" Disable bell.
setglobal t_vb=
setglobal novisualbell

" Display candidate supplement.
setglobal nowildmenu
setglobal wildmode=list:longest,full
" Increase history amount.
setglobal history=1000
" Display all the information of the tag by the supplement of the Insert mode.
setglobal showfulltag
" Can supplement a tag in a command-line.
setglobal wildoptions=tagfile

" Disable menu
let g:did_install_default_menus = 1

if !&verbose
  " Enable spell check.
  setglobal spelllang=en_us
  " Enable CJK support.
  setglobal spelllang+=cjk
endif

" Completion setting.
setglobal completeopt=menuone
" Don't complete from other buffer.
setglobal complete=.
"set complete=.,w,b,i,t
" Set popup menu max height.
setglobal pumheight=20

" Report changes.
setglobal report=0

" Maintain a current line at the time of movement as much as possible.
setglobal nostartofline

" Splitting a window will put the new window below the current one.
setglobal splitbelow
" Splitting a window will put the new window right the current one.
setglobal splitright
" Set minimal width for current window.
setglobal winwidth=30
" Set minimal height for current window.
" set winheight=20
setglobal winheight=1
" Set maximam maximam command line window.
setglobal cmdwinheight=5
" No equal window size.
setglobal noequalalways

" Adjust window size of preview and help.
setglobal previewheight=8
setglobal helpheight=12

setglobal ttyfast

" When a line is long, do not omit it in @.
setglobal display=lastline
" Display an invisible letter with hex format.
"set display+=uhex

" View setting.
setglobal viewdir=$CACHE/vim_view viewoptions-=options viewoptions+=slash,unix

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
  setglobal conceallevel=2 concealcursor=niv

  setglobal colorcolumn=79

  " Use builtin function.
  function! s:wcswidth(str)
    return strwidth(a:str)
  endfunction
else
  function! s:wcswidth(str)
    return len(a:str)
  endfunction
endif
