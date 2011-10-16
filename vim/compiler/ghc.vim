" Vim Compiler File
" Compiler:	GHC
" Maintainer:	Claus Reinke <claus.reinke@talk21.com>
" Last Change:	30/04/2009
"
" part of haskell plugins: http://projects.haskell.org/haskellmode-vim

" ------------------------------ paths & quickfix settings first
"

if exists("current_compiler") && current_compiler == "ghc"
  finish
endif
let current_compiler = "ghc"

let s:scriptname = "ghc.vim"

if (!exists("g:ghc") || !executable(g:ghc)) 
  if !executable('ghc') 
    echoerr s:scriptname.": can't find ghc. please set g:ghc, or extend $PATH"
    finish
  else
    let g:ghc = 'ghc'
  endif
endif    
let ghc_version = substitute(system(g:ghc . ' --numeric-version'),'\n','','')
if (!exists("b:ghc_staticoptions"))
  let b:ghc_staticoptions = ''
endif

" set makeprg (for quickfix mode) 
execute 'setlocal makeprg=' . g:ghc . '\ ' . escape(b:ghc_staticoptions,' ') .'\ -e\ :q\ %'
"execute 'setlocal makeprg=' . g:ghc .'\ -e\ :q\ %'
"execute 'setlocal makeprg=' . g:ghc .'\ --make\ %'

"CompilerSet makeprg=ghc\ --make\ -v0\ Main\ -fwarn-unused-binds\ -fwarn-unused-imports\ -fwarn-unused-matches\ -prof\ -auto-all
"CompilerSet errorformat=
            "\%f:%l:%v:\ %tarning:\ %m,
            "\%f:%l:%v:\ %m,
            "\%A%f:%l:%v:,
            "\%C\ \ \ \ \ \ %[%^\ ]%\\@=%m,
            "\%Z\ \ \ \ %[%^\ ]%\\@=%m,
            "\%E%>Module\ imports\ form\ a\ cycle\ for\ modules:,
            "\%C%>%*\\s%m

" quickfix mode: 
" fetch file/line-info from error message
" TODO: how to distinguish multiline errors from warnings?
"       (both have the same header, and errors have no common id-tag)
"       how to get rid of first empty message in result list?
setlocal errorformat=
                    \%-Z\ %#,
                    \%W%f:%l:%c:\ Warning:\ %m,
                    \%E%f:%l:%c:\ %m,
                    \%E%>%f:%l:%c:,
                    \%+C\ \ %#%m,
                    \%W%>%f:%l:%c:,
                    \%+C\ \ %#%tarning:\ %m,

" oh, wouldn't you guess it - ghc reports (partially) to stderr..
setlocal shellpipe=2>

" ------------------------- but ghc can do a lot more for us..
"

" allow map leader override
if !exists("maplocalleader")
  let maplocalleader='_'
endif

" initialize map of identifiers to their types
" associate type map updates to changedtick
if !exists("b:ghc_types")
  let b:ghc_types = {}
  let b:my_changedtick = b:changedtick
endif

if exists("g:haskell_functions")
  finish
endif
let g:haskell_functions = "ghc"

" avoid hit-enter prompts
set cmdheight=3

" edit static GHC options
" TODO: add completion for options/packages?
command! GHCStaticOptions call GHC_StaticOptions()
function! GHC_StaticOptions()
  let b:ghc_staticoptions = input('GHC static options: ',b:ghc_staticoptions)
  execute 'setlocal makeprg=' . g:ghc . '\ ' . escape(b:ghc_staticoptions,' ') .'\ -e\ :q\ %'
  let b:my_changedtick -=1
endfunction

map <LocalLeader>T :call GHC_ShowType(1)<cr>
map <LocalLeader>t :call GHC_ShowType(0)<cr>
function! GHC_ShowType(addTypeDecl)
  let namsym   = haskellmode#GetNameSymbol(getline('.'),col('.'),0)
  if namsym==[]
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [_,symb,qual,unqual] = namsym
  let name  = qual=='' ? unqual : qual.'.'.unqual
  let pname = ( symb ? '('.name.')' : name ) 
  call GHC_HaveTypes()
  if !has_key(b:ghc_types,name)
    redraw
    echo pname "type not known"
  else
    redraw
    for type in split(b:ghc_types[name],' -- ')
      echo pname "::" type
      if a:addTypeDecl
        call append( line(".")-1, pname . " :: " . type )
      endif
    endfor
  endif
endfunction

