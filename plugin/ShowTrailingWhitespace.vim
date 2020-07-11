" ShowTrailingWhitespace.vim: Detect unwanted whitespace at the end of lines.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ShowTrailingWhitespace') || (v:version == 701 && ! exists('*matchadd')) || (v:version < 701)
    finish
endif
let g:loaded_ShowTrailingWhitespace = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:ShowTrailingWhitespace')
    let g:ShowTrailingWhitespace = 1
endif
if ! exists('g:ShowTrailingWhitespace_FilterFunc')
    if v:version < 702
	" Vim 7.0/1 need preloading of functions referenced in Funcrefs.
	runtime autoload/ShowTrailingWhitespace/Filter.vim
    endif
    let g:ShowTrailingWhitespace_FilterFunc = function('ShowTrailingWhitespace#Filter#Default')
endif


"- autocmds --------------------------------------------------------------------

augroup ShowTrailingWhitespace
    autocmd!
    autocmd BufWinEnter,InsertLeave * call ShowTrailingWhitespace#Detect(0)
    autocmd InsertEnter             * call ShowTrailingWhitespace#Detect(1)
augroup END


"- highlight groups ------------------------------------------------------------

highlight def link ShowTrailingWhitespace Error

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
