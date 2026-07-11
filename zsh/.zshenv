#!/bin/zsh

# disable global zshrc, e.g. grml-zsh-config
#
# As we still want to source the other global startup files, defer unsetting
# global_rcs to zprofile in login shells and reenabled in zshrc.
#
# See: https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files
if [[ ! -o login ]]; then
  unsetopt global_rcs
fi

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
