#!/bin/bash

alias mux=__tmuxinator_sessions

cda() {
  # cda - Change Directory All
  if [[ "$1" ]]; then
    current_dir=$(pwd)
  fi

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
