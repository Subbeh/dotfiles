#!/bin/zsh
# vim: ft=zsh

if [ -f "$HOME/.profile" ]; then
  # setopt sh_word_split
  source "$HOME/.profile"
  # unsetopt sh_word_split
fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
