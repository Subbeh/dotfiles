#!/bin/sh

# set profile
if [ "$(uname -s)" = Darwin ]; then
  export ENV_PROFILE=work
  prepend_path "/opt/homebrew/bin"
fi
