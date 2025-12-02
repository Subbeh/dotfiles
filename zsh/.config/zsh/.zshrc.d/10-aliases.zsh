#!/bin/zsh

# global aliases
alias -g C='| cat'
alias -g B='| bat'
alias -g G='| grep -i --color'
alias -g H='--help'
alias -g J='| jq -r'
alias -g L='| less'
alias -g V='--version'
alias -g X='| xargs'
alias -g X-='| xargs -I--'
alias -g Y='| yq -r'
alias -g Z='| fzf'
_chkcmd wl-copy && alias -g CP='| wl-copy -n'
_chkcmd pbcopy && alias -g CP='| pbcopy'

# suffix aliases
alias -s {log,txt}=less
alias -s {html,pdf}=firefox
alias -s {mp4,MP4,mov,MOV}='vlc'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
for index in {1..9}; do alias "$index"="cd +${index}"; done
