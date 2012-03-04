" ShowTrailingWhitespace/HlGroup.vim: summary
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

function! ShowTrailingWhitespace#HlGroup#Default()
    return (! &l:modifiable || ShowTrailingWhitespace#IsSet() == 2 ? 'ShowTrailingWhitespaceNonText' : '')
endfunction

highlight def ShowTrailingWhitespaceNonText guibg=LightGrey

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
