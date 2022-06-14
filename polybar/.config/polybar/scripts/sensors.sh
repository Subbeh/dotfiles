#!/bin/bash

main() {
  while true; do
    update
    sleep 1
  done
}

update() {
  output=()
   while read temp ; do 
    output+=($(format $temp))
  done <<< $(sensors | awk '/^Core/{ print substr($3,2) }')
  output+=($(format_fan))
  echo "${output[*]}"
}

format() {
  temp=${1%%.*}
  if (($temp < 60)) ; then
    #bg=aa303030
    bg=afd787
    fg=d7d7d7
  elif (($temp < 75)) ; then
    bg=fcc92d
    fg=303030
  elif (($temp < 85)) ; then
    bg=de935f
    fg=303030
  else
    bg=ff5f5f
    fg=303030
  fi

  echo "%{u#$bg}%{+u} $temp°C%{-u}"
}

format_fan() {
  for i in $(i8kctl -s fan -n 1; i8kctl -s fan -n 2) ; do
    case $i in
      1) echo  ;;
      2) echo  ;;
    esac
  done
}


main
