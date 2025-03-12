#!/bin/bash

# check command
_chkcmd() { command -v "$1" >/dev/null 2>&1 || return 1; }

# calculator
_calc() { printf "%s\n" "$*" | bc -l; }

# mkdir & cd
md() { [ $# = 1 ] && mkdir -p "$@" && cd "$@" || echo "Error - no directory passed!"; }

# kill process
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo "$pid" | xargs kill -"${1:-9}"
  fi
}

# retry previous command
retry() {
  until fc -ln -1; do
    sleep "${1:-1}"
  done
}

# watch previous command
ck() { watch -n"${1:-5}" "$(fc -ln -1)"; }

# cd up n directories
up() { cd "$(eval printf '../'%.0s {1..$1})" || return 1; }
