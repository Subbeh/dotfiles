#!/bin/zsh

# global aliases
alias -g C='| cat'
alias -g G='| grep -i --color'
alias -g H='--help'
alias -g L='| less'
alias -g V='--version'
alias -g X='| xargs'
alias -g X-='| xargs -I--'
alias -g Z='| fzf'

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
