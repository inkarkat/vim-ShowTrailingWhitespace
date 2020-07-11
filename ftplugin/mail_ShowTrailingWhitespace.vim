" mail_ShowTrailingWhitespace.vim: Whitespace exceptions for the "mail" filetype.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" - The email signature separator consists of dash-dash-space.
" - Email headers from Outlook or the Thunderbird "External Editor" add-on
"   may leave whitespace after mail headers. Ignore them unless it's the
"   Subject: header.
" - Quoted empty lines may contain trailing whitespace.
call ShowTrailingWhitespace#SetLocalExtraPattern('\%(^\%(--\|\%( \?>\)\+\|\%(From\|Sent\|To\|Cc\|Bcc\):.*\)\)\@<!')

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
