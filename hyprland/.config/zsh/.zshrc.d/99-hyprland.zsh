#!/bin/zsh

function update_hyprland_signature() {
  if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ] && [ -S "$XDG_RUNTIME_DIR"/hypr/*/.socket.sock ]; then
    export HYPRLAND_INSTANCE_SIGNATURE="$(ls -t "$XDG_RUNTIME_DIR"/hypr/*/.socket.sock 2>/dev/null | head -1)"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_hyprland_signature
