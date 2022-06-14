#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

readonly WIFI=wlan0 WIFI_ICON=
readonly WIRED=eth0 WIRED_ICON=
readonly VPN=wg-mullvad VPN_ICON=
readonly PIHOLE_ICON=
readonly PIHOLE_URL='http://pi/admin/api.php?auth=6bf6f2a462785f9f79e41ccffd2039dc3f066f369a2973d5e605170c2d186fc4'
readonly CLR=#87d7ff

main() {
  while getopts vp flag
  do
    case "${flag}" in
      v) toggle_vpn ;;
      p) toggle_pihole ;;
    esac
  done

  get_inet_status ; inet_status=$?
  get_vpn_status ; vpn_status=$?
  get_pihole_status ; pihole_status=$?
  inet_dev=$(get_inet_dev)
  get_link_status
  update_bar
}

get_inet_dev() {
  ip route get 8.8.8.8 | grep -Po '(?<=(dev ))(\S+)'
}

get_inet_status() { 
  (ping -c 1 8.8.8.8 || ping -c 1 1.1.1.1) &>/dev/null
  return $?
}

get_link_status() {
  connections=()
  links=$(ip link | awk -F'[: ]' '/state UP/ {print $3}')

  for link in $links ; do
    ip=$(ip -4 -o addr show $link | awk '{sub(/\/.*/, "", $4); print $4}')
    case $link in
      $WIFI) [[ "$inet_dev" == "$WIFI" && $inet_status == 0 ]] && icon=%{F$CLR}$WIFI_ICON%{F-} || icon=$WIFI_ICON ;;
      $WIRED) [[ "$inet_dev" == "$WIRED" && $inet_status == 0 ]] && icon=%{F$CLR}$WIRED_ICON%{F-} || icon=$WIRED_ICON ;;
      *) icon= ;;
    esac
    connections+=($icon $ip)
  done
}

get_vpn_status() {
  mullvad status | grep -q Connected
  return $?
}

get_pihole_status() {
  curl -sf "${PIHOLE_URL}&status" | grep -q enabled 2>/dev/null
  return $?
}

toggle_vpn() {
  if get_vpn_status ; then
    notify-send "Mullvad VPN" "Disconnecting .."
    mullvad disconnect 
  else
    notify-send "Mullvad VPN" "Connecting .."
    mullvad connect
  fi
}

toggle_pihole() {
  if get_pihole_status ; then
    action=disable
    notify-send "Pi-hole" "Disabling .."
  else
    action=enable
    notify-send "Pi-hole" "Enabling .."
  fi
  curl -sf "${PIHOLE_URL}&${action}"
}

update_bar() {
  # vpn
  echo -n "%{A1:$0 -v:}"
  (($vpn_status)) && echo -n "$VPN_ICON " || echo -n "%{F$CLR}$VPN_ICON%{F-} "
  echo -n "%{A}"

  # pihole
  echo -n "%{A1:$0 -p:}"
  (($pihole_status)) && echo -n "$PIHOLE_ICON " || echo -n "%{F$CLR}$PIHOLE_ICON%{F-} "
  echo -n "%{A}"

  # network interfaces
  echo ${connections[*]}
}

main $*
