#!/bin/sh

export TASKRC="${XDG_CONFIG_HOME}/task/taskrc"
export TASKDATA="${WORKSPACE_DIR:?not set}/tasks"

if [ "$PROFILE_OS" = "darwin" ]; then
  export TASKWARRIOR_TUI_TASKWARRIOR_CLI="$(ls -t /opt/homebrew/Cellar/task/*/bin/task | head -1)"
fi
