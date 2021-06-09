" ShowTrailingWhitespace/Color.vim: Coloring of the highlighted whitespace.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2020-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

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
	let l:backgroundColor = ingo#hlgroup#GetBackgroundColor(a:syntaxId, l:mode)
	if empty(l:backgroundColor) || l:backgroundColor ==# ingo#hlgroup#GetBackgroundColor(hlID('Normal'), l:mode)
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
	let l:color = ingo#hlgroup#GetForegroundColor(g:ShowTrailingWhitespace_LinkedSyntaxId, l:mode)
	if ! empty(l:color)
	    execute printf('highlight %s %sbg=%s', g:ShowTrailingWhitespace#HighlightGroup, l:mode, l:color)
	    let s:didAutomaticBackground = 1
	endif
    endfor
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
