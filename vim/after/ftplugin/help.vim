" Disable conceal.
if &l:buftype !=# 'help'
  setlocal list tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab textwidth=78
  if exists('+colorcolumn')
    setlocal colorcolumn=+1
  endif
  if has('conceal')
    setlocal conceallevel=0
  endif
endif

command! -buffer -bar GenerateContents call s:generate_contents()
function! s:generate_contents()
  let cursor = getpos('.')

  let plug_name = expand('%:t:r')
  let ja = expand('%:e') ==? 'jax'
  1

  if search(plug_name . '-contents\*$', 'W')
    silent .+1;/^=\{78}$/-1 delete _
    .-1
    put =''
  else
    /^License:/+1
    let header = printf('%s%s*%s-contents*', (ja ? "目次\t" : 'CONTENTS'),
    \            repeat("\t", 5), plug_name)
    silent put =['', repeat('=', 78), header]
    .+1
  endif

  let contents_pos = getpos('.')

  let lines = []
  while search('^\([=-]\)\1\{77}$', 'W')
    let head = getline('.') =~ '=' ? '' : '  '
    .+1
    let caption = matchlist(getline('.'), '^\([^\t]*\)\t\+\*\(\S*\)\*$')
    if !empty(caption)
      let [title, tag] = caption[1 : 2]
      call add(lines, printf("%s%s\t%s|%s|", head, title, head, tag))
    endif
  endwhile

  call setpos('.', contents_pos)

  silent put =lines + ['', '']
  call setpos('.', contents_pos)
  let len = len(lines)
  setlocal expandtab tabstop=32
  execute '.,.+' . len . 'retab'
  setlocal noexpandtab tabstop=8
  execute '.,.+' . len . 'retab!'

  call setpos('.', cursor)
endfunction
