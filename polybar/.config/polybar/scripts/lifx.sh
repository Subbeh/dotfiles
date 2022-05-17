#!/bin/sh

CMD='lifx -g Office'
PIPE=/tmp/lifx.pipe
ICN=
CLR=${XCLR_COLOR3:-#de935f}
declare -i brightness

test -e $PIPE && exit 1
mkfifo -m 0600 $PIPE

trap "trap - SIGTERM && rm -f $PIPE && kill -- -$$" SIGINT SIGTERM EXIT

main() {
  update
  while true; do
    ((i++ % 60)) || { status; i=1; }
    sleep 1 &
    wait $!
  done &

  while read cmd ; do
    case $cmd in
      toggle) toggle ;;
      status) status ;;
      up)     brightness up ;;
      down)   brightness down ;;
    esac
  done < $PIPE 3> $PIPE
}

status() {
  while read status ; do
    case $status in
      *power*on*) power=1 ;;
      *power*off*) power=0 ;;
      *brightness*) brightness=$(echo $status | awk '-F[:,]' '{ print substr($2,0,5) *100 }') ;;
    esac
  done <<< $($CMD -a 2> /dev/null) 
  update
}

update() {
  (($power)) && echo -n "%{o$CLR}%{+o}"
  echo $ICN ${brightness:+$brightness% }
}

toggle() {
  (($power)) && notify-send "LIFX" "Turning on light..." || notify-send "LIFX" "Turning off light..."
  $CMD -T &> /dev/null
  status
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
  dunstify "LIFX brightness: " -h int:value:$brightness
  $CMD -B $brightness &>/dev/null &
  update
}

main $*

