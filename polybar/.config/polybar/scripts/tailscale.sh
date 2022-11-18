#!/bin/sh

trap "toggle" USR1
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

main() {
  while true; do
    update
    sleep 1
  done
}

status() {
  tailscale status &> /dev/null
  return $?
}

update() {
  command -v tailscale &> /dev/null || exit 1
  if status ; then 
    echo -n "%{+o}"
  fi
  echo "  "
}

toggle() {
  if status ; then
    notify-send "Tailscale" "Disconnecting .."
    tailscale down &> /dev/null
  else
    notify-send "Tailscale" "Connecting .."
    tailscale up --accept-routes &> /dev/null || notify-send "Tailscale" "ERROR: Unable to connect"
  fi
}

main $*
