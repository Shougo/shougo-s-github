function! job#nvim#start(args, options) abort
  let job = s:job->copy()->extend(a:options)
  let job_options = #{
        \   stderr_buffered: v:false,
        \   stdout_buffered: v:false
        \ }
  if a:options->has_key('cwd')
    let job_options.cwd = a:options.cwd
  endif
  if a:options->has_key('env')
    let job_options.env = a:options.env
  endif
  if job->has_key('on_stdout')
    let job_options.on_stdout = funcref('s:_on_stdout', [job])
  endif
  if job->has_key('on_stderr')
    let job_options.on_stderr = funcref('s:_on_stderr', [job])
  endif
  if job->has_key('on_exit')
    let job_options.on_exit = funcref('s:_on_exit', [job])
  else
    let job_options.on_exit = funcref('s:_on_exit_raw', [job])
  endif
  let job.__job = jobstart(a:args, job_options)
  let job.__pid = s:_jobpid_safe(job.__job)
  let job.__exitval = v:null
  let job.args = a:args
  return job
endfunction

" Neovim 0.3.0 and over seems to invoke on_stdout/on_stderr with an empty
" string data when the stdout/stderr channel has closed.
" It is different behavior from Vim and Neovim prior to 0.3.0 so remove an
" empty string list to keep compatibility.
function! s:_on_stdout(job, job_id, data, event) abort
  if a:data == ['']
    return
  endif
  call a:job.on_stdout(a:data)
endfunction

function! s:_on_stderr(job, job_id, data, event) abort
  if a:data == ['']
    return
  endif
  call a:job.on_stderr(a:data)
endfunction

function! s:_on_exit(job, job_id, exitval, event) abort
  let a:job.__exitval = a:exitval
  call a:job.on_exit(a:exitval)
endfunction

function! s:_on_exit_raw(job, job_id, exitval, event) abort
  let a:job.__exitval = a:exitval
endfunction

function! s:_jobpid_safe(job) abort
  try
    return jobpid(a:job)
  catch /^Vim\%((\a\+)\)\=:E900/
    " NOTE:
    " Vim does not raise exception even the job has already closed so fail
    " silently for 'E900: Invalid job id' exception
    return 0
  endtry
endfunction

" Instance -------------------------------------------------------------------
function! s:_job_pid() abort dict
  return self.__pid
endfunction

function! s:_job_status() abort dict
  try
    sleep 1m
    call jobpid(self.__job)
    return 'run'
  catch /^Vim\%((\a\+)\)\=:E900/
    return 'dead'
  endtry
endfunction

function! s:_job_send(data) abort dict
  return self.__job->chansend(a:data)
endfunction

function! s:_job_close() abort dict
  call chanclose(self.__job, 'stdin')
endfunction

function! s:_job_stop() abort dict
  try
    call jobstop(self.__job)
  catch /^Vim\%((\a\+)\)\=:E900/
    " NOTE:
    " Vim does not raise exception even the job has already closed so fail
    " silently for 'E900: Invalid job id' exception
  endtry
endfunction

function! s:_job_wait(...) abort dict
  let timeout = a:0 ? a:1 : v:null
  let exitval = timeout is# v:null
        \ ? jobwait([self.__job])[0]
        \ : jobwait([self.__job], timeout)[0]
  if exitval != -3
    return exitval
  endif
  " Wait until 'on_exit' callback is called
  while self.__exitval is# v:null
    sleep 1m
  endwhile
  return self.__exitval
endfunction

" To make debug easier, use funcref instead.
let s:job = #{
      \  pid: funcref('s:_job_pid'),
      \  status: funcref('s:_job_status'),
      \  send: funcref('s:_job_send'),
      \  close: funcref('s:_job_close'),
      \  stop: funcref('s:_job_stop'),
      \  wait: funcref('s:_job_wait'),
      \}
