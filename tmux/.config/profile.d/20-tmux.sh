#!/bin/bash
#
# Ensure user linger is enabled for tmux persistence
if ! loginctl show-user "$USER" | grep -q "Linger=yes"; then
  echo "Enabling user linger for tmux persistence..."
  loginctl enable-linger "$USER"
fi

alias mux=__tmuxinator_sessions

cda() {
  # cda - Change Directory All
  current_dir=$(pwd)

  window_index=$(tmux display-message -p '#I')

  tmux list-panes -F '#{pane_index} #{pane_current_command}' | while read -r pane_index pane_command; do
    if [ "$pane_index" != "$(tmux display-message -p '#{pane_index}')" ]; then
      if [[ "$pane_command" =~ (bash|zsh|sh|fish) ]]; then
        tmux send-keys -t "$window_index.$pane_index" "cd \"$current_dir\"" C-m
      else
        echo "Skipping pane $pane_index (running $pane_command)"
      fi
    fi
  done
}
