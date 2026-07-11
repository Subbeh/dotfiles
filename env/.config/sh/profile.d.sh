#!/bin/sh
# shellcheck disable=1090,2046

# Load profiles from $XDG_CONFIG_HOME/profile.d
#
# Sourced by both ~/.profile (login shells) and zsh's .zshrc (interactive
# non-login shells), so profile.d scripts are available in every shell.

# Prepend "$1" to $PATH when not already in.
# This function API is accessible to scripts in $XDG_CONFIG_HOME/profile.d
prepend_path() {
  case ":$PATH:" in
    *:"$1":*) ;;
    *)
      PATH="$1${PATH:+:$PATH}"
      ;;
  esac
}

if test -d "$XDG_CONFIG_HOME"/profile.d/; then
  for profile in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
    test -r "$profile" && . "$profile"
  done
  unset profile
fi

prepend_path "$HOME/.local/bin"

# Force PATH to be environment
export PATH

# Unload our profile API functions
unset -f prepend_path
