"=============================================================================
" FILE: vimshell.vim
" AUTHOR: Janakiraman .S <prince@india.ti.com>(Original)
"         Shougo Matsushita <Shougo.Matsu@gmail.com>(Modified)
" Last Modified: 22 Jan 2009
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
" Version: 3.8, for Vim 7.0
"=============================================================================

function! vimshell#switch_shell(split_flag)"{{{
    if expand('%:p:t') == 'VimShell'
        echo 'Already there.'
    else
        if bufexists('VimShell')
            if a:split_flag
                let l:num = bufwinnr('VimShell')
                if l:num < 0
                    sbuffer VimShell
                    setfiletype vimshell
                else
                    " Switch window.
                    execute l:num 'wincmd w'
                endif
            else
                buffer VimShell
            endif

            " Enter insert mode.
            startinsert!
            set iminsert=0 imsearch=0

            call s:print_prompt()
        else
            " Create window.
            call vimshell#create_shell(a:split_flag)
        endif
    endif
endfunction"}}}

function! vimshell#create_shell(split_flag)"{{{
    let l:bufname = 'VimShell'
    let l:cnt = 2
    while bufexists(l:bufname)
        let l:bufname = printf('[%d]VimShell', l:cnt)
        let l:cnt += 1
    endwhile

    if a:split_flag
        execute 'split ' . l:bufname
    else
        execute 'edit ' . l:bufname
    endif

    setlocal buftype=nofile
    setlocal noswapfile
    let &l:omnifunc = 'vimshell#history_complete'
    setfiletype vimshell

    " Load history.
    if !filereadable(g:VimShell_HistoryPath)
        " Create file.
        call writefile([], g:VimShell_HistoryPath)
    endif
    let s:hist_buffer = readfile(g:VimShell_HistoryPath)
    let s:hist_size = getfsize(g:VimShell_HistoryPath)

    if !exists('s:prev_numbered_list')
        let s:prev_numbered_list = []
    endif
    if !exists('s:prepre_numbered_list')
        let s:prepre_numbered_list = []
    endif

    " Enter insert mode.
    startinsert!
    set iminsert=0 imsearch=0

    call s:print_prompt()
endfunction"}}}

function! s:print_prompt()"{{{
    let l:escaped = escape(getline('.'), "\'")
    " Search prompt
    if match(l:escaped, g:VimShell_Prompt) < 0
        " Prompt not found
        if !empty(l:escaped)
            " Insert prompt line.
            call append(line('.'), g:VimShell_Prompt)
            normal! j
        else
            " Set prompt line.
            call setline(line('.'), g:VimShell_Prompt)
        endif
        normal! $
    else
        " Insert prompt line.
        call append(line('.'), g:VimShell_Prompt)
        normal! j$
    endif
    let &modified = 0
endfunction"}}}

function! vimshell#process_enter()"{{{
    "let l:escaped = escape(getline('.'), "\"\'")
    let l:escaped = getline('.')
    let l:prompt_pos = match(l:escaped, g:VimShell_Prompt)
    if l:prompt_pos < 0
        " Prompt not found
        echo "Not on the command line."
        normal! j
        return
    endif

    if line('.') != line('$')
        " History execution.
        if match(getline('$'), g:VimShell_Prompt) < 0
            " Insert prompt line.
            call append(line('$'), getline('.'))
        else
            " Set prompt line.
            call setline(line('$'), getline('.'))
        endif
        normal! G$
    endif

    " Delete prompt string.
    let l:line = substitute(l:escaped, g:VimShell_Prompt, '', '')

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

    " Delete head spaces.
    let l:line = substitute(l:line, '^\s\+', '', '')
    let l:program = (empty(l:line))? '' : split(l:line)[0]
    let l:argments = substitute(l:line, '^' . l:program . '\s*', '', '')

    " Special commands.
    if l:program == 'exit'
        " Exit vimshell.
        " Insert prompt line.
        call s:print_prompt()
        buffer #
        return
    elseif l:program == 'command'
        execute 'silent read! ' . l:argments
    elseif l:program =~ '^\h\w*='
        " Variables substitution.
        execute 'silent let $' . l:program
    elseif l:argments =~ '&\s*$'
        " Background execution.
        if has('win32') || has('win64')
            silent execute printf('!start %s %s', l:program, substitute(l:argments, '&\s*$', '', ''))
        elseif &term =~ "^screen"
            silent execute printf('!screen %s %s', l:program, substitute(l:argments, '&\s*$', '', ''))
        else
            execute printf('!%s %s', l:program, substitute(l:argments, '&\s*$', '', ''))
        endif
    elseif l:program =~ '^!'
        " Shell execution.
        execute printf('%s %s', l:program, l:argments)
    elseif l:program == 'vim' || l:program == 'view'
        " Edit file.
        
        call s:print_prompt()

        " Filename escape
        let l:argments = escape(l:argments, " \t\n*?[]{}`$\\%#'\"|!<")

        if l:program == 'vim'
            if empty(l:argments)
                new
            else
                split
                execute 'edit ' . l:argments
            endif
        else
            if empty(l:argments)
                echo 'Filename required.'
            else
                split
                execute 'edit ' . l:argments
                setlocal nomodifiable
            endif
        endif

        return
    else
        " Internal commands.
        if l:program == 'clear'
            " If it says clean, Clean up the screen.
            % delete _
        elseif l:program == 'cd'
            " If the command is a cd, Change the working directory.

            " Filename escape.
            let l:argments = escape(l:argments, " \t\n*?[]{}`$\\%#'\"|!<")

            execute 'lcd ' . l:argments
        elseif l:program == 'ls'
            let l:words = split(l:line)
            if len(l:words) == 1
                if has('win32')
                    execute 'silent read! ls .'
                else
                    execute 'silent read! ls -FC'
                endif
            else
                execute printf('silent read! %s %s', l:program, l:argments)
            endif
        elseif l:program == 'shell'
            " Starts shell.
            shell
        else
            " External commands.
            execute printf('silent read! %s %s', l:program, l:argments)
        endif
    endif

    call s:print_prompt()
    call s:highlight_escape_sequence()

    " Enter insert mode.
    startinsert!
    set iminsert=0 imsearch=0
