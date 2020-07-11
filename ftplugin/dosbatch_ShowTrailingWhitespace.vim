" dosbatch_ShowTrailingWhitespace.vim: Whitespace exceptions for the "dosbatch" filetype.
"
" DEPENDENCIES:
"
" Copyright: (C) 2013-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" A user prompt (set /P query=Your choice? ) may end with a trailing space.
call ShowTrailingWhitespace#SetLocalExtraPattern('\c\%(\<set\s/p\s.*\)\@<!')

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
