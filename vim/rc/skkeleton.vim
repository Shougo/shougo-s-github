" hook_add {{{
inoremap <C-j> <Plug>(skkeleton-toggle)
cnoremap <C-j> <Plug>(skkeleton-toggle)
tnoremap <C-j> <Plug>(skkeleton-toggle)
nnoremap <C-j> i<Plug>(skkeleton-enable)

" Lazy load by background
"call timer_start(10, { _ -> dpp#source('skkeleton') })
" }}}

" hook_source {{{
"let g:skkeleton#debug = v:true

call skkeleton#config(#{
      \   databasePath: '~/.cache/skkeleton.db'->expand(),
      \   eggLikeNewline: v:true,
      \   globalDictionaries:
      \       has('win32')
      \     ? ['~/.config/SKK-JISYO.L'->expand()]
      \     : ['/usr/share/skk/SKK-JISYO.L'],
      \   markerHenkan: '',
      \   markerHenkanSelect: '',
      \   registerConvertResult: v:true,
      \   sources: ["deno_kv", "google_japanese_input"],
      \ })

" For SKK server test.
"call skkeleton#config(#{
"      \   sources: ["deno_kv", "skk_server"],
"      \ })

call skkeleton#register_kanatable('rom', {
      \   'jj': 'escape',
      \   '~': ['〜', ''],
      \ })

autocmd MyAutoCmd User skkeleton-enable-pre
      \ call s:skkeleton_pre()
function! s:skkeleton_pre() abort
  if (!has('nvim') || $DISPLAY !=# '') && has('clipboard')
    " Copy to clipboard to use Vim as IME
    autocmd ModeChanged *:n ++once
      \ let @* = '.'->getline() | let @+ = @*
  endif

  const is_cmdline =
      \ '*cmdline#_get'->exists() && !cmdline#_get().pos->empty()
  const hl_name = is_cmdline ? 'CmdlineCursor' : 'Cursor'

  let s:hl_cursor = has('nvim') ?
      \ nvim_get_hl(0, #{ name: hl_name }) : hl_name->hlget()
endfunction

autocmd MyAutoCmd User skkeleton-mode-changed
      \ call s:skkeleton_changed()
function! s:skkeleton_changed() abort
  " Change the cursor color
  let hl_cursor = s:hl_cursor->copy()

  if g:skkeleton#mode ==# 'hira'
    const color = '#80403f'
  elseif g:skkeleton#mode ==# 'kata'
    const color = '#f04060'
  elseif g:skkeleton#mode ==# 'hankata'
    const color = '#60a060'
  elseif g:skkeleton#mode ==# 'zenkaku'
    const color = '#60c060'
  elseif g:skkeleton#mode ==# 'abbrev'
    const color = '#60f060'
  else
    const color = '#606060'
  endif

  if has('nvim')
    let hl_cursor.bg = color
  else
    let hl_cursor[0].guibg = color
  endif

  call s:highlight_cursor(hl_cursor)
endfunction

autocmd MyAutoCmd User skkeleton-handled call s:skkeleton_handled()
function! s:skkeleton_handled() abort
  if g:skkeleton#mode ==# ''
    return
  endif

  " Change the cursor color
  if g:skkeleton#state.phase ==# 'henkan' ||
      \ g:skkeleton#state.phase ==# 'input:okurinasi' ||
      \ g:skkeleton#state.phase ==# 'input:okuriari'
    let hl_cursor = s:hl_cursor->copy()
    const color = '#a0f0a0'
    if has('nvim')
      let hl_cursor.bg = color
    else
      let hl_cursor[0].guibg = color
    endif
    call s:highlight_cursor(hl_cursor)
  else
    call s:skkeleton_changed()
  endif
endfunction

function! s:highlight_cursor(highlight) abort
  const is_cmdline =
      \ '*cmdline#_get'->exists() && !cmdline#_get().pos->empty()

  if has('nvim')
    call nvim_set_hl(
      \ 0, is_cmdline ? 'CmdlineCursor' : 'Cursor', a:highlight)
  else
    if is_cmdline
      let a:highlight[0].name = 'CmdlineCursor'
    endif

    call hlset(a:highlight)
  endif

  " NOTE: redraw is needed
  redraw
endfunction

call skkeleton#initialize()
" }}}
