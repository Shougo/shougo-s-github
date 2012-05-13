" Vim Syntax File
" Language:     Gemspec for Bundler, Ruby
" Creator:      Tatsuhiro Ujihisa <ujihisa at gmail com>
" Maintainer:   Iain Hecker <iain at iain nl>
" Last Change:  2010 Sep 05
" Filenames:    Gemfile

if version < 600
    syntax clear
endif


" It's basically just Ruby
runtime syntax/ruby.vim

syntax case match

" Normal oneliners
syntax keyword gemfileKeywords gem gemspec
highlight link gemfileKeywords Function

" Things that accept a block (because that will create a clearer color
" distinction)
syntax keyword gemfileBlockKeywords source path bundle_path group platforms git env
highlight link gemfileBlockKeywords Keyword

" Old Gemfile Syntax
syntax keyword gemfileDeprecated only except disable_rubygems disable_system_gems clear_sources bundle_path bin_path
highlight link gemfileDeprecated Error

" Make commenting plugin work
if exists("*TCommentDefineType")
  call TCommentDefineType('Gemfile', '# %s')
endif
