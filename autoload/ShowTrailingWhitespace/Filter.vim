" ShowTrailingWhitespace/Filter.vim: Exclude certain buffers from detection.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin (optional)
"
" Copyright: (C) 2012-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

silent! call ingo#fs#path#DoesNotExist()	" Execute a function to force autoload.
if exists('*ingo#fs#path#Canonicalize')
function! s:GetFilespec()
    return ingo#fs#path#Canonicalize(expand('%:p'))
endfunction
function! s:IsPersistedBuffer()
    return ingo#buffer#IsPersisted()
endfunction
else
function! s:GetFilespec()
    return expand('%:p')
endfunction
function! s:IsPersistedBuffer()
    return (empty(&l:buftype) || &l:buftype ==# 'acwrite')
endfunction
endif


function! s:IsContainedInSessionBlacklist( filespec )
    return exists('g:ShowTrailingWhitespace_Blacklist') && has_key(g:ShowTrailingWhitespace_Blacklist, a:filespec)
endfunction
function! s:IsContainedInPersistedBlacklist( filespec )
    if ! exists('g:SHOWTRAILINGWHITESPACE_BLACKLIST')   " Check to avoid having to load the ingo/plugin/persistence.vim module when there's no persisted blacklist. This way, ingo-library stays optional for the main functionality.
	return 0
    endif

    return has_key(ingo#plugin#persistence#Load('SHOWTRAILINGWHITESPACE_BLACKLIST', {}), a:filespec)
endfunction

function! s:IsBlacklisted()
    let l:filespec = s:GetFilespec()
    return s:IsContainedInSessionBlacklist(l:filespec) || s:IsContainedInPersistedBlacklist(l:filespec)
endfunction
function! ShowTrailingWhitespace#Filter#BlacklistFile( isPermanent )
    if empty(bufname(''))
	call ingo#msg#ErrorMsg('Cannot add unnamed buffer to blacklist')
	return 0
    endif

    let l:filespec = s:GetFilespec()
    if a:isPermanent
	if ! ingo#plugin#persistence#Add('SHOWTRAILINGWHITESPACE_BLACKLIST', l:filespec, 1)
	    call ingo#msg#WarningMsg("Cannot persist marks, need ! flag in 'viminfo': :set viminfo+=!")
	endif
    else
	if ! exists('g:ShowTrailingWhitespace_Blacklist')
	    let g:ShowTrailingWhitespace_Blacklist = {}
	endif
	let g:ShowTrailingWhitespace_Blacklist[l:filespec] = 1
    endif

    call ShowTrailingWhitespace#Set(0, 0)
    return 1
endfunction
function! ShowTrailingWhitespace#Filter#RemoveFileFromBlacklist()
    let l:filespec = s:GetFilespec()
    if empty(l:filespec)
	call ingo#msg#ErrorMsg('Current file is unnamed')
	return 0
    endif

    let l:isRemoved = 0
    if s:IsContainedInPersistedBlacklist(l:filespec)
	call ingo#plugin#persistence#Remove('SHOWTRAILINGWHITESPACE_BLACKLIST', l:filespec)
	let l:isRemoved = 1
    endif
    if s:IsContainedInSessionBlacklist(l:filespec)
	unlet! g:ShowTrailingWhitespace_Blacklist[l:filespec]
	let l:isRemoved = 1
    endif

    if l:isRemoved
	call ShowTrailingWhitespace#Set(1, 0)
    else
	call ingo#msg#ErrorMsg("Current file isn't blacklisted: " . l:filespec)
    endif

    return l:isRemoved
endfunction


function! s:IsScratchBuffer()
    return (bufname('') =~# '\[Scratch]')
endfunction
function! s:IsForcedShow()
    return (ShowTrailingWhitespace#IsSet() == 2)
endfunction

function! ShowTrailingWhitespace#Filter#Default()
    if s:IsBlacklisted()
	return 0
    endif

    let l:isShownNormally = &l:modifiable && ! &l:binary && (s:IsPersistedBuffer() || s:IsScratchBuffer())
    return l:isShownNormally || s:IsForcedShow()
endfunction


if ! has('nvim') && (v:version == 800 && has('patch1596') || v:version > 800)
    augroup ShowTrailingWhitespace
	autocmd! TerminalOpen * call ShowTrailingWhitespace#Detect(0)
	" The filter will detect that 'buftype' is "terminal", so it's not one
	" of the persisted ones. Unfortunately, Vim first creates a normal empty
	" buffer (with 'buftype' empty), and only later changes the option.
    augroup END
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
