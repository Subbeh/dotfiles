#!/bin/sh

if [ "$PROFILE_OS" = "linux" ]; then
  # Reset HYPRLAND_INSTANCE_SIGNATURE to newest Hyprland instance
  update_hyprland_signature() {
    newest_socket="$(find "$XDG_RUNTIME_DIR/hypr" -maxdepth 2 -name '.socket.sock' -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)"
    [ -n "$newest_socket" ] || return
    export HYPRLAND_INSTANCE_SIGNATURE="$(basename "$(dirname "$newest_socket")")"
  }
  update_hyprland_signature

  # hyprland
  alias hl="start-hyprland"
  alias hyprlog="hyprctl rollinglog -f"
  alias hyprcd='cd $XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-$(basename $(find $XDG_RUNTIME_DIR/hypr/*/ -maxdepth 1 -type d | tail -1))}/'
  alias hyprsig=update_hyprland_signature

  hyprdbg() {
    hyprctl eval "hl.notification.create({ text = \"debug: \" .. tostring($*), timeout = 5000 })"
  }
fi
