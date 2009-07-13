"=============================================================================
" FILE: bufstatus.vim
" AUTHOR: Ico Doornekamp<http://www.vim.org/scripts/script.php?script_id=1664>(Original)
"         Gonbei <gonbei0671@hotmail.com>(Modified)
"         Shougo Matsushita <Shougo.Matsu@gmail.com>(Modified)
" Last Modified: 10 Jul 2009
" Usage: Just source this file.
"        source bufstatus.vim
" LICENSE: GPL version2"{{{
" This program is free software; you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation; either version 2
" of the License, or (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
""}}}
" Version: 4.1, for Vim 7.0
" Introduction"{{{
" ------------
" This is a simple script that shows a tabs-like list of buffers in the top
" of the window. The biggest advantage of this script over various others is
" that it does not take any lines away from your terminal, leaving more space
" for the document you're editing. The tabs are only visible when you need
" them - when you are switchin between buffers.
""}}}
" Usage"{{{
" -----
" This script draws buffer tabs on vim startup, when a new buffer is created
" and when switching between buffers.
"
" It might be handy to create a few maps for easy switching of buffers in your
" .vimrc file. For example, using F1 and F2 keys:
"
"   noremap <silent> <f1> :<C-u>bprev<CR> 
"   noremap <silent> <f2> :<C-u>bnext<CR>
"
" or using control-left and control-right keys:
"
"   noremap <silent> <C-p> :<C-u>bprev<CR>
"   noremap <silent> <C-n> :<C-u>bnext<CR>
"
"
" The following extra configuration variables are available:
" 
""}}}
"-----------------------------------------------------------------------------
" Changelog"{{{
" ---------
"   4.1:
"     - Don't use window variables.
"     - Displayed nomodifiable.
"     - Fixed mergin.
"
"   4.0:
"     - Show in tabline.
"
"   3.9:
"     - Optimized statusline.
"
"   3.8:
"     - Displayed nomodifiable.
"     - Optimized statusline.
"     - Improved adjustments.
"
"   3.7:
"     - Supported neocomplcache caching percent.
"
"   3.6:
"     - Improved l:item_length.
"
"   3.5:
"     - Improved alternate buffer.
"
"   3.4:
"     - Improved autocmd.
"     - Fixed preview window error.
"
"   3.3:
"     - Displayed alternate buffer name.
"
"   3.2:
"     - Added g:BufStatus_ShortStatus and g:BufStatus_RightStatus option.
"     - Improved restore statusline.
"     - Fixed small bug.
"     - Truncate filename when simple statusline.
"
"   3.1:
"     - Restore statusline when error occured. 
"     - Changed simple statusline width.
"     - Improved simple statusline.
"
"   3.0:
"     - Improved redraw timing.
"     - Refactoring.
"
"   2.6:
"     - Numbering from left side.
"
"   2.5:
"     - Improved show number.
"
"   2.4:
"     - Redraw statusline at <C-l>.
"
"   2.0:
"     - Fix many bugs.
"
"   1.0:
"     - Accept multibyte files.
"     - Calc overflow.
"     - Make adjustments to items length.
"
"   0.1:
"     - Initial version.
""}}}
"-----------------------------------------------------------------------------
" TODO: "{{{
"     - Nothing.
""}}}
" Bugs"{{{
"     -
""}}}
"=============================================================================

if exists("loaded_bufstatus") || v:version < 700
    finish
endif

