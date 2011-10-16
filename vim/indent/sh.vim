"
" Script:
"
"   Super Shell indentation
"
" Version: 1.6
"
" Description:
"
"   This is a shell indentation script that calculates the indent level based
"   on begin/end syntax pairs, as opposed to complex conditionals and pattern
"   matching.
"
"   This script also introduces indentation for:
"
"           case blocks 
"           paren blocks
"           '[[' blocks
"           line continuation
"
" Installation:
"
"   Place this file in your home directory under ~/.vim/indent/, or replace
"   the system indent/sh.vim file to affect all users.
"
" Maintainer: Tye Z. <zdro@yahoo.com>
"
" Customization:
"
"   The only thing that can really be customized at this point is whether or
"   not a line is echoed explaining the indentation result.  To turn this on,
"   set the following variable like so:
"
"       let b:super_sh_indent_echo = 1
"
"
" History:
"
"   TODO:
"       - Differentiate between '\' and &&/||/| line continuations
"
"   Version 1.6:
"       - Performance improvements
"
"   Version 1.5:
"       - Fixed indentation of first line in a file
"       - Fixed ignoring of certain keywords in comments
"       - Tested on 6.2
"
"   Version 1.4:
"       - Fixed line continuation w/in comments and strings
"       - Fixed an infinite loop
"
"   Version 1.3:
"       - fixed elif (again)
"
"   Version 1.2:
"       - Ignore open/close pairs that are in strings
"       - Fixed super_sh_indent_echo
"       - Fixed else/elif
"
"

let SuperShIndent_Dbg = 0

if version < 602
    echoerr "Super Shell Indentation only supported for Vim 6.2 and up."
    finish
endif

" Only load this indent file when no other was loaded.
if exists("b:did_indent") && ! SuperShIndent_Dbg
  finish
endif

let b:did_indent = 1

setlocal indentexpr=SuperShIndent()
setlocal indentkeys+==then,=do,=else,=elif,=esac,=fi,=fin,=fil,=done
setlocal indentkeys-=:,0#

" Only define the function once.
if exists("*SuperShIndent") && ! SuperShIndent_Dbg
  finish
endif

setlocal indentexpr=SuperShIndent()

if ! exists("b:super_sh_indent_echo")
    let b:super_sh_indent_echo = 0
endif


function! SuperShIndent()

    let adj = 0  " Adjustment

    let g:lastindent = ""
    let currline = getline(v:lnum)
    let lastline = ''
    let prevline = ''

    " Find non-blank lines above the current line.
    let lastlnum = prevnonblank(v:lnum - 1)
    let prevlnum = prevnonblank(lastlnum - 1)
    if lastlnum != 0 
        let lastline = getline(lastlnum)
    endif
    if prevlnum != 0
        let prevline = getline(prevlnum)
    endif

    " Start from the first char on the line.  Vim doesn't seem to consistently
    " place the cursor there before calling the indent routines.
    call cursor(0, 1)
    call search('\S')

    "
    " Call indentation adjustment functions.
    "
    let adj = adj + GetPairIndent(currline, lastline, lastlnum, '(', '', ')')
    let adj = adj + GetPairIndent(currline, lastline, lastlnum, '\[\[', '', ']]')
    let adj = adj + GetPairIndent(currline, lastline, lastlnum,
                \ '{', '', '}')
    let adj = adj + GetPairIndent(currline, lastline, lastlnum,
                \ '\<do\>', '', '\<done\>')
    let adj = adj + GetPairIndent(currline, lastline, lastlnum,
                \ '\<case\>', '', '\<esac\>')
    let adj = adj + GetPairIndent(currline, lastline, lastlnum,
                \ '\<then\>', '\<else\>', '\(\<elif\>\|\<fi\>\)')

    let ContRE = '\(|\s*\|&&\s*\)$'
    let adj = adj + GetContIndent(ContRE, currline, lastline, lastlnum, prevlnum)
    let adj = adj + GetSimpleContIndent(lastline, lastlnum)

    let adj = adj + GetCaseIndent(currline, lastline, lastlnum)

    " Get default indent and add our adjustment
    let prevind = indent(lastlnum)
    let prevind = (prevind == -1 ? 0 : prevind)

    if b:super_sh_indent_echo
        echom g:lastindent
    endif

    return adj + prevind

