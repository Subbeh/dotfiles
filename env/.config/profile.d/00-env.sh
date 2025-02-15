#!/bin/sh

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export BIN_DIR="${HOME}/.local/bin"
if [ "$XDG_RUNTIME_DIR" = "" ]; then
  if [ "$TMPDIR" != "" ]; then
    XDG_RUNTIME_DIR="$TMPDIR"
  else
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
  fi
  export XDG_RUNTIME_DIR
fi

export EDITOR=vim
export PAGER=less

test -d "/data" && export DATA_DIR="/data"

if [ -d "/data/temp" ]; then
  TEMP_DIR="/data/temp"
elif [ -d "$HOME/temp" ]; then
  TEMP_DIR="$HOME/temp"
fi

if [ -d "/data/workspace" ]; then
  WORKSPACE_DIR="/data/workspace"
elif [ -d "$HOME/workspace" ]; then
  WORKSPACE_DIR="$HOME/workspace"
fi

export TEMP_DIR WORKSPACE_DIR

test -d "${WORKSPACE_DIR}/notes" && export NOTES_DIR="${WORKSPACE_DIR}/notes"
test -d "${WORKSPACE_DIR}/projects" && export PROJECT_DIR="${WORKSPACE_DIR}/projects"
test -d "${WORKSPACE_DIR}/homelab" && export HOMELAB_DIR="${WORKSPACE_DIR}/homelab"
test -d "${WORKSPACE_DIR}/repos" && export REPOS_DIR="${WORKSPACE_DIR}/repos"