endfunction"}}}

function! vimshell#history_complete(findstart, base)"{{{
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

    if g:VimShell_QuickMatchEnable
        " Append numbered list.
        if match(l:cur_keyword_str, '\d$') >= 0
            " Get numbered list.
            let l:numbered = get(s:prev_numbered_list, str2nr(matchstr(l:cur_keyword_str, '\d$')))
            if type(l:numbered) == type({})
                call insert(l:complete_words, l:numbered)
            endif

            " Get next numbered list.
            if match(l:cur_keyword_str, '\d\d$') >= 0
                let l:num = str2nr(matchstr(l:cur_keyword_str, '\d\d$'))-10
                if l:num >= 0
                    unlet l:numbered
                    let l:numbered = get(s:prepre_numbered_list, l:num)
                    if type(l:numbered) == type({})
                        call insert(l:complete_words, l:numbered)
                    endif
                endif
            endif
        endif

        " Check dup.
        let l:dup_check = {}
        let l:num = 0
        let l:numbered_words = []
        for history in l:complete_words[:g:VimShell_QuickMatchMaxLists]
            if !empty(history.word) && !has_key(l:dup_check, history.word)
                let l:dup_check[history.word] = 1

                call add(l:numbered_words, history)
            endif
            let l:num += 1
        endfor

        " Add number.
        let l:num = 0
        let l:abbr_pattern_d = '%2d: %.' . g:VimShell_MaxHistoryWidth . 's'
        for history in l:numbered_words
            let history.abbr = printf(l:abbr_pattern_d, l:num, history.word)

            let l:num += 1
        endfor
        let l:abbr_pattern_n = '    %.' . g:VimShell_MaxHistoryWidth . 's'
        for history in l:complete_words[g:VimShell_QuickMatchMaxLists :]
            let history.abbr = printf(l:abbr_pattern_n, history.word)
        endfor

        " Append list.
        let l:complete_words = extend(l:numbered_words, l:complete_words)

        " Save numbered lists.
        let s:prepre_numbered_list = s:prev_numbered_list[10:g:VimShell_QuickMatchMaxLists-1]
        let s:prev_numbered_list = l:complete_words[:g:VimShell_QuickMatchMaxLists-1]
    endif

    return l:complete_words
endfunction"}}}

function! s:highlight_escape_sequence()"{{{
    let register_save = @"
    "while search('\[[0-9;]*m', 'c')
    while search("\<ESC>\\[[0-9;]*m", 'c')
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

function! vimshell#insert_command()"{{{
    let l:in = input('Command name completion: ', expand('<cword>'), 'shellcmd')
    " For ATOK X3.
    set iminsert=0 imsearch=0

    if !empty(l:in)
        execute 'normal! ciw' . l:in
    endif
endfunction"}}}

augroup VimShell"{{{
    au!
    au Filetype vimshell nmap <buffer><silent> <CR> <Plug>(vimshell_enter)
    au Filetype vimshell imap <buffer><silent> <CR> <ESC><CR>
    au Filetype vimshell nnoremap <buffer><silent> q :<C-u>hide<CR>
    au Filetype vimshell inoremap <buffer> <C-j> <C-x><C-o><C-p>
    au Filetype vimshell inoremap <buffer> <C-p> <C-o>:<C-u>call vimshell#insert_command()<CR>
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
if !exists('g:VimShell_QuickMatchEnable')
    let g:VimShell_QuickMatchEnable = 1
endif
if !exists('g:VimShell_QuickMatchMaxLists')
    let g:VimShell_QuickMatchMaxLists = 40
endif
"}}}

" vim: foldmethod=marker