endfunction

"
" Get additional indentation based on blocks of code, as defined by the Head
" and Tail patterns.
"
function! GetPairIndent(CurrLine, LastLine, LastLNum, Head, Mid, Tail)

    let levels = 0
    let adj = 0
    let origcol = col(".")
    let origline = line(".")

    "
    " How many levels were started on the last line?  Search backwards for
    " pair starters until we're not on the last nonblank.  If the last line
    " doesn't contain the pair-starter, then don't bother with searchpair();
    " it's a performance bottleneck because (I think) it will always search
    " all the way back until it finds a match or can't search any more.
    "
    if a:LastLine =~ a:Head
        while 1
            let pairstart = searchpair(a:Head, a:Mid, a:Tail, 'Wb')
            if pairstart == 0 || pairstart != a:LastLNum
                break
            endif
            let syn = synIDattr(synID(line("."), col("."), 1), "name")
            if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
                continue
            endif
            let levels = levels + 1
        endwhile
    endif

    " If we aren't within a level that was started on the last line, then
    " check how many levels were closed on the last line.
    if levels == 0

        " Move to the beginning of the last line
        call cursor(a:LastLNum,0)
        normal ^

        " If the line starts with an open, The close shouldn't be counted as
        " such, because we're looking for closes that didn't start on this
        " line.
        if a:LastLine =~ '^\s*' . a:Head || 
                    \ (a:Mid != '' && a:LastLine =~ '^\s*' . a:Mid)
            let levels = 1
        endif

        " If we're calculating close parens and this is a new case condition,
        " then the next close is the end of the conditional and we don't want
        " to count it.
        if a:Tail == ')'
            if "shCaseEsac" == synIDattr(synID(line("."), col("."), 1), "name")
                call searchpair(a:Head, a:Mid, a:Tail, 'W')
            endif
        endif

        "
        " Count the closes on the current line (i.e. LastLNum), stopping once
        " we've hit comments.  If the line doesn't even contain the end of the
        " pair, don't bother with searchpair() (same aforementioned
        " rationale).
        "
        if a:LastLine =~ a:Tail
            while 1
                let pairend = searchpair(a:Head, a:Mid, a:Tail, 'W')
                if pairend == 0 || a:LastLNum != pairend 
                    break
                endif
                let syn = synIDattr(synID(line("."), col("."), 1), "name")
                if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
                    break
                endif
                let levels = levels - 1
            endwhile
        endif
    endif

    " If the current line starts with a close, count it.  It won't effect the
    " indentation of the next line because it is the first thing on the line
    " and won't be counted as a "close on the last line".
    if a:CurrLine =~ '^\s*' . a:Tail 
                \ || (a:Mid != '' && a:CurrLine =~ '^\s*' . a:Mid)
        let levels = levels - 1
    endif

    " Restore original cursor location
    call cursor(origline, origcol)

    let adj = &sw*levels
    if adj != 0 && b:super_sh_indent_echo
        let g:lastindent = g:lastindent . 
                    \ "GetPairIndent(" . a:Head . "):" . adj . " "
    endif

    return adj

endfunction


"
" Get the proper indentation when inside a case ... esac block.  New case
" conditionals are lined up with the initial "case" and their statements are
" indented.
"
function! GetCaseIndent(CurrLine, LastLine, LastLNum)

    let adj = 0
    let syn = ""
    let lastsyn = ""

    " Get the syntax attribute for the previous two lines, unless they are
    " 'esac' lines.  'esac' is a special case, because it registers as
    " 'shCaseEsac', but indentation is decreased by stock indentation.
    if a:CurrLine !~ '^\s*esac'
        let syn = synIDattr(synID(line("."), 1, 1), "name")
    endif
    if a:LastLine !~ '^\s*esac'
        let lastsyn = synIDattr(synID(a:LastLNum, 1, 1), "name")
    endif

    " If this is a new case and the last line was body of the previous case,
    " decrease the indent.  Otherwise, if the last line was a new case and
    " this line is its body, increase the indent.
    if syn == "shCaseEsac" && lastsyn != 'shCaseEsac'
        let adj = adj - &sw
    elseif lastsyn == 'shCaseEsac' && syn != 'shCaseEsac'
        let adj = adj + &sw
    endif

    "
    " Return the result
    "
    if adj != 0 && b:super_sh_indent_echo
        let g:lastindent = g:lastindent . "GetCaseIndent:" . adj . " "
    endif
    return adj

