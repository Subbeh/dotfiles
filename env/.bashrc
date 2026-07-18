#!/usr/bin/bash
# shellcheck disable=1090

# Source shared profile.d for interactive non-login shells (login shells get it
# via .bash_profile -> .profile). Mirrors the equivalent guard in zsh's .zshrc.
if [[ $- == *i* ]] && ! shopt -q login_shell; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/profile.d.sh
fi

if [[ $- == *i* ]] && [ -d "$BASHCOMPDIR" ]; then
  for f in "$BASHCOMPDIR"/*; do
    source "$f"
  done
fi
