"---------------------------------------------------------------------------
" NeoBundle:
"

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundleLazy 'rhysd/vim-operator-surround', {
      \   'mappings' : '<Plug>(operator-surround',
      \ }
NeoBundleLazy 'kana/vim-niceblock', {
      \   'mappings' : '<Plug>(niceblock-',
      \ }

NeoBundleLazy 'Shougo/echodoc.vim', {
      \ 'insert' : 1
      \ }

" NeoBundle 'Shougo/neocomplcache.vim', {
      " \ 'insert' : 1
      " \ }

NeoBundleLazy 'Shougo/neocomplete.vim', {
      \ 'depends' : 'Shougo/context_filetype.vim',
      \ 'insert' : 1
      \ }

NeoBundleLazy 'Shougo/neosnippet.vim', {
      \ 'depends' : ['Shougo/neosnippet-snippets', 'Shougo/context_filetype.vim'],
      \ 'insert' : 1,
      \ 'filetypes' : 'snippet',
      \ 'unite_sources' : [
      \    'neosnippet', 'neosnippet/user', 'neosnippet/runtime'],
      \ }

NeoBundle 'Shougo/neobundle-vim-scripts'

NeoBundleLazy 'Shougo/unite.vim', {
      \ 'commands' : [{ 'name' : 'Unite',
      \                 'complete' : 'customlist,unite#complete_source'},
      \                 'UniteWithCursorWord', 'UniteWithInput']
      \ }
NeoBundleLazy 'Shougo/unite-build'
NeoBundleLazy 'Shougo/neossh.vim', {
      \ 'filetypes' : 'vimfiler',
      \ 'sources' : 'ssh',
      \ }
NeoBundle 'Shougo/neomru.vim'

NeoBundleLazy 'ujihisa/vimshell-ssh', {
      \ 'filetypes' : 'vimshell',
      \ }
NeoBundle 'Shougo/unite-sudo'
NeoBundleLazy 'Shougo/vim-vcs', {
      \ 'depends' : 'thinca/vim-openbuf',
      \ 'autoload' : {'commands' : 'Vcs'},
      \ }
NeoBundleLazy 'Shougo/vimfiler.vim', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'commands' : [
      \         { 'name' : 'VimFiler',
      \           'complete' : 'customlist,vimfiler#complete' },
      \         { 'name' : 'VimFilerTab',
      \           'complete' : 'customlist,vimfiler#complete' },
      \         { 'name' : 'VimFilerExplorer',
      \           'complete' : 'customlist,vimfiler#complete' },
      \         { 'name' : 'Edit',
      \           'complete' : 'customlist,vimfiler#complete' },
      \         { 'name' : 'Write',
      \           'complete' : 'customlist,vimfiler#complete' },
      \         'Read', 'Source'],
      \ 'mappings' : '<Plug>(vimfiler_',
      \ 'explorer' : 1,
      \ }
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    }
      \ }

NeoBundleLazy 'Shougo/vimshell.vim', {
      \ 'commands' : [{ 'name' : 'VimShell',
      \                 'complete' : 'customlist,vimshell#complete'},
      \               'VimShellExecute', 'VimShellInteractive',
      \               'VimShellCreate',
      \               'VimShellTerminal', 'VimShellPop'],
      \ 'mappings' : '<Plug>(vimshell_'
      \ }
NeoBundleLazy 'yomi322/vim-gitcomplete', {
      \ 'filetype' : 'vimshell'
      \ }

NeoBundleLazy 'Shougo/vinarise.vim', {
      \ 'commands' : [{
      \   'name' : 'Vinarise', 'complete' : 'file'
      \ }]
      \ }

NeoBundleLazy 'Shougo/vesting', {
      \ 'unite_sources' : 'vesting'
      \ }
NeoBundleLazy 'vim-jp/vital.vim', {
      \     'commands' : 'Vitalize',
      \ }
NeoBundleLazy 'Shougo/junkfile.vim', {
      \ 'commands' : 'JunkfileOpen',
      \ 'unite_sources' : ['junkfile', 'junkfile/new'],
      \ }

NeoBundleLazy 'Shougo/unite-outline'