" show type of identifier under mouse pointer in balloon
if has("balloon_eval")
  set ballooneval
  set balloondelay=600
  set balloonexpr=GHC_TypeBalloon()
  function! GHC_TypeBalloon()
    if exists("b:current_compiler") && b:current_compiler=="ghc" 
      let [line] = getbufline(v:beval_bufnr,v:beval_lnum)
      let namsym = haskellmode#GetNameSymbol(line,v:beval_col,0)
      if namsym==[]
        return ''
      endif
      let [start,symb,qual,unqual] = namsym
      let name  = qual=='' ? unqual : qual.'.'.unqual
      let pname = name " ( symb ? '('.name.')' : name )
      silent call GHC_HaveTypes()
      if has("balloon_multiline")
        return (has_key(b:ghc_types,pname) ? split(b:ghc_types[pname],' -- ') : '') 
      else
        return (has_key(b:ghc_types,pname) ? b:ghc_types[pname] : '') 
      endif
    else
      return ''
    endif
  endfunction
endif

map <LocalLeader>si :call GHC_ShowInfo()<cr>
function! GHC_ShowInfo()
  let namsym   = haskellmode#GetNameSymbol(getline('.'),col('.'),0)
  if namsym==[]
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [_,symb,qual,unqual] = namsym
  let name = qual=='' ? unqual : (qual.'.'.unqual)
  let output = GHC_Info(name)
  pclose | new 
  setlocal previewwindow
  setlocal buftype=nofile
  setlocal noswapfile
  put =output
  wincmd w
  "redraw
  "echo output
endfunction

" fill the type map, unless nothing has changed since the last attempt
function! GHC_HaveTypes()
  if b:ghc_types == {} && (b:my_changedtick != b:changedtick)
    let b:my_changedtick = b:changedtick
    return GHC_BrowseAll()
  endif
endfunction

" update b:ghc_types after successful make
au QuickFixCmdPost make if GHC_CountErrors()==0 | silent call GHC_BrowseAll() | endif

" count only error entries in quickfix list, ignoring warnings
function! GHC_CountErrors()
  let c=0
  for e in getqflist() | if e.type=='E' && e.text !~ "^[ \n]*Warning:" | let c+=1 | endif | endfor
  return c
endfunction

command! GHCReload call GHC_BrowseAll()
function! GHC_BrowseAll()
  " let imports = haskellmode#GatherImports()
  " let modules = keys(imports[0]) + keys(imports[1])
  let imports = {} " no need for them at the moment
  let current = GHC_NameCurrent()
  let module = current==[] ? 'Main' : current[0]
  if GHC_VersionGE([6,8,1])
    return GHC_BrowseBangStar(module)
  else
    return GHC_BrowseMultiple(imports,['*'.module])
  endif
endfunction

function! GHC_VersionGE(target)
  let current = split(g:ghc_version, '\.' )
  let target  = a:target
  for i in current
    if ((target==[]) || (i>target[0]))
      return 1
    elseif (i==target[0])
      let target = target[1:]
    else
      return 0
    endif
  endfor
  return 1
endfunction

function! GHC_NameCurrent()
  let last = line("$")
  let l = 1
  while l<last
    let ml = matchlist( getline(l), '^module\s*\([^ (]*\)')
    if ml != []
      let [_,module;x] = ml
      return [module]
    endif
    let l += 1
  endwhile
  redraw
  echo "cannot find module header for file " . expand("%")
  return []
endfunction

function! GHC_BrowseBangStar(module)
  redraw
  echo "browsing module " a:module
  let command = ":browse! *" . a:module
  let orig_shellredir = &shellredir
  let &shellredir = ">" " ignore error/warning messages, only output or lack of it
  let output = system(g:ghc . ' ' . b:ghc_staticoptions . ' -v0 --interactive ' . expand("%") , command )
  let &shellredir = orig_shellredir
  return GHC_ProcessBang(a:module,output)
endfunction

function! GHC_BrowseMultiple(imports,modules)
  redraw
  echo "browsing modules " a:modules
  let command = ":browse " . join( a:modules, " \n :browse ") 
  let command = substitute(command,'\(:browse \(\S*\)\)','putStrLn "-- \2" \n \1','g')
  let output = system(g:ghc . ' ' . b:ghc_staticoptions . ' -v0 --interactive ' . expand("%") , command )
  return GHC_Process(a:imports,output)
endfunction

function! GHC_Info(what)
  " call GHC_HaveTypes()
  let output = system(g:ghc . ' ' . b:ghc_staticoptions . ' -v0 --interactive ' . expand("%"), ":i ". a:what)
  return output
endfunction

