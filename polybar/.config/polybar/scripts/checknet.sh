#!/usr/bin/env bash

WIRED=eth0 WIRED_ICON=
WIFI=wlan0 WIFI_ICON=
VM=vboxnet0 VM_ICON=
VPN_ICON=
STATUS_ICON= 

clr=#87d7ff

URL='https://nordvpn.com/wp-admin/admin-ajax.php?action=get_user_info_data'
#URL='https://api.nordvpn.com/vpn/check/full'

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

[[ $(pgrep -f $0) != "$$" ]] && { echo script is already running ; exit 1; }

main() {
  i=0
  while true ; do
    if (($((i++ % 10)) == 0)) ; then
      check_inet ; inet_status=$?
      check_vpn ; vpn_status=$?
      (($inet_status)) && wan_ip=$(get_ip) || wan_ip=
    fi
    inet_dev=$(get_inet_dev)
    link_status
    update_bar
    sleep 1
  done
}

link_status() {
  connections=()
  icon=
  links=$(ip link | awk -F'[: ]' '/state UP/ {print $3}')

  for link in $links ; do
    ip=$(ip -4 -o addr show $link | awk '{sub(/\/.*/, "", $4); print $4}')
    case $link in
      $WIFI) [[ "$inet_dev" == "$WIFI" && $inet_status == 1 ]] && icon=%{F$clr}$WIFI_ICON%{F-} || icon=$WIFI_ICON ;;
      $WIRED) [[ "$inet_dev" == "$WIRED" && $inet_status == 1 ]] && icon=%{F$clr}$WIRED_ICON%{F-} || icon=$WIRED_ICON ;;
      $VM) [[ "$inet_dev" == "$VM" && $inet_status == 1 ]] && icon=%{F$clr}$VM_ICON%{F-} || icon=$VM_ICON ;;
      *) icon= ;;
    esac
    connections+=($icon $ip) 
  done
}

get_ip() { dig -4 @ns1.google.com -t txt o-o.myaddr.l.google.com +short | tr -d \"; }
get_inet_dev() { ip route get 8.8.8.8 | grep -Po '(?<=(dev ))(\S+)'; }
check_inet() { (ping -c 1 8.8.8.8 || ping -c 1 1.1.1.1) &>/dev/null && return 1 || return 0; }
check_vpn() { json=$(curl -s $URL); return $(echo $json | python -c 'import sys, json; data = json.load(sys.stdin); print(1 if data["status"] is True else 0);'); }

update_bar() {
  (($vpn_status)) && echo -n "%{F$clr}$VPN_ICON%{F-} " || echo -n "$VPN_ICON "
  echo ${connections[*]}
}

main
#check_vpn ; echo $?
