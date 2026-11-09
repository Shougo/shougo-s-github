"---------------------------------------------------------------------------
" Key-mappings:
"

" Use ',' instead of '\'.
" Use <Leader> in global plugin.
let g:mapleader = ','
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = 'm'

" Release keymappings for plug-in.
nnoremap ;  <Nop>
nnoremap m  <Nop>
nnoremap ,  <Nop>

" Use <C-Space>.
nmap <C-Space>  <C-@>
cmap <C-Space>  <C-@>

" Visual mode keymappings:
" Indent
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

if (!has('nvim') || $DISPLAY !=# '') && has('clipboard')
  xnoremap y "*y<Cmd>let [@+,@"]=[@*,@*]<CR>
endif

" Enable undo <C-w> and <C-u>.
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>

" Command-line mode keymappings:
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-g>: Exit.
cnoremap <C-g>          <C-c>
" <C-k>: Delete to the end.
cnoremap <C-k> <Cmd>call setcmdline(
      \ getcmdpos() ==# 1 ? '' : getcmdline()[:getcmdpos() - 2])<CR>

" [Space]: Other useful commands
" Smart space mapping.
nmap  <Space>   [Space]
nnoremap  [Space]   <Nop>

" Set autoread.
nnoremap [Space]ar
      \ <Cmd>call vimrc#toggle_option('autoread')<CR>
" Set spell check.
nnoremap [Space]p
      \ <Cmd>call vimrc#toggle_option('spell')<CR>
      \<Cmd>set spelllang=en_us<CR>
      \<Cmd>set spelllang+=cjk<CR>
nnoremap [Space]w
      \ <Cmd>call vimrc#toggle_option('wrap')<CR>
nnoremap [Space]c
      \ <Cmd>call <SID>toggle_conceal()<CR>
nnoremap [Space]m
      \ <Cmd>call vimrc#toggle_option('mouse')<CR>

function s:toggle_conceal() abort
  if &l:conceallevel == 0
    setlocal conceallevel=3
  else
    setlocal conceallevel=0
  endif
  setlocal conceallevel?
endfunction

" NOTE: hit-enter prompt is needed to debug.
nnoremap [Space]h
      \ <Cmd>call <SID>toggle_messagesopt()<CR>

function s:toggle_messagesopt() abort
  if &messagesopt->stridx('hit-enter') < 0
    set messagesopt+=hit-enter
    set more
  else
    set messagesopt-=hit-enter
    set nomore
  endif
  set messagesopt? more?
endfunction

if ':restart'->exists()
  nnoremap [Space]r <Cmd>restart<CR>
endif

" Quickfix
nnoremap [Space]q
      \ <Cmd>call vimrc#diagnostics_to_location_list()<CR>

" Useful save mappings.
nnoremap <Leader><Leader> <Cmd>silent update<CR>

" s: Windows and buffers(High priority)
" The prefix key.
nnoremap s    <Nop>
nnoremap sp  <Cmd>vsplit<CR><Cmd>wincmd w<CR>
nnoremap st  <Cmd>split<CR>
nnoremap <Tab>      <cmd>wincmd w<CR>
nnoremap <expr> q
      \   '$'->winnr() == 1
      \ ? '<Cmd>enew<CR>'
      \ : !range(1, '$'->winnr())
      \   ->filter({_, w -> w->winbufnr()->getbufvar('&buftype')
      \                    ->stridx('quickfix') >= 0})
      \   ->empty()
      \ ? '<Cmd>cclose<CR><Cmd>lclose<CR>'
      \ : '#'->winnr() > 0
      \ ? '<Cmd>close<CR>'
      \ : winnr()->getwinvar('&winfixbuf')
      \ ? ''
      \ : '<Cmd>enew<CR>'

" Original search
nnoremap s/    /\<%
nnoremap s?    ?\<%

" Better x
nnoremap x "_x

" Disable Ex-mode in normal mode.
nnoremap Q  q

" Smart <C-f>, <C-b>.
noremap <expr> <C-f>
      \    max([winheight(0) - 2, 1])
      \ .. '<C-d>' .. (line('w$') >= line('$') ? 'L' : 'M')
noremap <expr> <C-b>
      \    max([winheight(0) - 2, 1])
      \ .. '<C-u>' .. (line('w0') <= 1 ? 'H' : 'M')

" Disable ZZ.
nnoremap ZZ  <Nop>

" Select rectangle.
xnoremap r <C-v>

" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" Substitute.
xnoremap s :s//g<Left><Left>

" Sticky shift in English keyboard.
" Sticky key.
inoremap <expr> ;  vimrc#sticky_func()
cnoremap <expr> ;  vimrc#sticky_func()
snoremap <expr> ;  vimrc#sticky_func()

" Easy escape.
inoremap jj           <ESC>

inoremap j<Space>     j

" a>, i], etc...
" <angle>
onoremap aa  a>
xnoremap aa  a>
onoremap ia  i>
xnoremap ia  i>

" [rectangle]
onoremap ar  a]
xnoremap ar  a]
onoremap ir  i]
xnoremap ir  i]

" Improved increment.
nnoremap <C-a> <Cmd>AddNumbers 1<CR>
nnoremap <C-x> <Cmd>AddNumbers -1<CR>
command! -range -nargs=1 AddNumbers
      \ call vimrc#add_numbers(
      \   (<line2>-<line1>+1) * str2nr(<q-args>) * v:count1)

