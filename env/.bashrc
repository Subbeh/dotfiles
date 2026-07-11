#!/usr/bin/bash
# shellcheck disable=1090

if [[ $- == *i* ]] && [ -d "$BASHCOMPDIR" ]; then
  for f in "$BASHCOMPDIR"/*; do
    source "$f"
  done
fi
