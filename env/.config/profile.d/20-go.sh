#!/bin/sh

export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$HOME/.local/bin"

prepend_path "$GOPATH/bin"
