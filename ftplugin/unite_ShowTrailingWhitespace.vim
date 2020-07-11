" unite_ShowTrailingWhitespace.vim: Exempt the "unite" filetype.
"
" DEPENDENCIES:
"
" Copyright: (C) 2015-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Contributor:	Fernando "Firef0x" G.P. da Silva <firefgx { aT ) gmail [ d0t } com>

" The Unite plugin uses trailing whitespace in its scratch buffers to emulate a
" menu with the full current line highlighted.
if ShowTrailingWhitespace#IsSet()
    call ShowTrailingWhitespace#Set(0,0)
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