endfunction

function! GetContIndent(Pattern, CurrLine, LastLine, LastLNum, PrevLNum)

    let adj = 0
    let origcol = col(".")
    let origline = line(".")
    let lastcont = 0
    let prevcont = 0

    " Get the last matching line number.  If the match occurs w/in a comment
    " or string, then it's a non-match.
    let lastmatchlnum = search(a:Pattern, 'Wb')
    let syn = synIDattr(synID(line("."), col("."), 1), "name")
    if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
        let lastmatchlnum = 0
    endif

    " Get the previous matching line number.  If the match occurs w/in a
    " comment or string, then it's a non-match.
    let prevmatchlnum = search(a:Pattern, 'Wb')
    let syn = synIDattr(synID(line("."), col("."), 1), "name")
    if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
        let prevmatchlnum = 0
    endif

    " Figure out the last and previous continuation status
    if lastmatchlnum && lastmatchlnum == a:LastLNum 
        let lastcont = 1
    endif
    if ( lastmatchlnum && lastmatchlnum == a:PrevLNum ) 
                \ || ( prevmatchlnum && prevmatchlnum == a:PrevLNum )
        let prevcont = 1
    endif

    "echom "lastcont: " . lastcont . 
    "            \ ", prevcont: " . prevcont . 
    "            \ ", lastmatchlnum: " . lastmatchlnum .
    "            \ ", prevmatchlnum: " . prevmatchlnum .
    "            \ ", lastlnum: " . a:LastLNum . 
    "            \ ", PrevLNum: " . a:PrevLNum

    if lastcont && !prevcont && a:CurrLine !~ '^\s*{'
        let adj = adj + &sw
    elseif !lastcont && prevcont && a:LastLine !~ '^\s*{'
        let adj = adj - &sw
    endif

    call cursor(origline, origcol)

    if adj != 0 && b:super_sh_indent_echo
        let g:lastindent = g:lastindent . 
                    \ "GetContIndent('" . a:Pattern . "'):" . adj . " "
    endif
    return adj

endfunction

"
" The '\' line continuation should only effect the following line, as opposed
" to the next non-blank line.
"
function! GetSimpleContIndent(LastLine, LastLNum)

    let adj = 0
    let currcol = col(".")
    let currline = line(".")
    let pcont = 0
    let p2cont = 0
    let pndendcont = 0
    let pnbcont = 0
    let ppnbcont = 0

    "
    " If the last non-blank is the immediatly previous line, then we'll look
    " at it and its previous.  Otherwise, we'll see if the prev-non-blank was
    " the end of a continuation.
    "
    if a:LastLNum == currline - 1
        " Preceding line
        let pline = getline(currline-1)
        if pline =~ '\\$'
            let pcont = 1
            let syn = synIDattr(synID(currline-1, strlen(pline), 1), "name")
            if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
                let pcont = 0
            endif
        endif

        " 2nd Preceding line
        let p2line = getline(currline-2)
        if p2line =~ '\\$'
            let p2cont = 1
            let syn = synIDattr(synID(currline-2, strlen(p2line), 1), "name")
            if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
                let p2cont = 0
            endif
        endif

        if pcont && !p2cont
            let adj = adj + &sw
        elseif !pcont && p2cont
            let adj = adj - &sw
        endif
    else
        if a:LastLine =~ '\\$'
            let pnb = getline(a:LastLNum)
            if pnb =~ '\\$'
                let syn = synIDattr(synID(a:LastLNum, strlen(pnb), 1), "name")
                if syn !~ 'shComment\|sh\(Single\|Double\)Quote'
                    let pnbcont = 1
                endif
            endif
        endif
        if ! pnbcont
            let ppnb = getline(a:LastLNum-1)
            if ppnb =~ '\\$'
                let syn = synIDattr(synID(a:LastLNum-1, strlen(ppnb), 1), "name")
                if syn !~ 'shComment\|sh\(Single\|Double\)Quote'
                    let ppnbcont = 1
                endif
            endif
        endif

        if ! pnbcont && ppnbcont
            let adj = adj - &sw
        endif
    endif

    if adj != 0 && b:super_sh_indent_echo
        let g:lastindent = g:lastindent . 
                    \ "GetSimpleContIndent():" . adj . " "
    endif
    return adj

