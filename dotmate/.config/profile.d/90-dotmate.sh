#!/bin/sh

if [ -d "$WORKSPACE_DIR/dots" ]; then
	DOT_DIR="$WORKSPACE_DIR/dots"
elif [ -d "$HOME/.dots" ]; then
	DOT_DIR="$HOME/.dots"
fi
export DOT_DIR

alias cd.="cd \${DOT_DIR:?not set}"

alias dl='mate load'
alias dls='mate ls'
alias ds='mate status'
alias da='mate add'
alias daa='mate add --all'
alias dau='mate add -u'
alias dp='mate push'
alias dpo='mate push origin'
alias dtd='mate tag --delete'
alias dtdr='mate tag --delete origin'
alias dr='mate branch -r'
alias dplo='mate pull origin'
alias db='mate branch '
alias dc='mate commit -m'
alias ddf='mate -r diff'
alias dco='mate checkout '
alias dlg='mate log'
alias dr='mate remote'
alias drs='mate remote show'
alias dlo='mate log --pretty="oneline"'
alias dlol='mate log --graph --oneline --decorate'
