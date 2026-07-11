#!/bin/sh

# system
alias pa='ps -eaf | grep'
alias pg='pgrep -fa'
alias reset='reset && printf "\e[3J"'

# tools
alias calc='noglob _calc'
alias diff='diff --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias g='grep -Ri'
alias grep='grep --color=auto'
alias httpserver='python3 -m http.server'
alias lip='curl -sw "\n" -4 ifconfig.me'
alias sdiff='diff --color=always --side-by-side'

# navigation
alias d='dirs -v'
alias p='pwd'
alias l='ls -l --color'
alias ll='ls -la --color'
alias lt='ls -ltra --color'
alias lsd='ls -ld */'
alias lsl='readlink -f'
alias cdb='cd $XDG_BIN_HOME'
alias cdc='cd $XDG_CONFIG_HOME'
alias cdw='cd $XDG_WORKSPACE_HOME'
alias cdd='cd $XDG_DATA_HOME'
alias cdt='cd $XDG_TEMP_HOME'
alias cdn='cd $XDG_NOTES_HOME'
alias cdp='cd $XDG_PROJECTS_HOME'
alias cdr='cd $XDG_WORKSPACE_HOME/repos'

# misc
alias dat='date +%Y-%m-%d'