endfunction




" Try to do things without using searchpair?
"


function! BalancedCount(String, Open, Close)

    let trimmed = substitute(a:String, '[^\]#.*$', '', '')
    echo trimmed

    " This won't really work when a string traverses lines...
    let trimmed = substitute(trimmed, '\([^\\]\@<="\(\\"\|[^"]\)*"\)', '', 'g')

    echo trimmed

endfunction

function! TstBC()
    call BalancedCount('   foo("{(()((\"""") {}; { # bar', "{", "}")
endfunction

function! GetPairIndent(CurrLine, LastLine, LastLNum, Head, Mid, Tail)

    let levels = 0
    let adj = 0
    let origcol = col(".")
    let origline = line(".")

    " How many levels were started on the last line?  Search backwards for
    " pair starters until we're not on the last nonblank.
    if a:LastLine =~ a:Head
        while 1
            let pairstart = searchpair(a:Head, a:Mid, a:Tail, 'Wb')
            if pairstart == 0 || pairstart != a:LastLNum
                break
            endif
            let syn = synIDattr(synID(line("."), col("."), 1), "name")
            if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
                continue
            endif
            let levels = levels + 1
        endwhile
    endif

    " If we aren't within a level that was started on the last line, then
    " check how many levels were closed on the last line.
    if levels == 0

        " Move to the beginning of the last line
        call cursor(a:LastLNum,0)
        normal ^

        " If the line starts with an open, The close shouldn't be counted as
        " such, because we're looking for closes that didn't start on this
        " line.
        if a:LastLine =~ '^\s*' . a:Head || 
                    \ (a:Mid != '' && a:LastLine =~ '^\s*' . a:Mid)
            let levels = 1
        endif

        " If we're calculating close parens and this is a new case condition,
        " then the next close is the end of the conditional and we don't want
        " to count it.
        if a:Tail == ')'
            if "shCaseEsac" == synIDattr(synID(line("."), col("."), 1), "name")
                call searchpair(a:Head, a:Mid, a:Tail, 'W')
            endif
        endif

        " Count the closes on the current line (i.e. LastLNum), stopping once
        " we've hit comments.
        if a:LastLine =~ a:Tail
            while 1
                let pairend = searchpair(a:Head, a:Mid, a:Tail, 'W')
                if pairend == 0 || a:LastLNum != pairend 
                    break
                endif
                let syn = synIDattr(synID(line("."), col("."), 1), "name")
                if syn =~ 'shComment\|sh\(Single\|Double\)Quote'
                    break
                endif
                let levels = levels - 1
            endwhile
        endif
    endif

    " If the current line starts with a close, count it.  It won't effect the
    " indentation of the next line because it is the first thing on the line
    " and won't be counted as a "close on the last line".
    if a:CurrLine =~ '^\s*' . a:Tail 
                \ || (a:Mid != '' && a:CurrLine =~ '^\s*' . a:Mid)
        let levels = levels - 1
    endif

    " Restore original cursor location
    call cursor(origline, origcol)

    let adj = &sw*levels
    if adj != 0 && b:super_sh_indent_echo
        let g:lastindent = g:lastindent . 
                    \ "GetPairIndent(" . a:Head . "):" . adj . " "
    endif

    return adj

endfunction
