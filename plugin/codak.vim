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
  return substitute(a:str, '[#|%|!]', '\\\0', 'g')
endfunction
"}}}

function! codak#check_vcs() "{{{
  let l:output = system('git status')
  return !v:shell_error
endfunction
"}}}
"}}}

" Section: Debug {{{
" set as 1 for developing, more verbose messages, etc.
let g:debug_codak = 1
let s:msg_header_codak = '[codak]: '

function! codak#debug(msg) "{{{
  call s:message(a:msg)
endfunction
"}}}

function! codak#nodebug(msg) "{{{
endfunction
"}}}

if exists('g:debug_codak') && g:debug_codak
  let s:Debug = function("codak#debug")
  unlet g:loaded_codak
else
  let s:Debug = function("codak#nodebug")
endif

call s:Debug("In Debug Mode")
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
  let l:call_str = l:exec_str.' '.codak#quoteescape(a:str)
  call s:Debug("Standalone calling '".l:call_str."'")
  execute(l:call_str)
  return '0'
endfunction
"}}}
"}}}

" Section: Git {{{
" Current hack: simple git log. Prefer vim-fugitive
function! codak#git_log(fn_name, file_name) "{{{
  let l:fn_name = codak#quoteescape(a:fn_name)
  " save current directory
  let l:saved_dir = system("pwd")
  " Switch to this file's directory
  execute("lcd %:p:h")
  if codak#check_vcs()
    " Do git log magic
    echom system("pwd")
    let l:cmd = '!git log --graph --date=short --date-order -L :'
    let l:str = l:cmd.codak#vimescape(l:fn_name.':'.a:file_name)
    call s:Debug("Gitlog calling '".l:str."'")
    execute(l:str)
  else
    call s:Debug("No recognised rcs found to find diff logs")
  endif
  " Switch back
  execute("lcd ".l:saved_dir)
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
  call s:Debug("func_name found as '".l:result."'")
  return l:result
endfunction
"}}}

function! codak#get_file_name() "{{{
  " Get just the file name
  let l:result = expand('%:t')
  call s:Debug("file_name is '".l:result."'")
  return l:result
endfunction
"}}}

function! codak#get_vcs_root_relative_file_name() "{{{
  " Find the complete path of this file wrt the rcs root
  let l:full_path = expand("%:p")
  " Save the present directory
  let l:saved_dir = system("pwd")
  " Switch to this file's directory
  execute("lcd %:p:h")
  " Find the git root
  let l:output = substitute(system("git rev-parse --show-toplevel"),
        \ '\n$', '', '')
  if v:shell_error
    let l:output = ""
    call s:Debug("File not under any recognised rcs")
  else
    call s:Debug("Git root dir: '".l:output."'")
  endif
  " Switch back
  execute("lcd ".l:saved_dir)
  if !v:shell_error
    " Remove the git root from the complete file path
    let l:file_name = substitute(l:full_path, l:output, '', '')
    " Sanitise the file name
    let l:result = substitute(l:file_name, '\v^.', '', '')
  else
    let l:result = ''
  endif
  call s:Debug("file_name under rcs found as '".l:result."'")
  return l:result
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
" This one has issue. Doesn't go back in insert mode. Commented is better
" inoremap <F9> <Esc>:call Codak()<CR>
"}}}

" Mode Line {{{
" vim:tabstop=2 shiftwidth=2 foldmethod=marker:foldlevel=1
"}}}
