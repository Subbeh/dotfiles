#!/bin/zsh

autoload -Uz compinit
compinit -u -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

_chkcmd zinit && zinit cdreplay -q
