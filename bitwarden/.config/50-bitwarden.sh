#!/bin/sh

export BITWARDENCLI_APPDATA_DIR="${BITWARDENCLI_APPDATA_DIR:-"$HOME/.local/share/bitwardencli"}"
export BW_SESSION="$(gpg --decrypt "$BITWARDENCLI_APPDATA_DIR/.bitwarden-session.keychain" 2>/dev/null)"

bwunlock() {
  command bwunlock && export BW_SESSION="$(gpg --decrypt "$BITWARDENCLI_APPDATA_DIR/.bitwarden-session.keychain" 2>/dev/null)"
}
