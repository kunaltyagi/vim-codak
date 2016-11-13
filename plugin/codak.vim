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

function! codak#quoteescape(str) "{{{
  return "'".a:str."'"
endfunction
"}}}

function! codak#vimescape(str) "{{{
  return substitute(a:str, '[#|%]', '\\\0', 'g')
endfunction
"}}}
"}}}

" Section: Initialization {{{
" Use Ack! to not jump immediately to first search
let g:search_codak_exe = 'Ack!'
" Only search for words, literally, and ignore the tag file, if any
let g:search_codak_option = ['-w', '-Q', '--ignore-file=is:tags']
"}}}

" Section: Search {{{
" Current hack: no sematic search, simple ack
function! codak#search_standalone(str) "{{{
  " Searches for all possible mention of str
  let l:exec_str = g:search_codak_exe.' '.join(g:search_codak_option)
  execute(l:exec_str.' '.codak#quoteescape(a:str))
  return '0'
endfunction
"}}}
"}}}

" Section: Git {{{
" Current hack: simple git log. Prefer vim-fugitive
function! codak#git_log(fn_name, file_name) "{{{
  let l:fn_name = codak#quoteescape(a:fn_name)
  " echom "!git log -L :".codak#vimescape(l:fn_name.':'.a:file_name)
  " echom shellescape("!git log -L :".codak#vimescape(l:fn_name.':'.a:file_name))
  " execute("!git log -L :".codak#vimescape(l:fn_name.':'.a:file_name))
endfunction
"}}}
"}}}

" Section: GetDetails {{{
function! codak#get_func_name() "{{{
  " Get the function name
  let l:cursor = getpos(".")
  " See ctags.vim. This implementation is a hack
  " https://github.com/vim-scripts/ctags.vim/blob/master/plugin/ctags.vim#L97
  let l:result =  getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  call setpos(".", l:cursor)
  return l:result
endfunction
"}}}

function! codak#get_file_name() "{{{
  return 'plugin/codak.vim'
endfunction
"}}}
"}}}

" Section: Commands {{{
function! Codak() "{{{
  " manually replace vim special characters
  return codak#search_standalone(codak#vimescape(codak#get_func_name()))
endfunction
"}}}
"}}}

" Section: Mappings {{{
nnoremap <F9> :call Codak()<CR>
" This one has issue. Doesn't go back in insert mode
inoremap <F9> <Esc>:call Codak()<CR>
"}}}

" Mode Line {{{
" vim:tabstop=2 shiftwidth=2 foldmethod=marker:foldlevel=1
"}}}
