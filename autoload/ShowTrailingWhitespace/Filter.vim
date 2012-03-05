" ShowTrailingWhitespace/Filter.vim: Exclude certain buffers from detection.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	05-Mar-2012	file creation

function! ShowTrailingWhitespace#Filter#Default()
    return ! ((&l:buftype ==# 'nofile' || &l:buftype ==# 'nowrite') && bufname('') !~# '\[Scratch]') && (&l:modifiable || ShowTrailingWhitespace#IsSet() == 2)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
