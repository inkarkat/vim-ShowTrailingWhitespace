" ShowTrailingWhitespace.vim: Detect unwanted whitespace at the end of lines.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2012-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! ShowTrailingWhitespace#Pattern( isInsertMode )
    return (exists('b:ShowTrailingWhitespace_ExtraPattern') ? b:ShowTrailingWhitespace_ExtraPattern : '') .
    \	(a:isInsertMode ? '\s\+\%#\@<!$' : '\s\+$')
endfunction
function! s:UpdateMatch( isInsertMode )
    let l:pattern = ShowTrailingWhitespace#Pattern(a:isInsertMode)
    if exists('w:ShowTrailingWhitespace_Match')
	" Info: matchadd() does not consider the 'magic' (it's always on),
	" 'ignorecase' and 'smartcase' settings.
	silent! call matchdelete(w:ShowTrailingWhitespace_Match)
	call matchadd(g:ShowTrailingWhitespace#HighlightGroup, l:pattern, -1, w:ShowTrailingWhitespace_Match)
    else
	let w:ShowTrailingWhitespace_Match =  matchadd(g:ShowTrailingWhitespace#HighlightGroup, l:pattern)
    endif
endfunction
function! s:DeleteMatch()
    if exists('w:ShowTrailingWhitespace_Match')
	silent! call matchdelete(w:ShowTrailingWhitespace_Match)
	unlet w:ShowTrailingWhitespace_Match
    endif
endfunction

function! s:DetectAll()
    call ingo#window#iterate#All(function('ShowTrailingWhitespace#Detect'), 0)
endfunction

function! ShowTrailingWhitespace#IsSet()
    return (exists('b:ShowTrailingWhitespace') ? b:ShowTrailingWhitespace : get(g:, 'ShowTrailingWhitespace', 0))
endfunction
function! ShowTrailingWhitespace#NotFiltered()
    let l:Filter = (exists('b:ShowTrailingWhitespace_FilterFunc') ? b:ShowTrailingWhitespace_FilterFunc : g:ShowTrailingWhitespace_FilterFunc)
    return (empty(l:Filter) ? 1 : call(l:Filter, []))
endfunction

function! ShowTrailingWhitespace#Detect( isInsertMode )
    if ShowTrailingWhitespace#IsSet() && ShowTrailingWhitespace#NotFiltered()
	call s:UpdateMatch(a:isInsertMode)
    else
	call s:DeleteMatch()
    endif
endfunction

" The showing of trailing whitespace be en-/disabled globally or only for a particular buffer.
function! ShowTrailingWhitespace#Set( isTurnOn, isGlobal )
    if a:isGlobal
	let g:ShowTrailingWhitespace = a:isTurnOn
	call s:DetectAll()
    else
	let b:ShowTrailingWhitespace = a:isTurnOn
	call ShowTrailingWhitespace#Detect(0)
    endif
endfunction
function! ShowTrailingWhitespace#Reset()
    unlet! b:ShowTrailingWhitespace
    call ShowTrailingWhitespace#Detect(0)
endfunction
function! ShowTrailingWhitespace#Toggle( isGlobal )
    if a:isGlobal
	let l:newState = ! g:ShowTrailingWhitespace
    else
	if ShowTrailingWhitespace#NotFiltered()
	    let l:newState = ! ShowTrailingWhitespace#IsSet()
	else
	    let l:newState = (ShowTrailingWhitespace#IsSet() > 1 ? 0 : 2)
	endif
    endif

    call ShowTrailingWhitespace#Set(l:newState, a:isGlobal)
endfunction

function! ShowTrailingWhitespace#SetLocalExtraPattern( pattern )
    let b:ShowTrailingWhitespace_ExtraPattern = a:pattern
    call s:DetectAll()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
