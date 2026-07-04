#!/bin/zsh

bwunlock() {
  command bwunlock && export BW_SESSION="$(gpg --decrypt "$BITWARDENCLI_APPDATA_DIR/.bitwarden-session.keychain" 2>/dev/null)"
}
