"=============================================================================
" FILE: vimshell.vim
" AUTHOR: Janakiraman .S <prince@india.ti.com>(Original)
"         Shougo Matsushita <Shougo.Matsu@gmail.com>(Modified)
" Last Modified: 16 Jan 2009
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
" Version: 3.4, for Vim 7.0
"-----------------------------------------------------------------------------
" ChangeLog: "{{{
"   3.4:
"     - Fixed filename escape bug.
"     - Fixed vimshell buffer clear when hide.
"     - No setlocal lazyredraw.
"     - Filename escape when cd.
"     - Implemented pseudo shell variable.
"   3.3:
"     - Changed escape sequence into "\<ESC>".
"     - Changed autocmd timing.
"     - Added filename escape.
"     - Added vimshell_split_switch, vimshell_switch, vimshell_split_create, vimshell_create.
"     - Can have multiple Vimshell instance.
"   3.2:
"     - Fixed space name command bug.
"     - Fixed quick match bug.
"     - Implemented vim and view command.
"   3.1:
"     - Fixed ATOK X3 is ON  when startinsert.
"     - Silent message if exit code isn't 0.
"   3.0:
"     - Do startinsert! after command executed.
"     - Added g:VimShell_QuickMatchMaxLists option.
"     - Added g:VimShell_QuickMatchEnable option.
"     - Implemented two digits quick match.
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
nnoremap <silent> <Plug>(vimshell_split_switch)  :<C-u>call <SID>VimShell_SwitchShell(1)<CR>
nnoremap <silent> <Plug>(vimshell_split_create)  :<C-u>call <SID>VimShell_CreateShell(1)<CR>
nnoremap <silent> <Plug>(vimshell_switch)  :<C-u>call <SID>VimShell_SwitchShell(0)<CR>
nnoremap <silent> <Plug>(vimshell_create)  :<C-u>call <SID>VimShell_CreateShell(0)<CR>
nnoremap <silent> <Plug>(vimshell_enter)  :<C-u>call <SID>VimShell_ProcessEnter()<CR>
nmap <silent> <Leader>sp     <Plug>(vimshell_split_switch)
nmap <silent> <Leader>sn     <Plug>(vimshell_split_create)
nmap <silent> <Leader>sh     <Plug>(vimshell_switch)
nmap <silent> <Leader>sc     <Plug>(vimshell_create)

command! -nargs=0 VimShell call s:VimShell_SwitchShell(0)

function! s:VimShell_SwitchShell(split_flag)"{{{
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

            call s:VimShell_PrintPrompt()
        else
            " Create window.
            call s:VimShell_CreateShell(a:split_flag)
        endif
    endif
endfunction"}}}

function! s:VimShell_CreateShell(split_flag)"{{{
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
    let &l:omnifunc = 'g:VimShell_HistoryComplete'
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
        echo "Not on the command line."
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

    " Delete head spaces.
    let l:line = substitute(l:line, '^\s\+', '', '')
    let l:program = split(l:line)[0]
    let l:argments = substitute(l:line, '^' . l:program, '', '')

    " Special commands.
    if l:program == 'clear'
        " If it says clean, Clean up the screen.
        % delete _
        call s:VimShell_PrintPrompt()

        " Enter insert mode.
        startinsert!
        set iminsert=0 imsearch=0
        return
    elseif l:program == 'command'
        execute 'silent read! ' . l:argments
    elseif l:program =~ '^\h\w*='
        execute 'let $' . l:program
    else
        " Internal commands.
        if l:program == 'cd' || l:line == 'lcd'
            " If the command is a cd, Change the working directory.
            let l:line = substitute(l:line, '^\s*cd', 'lcd', '')

            " Filename escape.
            let l:line = escape(l:line, " \t\n*?[]{}`$\\%#'\"|!<")

            execute l:line
        elseif l:line == 'ls'
            let l:words = split(l:line)
            if len(l:words) == 1
                if has('win32')
                    execute 'silent read! ls .'
                else
                    execute 'silent read! ls -FC'
                endif
            else
                execute 'silent read! ' . l:line
            endif
        elseif l:program == 'vim'
            call s:VimShell_PrintPrompt()

            " Edit file.
            let l:filename = strpart(l:line, matchend(l:line, '^\s*vim\s*'))
            "split
            if empty(l:filename)
                enew
            else
                execute 'edit ' . l:filename
            endif

            return
        elseif l:program == 'view'
            call s:VimShell_PrintPrompt()

            " Edit file with readonly.
            let l:filename = strpart(l:line, matchend(l:line, '^\s*view\s*'))
            if empty(l:filename)
                echo 'Filename required.'
            else
                split
                execute 'edit ' . l:filename
                setlocal nomodifiable
            endif

            return
            " External commands.
        elseif l:program =~ '^\w'
            execute 'silent read! ' . l:line
        endif
    endif


    if line('.') == line('$')
        " Insert blank line.
        call append(line('$'), '')
        normal! j
    endif

    call s:VimShell_HighlightEscapeSequence()

    call s:VimShell_PrintPrompt()

    " Enter insert mode.
    startinsert!
    set iminsert=0 imsearch=0
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

function! s:VimShell_HighlightEscapeSequence()"{{{
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

augroup VimShell"{{{
    au!
    au Filetype VimShell nmap <buffer><silent> <CR> <Plug>(vimshell_enter)
    au Filetype VimShell imap <buffer><silent> <CR> <ESC><CR>
    au Filetype VimShell nnoremap <buffer><silent> q :<C-u>hide<CR>
    au Filetype VimShell inoremap <buffer> <C-j> <C-x><C-o><C-p>
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


let g:loaded_vimshell = 1
