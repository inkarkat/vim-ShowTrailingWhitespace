" markdown_ShowTrailingWhitespace.vim: Whitespace exceptions for the "markdown" filetype.
"
" DEPENDENCIES:
"
" Copyright: (C) 2013-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" End a line with two (or more) spaces to add a <br/> linebreak.
call ShowTrailingWhitespace#SetLocalExtraPattern('\%( \@<! \|\t\s*\| \t\+\)$\&')

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
