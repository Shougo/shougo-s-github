"---------------------------------------------------------------------------
" Key-mappings:
"

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
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif

" Insert mode keymappings:
" <C-t>: insert tab.
inoremap <C-t>  <C-v><TAB>
" Enable undo <C-w> and <C-u>.
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-k>  <C-o>D

" Command-line mode keymappings:
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
" <C-g>: Exit.
cnoremap <C-g>          <C-c>

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
nnoremap [Space]l
      \ <Cmd>call vimrc#toggle_option('laststatus')<CR>

" Easily edit current buffer
nnoremap <silent><expr> [Space]e
      \ bufname('%') !=# '' && &l:buftype ==# '' ?
      \ "\<Cmd>edit %\<CR>" : ''

" Useful save mappings.
nnoremap <silent> <Leader><Leader> <Cmd>update<CR>

" s: Windows and buffers(High priority)
" The prefix key.
nnoremap <silent> sp  <Cmd>vsplit<CR>:wincmd w<CR>
nnoremap <silent> so  <Cmd>only<CR>
nnoremap <silent> <Tab>      <cmd>wincmd w<CR>
nnoremap <silent><expr> q winnr('$') != 1 ? '<Cmd>close<CR>' : ""

" Original search
nnoremap s/    /
nnoremap s?    ?

" Better x
nnoremap x "_x

" Disable Ex-mode.
nnoremap Q  q

" Useless command.
nnoremap M  m

" Smart <C-f>, <C-b>.
noremap <expr> <C-f> max([winheight(0) - 2, 1])
      \ . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
      \ . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")

" Disable ZZ.
nnoremap ZZ  <Nop>

" Select rectangle.
xnoremap r <C-v>

" Redraw.
nnoremap <silent> <C-l>    <Cmd>redraw!<CR>

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
cnoremap <expr> j
      \ getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'

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
nmap <C-a> <SID>(increment)
nmap <C-x> <SID>(decrement)
nnoremap <silent> <SID>(increment)    <Cmd>AddNumbers 1<CR>
nnoremap <silent> <SID>(decrement)    <Cmd>AddNumbers -1<CR>
command! -range -nargs=1 AddNumbers
      \ call vimrc#add_numbers((<line2>-<line1>+1) * eval(<args>))

nnoremap <silent> #    <C-^>

if exists(':tnoremap')
  " Note: Does not overwrite <ESC> behavior
  if has('nvim')
    tnoremap   jj         <C-\><C-n>
  else
    tnoremap   <ESC><ESC>  <C-w>N
    tnoremap   jj          <C-w>N
  endif
  tnoremap   j<Space>   j
  tnoremap <expr> ;  vimrc#sticky_func()
endif

" Wordcount
command! WordCount echo strchars(join(getline(1, '$')))

" {visual}P to put without yank to unnamed register
" https://github.com/neovim/neovim/pull/12383#issuecomment-695768082
xnoremap <silent> p <Cmd>call vimrc#visual_paste('p')<CR>
xnoremap <silent> P <Cmd>call vimrc#visual_paste('P')<CR>


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
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16
      \ edit<bang> ++enc=ucs-2le <args>

" Tried to make a file note version.
command! WUtf8 setlocal fenc=utf-8
command! WCp932 setlocal fenc=cp932

" Appoint a line feed.
command! -bang -complete=file -nargs=? WUnix
      \ write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos
      \ write<bang> ++fileformat=dos <args> | edit <args>

" Insert special character
inoremap <C-v>u  <C-r>=nr2char(0x)<Left>