NeoBundleLazy 'hail2u/vim-css3-syntax'
NeoBundleLazy 'kana/vim-smartchr', {
      \ 'insert' : 1,
      \ }
NeoBundle 'kana/vim-operator-user', {
      \   'functions' : 'operator#user#define',
      \ }
NeoBundleLazy 'kana/vim-operator-replace', {
      \ 'depends' : 'vim-operator-user',
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>(operator-replace)']]
      \ }}
NeoBundleLazy 'kana/vim-textobj-user'

NeoBundleLazy 'kien/ctrlp.vim'
NeoBundleLazy 'LeafCage/foldCC', {
      \ 'filetypes' : 'vim' }
NeoBundleLazy 'mattn/webapi-vim'
NeoBundleLazy 'add20/vim-conque', {
      \ 'commands' : 'ConqueTerm'
      \ }
NeoBundleLazy 'thinca/vim-fontzoom', {
      \ 'gui' : 1,
      \ 'autoload' : {
      \  'mappings' : [
      \   ['n', '<Plug>(fontzoom-larger)'],
      \   ['n', '<Plug>(fontzoom-smaller)']]
      \ }}
NeoBundleLazy 'thinca/vim-prettyprint', {
      \ 'commands' : 'PP'
      \ }
NeoBundleLazy 'thinca/vim-qfreplace', {
      \ 'filetypes' : ['unite', 'quickfix'],
      \ }
NeoBundleLazy 'thinca/vim-quickrun', {
      \ 'commands' : 'QuickRun',
      \ 'mappings' : [
      \   ['nxo', '<Plug>(quickrun)']],
      \ }
NeoBundleLazy 'thinca/vim-scouter', {
      \ 'commands' : 'Scouter'
      \ }
NeoBundleLazy 'thinca/vim-ref', {
      \ 'commands' : 'Ref',
      \ 'unite_sources' : 'ref',
      \ }
NeoBundleLazy 'thinca/vim-unite-history', {
      \ 'unite_sources' : ['history/command', 'history/search']
      \ }
NeoBundleLazy 'vim-ruby/vim-ruby', {
      \ 'mappings' : '<Plug>(ref-',
      \ 'filetypes' : 'ruby'
      \ }

NeoBundleLazy 'basyura/J6uil.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'commands' : {
      \      'name' : 'J6uil',
      \      'complete' : 'custom,J6uil#complete#room'},
      \   'function_prefix' : 'J6uil',
      \   'unite_sources' : 'J6uil/rooms',
      \ },
      \ 'depends' : 'mattn/webapi-vim',
      \ }

NeoBundleLazy 'Shougo/unite-help'
NeoBundleLazy 'tsukkee/unite-tag', {
      \ 'unite_sources' : ['tag', 'tag/include', 'tag/file']
      \ }
NeoBundleLazy 'tyru/caw.vim', {
      \ 'mappings' : [['nxo',
      \   '<Plug>(caw:prefix)', '<Plug>(caw:i:toggle)']]
      \ }
NeoBundleLazy 'tyru/eskk.vim', {
      \ 'mappings' : [['i', '<Plug>(eskk:']],
      \ }
NeoBundleLazy 'tyru/open-browser.vim', {
      \ 'mappings' : '<Plug>(open-browser-',
      \ }
NeoBundleLazy 'tyru/restart.vim', {
      \ 'gui' : 1,
      \ 'autoload' : {
      \  'commands' : 'Restart'
      \ }}
NeoBundleLazy 'tyru/winmove.vim', {
      \ 'mappings' : [['nxo',
      \   '<Plug>(winmove-up)', '<Plug>(winmove-down)',
      \         '<Plug>(winmove-left)', '<Plug>(winmove-right)'
      \ ]],
      \ 'gui' : 1,
      \ 'augroup' : 'winmove',
      \ }
NeoBundleLazy 'ujihisa/neco-ghc', {
      \ 'filetypes' : 'haskell'
      \ }
NeoBundleLazy 'ujihisa/neco-look'
NeoBundleLazy 'ujihisa/unite-colorscheme'
NeoBundleLazy 'vim-jp/vimdoc-ja', {
      \ 'filetype' : 'help',
      \ }
