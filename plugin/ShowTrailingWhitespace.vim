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

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ShowTrailingWhitespace') || (v:version == 701 && ! exists('*matchadd')) || (v:version < 702)
    finish
endif
let g:loaded_ShowTrailingWhitespace = 1

if ! exists('g:ShowTrailingWhitespace')
    let g:ShowTrailingWhitespace = 1
endif

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

    noautocmd windo call s:Detect(0)
    execute l:currentWinNr . 'wincmd w'
    silent! execute l:originalWindowLayout
endfunction

function! s:Detect( isInsertMode )
    if (exists('b:ShowTrailingWhitespace') ? b:ShowTrailingWhitespace : g:ShowTrailingWhitespace)
	call s:UpdateMatch(a:isInsertMode)
    else
	call s:DeleteMatch()
    endif
endfunction

augroup ShowTrailingWhitespace
    autocmd!
    autocmd BufWinEnter,InsertLeave * call <SID>Detect(0)
    autocmd InsertEnter             * call <SID>Detect(1)
augroup END

highlight def link ShowTrailingWhitespace Error

"command! -bar ShowTrailingWhitespaceOn        let g:ShowTrailingWhitespace = 1 | call <SID>DetectAll()
"command! -bar ShowTrailingWhitespaceOff       let g:ShowTrailingWhitespace = 0 | call <SID>DetectAll()
"command! -bar ShowTrailingWhitespaceBufferOn  let b:ShowTrailingWhitespace = 1 | call <SID>UpdateMatch(0)
"command! -bar ShowTrailingWhitespaceBufferOff let b:ShowTrailingWhitespace = 0 | call <SID>DeleteMatch()
"command! -bar ShowTrailingWhitespaceBufferClear unlet! b:ShowTrailingWhitespace | call <SID>Detect(0)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
