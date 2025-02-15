#!/bin/sh
# shellcheck disable=1090,2046

# Most of this script is a user scoped version of /etc/profile

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

# Load profiles from $XDG_CONFIG_HOME/profile.d
if test -d "${XDG_CONFIG_HOME:-$HOME/.config}"/profile.d/; then
	for profile in "${XDG_CONFIG_HOME:-$HOME/.config}"/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

prepend_path "$HOME/.local/bin"

# Force PATH to be environment
export PATH

# Unload our profile API functions
unset -f prepend_path
