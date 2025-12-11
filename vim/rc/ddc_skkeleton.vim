" hook_source {{{
autocmd MyAutoCmd User skkeleton-enable-pre call s:skkeleton_pre_ddc()
function! s:skkeleton_pre_ddc() abort
  if 'b:prev_buffer_skkeleton_config'->exists()
    return
  endif

  " Overwrite sources
  let b:prev_buffer_skkeleton_config = ddc#custom#get_buffer()

  call ddc#custom#patch_buffer(#{
          \   cmdlineSources: [
          \    'skkeleton',
          \    'skkeleton_okuri',
          \   ],
          \   sources: [
          \    'around',
          \    'skkeleton',
          \    'skkeleton_okuri',
          \    'line',
          \   ],
          \   sourceOptions: #{
          \     _: #{
          \       keywordPattern: '[ァ-ヮア-ンー]+',
          \     },
          \   },
          \ })
endfunction

autocmd MyAutoCmd User skkeleton-disable-post call s:skkeleton_post_ddc()
function! s:skkeleton_post_ddc() abort
  if 'b:prev_buffer_skkeleton_config'->exists()
    " Restore sources
    call ddc#custom#set_buffer(b:prev_buffer_skkeleton_config)
    unlet b:prev_buffer_skkeleton_config
  endif
endfunction

function s:skkeleton_handle_dot() abort
  if ddc#map#can_complete()
    call feedkeys(ddc#map#insert_item(0), 'nt')
  else
    call skkeleton#handle('handleKey', #{ key: '.' })
  endif
endfunction

" Accept completion item by dot key.
" https://github.com/vim-skk/skkeleton/issues/224
"autocmd User skkeleton-enable-post
"      \ inoremap <buffer> <nowait> .
"      \ <Cmd>call <SID>skkeleton_handle_dot()<CR>
" }}}
