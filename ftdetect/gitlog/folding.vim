" codak.vim - A cokad moment with your code
" Maintainer:       Kunal Tyagi
" Version:          0.0.1
" GetLatestVimScripts: XXX 1 :AutoInstall: codak.vim

" Section: Folding {{{
setlocal foldmethod=expr
setlocal foldexpr=GetGitlogFold(v:lnum)
"}}}

" Section: Fold the text {{{
function! GetGitlogFold(v:lnum)
  " returns the fold level of the line
  if getline(a:lnum) =~? '\v^\s*$'
    " ensure that a blank line is given the least preference for folding
    return '-1'
  endif

  return '0'
endfunction
"}}}

" Mode Line {{{
" vim:tabstop=2 shiftwidth=2 foldmethod=marker:foldlevel=1
"}}}
