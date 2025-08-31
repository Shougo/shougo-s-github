" hook_source {{{
autocmd MyAutoCmd User skkeleton-enable-pre call s:skkeleton_pre_ddc()
function! s:skkeleton_pre_ddc() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
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

autocmd MyAutoCmd User skkeleton-disable-pre call s:skkeleton_post_ddc()
function! s:skkeleton_post_ddc() abort
  if 's:prev_buffer_config'->exists()
    " Restore sources
    call ddc#custom#set_buffer(s:prev_buffer_config)
  endif
endfunction

function s:skkeleton_handle_dot() abort
  if ddc#map#can_complete()
    call feedkeys(ddc#map#insert_item(0), 'nt')
  else
    call skkeleton#handle('handleKey', #{ key: '.' })
  endif
endfunction

autocmd User skkeleton-enable-post
      \ inoremap <buffer> <nowait> .
      \ <Cmd>call <SID>skkeleton_handle_dot()<CR>
" }}}
