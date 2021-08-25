#!/bin/bash

main() {
  while true; do
    update
    sleep 1
  done
}

update() {
  output=()
  temps=$(sensors | grep Core | awk '{ print $3 }' | sed 's/^\+//')
  while read temp ; do
    output+=($(format_temp $temp))
  done <<< $temps
  #echo "${output[*]}" | sed 's/ //g'

  output+=($(format_fan))

  echo " ${output[*]}"
  #echo $temps | paste -sd ' ' | sed 's/ / - /g'
}

format_temp() {
  temp=${1%%.*}
  if (($temp < 60)) ; then
    color=689d6a    
  elif (($temp < 75)) ; then
    color=de935f
  else
    color=cc241d
  fi

  echo %{u#$color}%{+u}$temp°C%{-u}
}

format_fan() {
  for i in $(i8kfan) ; do
    case $i in
      0) echo  ;;
      1) echo  ;;
      2) echo  ;;
    esac
  done
}

main $*
