#!/bin/zsh

# list all commands / functions / aliases / builtins
lsc() {
  [ -z $1 ] && return
  for command in ${(k)commands} ; do
    echo c: $command | grep -i $1
  done
  for alias in ${(k)aliases} ; do
    echo a: $alias | grep -i $1
  done
  for function in ${(k)functions} ; do
    echo f: $function | grep -i $1
  done
  for builtin in ${(k)builtins} ; do
    echo b: $builtin | grep -i $1
  done
  for var in $(env) ; do
    echo v: $var | grep -i $1
  done
}


# list colors
lscolor() { for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done }

# source
src() {
  for file in .zprofile .zshrc; do
    source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/$file"
  done
  direnv status | grep -q Loaded && direnv reload
}
