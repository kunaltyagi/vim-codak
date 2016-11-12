" codak.vim - A cokad moment with your code
" Maintainer:       Kunal Tyagi
" Version:          0.0.1
" GetLatestVimScripts: XXX 1 :AutoInstall: codak.vim

" Section: Load {{{
" Prevent running again and again
if exists('g:loaded_codak') || &cp
  finish
endif
let g:loaded_codak = 1

if !exists('g:codak_vcs_executable')
  let g:codak_vcs_executable = 'git'
endif

" set as 1 for developing, more verbose messages, etc.
let g:testing_codak = 1

if exists('g:testing_codak') && g:testing_codak
  echom "Codak testing"
  " Allow running again and again
  unlet g:loaded_codak
endif
"}}}

" Section: Utility {{{

function! s:trial(msg) abort "{{{
  let v:errmsg = 'fugitive: '.a:msg
  throw v:errmsg
endfunction
"}}}
"}}}

" Section: Initialization {{{

function! codak#is_vcs_dir(path) abort "{{{
  let path = s:sub(a:path, '[\/]$', '') . '/'
  return getfsize(path.'HEAD') > 10 && (
    \ isdirectory(path.'objects') && isdirectory(path.'refs') ||
    \ getftype(path.'commondir') ==# 'file')
endfunction
"}}}
"}}}

" Mode Line{{{
" vim:tabstop=2 shiftwidth=2 foldmethod=marker:foldlevel=1
" }}}
