" ShowTrailingWhitespace.vim: Detect and delete unwanted whitespace at the end of lines.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	25-Feb-2012	file creation

function! s:UpdateMatch( isInsertMode )
    let l:pattern = (a:isInsertMode ? '\s\+\%#\@<!$' : '\s\+$')
    if exists('w:ShowTrailingWhitespace_Match')
	call matchdelete(w:ShowTrailingWhitespace_Match)
	call matchadd('ShowTrailingWhitespace', pattern, -1, w:ShowTrailingWhitespace_Match)
    else
	let w:ShowTrailingWhitespace_Match =  matchadd('ShowTrailingWhitespace', pattern)
    endif
endfunction
function! s:DeleteMatch()
    if exists('w:ShowTrailingWhitespace_Match')
	silent! call matchdelete(w:ShowTrailingWhitespace_Match)
	unlet w:ShowTrailingWhitespace_Match
    endif
endfunction

function! s:DetectAll()
    let l:currentWinNr = winnr()

    " By entering a window, its height is potentially increased from 0 to 1 (the
    " minimum for the current window). To avoid any modification, save the window
    " sizes and restore them after visiting all windows.
    let l:originalWindowLayout = winrestcmd()

    noautocmd windo call ShowTrailingWhitespace#Detect(0)
    execute l:currentWinNr . 'wincmd w'
    silent! execute l:originalWindowLayout
endfunction

function! ShowTrailingWhitespace#IsSet()
    return (exists('b:ShowTrailingWhitespace') ? b:ShowTrailingWhitespace : g:ShowTrailingWhitespace)
endfunction

function! ShowTrailingWhitespace#Detect( isInsertMode )
    if ShowTrailingWhitespace#IsSet()
	call s:UpdateMatch(a:isInsertMode)
    else
	call s:DeleteMatch()
    endif
endfunction

" The showing of trailing whitespace be en-/disabled globally or only for a particular buffer.
function! ShowTrailingWhitespace#Set( isTurnOn, isGlobal )
    if a:isGlobal
	let g:ShowTrailingWhitespace = (!! a:isTurnOn)
	call s:DetectAll()
    else
	let b:ShowTrailingWhitespace = (!! a:isTurnOn)
	if a:isTurnOn
	    call s:UpdateMatch(0)
	else
	    call s:DeleteMatch()
	endif
    endif
endfunction
function! ShowTrailingWhitespace#Reset()
    unlet! b:ShowTrailingWhitespace
    call ShowTrailingWhitespace#Detect(0)
endfunction
function! ShowTrailingWhitespace#Toggle( isGlobal )
    call ShowTrailingWhitespace#Set(! (a:isGlobal ? g:ShowTrailingWhitespace : ShowTrailingWhitespace#IsSet()), a:isGlobal)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
