" yanktmp.vim - Yank string write to tmpfile and read from tmpfile
" Author:       secondlife <hotchpotch@NOSPAM@gmail.com>
" Revised:      Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Change:  2009 Jan 12
" Version: 0.6

" DESCRIPTION:
"  This plugin enables vim to yank and paste through the multi processes.
"
"  If <Plug>(yanktmp_yank), yank string write to tmpfile.
"  And <Plug>(yanktmp_paste_p) or <Plug>(yanktmp_paste_P), paste string from tmpfile.
"  
"  Default tmp file is '$HOME/.vimyanktmp'
"  If you want to change tmp file.
"  let g:yanktmp_file = '/tmp/example_tmp_file'
"
" ==================== file yanktmp.vimrc ====================
" map <silent> sy    <Plug>(yanktmp_yank)
" map <silent> sp    <Plug>(yanktmp_paste_p)
" map <silent> sP    <Plug>(yanktmp_paste_P)
" ==================== end: yanktmp.vimrc ====================

if v:version < 700 || (exists('g:loaded_yanktmp') && g:loaded_yanktmp || &cp)
    finish
endif
let g:loaded_yanktmp = 1

if !exists('g:yanktmp_file')
    let g:yanktmp_file = $HOME . '/.vimyanktmp'
endif

noremap <silent> <Plug>(yanktmp_yank)  :call <SID>YanktmpYank()<CR>
noremap <silent> <Plug>(yanktmp_paste_p)  :call <SID>YanktmpPaste_p()<CR>
noremap <silent> <Plug>(yanktmp_paste_P)  :call <SID>YanktmpPaste_P()<CR>

function! s:YanktmpYank() range
    let [visual_p, pos] = [mode() =~# "[vV\<C-v>]", getpos('.')]
    let [r_, r_t] = [@@, getregtype('"')]
    let [r0, r0t] = [@0, getregtype('0')]

    if visual_p
        execute "normal! \<Esc>"
    endif
    silent normal! gvy
    let [_, _t] = [@@, getregtype('"')]

    call setreg('"', r_, r_t)
    call setreg('0', r0, r0t)
    if visual_p
        normal! gv
    else
        call setpos('.', pos)
    endif
    let l:selected_lines = split((a:0 && a:1 ? [_, _t] : _), '\n')
    call writefile(l:selected_lines, g:yanktmp_file, 'b')
endfunction

function! s:YanktmpPaste_p() range
    let l:pos = getpos('.')
    call append(a:firstline, readfile(g:yanktmp_file, "b"))
    call setpos('.', [0, l:pos[1] + 1, 1, 0])
endfunction

function! s:YanktmpPaste_P() range
    let l:pos = getpos('.')
    call append(a:firstline - 1, readfile(g:yanktmp_file, "b"))
    call setpos('.', [0, l:pos[1], 1, 0])
endfunction

