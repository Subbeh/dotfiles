t=0

locations=(
  Australia/Melbourne
  Europe/Amsterdam
  America/New_York
)

toggle() {
  case $1 in
    up) t=$(((t - 1) % ${#locations[@]})) ;;
  down) t=$(((t + 1) % ${#locations[@]})) ;;
  esac
}

trap "toggle up" USR1
trap "toggle down" USR2

while true; do
  TZ=${locations[$t]} date +" %H:%M %Z  %A %d %B %Y"
  sleep 1 &
  wait
done
