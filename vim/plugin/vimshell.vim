"=============================================================================
" FILE: vimshell.vim
" AUTHOR: Janakiraman .S <prince@india.ti.com>(Original)
"         Shougo Matsushita <Shougo.Matsu@gmail.com>(Modified)
" Last Modified: 14 Jan 2009
" Usage: Just source this file.
"        source vimshell.vim
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Version: 2.9, for Vim 7.0
"-----------------------------------------------------------------------------
" ChangeLog: "{{{
"   2.9:
"     - Trial implemented highlight escape sequence.
"     - Fixed history bug.
"     - Convert cd to lcd.
"   2.8:
"     - Dup check when quick match.
"     - Due to optimize, filtering len(cur_keyword_str) >.
"     - Ignore head spaces when completion.
"   2.7:
"     - Implemented shell history completion by omnifunc.
"     - Mapping omnifunc <C-j>.
"     - Implemented quick match.
"     - Improved escape.
"   2.6:
"     - Implemented shell history.
"   2.5:
"     - Set lazyredraw in vimshell buffer.
"     - Refactoring.
"   2.3:
"     - Code cleanup.
"   2.2:
"     - Fix syntax highlight at pipe command.
"     - Fix quotetion highlight.
"   2.1:
"     - Fix syntax highlights.
"   2.0:
"     - Implemented syntax highlight.
"   1.0:
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

if exists('g:loaded_vimshell') || v:version < 700
  finish
endif

" Plugin keymapping
nnoremap <silent> <Plug>(vimshell_init)  :<C-u>call <SID>VimShell_InitShell()<CR>
nnoremap <silent> <Plug>(vimshell_enter)  :<C-u>call <SID>VimShell_ProcessEnter()<CR>
nmap <silent> <Leader>sh     <Plug>(vimshell_init)

command! -nargs=0 VimShell call s:VimShell_InitShell()

function! s:VimShell_InitShell()"{{{
    if expand('%:p:t') == 'VimShell'
        echo 'Already there'
    else
        if bufexists('VimShell')
            let l:num = bufwinnr('VimShell')
            if l:num < 0
                sbuffer VimShell
                setfiletype vimshell
            else
                " Switch window.
                execute l:num 'wincmd w'
            endif
        else
            " Create window.
            split VimShell
            setlocal lazyredraw
            setlocal bufhidden=unload
            setlocal buftype=nofile
            setlocal noswapfile
            let &l:omnifunc = 'g:VimShell_HistoryComplete'
            setfiletype vimshell

            " Load history.
            if !filereadable(g:VimShell_HistoryPath)
                " Create file.
                call writefile([], g:VimShell_HistoryPath)
            endif
            let s:hist_buffer = readfile(g:VimShell_HistoryPath)
            let s:hist_size = getfsize(g:VimShell_HistoryPath)

            let s:prev_numbered_list = []
        endif
    endif

    call s:VimShell_PrintPrompt()
endfunction"}}}

function! s:VimShell_PrintPrompt()"{{{
    let l:escaped = escape (getline('$'), "\'")
    " Search prompt
    if match(l:escaped, g:VimShell_Prompt) < 0
        " Prompt not found
        if !empty(getline('.'))
            call append(line('.'), g:VimShell_Prompt)
            normal! j
        else
            call setline(line('.'), g:VimShell_Prompt)
        endif
        normal! $
    else
        " If the line we are on has only the prompt , place the cursor at the end.
        let l:escaped = escape (getline('.'), "\'")
        let l:pattern = printf('%s\s*$', g:VimShell_Prompt)
        if match(l:escaped, l:pattern) > 0
            normal! $
        endif
    endif
    let &modified = 0
endfunction"}}}

function! s:VimShell_ProcessEnter()"{{{
    let l:escaped = escape(getline('.'), '"')
    let l:prompt_pos = match(substitute(l:escaped, "'", "''", 'g'), g:VimShell_Prompt)
    if l:prompt_pos < 0
        " Prompt not found
        echo "Not on the command line"
        normal! j
        return
    endif

    " Delete prompt string.
    let l:line = substitute(l:escaped, g:VimShell_Prompt, '', '')
    if line('.') != line('$')
        if l:line =~ '\w' && &modified == 0
            " Insert prompt line.
            call append(line('.'), getline('.'))
        endif
    endif

    " Not append history if starts spaces or dups.
    if l:line !~ '^\s' && (empty(s:hist_buffer) || l:line != s:hist_buffer[0])
        let l:now_hist_size = getfsize(g:VimShell_HistoryPath)
        if l:now_hist_size != s:hist_size
            " Reload.
            let s:hist_buffer = readfile(g:VimShell_HistoryPath)
        endif

        " Append history.
        call insert(s:hist_buffer, l:line)

        " Trunk.
        let s:hist_buffer = s:hist_buffer[:g:VimShell_HistoryMaxSize-1]

        call writefile(s:hist_buffer, g:VimShell_HistoryPath)

        let s:hist_size = getfsize(g:VimShell_HistoryPath)
    endif

    if l:line =~ '^clear'
        " If it says clean, Clean up the screen.
        normal! ggdG
        call s:VimShell_PrintPrompt()
        return
    endif

    if l:line =~ '^cd ' || l:line =~ '^lcd '
        " If the command is a cd, Change the working directory.
        let l:line = substitute(l:line, '^cd', 'lcd', '')
        execute l:line
    elseif l:line =~ '^ls'
        let l:words = split(l:line)
        if len(l:words) == 1
            if has('win32')
                execute 'read! ls .'
            else
                execute 'read! ls -FC'
            endif
        else
            execute 'read! ' . l:line
        endif
    elseif l:line =~ '\w'
        execute 'read! ' . l:line
    endif

    if line('.') == line('$')
        " Insert blank line.
        call append(line('$'), '')
        normal! j
    endif

    call s:VimShell_HighlightEscapeSequence()

    call s:VimShell_PrintPrompt()
endfunction"}}}

function! g:VimShell_HistoryComplete(findstart, base)"{{{
    if a:findstart
        let l:escaped = escape(getline('.'), '"')
        let l:prompt_pos = match(substitute(l:escaped, "'", "''", 'g'), g:VimShell_Prompt)
        if l:prompt_pos < 0
            " Prompt not found
            return -1
        endif
        
        return len(g:VimShell_Prompt)
    endif

    " Save options.
    let l:ignorecase_save = &l:ignorecase

    " Complete.
    let &l:ignorecase = g:VimShell_IgnoreCase
    " Ignore head spaces.
    let l:cur_keyword_str = substitute(a:base, '^\s\+', '', '')
    let l:complete_words = []
    for hist in s:hist_buffer
        if len(hist) > len(l:cur_keyword_str) && hist =~ l:cur_keyword_str
            call add(l:complete_words, { 'word' : hist, 'abbr' : hist, 'dup' : 0 })
        endif
    endfor

    " Restore options.
    let &l:ignorecase = l:ignorecase_save

    " Append numbered list.
    let l:match_str = matchstr(l:cur_keyword_str, '\d$')
    if !empty(l:match_str)
        " Get numbered list.
        let l:numbered = get(s:prev_numbered_list, str2nr(l:match_str)-1)
        if type(l:numbered) == type({})
            call insert(l:complete_words, l:numbered)
        endif
    endif

    " Check dup.
    let l:dup_check = {}
    let l:num = 0
    let l:numbered_words = []
    for history in l:complete_words[0:14]
        if !empty(history.word) && !has_key(l:dup_check, history.word)
            let l:dup_check[history.word] = 1

            call add(l:numbered_words, history)
        endif
        let l:num += 1
    endfor

    " Add number.
    let l:num = 0
    let l:abbr_pattern_d = '%d: %.' . g:VimShell_MaxHistoryWidth . 's'
    let l:abbr_pattern_n = '   %.' . g:VimShell_MaxHistoryWidth . 's'
    for history in l:numbered_words
        if l:num == 0
            let history.abbr = printf('*: %.' . g:VimShell_MaxHistoryWidth . 's', history.word)
        elseif l:num == 10
            let history.abbr = printf('0: %.' . g:VimShell_MaxHistoryWidth . 's', history.word)
        elseif l:num < 10
            let history.abbr = printf(l:abbr_pattern_d, l:num, history.word)
        else
            let history.abbr = printf(l:abbr_pattern_n, history.word)
        endif

        let l:num += 1
    endfor
    for history in l:complete_words[15:]
        let history.abbr = printf(l:abbr_pattern_n, history.word)
    endfor

    " Append list.
    let l:complete_words = extend(l:numbered_words, l:complete_words)

    " Save numbered lists.
    let s:prev_numbered_list = l:complete_words[1:10]

    return l:complete_words
endfunction"}}}

function! s:VimShell_HighlightEscapeSequence()"{{{
    let register_save = @"
    while search('\[[0-9;]*m', 'c')
        normal! dfm

        let [lnum, col] = getpos('.')[1:2]
        if len(getline('.')) == col
            let col += 1
        endif
        let syntax_name = 'EscapeSequenceAt_' . bufnr('%') . '_' . lnum . '_' . col
        execute 'syntax region' syntax_name 'start=+\%' . lnum . 'l\%' . col . 'c+ end=+\%$+' 'contains=ALL'

        let highlight = ''
        for color_code in split(matchstr(@", '[0-9;]\+'), ';')
            if color_code == 0
                let highlight .= ' ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE'
            elseif color_code == 1
                let highlight .= ' cterm=bold gui=bold'
            elseif 30 <= color_code && color_code <= 37
                let highlight .= ' ctermfg=' . (color_code - 30)
            elseif color_code == 38
                " TODO
            elseif color_code == 39
                " TODO
            elseif 40 <= color_code && color_code <= 47
                let highlight .= ' ctermbg=' . (color_code - 40)
            elseif color_code == 48
                " TODO
            elseif color_code == 49
                " TODO
            endif
        endfor
        if len(highlight)
            execute 'highlight' syntax_name highlight
        endif
    endwhile
    let @" = register_save
endfunction"}}}

augroup VimShell"{{{
    au!
    au BufEnter VimShell nmap <buffer><silent> <CR> <Plug>(vimshell_enter)
    au BufEnter VimShell imap <buffer><silent> <CR> <ESC><CR>
    au BufEnter VimShell nnoremap <buffer><silent> q :<C-u>hide<CR>
    au BufEnter VimShell inoremap <buffer> <C-j> <C-x><C-o><C-p>
augroup end"}}}

" Global options definition."{{{
if !exists('g:VimShell_Prompt')
    let g:VimShell_Prompt = 'VimShell% '
endif
if !exists('g:VimShell_HistoryPath')
    let g:VimShell_HistoryPath = $HOME.'/.vimshell_hist'
endif
if !exists('g:VimShell_HistoryMaxSize')
    let g:VimShell_HistoryMaxSize = 1000
endif
if !exists('g:VimShell_IgnoreCase')
    let g:VimShell_IgnoreCase = 1
endif
if !exists('g:VimShell_MaxHistoryWidth')
    let g:VimShell_MaxHistoryWidth = 40
endif
"}}}


let g:loaded_vimshell = 1
