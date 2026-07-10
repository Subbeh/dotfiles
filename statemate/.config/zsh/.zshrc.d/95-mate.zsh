#!/bin/zsh

if [ "$PROFILE_OS" = "darwin" ]; then
  _bin=${PROJECT_DIR}/statemate/dist/mate-darwin-arm64
elif [ "$PROFILE_OS" = "linux" ]; then
  _bin=${PROJECT_DIR}/statemate/dist/mate-linux-amd64
fi

source <($_bin completion zsh)

rm -f "$BIN_DIR/mate"
ln -s "$_bin" "$BIN_DIR/mate" 2>/dev/null