function! GHC_ProcessBang(module,output)
  let module      = a:module
  let b           = a:output
  let linePat     = '^\(.\{-}\)\n\(.*\)'
  let contPat     = '\s\+\(.\{-}\)\n\(.*\)'
  let typePat     = '^\(\)\(\S*\)\s*::\(.*\)'
  let commentPat  = '^-- \(\S*\)'
  let definedPat  = '^-- defined locally'
  let importedPat = '^-- imported via \(.*\)'
  if !(b=~commentPat)
    echo s:scriptname.": GHCi reports errors (try :make?)"
    return 0
  endif
  let b:ghc_types = {}
  let ml = matchlist( b , linePat )
  while ml != []
    let [_,l,rest;x] = ml
    let mlDecl = matchlist( l, typePat )
    if mlDecl != []
      let [_,indent,id,type;x] = mlDecl
      let ml2 = matchlist( rest , '^'.indent.contPat )
      while ml2 != []
        let [_,c,rest;x] = ml2
        let type .= c
        let ml2 = matchlist( rest , '^'.indent.contPat )
      endwhile
      let id   = substitute( id, '^(\(.*\))$', '\1', '')
      let type = substitute( type, '\s\+', " ", "g" )
      " using :browse! *<current>, we get both unqualified and qualified ids
      let qualified = (id =~ '\.') && (id =~ '[A-Z]')
      let b:ghc_types[id] = type
      if !qualified
        for qual in qualifiers
          let b:ghc_types[qual.'.'.id] = type
        endfor
      endif
    else
      let mlImported = matchlist( l, importedPat )
      let mlDefined  = matchlist( l, definedPat )
      if mlImported != []
        let [_,modules;x] = mlImported
        let qualifiers = split( modules, ', ' )
      elseif mlDefined != []
        let qualifiers = [module]
      endif
    endif
    let ml = matchlist( rest , linePat )
  endwhile
  return 1
endfunction

function! GHC_Process(imports,output)
  let b       = a:output
  let imports = a:imports
  let linePat = '^\(.\{-}\)\n\(.*\)'
  let contPat = '\s\+\(.\{-}\)\n\(.*\)'
  let typePat = '^\(\s*\)\(\S*\)\s*::\(.*\)'
  let modPat  = '^-- \(\S*\)'
  " add '-- defined locally' and '-- imported via ..'
  if !(b=~modPat)
    echo s:scriptname.": GHCi reports errors (try :make?)"
    return 0
  endif
  let b:ghc_types = {}
  let ml = matchlist( b , linePat )
  while ml != []
    let [_,l,rest;x] = ml
    let mlDecl = matchlist( l, typePat )
    if mlDecl != []
      let [_,indent,id,type;x] = mlDecl
      let ml2 = matchlist( rest , '^'.indent.contPat )
      while ml2 != []
        let [_,c,rest;x] = ml2
        let type .= c
        let ml2 = matchlist( rest , '^'.indent.contPat )
      endwhile
      let id   = substitute(id, '^(\(.*\))$', '\1', '')
      let type = substitute( type, '\s\+', " ", "g" )
      " using :browse *<current>, we get both unqualified and qualified ids
      if current_module " || has_key(imports[0],module) 
        if has_key(b:ghc_types,id) && !(matchstr(b:ghc_types[id],escape(type,'[].'))==type)
          let b:ghc_types[id] .= ' -- '.type
        else
          let b:ghc_types[id] = type
        endif
      endif
      if 0 " has_key(imports[1],module) 
        let qualid = module.'.'.id
        let b:ghc_types[qualid] = type
      endif
    else
      let mlMod = matchlist( l, modPat )
      if mlMod != []
        let [_,module;x] = mlMod
        let current_module = module[0]=='*'
        let module = current_module ? module[1:] : module
      endif
    endif
    let ml = matchlist( rest , linePat )
  endwhile
  return 1
endfunction

let s:ghc_templates = ["module _ () where","class _ where","class _ => _ where","instance _ where","instance _ => _ where","type family _","type instance _ = ","data _ = ","newtype _ = ","type _ = "]

" use ghci :browse index for insert mode omnicompletion (CTRL-X CTRL-O)
function! GHC_CompleteImports(findstart, base)
  if a:findstart 
    let namsym   = haskellmode#GetNameSymbol(getline('.'),col('.'),-1) " insert-mode: we're 1 beyond the text
    if namsym==[]
      redraw
      echo 'no name/symbol under cursor!'
      return -1
    endif
    let [start,symb,qual,unqual] = namsym
    return (start-1)
  else " find keys matching with "a:base"
    let res = []
    let l   = len(a:base)-1
    call GHC_HaveTypes()
    for key in keys(b:ghc_types) 
      if key[0 : l]==a:base
        let res += [{"word":key,"menu":":: ".b:ghc_types[key],"dup":1}]
      endif
    endfor
    return res
  endif
