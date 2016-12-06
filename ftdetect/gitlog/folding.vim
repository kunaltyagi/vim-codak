" codak.vim - A cokad moment with your code
" Maintainer:       Kunal Tyagi
" Version:          0.0.1
" GetLatestVimScripts: XXX 1 :AutoInstall: codak.vim

" Section: Folding {{{
setlocal foldmethod=expr
setlocal foldexpr=GetGitlogFold(v:lnum)
"}}}

" Section: Fold the text {{{
function! GetGitlogFold(lnum)
  " returns the fold level of the line
  let l:line = getline(a:lnum)
  if l:line =~? '\v^\s*$'
    " ensure that a blank line is given the least preference for folding
    return '-1'
  elseif l:line =~? '\v^\*[\s\S]*'
    " a line contains * in the beginning (commit)
    return '1'
  elseif l:line =~? '\v^\|[\s\|\/\\]*(Author|Date):[\s\S]*'
    " a line contains Author or Date details so can be unfolded slightly
    return '2'
  " elseif l:line =~? '\v^[\s\|\/\\]*$'
  "   " a line contains |, \, / and spaces and nothing else (commit tree)
  "   return '-1'
  " elseif l:line =~? '\v^\|[\s\S]*$'
  "   " a line contains | in the beginning (commit message)
  "   return '3'
  endif

  return '0'
endfunction
"}}}

" Mode Line {{{
" vim:tabstop=2 shiftwidth=2 foldmethod=marker:foldlevel=1
"}}}
