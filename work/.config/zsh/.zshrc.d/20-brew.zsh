#!/bin/zsh

if test -x /opt/homebrew/bin/brew; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"

  alias bu="brew update && brew upgrade --quiet --force"
fi
