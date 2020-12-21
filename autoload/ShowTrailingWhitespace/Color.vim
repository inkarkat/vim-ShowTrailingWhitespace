" ShowTrailingWhitespace/Color.vim: Coloring of the highlighted whitespace.
"
" DEPENDENCIES:
"
" Copyright: (C) 2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Note: Could use ingo#hlgroup#GetForegroundColor(), but avoid a hard dependency
" to ingo-library for now.
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
    elseif has('gui') || has('nvim')
	" This terminal may be upgraded to the GUI via :gui.
	" Neovim uses cterm or gui depending on &termguicolors, and can be
	" changed whenever the user wishes to.
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

let s:didAutomaticBackground = 0
function! ShowTrailingWhitespace#Color#EnsureVisibleBackgroundColor() abort
    if s:HasVisibleBackground(g:ShowTrailingWhitespace_LinkedSyntaxId)
	if s:didAutomaticBackground
	    " Restore the original link that had been automatically adapted for
	    " a previous colorscheme that did not define a background color.
	    execute printf('highlight link %s %s', g:ShowTrailingWhitespace#HighlightGroup, synIDattr(g:ShowTrailingWhitespace_LinkedSyntaxId, 'name'))
	    let s:didAutomaticBackground = 0
	endif
	return
    endif

    for l:mode in s:GetColorModes()
	let l:color = s:GetForegroundColor(g:ShowTrailingWhitespace_LinkedSyntaxId, l:mode)
	if ! empty(l:color)
	    execute printf('highlight %s %sbg=%s', g:ShowTrailingWhitespace#HighlightGroup, l:mode, l:color)
	    let s:didAutomaticBackground = 1
	endif
    endfor
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
