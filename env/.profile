#!/bin/sh
# shellcheck disable=1090,2046

# Most of this script is a user scoped version of /etc/profile from the
# Arch Linux's 'filesystem' package

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

# Load profiles from $XDG_CONFIG_HOME/profile.d (also sourced by zsh's .zshrc
# for interactive non-login shells, which do not run this file)
. "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/profile.d.sh
