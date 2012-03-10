" - The email signature separator consists of dash-dash-space.
" - Email headers from Outlook or the Thunderbird "External Editor" add-on
"   may leave whitespace after mail headers. Ignore them unless it's the
"   Subject: header.
call ShowTrailingWhitespace#SetLocalExtraPattern( '\%(^\%(--\|\%(From\|Sent\|To\|Cc\|Bcc\):.*\)\)\@<!')
