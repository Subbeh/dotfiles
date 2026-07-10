#!/bin/sh
# shellcheck disable=1090,2046

# Most of this script is a user scoped version of /etc/profile from the
# Arch Linux's 'filesystem' package

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

# Use systemd-environment-d-generator(8) to generate environment, and export
# those variables
#
# See: https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session
for generator in /usr/lib/systemd/user-environment-generators/*; do
  set -a
  . /dev/fd/0 <<-EOF
		$($generator)
	EOF
  set +a
done

# Load profiles from $XDG_CONFIG_HOME/profile.d
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
