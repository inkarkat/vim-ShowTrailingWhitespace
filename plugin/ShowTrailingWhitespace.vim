" ShowTrailingWhitespace.vim: Detect and delete unwanted whitespace at the end of lines.
"
" DEPENDENCIES:
"   - ShowTrailingWhitespace.vim autoload script.
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	002	26-Feb-2012	Move functions to autoload script.
"				Rewrite example commands with new autoload
"				functions.
"	001	25-Feb-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ShowTrailingWhitespace') || (v:version == 701 && ! exists('*matchadd')) || (v:version < 701)
    finish
endif
let g:loaded_ShowTrailingWhitespace = 1

if ! exists('g:ShowTrailingWhitespace')
    let g:ShowTrailingWhitespace = 1
endif

augroup ShowTrailingWhitespace
    autocmd!
    autocmd BufWinEnter,InsertLeave * call ShowTrailingWhitespace#Detect(0)
    autocmd InsertEnter             * call ShowTrailingWhitespace#Detect(1)
augroup END

highlight def link ShowTrailingWhitespace Error

"command! -bar ShowTrailingWhitespaceOn          call ShowTrailingWhitespace#Set(1,1)
"command! -bar ShowTrailingWhitespaceOff         call ShowTrailingWhitespace#Set(0,1)
"command! -bar ShowTrailingWhitespaceBufferOn    call ShowTrailingWhitespace#Set(1,0)
"command! -bar ShowTrailingWhitespaceBufferOff   call ShowTrailingWhitespace#Set(0,0)
"command! -bar ShowTrailingWhitespaceBufferClear call ShowTrailingWhitespace#Reset()

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
