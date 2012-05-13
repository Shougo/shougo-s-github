" Vim syntax file
" Language:     RDoc - Ruby Documentation
" Maintainer:   Hallison Batista <email@hallisonbatista.com>
" URL:          http://hallisonbatista.com/projetos/rdoc.vim
" Version:      1.0.0
" Last Change:  Fri Dec  4 09:47:32 AMT 2009
" Remark:       Inspired in Markdown syntax written by Ben Williams <benw@plasticboy.com>.
"               http://www.vim.org/scripts/script.php?script_id=1242

" Read the HTML syntax to start with
if version < 600
  source <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink highlight link <args>
else
  command! -nargs=+ HtmlHiLink highlight def link <args>
endif

syntax spell toplevel
syntax case ignore
syntax sync linebreaks=1

" RDoc text markup
syntax region rdocBold      start=/\\\@<!\(^\|\A\)\@=\*\(\s\|\W\)\@!\(\a\{1,}\s\|$\n\)\@!/ skip=/\\\*/ end=/\*\($\|\A\|\s\|\n\)\@=/ contains=@Spell
syntax region rdocEmphasis  start=/\\\@<!\(^\|\A\)\@=_\(\s\|\W\)\@!\(\a\{1,}\s\|$\n\)\@!/  skip=/\\_/  end=/_\($\|\A\|\s\|\n\)\@=/  contains=@Spell
syntax region rdocMonospace start=/\\\@<!\(^\|\A\)\@=+\(\s\|\W\)\@!\(\a\{1,}\s\|$\n\)\@!/  skip=/\\+/  end=/+\($\|\A\|\s\|\n\)\@=/  contains=@Spell

" RDoc links: {link}[URL]
syntax region rdocLink matchgroup=rdocDelimiter start="\!\?{" end="}\ze\s*[\[\]]" contains=@Spell nextgroup=rdocURL,rdocID skipwhite oneline
syntax region rdocID   matchgroup=rdocDelimiter start="{"     end="}"  contained
syntax region rdocURL  matchgroup=rdocDelimiter start="\["    end="\]" contained

" Define RDoc markup groups
syntax match  rdocLineContinue ".$" contained
syntax match  rdocRule      /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syntax match  rdocRule      /^\s*-\s\{0,1}-\s\{0,1}-$/
syntax match  rdocRule      /^\s*_\s\{0,1}_\s\{0,1}_$/
syntax match  rdocRule      /^\s*-\{3,}$/
syntax match  rdocRule      /^\s*\*\{3,5}$/
syntax match  rdocListItem  "^\s*[-*+]\s\+"
syntax match  rdocListItem  "^\s*\d\+\.\s\+"
syntax match  rdocLineBreak /  \+$/

" RDoc pre-formatted markup
" syntax region rdocCode      start=/\s*``[^`]*/          end=/[^`]*``\s*/
syntax match  rdocCode  /^\s*\n\(\(\s\{1,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syntax region rdocCode  start="<pre[^>]*>"         end="</pre>"
syntax region rdocCode  start="<code[^>]*>"        end="</code>"

" RDoc HTML headings
syntax region htmlH1  start="^\s*="       end="\($\)" contains=@Spell
syntax region htmlH2  start="^\s*=="      end="\($\)" contains=@Spell
syntax region htmlH3  start="^\s*==="     end="\($\)" contains=@Spell
syntax region htmlH4  start="^\s*===="    end="\($\)" contains=@Spell
syntax region htmlH5  start="^\s*====="   end="\($\)" contains=@Spell
syntax region htmlH6  start="^\s*======"  end="\($\)" contains=@Spell

" Highlighting for RDoc groups
HtmlHiLink rdocCode         String
HtmlHiLink rdocBlockquote   Comment
HtmlHiLink rdocLineContinue Comment
HtmlHiLink rdocListItem     Identifier
HtmlHiLink rdocRule         Identifier
HtmlHiLink rdocLineBreak    Todo
HtmlHiLink rdocLink         htmlLink
HtmlHiLink rdocURL          htmlString
HtmlHiLink rdocID           Identifier
HtmlHiLink rdocBold         htmlBold
HtmlHiLink rdocEmphasis     htmlItalic
HtmlHiLink rdocMonospace    String

HtmlHiLink rdocDelimiter     Delimiter

let b:current_syntax = "rdoc"

delcommand HtmlHiLink

" vim: tabstop=2
