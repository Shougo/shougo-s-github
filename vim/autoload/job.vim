function! job#system(command) abort
  return s:job_system.system(a:command)
endfunction
function! job#status() abort
  return s:job_system.status
endfunction

let s:job_system = {}
function! s:job_system.on_out(data) abort
  let candidates = s:job_system.candidates
  if candidates->empty()
    call add(candidates, a:data[0])
  else
    let candidates[-1] ..= a:data[0]
  endif
  let candidates += a:data[1:]
endfunction
function! s:job_system.system(cmd) abort
  let self.candidates = []

  let job = { has('nvim') ? 'job#nvim#' : 'job#vim#' }start(
        \ s:convert_args(a:cmd), #{
        \   on_stdout: self.on_out,
        \   on_stderr: self.on_out,
        \ })
  let s:job_system.status = job.wait(1000)
  return s:job_system.candidates->join("\n")->substitute('\r\n', '\n', 'g')
endfunction
function! s:convert_args(args) abort
  let args = s:iconv(a:args, &encoding, 'char')
  if args->type() != v:t_list
    let args = &shell->split() + &shellcmdflag->split() + [args]
  endif
  return args
endfunction
function! s:iconv(expr, from, to) abort
  if a:from ==# '' || a:to ==# '' || a:from ==? a:to
    return a:expr
  endif

  if a:expr->type() == v:t_list
    return a:expr->copy()->map({ _, val -> iconv(val, a:from, a:to) })
  else
    let result = a:expr->iconv(a:from, a:to)
    return result !=# '' ? result : a:expr
  endif
endfunction

