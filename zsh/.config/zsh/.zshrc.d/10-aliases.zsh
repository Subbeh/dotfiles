#!/bin/zsh

# global aliases
alias -g Z='| fzf'
alias -g L='| less'
alias -g G='| grep -i --color'

# suffix aliases
alias -s {log,txt}=less
alias -s pdf=firefox
alias -s {mp4,MP4,mov,MOV}='vlc'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
for index in {1..9}; do alias "$index"="cd +${index}"; done