" NeoBundleLazy 'eignn/netrw.vim', {
      " \ 'commands' : 'Explore',
      " \ }
NeoBundleLazy 'osyo-manga/unite-quickfix'
NeoBundleLazy 'osyo-manga/unite-filetype'
NeoBundleLazy 'rbtnn/hexript.vim'
NeoBundleLazy 'kana/vim-tabpagecd', {
      \ 'unite_sources' : 'tab'
      \ }
NeoBundleLazy 'rhysd/accelerated-jk', {
      \ 'mappings' : '<Plug>(accelerated_jk_',
      \ }

NeoBundleLazy 'vim-jp/autofmt', {
      \ 'mappings' : [['x', 'gq']],
      \ }

NeoBundleLazy 'supermomonga/unite-kawaii-calc'

NeoBundleLazy 'godlygeek/csapprox', { 'terminal' : 1 }
NeoBundleLazy 'thinca/vim-guicolorscheme', { 'terminal' : 1 }
NeoBundleLazy 'tpope/vim-repeat', {
      \ 'mappings' : '.',
      \ }

NeoBundleLazy 'matchit.zip', {
      \ 'mappings' : [['nxo', '%', 'g%']]
      \ }

NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
      \ 'filetypes' : 'javascript',
      \ }
NeoBundleLazy 'jelera/vim-javascript-syntax', {
      \ 'filetypes' : 'javascript',
      \ }
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
      \ 'filetypes' : 'python',
      \ }
NeoBundleLazy 'bkad/CamelCaseMotion', {
      \ 'mappings' : '<Plug>CamelCaseMotion_',
      \ }
NeoBundleLazy 'aharisu/vim-gdev', {
      \ 'filetypes' : 'scheme',
      \ }
NeoBundleLazy 'vim-jp/cpp-vim', {
      \ 'filetypes' : 'cpp',
      \ }
NeoBundleLazy 'thinca/vim-ft-diff_fold', {
      \ 'filetypes' : 'diff'
      \ }
" NeoBundleLazy 'thinca/vim-ft-markdown_fold', {
"       \ 'filetypes' : 'markdown'
"       \ }
NeoBundleLazy 'nsf/gocode', {
      \ 'rtp' : 'vim',
      \ 'filetypes' : 'go',
      \ }

NeoBundleLazy 'thinca/vim-ft-help_fold', {
      \ 'filetypes' : 'help'
      \ }

NeoBundleLazy 'elzr/vim-json', {
      \   'filetypes' : 'json',
      \ }

NeoBundleLazy 'tyru/open-browser.vim', {
      \   'commands' : ['OpenBrowserSearch', 'OpenBrowser'],
      \   'functions' : 'openbrowser#open',
      \ }

NeoBundleLazy 'kana/vim-filetype-haskell', {
      \   'filetypes' : 'haskell',
      \ }
NeoBundleLazy 'JesseKPhillips/d.vim', {
      \   'filetypes' : 'd',
      \ }
NeoBundleLazy 'chikatoike/concealedyank.vim', {
      \   'mappings' : [['x', '<Plug>(operator-concealedyank)']]
      \ }

NeoBundleLazy 't9md/vim-choosewin', {
      \   'mappings' : '<Plug>(choosewin)'
      \ }

NeoBundleLazy 'fatih/vim-go', {
      \ 'filetypes' : 'go',
      \ }

NeoBundleLazy 'lambdalisue/vim-fullscreen', {
      \ 'gui': 1,
      \ 'autoload': {
      \   'commands': [
      \     'FullscreenStart',
      \     'FullscreenStop',
      \     'FullscreenToggle',
      \   ],
      \   'mappings': '<Plug>(fullscreen-',
      \ },
      \ }

NeoBundleLazy 'plasticboy/vim-markdown', {
      \ 'filetypes' : 'mkd'
      \ }

NeoBundleLazy 'todesking/ruby_hl_lvar.vim', {
      \   'autoload': {
      \     'filetypes': ['ruby']
      \   }
      \ }

NeoBundleLazy 'syngan/vim-vimlint', {
    \ 'depends' : 'ynkdir/vim-vimlparser',
    \ }
