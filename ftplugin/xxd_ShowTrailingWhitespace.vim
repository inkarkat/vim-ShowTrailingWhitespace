" xxd_ShowTrailingWhitespace.vim: Exempt the "xxd" filetype.
"
" DEPENDENCIES:
"
" Copyright: (C) 2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Contributor:	Fernando "Firef0x" G.P. da Silva <firefgx { aT ) gmail [ d0t } com>

" The ASCII column on the right may end with spaces, as it arbitrarily breaks
" the buffer into 16-char lines.
if ShowTrailingWhitespace#IsSet()
    call ShowTrailingWhitespace#Set(0,0)
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
