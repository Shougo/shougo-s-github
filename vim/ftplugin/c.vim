" Set cpp tags file.
"let &l:tags='./tags,tags,'.$DOTVIM.'/tags/cpp/tags'

" Set path.
if has('win32') || has('win64')
    set path+=C:/gcc/i386-pc-mingw32/include
else
    set path+=/usr/local/include;/usr/include
endif

" For OmniCppComplete.
" Search namespaces in the current file and included files
let g:OmniCpp_NamespaceSearch = 2
" The function prototype is displayed in the abbr column of the popup.
let g:OmniCpp_ShowPrototypeInAbbr = 1
" The scope is displayed in the abbr column of the popup.
let g:OmniCpp_ShowScopeInAbbr = 1
" Set the list of default namespaces
let g:OmniCpp_DefaultNamespaces = ['std']
" Set MayComplete to ::.
let g:OmniCpp_MayCompleteScope = 1
