" diff_ShowTrailingWhitespace.vim: Whitespace exceptions for the "diff" filetype.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" - A single space at the beginning of a line can represent an empty context line.
" - Patch instructions (e.g. from git add --patch) start with a # comment in
"   column 1 and may just be followed by a single space.
call ShowTrailingWhitespace#SetLocalExtraPattern('^\%( \@!\s\)$\|\%(^#\)\@<!\%>1v')

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
