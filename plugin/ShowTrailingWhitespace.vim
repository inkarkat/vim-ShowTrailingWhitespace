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

let g:ShowTrailingWhitespace#HighlightGroup = 'ShowTrailingWhitespace'

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

if ! exists('g:ShowTrailingWhitespace_IsAutomaticBackground')
    let g:ShowTrailingWhitespace_IsAutomaticBackground = 1
endif


"- autocmds --------------------------------------------------------------------

augroup ShowTrailingWhitespace
    autocmd!
    autocmd BufWinEnter,InsertLeave * call ShowTrailingWhitespace#Detect(0)
    autocmd InsertEnter             * call ShowTrailingWhitespace#Detect(1)
augroup END


"- highlight groups ------------------------------------------------------------

execute printf('highlight def link %s Error', g:ShowTrailingWhitespace#HighlightGroup)

if g:ShowTrailingWhitespace_IsAutomaticBackground
    let g:ShowTrailingWhitespace_LinkedSyntaxId = synIDtrans(hlID(g:ShowTrailingWhitespace#HighlightGroup))
    if g:ShowTrailingWhitespace_LinkedSyntaxId == hlID(g:ShowTrailingWhitespace#HighlightGroup)
	" The highlight group is not linked; i.e. the user set up their own
	" custom highlighting. They are responsible that this is visible.
    else
	" Especially the default linked highlight group may (depending on the
	" colorscheme) not have a visible background color. In that case, we
	" should take the foreground color as the background color instead, so
	" that the trailing whitespace (that, being whitespace, has no visible
	" foreground color, unless we've :set list) actually shows up.
	call ShowTrailingWhitespace#Color#EnsureVisibleBackgroundColor()
	autocmd ShowTrailingWhitespace ColorScheme * call ShowTrailingWhitespace#Color#EnsureVisibleBackgroundColor()
    endif
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
