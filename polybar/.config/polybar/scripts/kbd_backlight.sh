#!/bin/bash

trap "toggle" USR1

main() {
  while true; do
    status
    sleep 1
  done
}

status() {
  while read status ; do
    case $status in
        *Current\ brightness*) brightness=$(echo $status|awk '{print $3}') ;;
        *Max\ brightness*) max=$(echo $status|awk '{print $3}') ;;
    esac
  done <<< $(brightnessctl --device='dell::kbd_backlight' info)

  if (($brightness)) ; then
    echo "%{B#d7d7af}%{F#aa303030}  %{B- F-}"
  else
    echo "%{B#aa303030}%{F#d7d7d7}  %{B- F-}"
  fi
}

toggle() {
  if (($brightness)) ; then
    brightnessctl --device='dell::kbd_backlight' set 0 &> /dev/null
  else
    brightnessctl --device='dell::kbd_backlight' set ${max:-1} &> /dev/null
  fi
  status
}

main
