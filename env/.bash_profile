#!/bin/bash
# shellcheck disable=1090

export BASH_COMPLETION_USER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions"

. ~/.profile

if [[ $- == *i* ]]; then . ~/.bashrc; fi
