#!/bin/zsh

if [ -f "$HOME/.profile" ]; then
    # setopt sh_word_split
    source "$HOME/.profile"
    # unsetopt sh_word_split
fi
