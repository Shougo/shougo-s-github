let g:ref_cache_dir = expand('$CACHE/ref')
let g:ref_use_vimproc = 1
if IsWindows()
  let g:ref_refe_encoding = 'cp932'
endif

" ref-lynx.
if IsWindows()
  let s:lynx = 'C:/lynx/lynx.exe'
  let s:cfg  = 'C:/lynx/lynx.cfg'
  let g:ref_lynx_cmd = s:lynx.' -cfg='.s:cfg.' -dump -nonumbers %s'
  let g:ref_alc_cmd = s:lynx.' -cfg='.s:cfg.' -dump %s'
endif

let g:ref_lynx_use_cache = 1
let g:ref_lynx_start_linenumber = 0 " Skip.
let g:ref_lynx_hide_url_number = 0

autocmd MyAutoCmd FileType ref call s:ref_my_settings()
function! s:ref_my_settings() abort "{{{
  " Overwrite settings.
  nmap <buffer> [Tag]t  <Plug>(ref-keyword)
  nmap <buffer> [Tag]p  <Plug>(ref-back)
  nnoremap <buffer> <TAB> <C-w>w
endfunction"}}}