endfunction
set omnifunc=GHC_CompleteImports
"
" Vim's default completeopt is menu,preview
" you probably want at least menu, or you won't see alternatives listed
" setlocal completeopt+=menu

" menuone is useful, but other haskellmode menus will try to follow your choice here in future
" setlocal completeopt+=menuone

" longest sounds useful, but doesn't seem to do what it says, and interferes with CTRL-E
" setlocal completeopt-=longest

map <LocalLeader>ct :call GHC_CreateTagfile()<cr>
function! GHC_CreateTagfile()
  redraw
  echo "creating tags file" 
  let output = system(g:ghc . ' ' . b:ghc_staticoptions . ' -e ":ctags" ' . expand("%"))
  " for ghcs older than 6.6, you would need to call another program 
  " here, such as hasktags
  echo output
endfunction

command! -nargs=1 GHCi redraw | echo system(g:ghc. ' ' . b:ghc_staticoptions .' '.expand("%").' -e "'.escape(<f-args>,'"').'"')

" use :make 'not in scope' errors to explicitly list imported ids
" cursor needs to be on import line, in correctly loadable module
map <LocalLeader>ie :call GHC_MkImportsExplicit()<cr>
function! GHC_MkImportsExplicit()
  let save_cursor = getpos(".")
  let line   = getline('.')
  let lineno = line('.')
  let ml     = matchlist(line,'^import\(\s*qualified\)\?\s*\([^( ]\+\)')
  if ml!=[]
    let [_,q,mod;x] = ml
    silent make
    if getqflist()==[]
      if line=~"import[^(]*Prelude"
        call setline(lineno,substitute(line,"(.*","","").'()')
      else
        call setline(lineno,'-- '.line)
      endif
      silent write
      silent make
      let qflist = getqflist()
      call setline(lineno,line)
      silent write
      let ids = {}
      for d in qflist
        let ml = matchlist(d.text,'Not in scope: \([^`]*\)`\([^'']*\)''')
        if ml!=[]
          let [_,what,qid;x] = ml
          let id  = ( qid =~ "^[A-Z]" ? substitute(qid,'.*\.\([^.]*\)$','\1','') : qid )
          let pid = ( id =~ "[a-zA-Z0-9_']\\+" ? id : '('.id.')' )
          if what =~ "data"
            call GHC_HaveTypes()
            if has_key(b:ghc_types,id)
              let pid = substitute(b:ghc_types[id],'^.*->\s*\(\S*\).*$','\1','').'('.pid.')'
            else
              let pid = '???('.pid.')'
            endif
          endif
          let ids[pid] = 1
        endif
      endfor
      call setline(lineno,'import'.q.' '.mod.'('.join(keys(ids),',').')')
    else
      copen
    endif
  endif
  call setpos('.', save_cursor)
endfunction

if GHC_VersionGE([6,8,2])
  let opts = filter(split(substitute(system(g:ghc . ' -v0 --interactive', ':set'), '  ', '','g'), '\n'), 'v:val =~ "-f"')
else
  let opts = ["-fglasgow-exts","-fallow-undecidable-instances","-fallow-overlapping-instances","-fno-monomorphism-restriction","-fno-mono-pat-binds","-fno-cse","-fbang-patterns","-funbox-strict-fields"]
endif

amenu ]OPTIONS_GHC.- :echo '-'<cr>
aunmenu ]OPTIONS_GHC
for o in opts
  exe 'amenu ]OPTIONS_GHC.'.o.' :call append(0,"{-# OPTIONS_GHC '.o.' #-}")<cr>'
endfor
if has("gui_running")
  map <LocalLeader>opt :popup ]OPTIONS_GHC<cr>
else
  map <LocalLeader>opt :emenu ]OPTIONS_GHC.
endif

amenu ]LANGUAGES_GHC.- :echo '-'<cr>
aunmenu ]LANGUAGES_GHC
if GHC_VersionGE([6,8])
  let ghc_supported_languages = split(system(g:ghc . ' --supported-languages'),'\n')
  for l in ghc_supported_languages
    exe 'amenu ]LANGUAGES_GHC.'.l.' :call append(0,"{-# LANGUAGE '.l.' #-}")<cr>'
  endfor
  if has("gui_running")
    map <LocalLeader>lang :popup ]LANGUAGES_GHC<cr>
  else
    map <LocalLeader>lang :emenu ]LANGUAGES_GHC.
  endif
endif