nnoremap #    <C-^>

" NOTE: Does not overwrite <ESC> behavior
if has('nvim')
  tnoremap jj          <C-\><C-n>
else
  tnoremap <ESC><ESC>  <C-l>N
  tnoremap jj          <C-l>N
endif
tnoremap j<Space>   j
tnoremap <expr> ;  vimrc#sticky_func()

" {visual}p to put without yank to unnamed register
xnoremap p   P

" Command group opening with a specific character code again.
" In particular effective when I am garbled in a terminal.
" Open in UTF-8 again.
command! -bang -bar -complete=file -nargs=? Utf8
      \ edit<bang> ++enc=utf-8 <args>
" Open in iso-2022-jp again.
command! -bang -bar -complete=file -nargs=? Iso2022jp
      \ edit<bang> ++enc=iso-2022-jp <args>
" Open in Shift_JIS again.
command! -bang -bar -complete=file -nargs=? Cp932
      \ edit<bang> ++enc=cp932 <args>
" Open in EUC-jp again.
command! -bang -bar -complete=file -nargs=? Euc
      \ edit<bang> ++enc=euc-jp <args>

" Tried to make a file note version.
command! WUtf8 setlocal fenc=utf-8
command! WCp932 setlocal fenc=cp932

" Appoint a line feed.
command! -bang -complete=file -nargs=? WUnix
      \ write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos
      \ write<bang> ++fileformat=dos <args> | edit <args>

" Tag jump
nnoremap tt  g<C-]>
nnoremap tp  <Cmd>pop<CR>

" vim-niceblock
xnoremap <expr> I
      \   mode() ==# 'v'
      \ ? "\<C-v>I"
      \ : mode() ==# 'V'
      \ ? "\<C-v>0o$I"
      \ : 'I'
xnoremap <expr> A
      \   mode() ==# 'v'
      \ ? "\<C-v>A"
      \ : mode() ==# 'V'
      \ ? "\<C-v>0o$A"
      \ : 'A'

" sd{textobj}       : delete the surrounding pair, e.g. sda( sdi" -> uses a" / a(
" sr{textobj}{char} : replace the surrounding pair, e.g. sra("
" Replacement for rhysd/vim-operator-surround (delete/replace only).
let s:pairs = {
      \ '(': ['(', ')'], ')': ['(', ')'], 'b': ['(', ')'],
      \ '[': ['[', ']'], ']': ['[', ']'],
      \ '{': ['{', '}'], '}': ['{', '}'], 'B': ['{', '}'],
      \ '<': ['<', '>'], '>': ['<', '>'],
      \ '「': ['「', '」'], '」': ['「', '」'],
      \ '（': ['（', '）'], '）': ['（', '）'],
      \ }
let s:ask = 0
let s:last = ''

" Return [start, end] positions of the surrounding chars, or [] if invalid.
function! s:edges() abort
  let s = getpos("'[")
  let e = getpos("']")
  " Visual-mode '] may point into the middle of a multibyte char:
  " move it to the first byte of that char.
  let line = getline(e[1])
  let e[2] = strlen(strcharpart(line, 0, charidx(line, e[2] - 1))) + 1
  " a" / a' include surrounding whitespace: skip it on both ends
  call setpos('.', e)
  while e[1] > s[1] || e[2] > s[2]
    if getline('.')[col('.') - 1] !~# '\s' | break | endif
    normal! h
    let e = getpos('.')
  endwhile
  call setpos('.', s)
  while s[1] < e[1] || s[2] < e[2]
    if getline('.')[col('.') - 1] !~# '\s' | break | endif
    normal! l
    let s = getpos('.')
  endwhile
  if s == e | return [] | endif
  let l = s:char_at(s)
  let r = s:char_at(e)
  let p = get(s:pairs, l, [l, l])
  return p ==# [l, r] ? [s, e] : []
endfunction

function! s:char_at(pos) abort
  return matchstr(getline(a:pos[1]), '\%' . a:pos[2] . 'c.')
endfunction

function! s:delete(type) abort
  if a:type !=# 'char' | return | endif
  let edges = s:edges()
  if empty(edges) | return | endif
  " right side first so the left position stays valid
  call setpos('.', edges[1])
  normal! "_x
  call setpos('.', edges[0])
  normal! "_x
endfunction

function! s:replace(type) abort
  if a:type !=# 'char' | return | endif
  if s:ask
    let s:last = nr2char(getchar())
    let s:ask = 0
  endif
  let edges = s:edges()
  if empty(edges) || s:last ==# "\<Esc>" | return | endif
  let p = get(s:pairs, s:last, [s:last, s:last])
  call setpos('.', edges[1])
  execute 'normal! "_s' . p[1] . "\<Esc>"
  call setpos('.', edges[0])
  execute 'normal! "_s' . p[0] . "\<Esc>"
endfunction

function! s:prepare(func) abort
  let s:ask = 1
  let &operatorfunc = expand('<SID>') . a:func
endfunction

nnoremap <silent> sd :<C-u>call <SID>prepare('delete')<CR>g@
xnoremap <silent> sd :<C-u>call <SID>prepare('delete')<CR>gvg@
nnoremap <silent> sr :<C-u>call <SID>prepare('replace')<CR>g@
xnoremap <silent> sr :<C-u>call <SID>prepare('replace')<CR>gvg@
