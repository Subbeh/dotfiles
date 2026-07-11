#!/bin/bash

# check command
chkcmd() { command -v "$1" >/dev/null 2>&1 || return 1; }

# mkdir & cd
md() { [ $# = 1 ] && mkdir -p "$@" && cd "$@" || echo "Error - no directory passed!"; }

# retry previous command
retry() {
  until eval $(fc -ln -1); do
    sleep "${1:-1}"
  done
}

# watch previous command
ck() { watch -n"${1:-5}" "$(fc -ln -1)"; }

# copy full path to clipboard
xf() {
  chkcmd pbcopy && echo -n "${PWD}/$*" | pbcopy
  chkcmd wl-copy && echo -n "${PWD}/$*" | pbcopy -n
}

# copy with rsync
cpr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --exclude='.snapshots' --exclude='.vifm-Trash*' "$@"
}

# move with rsync
mvr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}

# calculator
_calc() { printf "%s\n" "$*" | bc -l; }
