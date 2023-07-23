#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

WIFI=wlan0
WIRED=eth0
VPN=proton
ICON_WIFI=
ICON_WIRED=
ICON_VPN=
ICON_TAILSCALE=
ICON_ADGUARD=
CLR=#87d7ff
CLR_ERR=#ff5f5f
ADGUARD_URL="http://10.11.254.1:5380/control"
ADGUARD_USER="sysadm"
ADGUARD_PASSWORD="$(<$HOME/.adguard_api)"
ADGUARD_DISABLE_TIME=1800

main() {
	while getopts vat flag; do
		case "${flag}" in
		v) toggle_vpn ;;
		a) toggle_adguard ;;
		t) toggle_tailscale ;;
		esac
	done

	get_inet_status
	inet_status=$?
	get_vpn_status
	vpn_status=$?
	get_adguard_status
	adguard_status=$?
	get_tailscale_status
	tailscale_status=$?
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

	for link in $links; do
		ip=$(ip -4 -o addr show $link | awk '{sub(/\/.*/, "", $4); print $4}')
		case $link in
		$WIFI) [[ "$inet_dev" == "$WIFI" && $inet_status == 0 ]] && icon=%{F$CLR}$ICON_WIFI%{F-} || icon=$ICON_WIFI ;;
		$WIRED) [[ "$inet_dev" == "$WIRED" && $inet_status == 0 ]] && icon=%{F$CLR}$ICON_WIRED%{F-} || icon=$ICON_WIRED ;;
		*) icon= ;;
		esac
		connections+=($icon $ip)
	done
}

get_vpn_status() {
	# for dev in "${VPN[@]}"; do
	# 	if ip link show $dev >/dev/null 2>&1; then
	# 		case "$dev" in
	# 		*nord*)
	# 			nordvpn status | grep -q Connected && return 1
	# 			;;
	# 		*mullvad*)
	# 			mullvad status | grep -q Connected && return 1
	# 			;;
	# 		esac
	# 	fi
	# done
	ip link show ${VPN:?not set} &>/dev/null
}

get_tailscale_status() {
	tailscale status &>/dev/null
	return $?
}

get_adguard_cookie() {
	curl -si -X POST "${ADGUARD_URL}/login" \
		-H 'Content-Type: application/json' \
		-d "{\"name\":\"$ADGUARD_USER\",\"password\":\"$ADGUARD_PASSWORD\"}" | grep -oE 'agh_session=\w+' >/tmp/adguard_cookie
}

get_adguard_status() {
	[ ! -s /tmp/adguard_cookie ] && get_adguard_cookie
	_status=$(
		curl -is --cookie "$(</tmp/adguard_cookie)" "${ADGUARD_URL}/status" |
			awk '/403 Forbidden/ { system("get_adguard_cookie") } NR==7' | jq '.protection_enabled'
	)
	case "$_status" in
	true) return 0 ;;
	false) return 1 ;;
	*) return 2 ;;
	esac
}

toggle_vpn() {
	if ! get_vpn_status; then
		notify-send "VPN" "Connecting .."
		nmcli connection up $VPN && notify-send "VPN" "Connected"
	else
		notify-send "VPN" "Disconnecting .."
		nmcli connection down $VPN && notify-send "VPN" "Disconnected"
	fi

	if (($?)); then
		notify-send "VPN" "Error setting interface up/down"
	fi
}

toggle_tailscale() {
	if get_tailscale_status; then
		notify-send "Tailscale" "Disconnecting .."
		tailscale down &>/dev/null && notify-send "Tailscale" "Disconnected"
	else
		notify-send "Tailscale" "Connecting .."
		tailscale up --accept-routes &>/dev/null && notify-send "Tailscale" "Connected" || notify-send "Tailscale" "ERROR: Unable to connect"
	fi
}

toggle_adguard() {
	get_adguard_status
	case "$?" in
	0)
		_body="{\"duration\":$((ADGUARD_DISABLE_TIME * 1000)),\"enabled\":false}"
		notify-send "AdGuard" "Disabling .."
		;;
	1)
		_body="{\"enabled\":true}"
		notify-send "AdGuard" "Enabling .."
		;;
	*) return 1 ;;
	esac
	curl -is --cookie "$(</tmp/adguard_cookie)" -X POST "${ADGUARD_URL}/protection" \
		-H 'Content-Type: application/json' \
		-d "$_body"
}

update_bar() {
	# adguard
	echo -n "%{A1:$0 -a:}"
	case "$adguard_status" in
	0) echo -n "%{F$CLR}$ICON_ADGUARD%{F-} " ;;
	1) echo -n "$ICON_ADGUARD " ;;
	*) echo -n "%{F$CLR_ERR}$ICON_ADGUARD%{F-} " ;;
	esac
	echo -n "%{A}"

	# tailscale
	echo -n "%{A1:$0 -t:}"
	(($tailscale_status)) && echo -n "$ICON_TAILSCALE " || echo -n "%{F$CLR}$ICON_TAILSCALE%{F-} "
	echo -n "%{A}"

	# vpn
	echo -n "%{A1:$0 -v:}"
	case "$vpn_status" in
	0) echo -n "%{F$CLR}$ICON_VPN%{F-} " ;;
	1) echo -n "$ICON_VPN " ;;
	esac
	echo -n "%{A}"

	# network interfaces
	echo ${connections[*]}
}

export -f get_adguard_cookie
main $*
