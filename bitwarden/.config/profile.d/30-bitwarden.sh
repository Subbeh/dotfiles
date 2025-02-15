#!/bin/sh

export BITWARDENCLI_APPDATA_DIR="${XDG_DATA_HOME}/bitwarden"

bwunlock() {
	keychain_file="${BITWARDENCLI_APPDATA_DIR}/.bitwarden-session.keychain"
	gpg_key="1BFE9EB0434D7D1C"

	bw unlock --raw | gpg --yes --encrypt --recipient "$gpg_key" -o "$keychain_file" &&
		chmod 600 "$keychain_file"
}

alias bw="BW_SESSION=\$(gpg --decrypt \$BITWARDENCLI_APPDATA_DIR/.bitwarden-session.keychain) bw"

