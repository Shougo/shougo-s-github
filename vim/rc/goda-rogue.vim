" goda-rogue {{{
for [key, dir] in items(#{
      \   h: 'left',
      \   j: 'down',
      \   k: 'up',
      \   l: 'right',
      \   y: 'upleft',
      \   u: 'upright',
      \   b: 'downleft',
      \   n: 'downright',
      \ })

  execute $'nnoremap <buffer> {key} <Cmd>call goda_rogue#do("move", "{dir}")<CR>'
  execute $'nnoremap <buffer> {key->toupper()} <Cmd>call goda_rogue#do("dash", "{dir}")<CR>'
  execute $'nnoremap <buffer> g{key} <Cmd>call goda_rogue#do("turn", "{dir}")<CR>'
endfor

nnoremap <buffer> <Space> <Cmd>call goda_rogue#do('attack')<CR>
nnoremap <buffer> d <Cmd>call goda_rogue#do('debug')<CR>
" Face an enemy next to the player (again: the next one).
nnoremap <buffer> t <Cmd>call goda_rogue#do('turn')<CR>
nnoremap <buffer> . <Cmd>call goda_rogue#do('wait')<CR>
nnoremap <buffer> ;; <Cmd>call goda_rogue#do('foot')<CR>
nnoremap <buffer> > <Cmd>call goda_rogue#do('stairs')<CR>
nnoremap <buffer> i <Cmd>call goda_rogue#do('inventory')<CR>
nnoremap <buffer> , <Cmd>call goda_rogue#do('pickup')<CR>
nnoremap <buffer> f <Cmd>call goda_rogue#do('shoot')<CR>
nnoremap <buffer> x <Cmd>call goda_rogue#do('look')<CR>
nnoremap <buffer> m <Cmd>call goda_rogue#do('map')<CR>
nnoremap <buffer> I <Cmd>call goda_rogue#do('items')<CR>
nnoremap <buffer> M <Cmd>call goda_rogue#do('log')<CR>
nnoremap <buffer> q <Cmd>call goda_rogue#suspend()<CR>
nnoremap <buffer> S <Cmd>call goda_rogue#suspend()<CR>
"}}}
