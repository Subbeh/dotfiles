#!/bin/zsh

if [ "$PROFILE_OS" = "darwin" ]; then
  _bin=${XDG_PROJECTS_HOME}/statemate/dist/mate-darwin-arm64
elif [ "$PROFILE_OS" = "linux" ]; then
  _bin=${XDG_PROJECTS_HOME}/statemate/dist/mate-linux-amd64
fi

if [ -x "$_bin" ]; then
  source <($_bin completion zsh)
  ln -s "$_bin" "$XDG_BIN_HOME/mate" 2>/dev/null
fi

mate() {
  command mate "$@"
  local ret=$?
  if [[ $ret -eq 0 && "$1" == "apply" ]]; then
    pkill -u "$USER" zsh --signal=USR1 2>/dev/null || true
  fi
  return $ret
}
