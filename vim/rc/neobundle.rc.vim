"---------------------------------------------------------------------------
" NeoBundle:
"

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundleLazy 'kana/vim-niceblock', {
      \   'mappings' : '<Plug>',
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
      \                 'complete' : 'customlist,unite#complete_source'}]
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
      \ }
NeoBundleLazy 'Shougo/vimfiler.vim', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'commands' : [
      \         { 'name' : ['VimFiler', 'Edit', 'Write'],
      \           'complete' : 'customlist,vimfiler#complete' },
      \         'Read', 'Source'],
      \ 'mappings' : '<Plug>',
      \ 'explorer' : 1,
      \ }
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    }
      \ }

NeoBundleLazy 'Shougo/vimshell.vim', {
      \ 'commands' : [{ 'name' : 'VimShell',
      \                 'complete' : 'customlist,vimshell#complete'},
      \               ],
      \ 'mappings' : '<Plug>'
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
      \ 'unite_sources' : 'junkfile',
      \ }

NeoBundleLazy 'Shougo/unite-outline'

NeoBundleLazy 'hail2u/vim-css3-syntax'
NeoBundleLazy 'kana/vim-smartchr', {
      \ 'insert' : 1,
      \ }

NeoBundleLazy 'ctrlpvim/ctrlp.vim'
NeoBundleLazy 'LeafCage/foldCC', {
      \ 'filetypes' : 'vim' }
NeoBundleLazy 'mattn/webapi-vim'
NeoBundleLazy 'add20/vim-conque'
NeoBundleLazy 'thinca/vim-fontzoom', {
      \ 'gui' : 1,
      \ 'autoload' : {
      \  'mappings' : '<Plug>'
      \ }}
NeoBundleLazy 'thinca/vim-prettyprint', {
      \ 'commands' : 'PP'
      \ }
NeoBundleLazy 'thinca/vim-qfreplace', {
      \ 'filetypes' : ['unite', 'quickfix'],
      \ }
NeoBundleLazy 'thinca/vim-quickrun', {
      \ 'mappings' : '<Plug>'
      \ }
NeoBundleLazy 'thinca/vim-scouter'
NeoBundleLazy 'thinca/vim-ref', {
      \ 'unite_sources' : 'ref',
      \ }
NeoBundleLazy 'thinca/vim-unite-history'
NeoBundleLazy 'vim-ruby/vim-ruby', {
      \ 'mappings' : '<Plug>',
      \ 'filetypes' : 'ruby'
      \ }

NeoBundleLazy 'basyura/J6uil.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'commands' : {
      \      'name' : 'J6uil',
      \      'complete' : 'custom,J6uil#complete#room'},
      \   'function_prefix' : 'J6uil',
      \   'unite_sources' : 'J6uil',
      \ },
      \ 'depends' : 'mattn/webapi-vim',
      \ }

NeoBundleLazy 'Shougo/unite-help'
NeoBundleLazy 'tsukkee/unite-tag'
NeoBundleLazy 'tyru/caw.vim', {
      \ 'mappings' : '<Plug>'
      \ }
NeoBundleLazy 'tyru/eskk.vim', {
      \ 'mappings' : [['i', '<Plug>']],
      \ }
NeoBundleLazy 'tyru/open-browser.vim', {
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'tyru/restart.vim', {
      \ 'gui' : 1,
      \ }
NeoBundleLazy 'tyru/winmove.vim', {
      \ 'mappings' : '<Plug>',
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
      \ 'mappings' : '<Plug>',
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
      \   'functions' : 'openbrowser#open',
      \ }

NeoBundleLazy 'kana/vim-filetype-haskell', {
      \   'filetypes' : 'haskell',
      \ }
NeoBundleLazy 'JesseKPhillips/d.vim', {
      \   'filetypes' : 'd',
      \ }

NeoBundleLazy 't9md/vim-choosewin', {
      \   'mappings' : '<Plug>'
      \ }

NeoBundleLazy 'fatih/vim-go', {
      \ 'filetypes' : 'go',
      \ }

NeoBundleLazy 'lambdalisue/vim-fullscreen', {
      \ 'gui': 1,
      \ 'mappings': '<Plug>',
      \ }

NeoBundleLazy 'todesking/ruby_hl_lvar.vim', {
      \   'autoload': {
      \     'filetypes': ['ruby']
      \   }
      \ }

NeoBundleLazy 'syngan/vim-vimlint', {
    \ 'depends' : 'ynkdir/vim-vimlparser',
    \ }

" Operators
NeoBundleLazy 'kana/vim-operator-user', {
      \   'functions' : 'operator#user#define',
      \ }
NeoBundleLazy 'kana/vim-operator-replace', {
      \ 'depends' : 'vim-operator-user',
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>(operator-replace)']]
      \ }}
NeoBundleLazy 'rhysd/vim-operator-surround', {
      \ 'depends' : 'vim-operator-user',
      \   'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'chikatoike/concealedyank.vim', {
      \   'mappings' : [['x', '<Plug>(operator-concealedyank)']]
      \ }

" Textobjs
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \   'mappings' : [
      \     ['ox', '<Plug>']]
      \ }}

NeoBundleLazy 'saihoooooooo/glowshi-ft.vim', {
      \ 'mappings' : '<Plug>'
      \ }

NeoBundleLazy 'Rykka/riv.vim', {
      \ 'filetypes' : 'rst'
      \ }

NeoBundleLazy 'rcmdnk/vim-markdown', {
      \ 'filetypes' : 'markdown'
      \ }

NeoBundleLazy 'kannokanno/previm', {
      \ 'filetypes' : ['markdown', 'rst'],
      \ 'depends' : 'tyru/open-browser.vim',
      \ }

NeoBundleLazy 'Kocha/vim-unite-tig'

NeoBundleLazy 'Shougo/javacomplete', {
      \ 'filetypes' : 'java',
      \ }

NeoBundleLazy 'osyo-manga/vim-jplus', {
      \ 'mappings' : '<Plug>'
      \ }

NeoBundleLazy 'osyo-manga/unite-vimpatches'

NeoBundleLazy 'katono/rogue.vim', {
      \ 'commands' : 'Rogue'
      \ }
