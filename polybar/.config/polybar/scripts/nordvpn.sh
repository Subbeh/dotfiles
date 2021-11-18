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
    echo -n "%{B#afd787}%{F#aa303030}"
  else
    echo -n "%{F#afd787}"
  fi
  echo "  "
}

toggle() {
  if status ; then
    nordvpn disconnect &> /dev/null
  else
    nordvpn connect melbourne &> /dev/null
  fi
}

main $*
