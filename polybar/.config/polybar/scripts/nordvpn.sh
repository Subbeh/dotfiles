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
  nordvpn status | grep -q Connected
  return $?
}

update() {
  command -v nordvpn &> /dev/null || exit 1
  if status ; then 
    echo -n "%{+o}"
  fi
  echo "  "
}

toggle() {
  if status ; then
    notify-send "NordVPN" "Disconnecting .."
    nordvpn disconnect &> /dev/null
  else
    notify-send "NordVPN" "Connecting .."
    nordvpn connect &> /dev/null || notify-send "NordVPN" "ERROR: Unable to connect"
  fi
}

main $*
