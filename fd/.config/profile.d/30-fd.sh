#!/bin/sh

if _chkcmd fd; then
  alias f="fd --list-details --ignore-case --hidden --follow --hyperlink=auto --one-file-system --exclude .git"
  alias fdir="fd --type dir --list-details --ignore-case --hidden --follow --hyperlink=auto --one-file-system --exclude .git"
fi
