#!/bin/bash
#
# Ensure user linger is enabled for tmux persistence
if _chkcmd loginctl && ! loginctl show-user "$USER" | grep -q "Linger=yes"; then
  echo "Enabling user linger for tmux persistence..."
  loginctl enable-linger "$USER"
fi

alias mux=__tmuxinator_sessions
