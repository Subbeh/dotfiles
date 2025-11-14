#!/bin/sh

if [ -d "$WORKSPACE_DIR/dots" ]; then
  DOT_DIR="$WORKSPACE_DIR/dots"
elif [ -d "$HOME/.dots" ]; then
  DOT_DIR="$HOME/.dots"
fi
export DOT_DIR

alias cd.="cd \${DOT_DIR:?not set}"

alias ml='mate load'
alias mls='mate ls'
alias ms='mate status'
alias ma='mate add'
alias maa='mate add --all'
alias mau='mate add -u'
alias mp='mate push'
alias mpo='mate push origin'
alias mtd='mate tag --delete'
alias mtdr='mate tag --delete origin'
alias mr='mate branch -r'
alias mplo='mate pull origin'
alias mb='mate branch '
alias mc='mate commit -m'
alias mdf='mate -r diff'
alias mco='mate checkout '
alias mlg='mate log'
alias mr='mate remote'
alias mrs='mate remote show'
alias mlo='mate log --pretty="oneline"'
alias mlol='mate log --graph --oneline --decorate'
