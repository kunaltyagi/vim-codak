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
let g:debug_codak = 1
let s:msg_header_codak = '[codak]: '

if exists('g:debug_codak') && g:debug_codak
  echom s:msg_header_codak."In Debug Mode"
  " Allow running again and again
  unlet g:loaded_codak
endif
"}}}

" Section: Utility {{{
function! s:error(msg) abort "{{{
  " Adds header to error messages
  let v:errmsg = s:msg_header_codak.a:msg
  throw v:errmsg
endfunction
"}}}

function! s:message(msg) "{{{
  " Adds header to normal messages
  echom s:msg_header_codak.a:msg
endfunction
"}}}

function! codak#license() "{{{
  " Prints the license
  echom "Codak Copyright (C) 2016 Kunal Tyagi"
  echom "This program comes with ABSOLUTELY NO WARRANTY;"
  echom "This is free software, and you are welcome to redistribute it".
      \ "under certain conditions as specified under GPLv3"
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

" Section: Search {{{
" Use Ack plugin to search for terms
runtime Ack

function! codak#search_standalone(fn)
  execute('Ack '.a:str)
  return '0'
endfunction
" }}}

" Mode Line {{{
" vim:tabstop=2 shiftwidth=2 foldmethod=marker:foldlevel=1
" }}}
