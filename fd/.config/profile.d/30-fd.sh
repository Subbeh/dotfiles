#!/bin/sh

_chkcmd fd && alias f="fd --list-details --ignore-case --hidden --follow --hyperlink=auto --one-file-system --exclude .git"
