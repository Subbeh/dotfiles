#!/bin/sh

export NVIM_APPNAME=nvim
export NVIM_HOME="$HOME/.config/$NVIM_APPNAME"

export EDITOR="nvim"
export DIFFPROG="$EDITOR -d"
export MERGE_EDITOR="$EDITOR -d"
export MANPAGER='nvim +Man!'

alias vi=nvim
