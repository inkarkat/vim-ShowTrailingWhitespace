" ShowTrailingWhitespace/Color.vim: Coloring of the highlighted whitespace.
"
" DEPENDENCIES:
"
" Copyright: (C) 2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! s:GetColor( isBackground, syntaxId, mode ) abort
    let l:attributes = ['fg', 'bg']
    if a:isBackground | call reverse(l:attributes) | endif
    if synIDattr(synIDtrans(a:syntaxId), 'reverse', a:mode) | call reverse(l:attributes) | endif

    return synIDattr(synIDtrans(a:syntaxId), l:attributes[0] . (a:mode ==# 'gui' ? '#' : ''), a:mode)    " Note: Use RGB comparison for GUI mode to account for the different ways of specifying the same color.
endfunction
function! s:GetForegroundColor( syntaxId, mode ) abort
    return s:GetColor(0, a:syntaxId, a:mode)
endfunction
function! s:GetBackgroundColor( syntaxId, mode ) abort
    return s:GetColor(1, a:syntaxId, a:mode)
endfunction

function! s:GetColorModes() abort
    if has('gui_running')
	" Can't get back from GUI to terminal.
	return ['gui']
    elseif has('gui')
	" This terminal may be upgraded to the GUI via :gui.
	return ['cterm', 'gui']
    else
	" This terminal doesn't have GUI capabilities built in.
	return ['cterm']
    endif
endfunction

function! s:HasVisibleBackground( syntaxId ) abort
    for l:mode in s:GetColorModes()
	let l:backgroundColor = s:GetBackgroundColor(a:syntaxId, l:mode)
	if empty(l:backgroundColor) || l:backgroundColor ==# s:GetBackgroundColor(hlID('Normal'), l:mode)
	    return 0
	endif
    endfor
    return 1
endfunction

function! ShowTrailingWhitespace#Color#EnsureVisibleBackgroundColor() abort
    let l:linkedSyntaxId = synIDtrans(hlID(g:ShowTrailingWhitespace#HighlightGroup))
    if l:linkedSyntaxId == hlID(g:ShowTrailingWhitespace#HighlightGroup)
	" The highlight group is not linked; i.e. the user set up their own
	" custom highlighting. They are responsible that this is visible.
	return
    endif

    " Especially the default linked highlight group may (depending on the
    " colorscheme) not have a visible background color. In that case, we should
    " take the foreground color as the background color instead, so that the
    " trailing whitespace (that, being whitespace, has no visible foreground
    " color, unless we've :set list) actually shows up.
    if s:HasVisibleBackground(l:linkedSyntaxId)
	return
    endif

    for l:mode in s:GetColorModes()
	let l:color = s:GetForegroundColor(l:linkedSyntaxId, l:mode)
	if ! empty(l:color)
	    execute printf('highlight %s %sbg=%s', g:ShowTrailingWhitespace#HighlightGroup, l:mode, l:color)
	endif
    endfor
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