" Set highlight"{{{
if !exists('s:highlight_set')
    let s:highlight_set = 1

    " HighLight
    command! -nargs=* StatusBufferHighlight hi def link <args>

    StatusBufferHighlight    BUFHL  Search
    StatusBufferHighlight    BUFNHL StatusLine
    delcommand StatusBufferHighlight
endif"}}}

" Return buffer list.
function! s:getbuf()"{{{
    " Count buffer list
    let l:maxbuf = 0
    let l:i = 1
    while l:i <= bufnr('$')
        if buflisted(l:i)
            let l:maxbuf += 1
        endif
        let l:i += 1
    endwhile

    if bufnr('%') != bufnr('#') && buflisted(bufnr('#'))
        let l:alter = bufnr('#')
    else
        " Search next buffer.
        let l:i = 1
        let [l:first, l:last] = [-1, -1]
        let [l:previous, l:current, l:next] = [bufnr('%'), bufnr('%'), bufnr('%')]
        while l:i <= bufnr('$')
            if buflisted(l:i)
                if l:i < l:current
                    let l:previous = l:i
                elseif l:i > l:current && l:next == l:current
                    let l:next = l:i
                endif

                let l:last = l:i

                if l:first < 0 
                    let l:first = l:i
                endif
            endif
            let l:i += 1
        endwhile

        if l:current > l:i / 2
            let l:alter = l:previous
        else
            let l:alter = l:next
        endif
    endif

    let s:display_width = winwidth(0) - g:BufStatus_SideMargin

    " Make adjustments to item length"{{{
    let l:item_length = s:display_width / l:maxbuf - 2
    if l:item_length <= g:BufStatus_MinItemLength
        let l:item_length = 3
    elseif l:item_length > g:BufStatus_MaxItemLength
        let l:item_length = g:BufStatus_MaxItemLength
    endif
    "}}}

    let l:num = 0
    let l:i = 1
    let l:bufs = []
    while l:i <= bufnr('$')
        let l:filepath = expand(printf('#%d:p', l:i))

        if buflisted(l:i)
            if l:i == l:alter
                " Alternate buffer name.
                let l:fname = printf("%s#%s", l:num, fnamemodify(bufname(l:i), ':t'))
            else
                " Normal buffer name.
                let l:fname = printf("%s:%s", l:num, fnamemodify(bufname(l:i), ':t'))
            endif

            if len(l:fname) > l:item_length
                let l:pos = 0
                let l:mlength = len(l:fname)

                " Accept multibyte file name"{{{
                let l:fchar = char2nr(l:fname[l:pos])
                let l:display_diff = 0
                while l:pos-l:display_diff < l:item_length
                    if l:fchar >= 0x80
                        " Skip multibyte
                        if l:fchar < 0xc0
                            " Skip UTF-8 on the way
                            let l:fchar = char2nr(l:fname[l:pos])
                            while l:pos < l:mlength && 0x80 <= l:fchar && l:fchar < 0xc0
                                let l:pos += 1
                                let l:fchar = char2nr(l:fname[l:pos])
                            endwhile
                        elseif l:fchar < 0xe0
                            " 2byte code
                            let l:pos += 1
                        elseif l:fchar < 0xf0
                            " 3byte code
                            let l:display_diff += 1
                            let l:pos += 2
                        elseif l:fchar < 0xf8
                            " 4byte code
                            let l:display_diff += 2
                            let l:pos += 3
                        elseif l:fchar < 0xfe
                            " 5byte code
                            let l:display_diff += 3
                            let l:pos += 4
                        else
                            " 6byte code
                            let l:display_diff += 4
                            let l:pos += 5
                        endif
                    endif

                    let l:pos += 1
                    let l:fchar = char2nr(l:fname[l:pos])
                endwhile"}}}

                let l:oldlen = len(l:fname)
                let l:fname = printf('%.' . l:pos . 's', l:fname)

                if l:display_diff > 0
                    let s:display_width += l:display_diff

                    " Check truncated
                    if l:oldlen > l:pos
                        let l:fname .= "~"
                    endif
                else 
                    let l:fname .= "~"
                endif
            else
                let l:fname = printf('%-' . g:BufStatus_MinItemLength . 's', l:fname) 
            endif

            " Check modified
            if getbufvar(l:i, "&modified")
                let l:fname .= "!"
            elseif !getbufvar(l:i, "&modifiable")
                let l:fname .= "-"
            else
                let l:fname .= " "
            endif

            let l:bufs += [l:fname]

            let l:num += 1
        else 
            " Deleted buffer
            let l:bufs += ['']
        endif

        let l:i += 1
    endwhile

    return l:bufs
endfunction"}}}

" Redraw status.
function! s:redraw()"{{{
    " Get all buffers
    let l:bufs = s:getbuf()

    " return list
    let l:ret = []

    " buffer number(1 origin)
    let l:i = 1
    " list number(0 origin)
    let l:j = 0
    let l:active = -1
    for l:buf in l:bufs
        if l:buf != ''
            " Get active buffer number
            if l:i == bufnr('%')
                let l:active = l:j
            endif

            let l:j += 1

            " Add return list
            call add(ret, buf)
        endif

        let l:i += 1
    endfor

    let l:capacity = s:calc_capacity(s:display_width, l:bufs)

    let l:l = len(l:ret)
    if l:l <= 0
        " Empty list
        let l:_sbl_left_item = []
        let l:_sbl_active_item = ''
        let l:_sbl_right_item = []
    elseif l:l > l:capacity
        " Over capacity
        let l:_sbl_left_item = []
        let l:i = -(l:capacity - 1) / 2
        while l:i <  0
            if l:active < 0
                call add(l:_sbl_left_item, l:ret[l:i])
            else
                call add(l:_sbl_left_item, l:ret[l:active + l:i])
            endif
            let l:i += 1
        endwhile

        if l:active < 0
            let l:_sbl_active_item = ''
        else
            let l:_sbl_active_item = l:ret[l:active]
        endif

        let l:_sbl_right_item = []
        if l:active >= 0
            let l:i = 1
            while l:i <= (capacity) / 2
                call add(l:_sbl_right_item, l:ret[(l:active + l:i) % l:l])
                let l:i += 1
            endwhile
        endif
    else
        if l:active < 0
            let l:_sbl_left_item = l:ret
            let l:_sbl_active_item = ''
            let l:_sbl_right_item = []
        else 
            let l:_sbl_left_item = (l:active < 1) ? [] : l:ret[: l:active-1]
            let l:_sbl_active_item = l:ret[l:active]
            let l:_sbl_right_item = l:ret[l:active+1 :]
        endif
    endif

    " Join list
    let l:sbl_left_item = join(l:_sbl_left_item)
    if l:sbl_left_item != ''
        " Spacing
        let l:sbl_left_item .= ' '
    endif
    let l:sbl_active_item = l:_sbl_active_item
    let l:sbl_right_item = join(l:_sbl_right_item)

    return printf('%%#BUFNHL#%s%%#BUFHL#%s%%#BUFNHL# %s %%=%s',
                \l:sbl_left_item, l:sbl_active_item, l:sbl_right_item, g:BufStatus_RightStatus)
endfunction"}}}

" Calc capacity.
function! s:calc_capacity(width, bufs)"{{{
    let l:bufs = a:bufs
    let l:max_width = a:width*90/100

    " Check
    let l:capacity = len(a:bufs)
    let l:item_width = len(join(l:bufs))
    while l:item_width > l:max_width
        let l:capacity -= 1
        let l:bufs = l:bufs[: l:capacity-1]
        let l:item_width = len(join(l:bufs))
    endwhile

    return l:capacity
endfunction"}}}

" Global variables difinition."{{{
"
if !exists("g:BufStatus_MaxItemLength")
    " Maximum item length.
    let g:BufStatus_MaxItemLength = 15
endif
if !exists("g:BufStatus_MinItemLength")
    " Minimum item length.
    let g:BufStatus_MinItemLength = 2
endif
if !exists("g:BufStatus_SideMargin")
    " Right side information margin.
    let g:BufStatus_SideMargin = 5
endif
if !exists("g:BufStatus_RightStatus")
    " Right tabline information.
    let g:BufStatus_RightStatus = ''
endif
"}}}

" Anywhere SID.
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

" Tab line set.
let &tabline = '%!'. s:SID_PREFIX() . 'redraw()'

let loaded_bufstatus = 1

" vim: foldmethod=marker
