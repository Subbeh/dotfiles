#!/bin/sh

CMD='lifx -g Office'

pipe=/tmp/lifx.pipe
test -e $pipe && rm $pipe
mkfifo -m 0600 $pipe

declare -i brightness
offclr=#aa303030 offclrfg=#d7d7d7 clr=#de935f

trap "trap - SIGTERM && rm -f $pipe && kill -- -$$" SIGINT SIGTERM EXIT

main() {
  reset
  status
  while true; do
    ((i++ % 60)) || { status && update; i=1; }
    sleep 1 &
    wait $!
  done &

  while read cmd ; do
    #echo test
    case $cmd in
      toggle) toggle ;;
      up)     brightness up ;;
      down)   brightness down ;;
    esac
  done < $pipe 3> $pipe
}

reset() {
  bg=$offclr fg=$offclrfg update
}

toggle() {
  ($CMD -T && $CMD -a) &> /dev/null &
  reset
  sleep 5
  status && update
}

brightness() {
  case $1 in
    up) x=1 ;;
    down) x=-1 ;;
  esac

  brightness+=$((10 * $x))
  if (($brightness > 100)) ; then
    brightness=100
  elif (($brightness < 0)) ; then
    brightness=0
  fi
  update
  $CMD -B $brightness &>/dev/null &
}

status() {
  while read status ; do
    case $status in
      *power*on*) bg=$clr fg=$offclr icon= ;;
      *power*off*) bg=$offclr fg=$offclrfg icon=%{F$clr}%{F$fg} ;;
      *brightness*) brightness=$(echo $status | awk '-F[:,]' '{ print substr($2,0,5) *100 }') ;;
    esac
  done <<< $($CMD -a 2> /dev/null) 
}

update() {
  echo "%{B$bg}%{F$fg} $icon ${brightness:+$brightness% }"
}

main $*
