#!/bin/zsh

# disable global zshrc, see ~/.zshenv
unsetopt global_rcs

# Adopt the behavior of the system wide configuration
#
# See: https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files
emulate sh -c 'source ~/.profile'
