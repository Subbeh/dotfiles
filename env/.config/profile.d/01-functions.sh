#!/bin/bash

# check command
_chkcmd() { command -v "$1" >/dev/null 2>&1 || return 1; }

# prepend directory to a colon-separated variable (e.g. PATH, XDG_DATA_DIRS)
# skips if dir doesn't exist or is already present
# usage: _prepend_dir VAR_NAME DIR
_prepend_dir() {
  eval "_cur=\$$1"
  case ":${_cur}:" in
    *":$2:"*) ;;
    *) test -d "$2" && eval "$1=\"$2\${$1:+:\$$1}\"" ;;
  esac
  unset _cur
}

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
  until eval fc -ln -1; do
    sleep "${1:-1}"
  done
}

# watch previous command
ck() { watch -n"${1:-5}" "$(fc -ln -1)"; }

# cd up n directories
up() { cd "$(eval printf '../'%.0s {1..$1})" || return 1; }

# create files in subdirectories
touchr() {
  mkdir -p "$(dirname "$1")" 2>/dev/null
  touch "$1" && ls -l "$1"
}

# copy full path to clipboard
xf() {
  _chkcmd pbcopy && echo -n "${PWD}/$*" | pbcopy
  _chkcmd wl-copy && echo -n "${PWD}/$*" | pbcopy -n
}

# copy with rsync
cpr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --exclude='.snapshots' --exclude='.vifm-Trash*' "$@"
}
# move with rsync
mvr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}
