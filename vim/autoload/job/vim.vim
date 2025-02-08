" https://github.com/neovim/neovim/blob/f629f83/src/nvim/event/process.c#L24-L26
let s:KILL_TIMEOUT_MS = 2000

function! job#vim#start(args, options) abort
  let job = extend(copy(s:job), a:options)
  let job_options = #{
        \  mode: 'raw',
        \  timeout: 0,
        \  noblock: 1,
        \}
  if job->has_key('on_stdout')
    let job_options.out_cb = funcref('s:_out_cb', [job])
  else
    let job_options.out_io = 'null'
  endif
  if job->has_key('on_stderr')
    let job_options.err_cb = funcref('s:_err_cb', [job])
  else
    let job_options.err_io = 'null'
  endif
  if job->has_key('on_exit')
    let job_options.exit_cb = funcref('s:_exit_cb', [job])
  endif
  if job->has_key('cwd')
    let job_options.cwd = job.cwd
  endif
  if job->has_key('env')
    let job_options.env = job.env
  endif
  let job.__job = job_start(a:args, job_options)
  let job.args = a:args
  return job
endfunction

function! s:_out_cb(job, channel, msg) abort
  call a:job.on_stdout(a:msg->split("\n", 1))
endfunction

function! s:_err_cb(job, channel, msg) abort
  call a:job.on_stderr(a:msg->split("\n", 1))
endfunction

function! s:_exit_cb(job, channel, exitval) abort
  " Make sure on_stdout/on_stderr are called prior to on_exit.
  if a:job->has_key('on_stdout')
    let options = #{ part: 'out' }
    while a:channel->ch_status(options) ==# 'open'
      sleep 1m
    endwhile
    while a:channel->ch_status(options) ==# 'buffered'
      call s:_out_cb(a:job, a:channel, a:channel->ch_readraw(options))
    endwhile
  endif
  if a:job->has_key('on_stderr')
    let options = #{ part: 'err' }
    while a:channel->ch_status(options) ==# 'open'
      sleep 1m
    endwhile
    while a:channel->ch_status(options) ==# 'buffered'
      call s:_err_cb(a:job, a:channel, a:channel->ch_readraw(options))
    endwhile
  endif
  call a:job.on_exit(a:exitval)
endfunction


" Instance -------------------------------------------------------------------
function! s:_job_pid() abort dict
  return self.__job->job_info().process
endfunction

" NOTE:
" On Unix a non-existing command results in "dead" instead
" So returns "dead" instead of "fail" even in non Unix.
function! s:_job_status() abort dict
  let status = self.__job->job_status()
  return status ==# 'fail' ? 'dead' : status
endfunction

" NOTE:
" A Null character (\0) is used as a terminator of a string in Vim.
" Neovim can send \0 by using \n split list but in Vim.
" So replace all \n in \n split list to ''
function! s:_job_send(data) abort dict
  let data = a:data->type() == v:t_list
        \ ? a:data->map('v:val->substitute("\n", '''', ''g'')')->join("\n")
        \ : a:data
  return self.__job->ch_sendraw(data)
endfunction

function! s:_job_close() abort dict
  call ch_close_in(self.__job)
endfunction

function! s:_job_stop() abort dict
  call job_stop(self.__job)
  call timer_start(s:KILL_TIMEOUT_MS, { -> self.__job->job_stop('kill') })
endfunction

function! s:_job_wait(...) abort dict
  let timeout = a:0 ? a:1 : v:null
  let timeout = timeout is# v:null ? v:null : timeout / 1000.0
  let start_time = reltime()
  let job = self.__job
  try
    while timeout is# v:null
          \ || timeout > start_time->reltime()->reltimefloat()
      let status = job->job_status()
      if status !=# 'run'
        return status ==# 'dead' ? job->job_info().exitval : -3
      endif
      sleep 1m
    endwhile
  catch /^Vim:Interrupt$/
    call self.stop()
    return -2
  endtry
  return -1
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
