#!/bin/sh

# Make sure hyprpolkitdaemon is enabled
if systemctl --user cat hyprpolkitagent.service >/dev/null 2>&1; then
  systemctl --user enable --now hyprpolkitagent.service
fi

# Reset HYPRLAND_INSTANCE_SIGNATURE to newest Hyprland instance
update_hyprland_signature() {
  if [ "$HYPRLAND_INSTANCE_SIGNATURE" != "" ]; then
    newest_socket="$(ls -t "$XDG_RUNTIME_DIR"/hypr/*/.socket.sock 2>/dev/null | head -1)"
    if [ "$newest_socket" != "" ]; then
      HYPRLAND_INSTANCE_SIGNATURE="$(basename "$(dirname "$newest_socket")")"
    fi
  fi
}
update_hyprland_signature

# hyprland
alias hl="uwsm check may-start && uwsm start hyprland.desktop"
alias hyprlogs='less $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log'
alias hyprdir='cd $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/'
alias hyprstop='uwsm stop'
alias hyprkill='loginctl terminate-session 1'
alias hyprnuke='loginctl terminate-user ""'

# clipboard
alias cc="fc -ln -1 | wl-copy -n"
alias xc="wl-copy -n"
alias xp="pwd | wl-copy -n"
