" codak.vim - A cokad moment with your code
" Maintainer:       Kunal Tyagi
" Version:          0.0.1
" GetLatestVimScripts: XXX 1 :AutoInstall: codak.vim

" Section: Init {{{
if exists("b:current_syntax")
  finish
endif

echom "Gitlog file syntax highlight"

let b:current_syntax = "gitlog"
"}}}

" Mode Line {{{
" vim:tabstop=2 shiftwidth=2 foldmethod=marker:foldlevel=1
"}}}
