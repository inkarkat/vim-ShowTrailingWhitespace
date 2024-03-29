SHOW TRAILING WHITESPACE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin highlights whitespace at the end of each line (except when typing
at the end of a line). It uses the matchadd()-function, therefore doesn't
interfere with syntax highlighting and leaves the :match command for other
uses.
Highlighting can be switched on/off globally and for individual buffers. The
plugin comes with exceptions for certain filetypes, where certain lines can /
must include trailing whitespace; additional patterns can be configured.

### SEE ALSO

Many plugins also come with a command to strip off the trailing whitespace;
this plugin separates this into the companion DeleteTrailingWhitespace.vim
plugin ([vimscript #3967](http://www.vim.org/scripts/script.php?script_id=3967)), which can even remove the trailing whitespace
automatically on each write.

To quickly locate the occurrences of trailing whitespace, you can use the
companion JumpToTrailingWhitespace.vim plugin ([vimscript #3968](http://www.vim.org/scripts/script.php?script_id=3968)).

### RELATED WORKS

There are already a number of plugins for this purpose, most based on this
VimTip:
    http://vim.wikia.com/wiki/Highlight_unwanted_spaces
However, most of them use the older :match command and are not as flexible.
- smartmatcheol.vim ([vimscript #2635](http://www.vim.org/scripts/script.php?script_id=2635)) highlights based on file extension or
  name.
- trailing-whitespace ([vimscript #3201](http://www.vim.org/scripts/script.php?script_id=3201)) uses :match.
- bad-whitespace ([vimscript #3735](http://www.vim.org/scripts/script.php?script_id=3735)) uses :match, allows on/off/toggling via
  commands.
- Trailer Trash ([vimscript #3938](http://www.vim.org/scripts/script.php?script_id=3938)) uses :match.
- DynamicSigns ([vimscript #3965](http://www.vim.org/scripts/script.php?script_id=3965)) can show whitespace errors (also mixed
  indent) in the sign column.
- better-whitespace ([vimscript #4859](http://www.vim.org/scripts/script.php?script_id=4859)) can use either :match or :syntax (with
  the option of excluding the current line), and has a :StripWhitespace
  command, also automatic triggering for some filetypes.
- ShowSpaces ([vimscript #5148](http://www.vim.org/scripts/script.php?script_id=5148)) highlights spaces inside indentation, per
  buffer / filetype.

USAGE
------------------------------------------------------------------------------

    By default, trailing whitespace is highlighted in all Vim buffers. Some users
    may want to selectively enable / disable this for certain filetypes, or files
    in a particular directory hierarchy, or toggle this on demand. Since it's
    difficult to accommodate all these demands with short and easy mappings and
    commands, this plugin does not define any of them, and leaves it to you to
    tailor the plugin to your needs. See ShowTrailingWhitespace-configuration
    below.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-ShowTrailingWhitespace
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim ShowTrailingWhitespace*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.1 with "matchadd()", or Vim 7.2 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.043 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

To change the highlighting colors (do this after any :colorscheme):

    highlight ShowTrailingWhitespace ctermbg=Red guibg=Red

The default highlighting links to the "Error" highlight group.

As a background color is needed to highlight the whitespace, the plugin
inspects the linked highlight group and switches to its foreground color if
your chosen colorscheme does not define a background color there. You can turn
off this logic via:

    let g:ShowTrailingWhitespace_IsAutomaticBackground = 0

By default, highlighting is enabled for all buffers, and you can (selectively)
disable it. To work from the opposite premise, launch Vim with highlighting
disabled:

    let g:ShowTrailingWhitespace = 0

With regards to exceptions, the plugin offers multiple approaches: The most
generic is a filter function where your code tells the plugin whether it
should check or ignore. By default, the plugin uses this to offer a file-based
set of blacklists, one persisted and one only for the current session.
Alternatively, you can use Vim's built-in functionality like :autocmd or
filetype-plugins, and invoke plugin function to enable / disable it from
there. These plugin functions can also be used to define custom toggle
commands or mappings, allowing you to interactively control the plugin.

In addition to toggling the highlighting on/off via
g:ShowTrailingWhitespace, the decision can also be influenced by buffer
settings or the environment. By default, buffers that are not persisted to
disk (unless they are explicitly marked as "[Scratch]" buffers) or not
modifiable (like user interface windows from various plugins, but note that
clearing the option is usually done too late) are skipped. You can disable
this filtering:

    let g:ShowTrailingWhitespace_FilterFunc = ''

or install your own custom filter function instead:

    let g:ShowTrailingWhitespace_FilterFunc = function('MyFunc')

The default filter also checks two blacklists:
- \*g:ShowTrailingWhitespace\_Blacklist\* (valid for the current Vim session)
- \*g:SHOWTRAILINGWHITESPACE\_BLACKLIST\* (persisted across Vim sessions)
You can define your own commands or mappings to add or remove the current file
to that blacklist:
 <!-- -->

    command! -bar ShowTrailingWhitespaceBlacklistForSession  call ShowTrailingWhitespace#Filter#BlacklistFile(0)
    command! -bar ShowTrailingWhitespaceBlacklistPermanently call ShowTrailingWhitespace#Filter#BlacklistFile(1)
    command! -bar ShowTrailingWhitespaceBlacklistRemoveFile  call ShowTrailingWhitespace#Filter#RemoveFileFromBlacklist()

Highlighting can be enabled / disabled globally and for individual buffers.
Analog to the :set and :setlocal commands, you can define the following
commands:

    command! -bar ShowTrailingWhitespaceOn          call ShowTrailingWhitespace#Set(1,1)
    command! -bar ShowTrailingWhitespaceOff         call ShowTrailingWhitespace#Set(0,1)
    command! -bar ShowTrailingWhitespaceBufferOn    call ShowTrailingWhitespace#Set(1,0)
    command! -bar ShowTrailingWhitespaceBufferOff   call ShowTrailingWhitespace#Set(0,0)

To set the local highlighting back to its global value (like :set {option}&lt;
does), the following command can be defined:

    command! -bar ShowTrailingWhitespaceBufferClear call ShowTrailingWhitespace#Reset()

You can also define a quick mapping to toggle the highlighting (here, locally;
for global toggling use ShowTrailingWhitespace#Toggle(1):

    nnoremap <silent> <Leader>t$ :<C-u>call ShowTrailingWhitespace#Toggle(0)<Bar>
    \ echo (ShowTrailingWhitespace#IsSet() ?
    \   'Show trailing whitespace' :
    \   'Not showing trailing whitespace')<CR>

For some filetypes, trailing whitespace is part of the syntax or even
mandatory. To disable the plugin for a filetype, put the following in a file
named e.g. ftplugin/{filetype}\_ShowTrailingWhitespace.vim:

    if ShowTrailingWhitespace#IsSet()
        call ShowTrailingWhitespace#Set(0,0)
    endif

The plugin already ships with some common exceptions; you can submit yours,
too!

Some filetypes need trailing whitespace only in certain places. If you don't
want to be bothered by these showing up as false positives, you may be able to
augment the regular expression so that these places do not match. The
ShowTrailingWhitespace#SetLocalExtraPattern() function takes a regular
expression that is prepended to the pattern for the trailing whitespace
('\\s\\+\\%#\\@&lt;!$' in insert mode, '\\s\\+$' otherwise). For a certain filetype,
this is best set in a file ftplugin/{filetype}\_ShowTrailingWhitespace.vim.

INTEGRATION
------------------------------------------------------------------------------

The ShowTrailingWhitespace#IsSet() function can be used to query the on/off
status for the current buffer, e.g. for use in the statusline.

To obtain the pattern for matching trailing whitespace, including any
ShowTrailingWhitespace-exceptions, you can use the function
ShowTrailingWhitespace#Pattern(0).

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-ShowTrailingWhitespace/issues or email
(address below).

HISTORY
------------------------------------------------------------------------------

##### 1.12    01-Nov-2022
- More robust and efficient iteration through visible windows through
  win\_execute() (where available).
- Add (hard, previously only optional) dependency to ingo-library (vimscript
  #4433).
- diff filetype: Exclude patch instructions that just consist of # + single
  space.

__You need to separately install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version
  1.043 (or higher)!__

##### 1.11    21-Dec-2020
- Neovim does not have the TerminalOpen event; don't use it then, to avoid
  startup errors. (Patch by subnut.)
- Exempt the "xxd" filetype used e.g. by the Hexman plugin ([vimscript #666](http://www.vim.org/scripts/script.php?script_id=666)).
- ENH: The plugin now inspects the linked highlight group and switches to its
  foreground color if your chosen colorscheme does not define a background
  color there, to avoid that no trailing whitespace highlighting can be seen.
  This logic can be disabled through
  g:ShowTrailingWhitespace\_IsAutomaticBackground. Thanks to subnut for raising
  this issue, providing a suggestion on how to fix that and a patch for Neovim
  compatibility.

##### 1.10    11-Jul-2020
- The default g:ShowTrailingWhitespace\_FilterFunc now also skips highlighting
  in |terminal-window|s. Unfortunately, this requires a special hook, as the
  'buftype' gets set too late.
- ENH: Make the default filter also consider session-local and persistent
  blacklists for files where highlighting should be off. Offer public
  functions to implement custom commands or mappings for blacklist management.
  See ShowTrailingWhitespace-blacklist for details.
- FIX: Avoid creating jump when enabling / setting a local extra pattern.

__You need to separately install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version
  1.036 (or higher) in order to use the blacklist feature!__

##### 1.03    19-Mar-2015
- Exempt the "unite" filetype used by the Unite plugin ([vimscript #3396](http://www.vim.org/scripts/script.php?script_id=3396)).
  Thanks to Fernando "Firef0x" G.P. da Silva for the patch.

##### 1.02    08-Mar-2015
- Add whitespace exception for the "markdown" filetype.
- Make ShowTrailingWhitespace#IsSet() also handle Vim 7.0/1 where the
  g:ShowTrailingWhitespace variable is not set. Return 0 instead of causing a
  function abort.
- ENH: Keep previous (last accessed) window on :windo.

##### 1.01    14-Dec-2013
- Minor: Also exclude quickfix and help buffers from detection.
- Add whitespace exception for the "dosbatch" filetype.

##### 1.00    16-Mar-2012
- First published version.

##### 0.01    25-Feb-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
