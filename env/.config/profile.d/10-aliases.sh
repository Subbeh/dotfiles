#!/bin/sh

# system
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ip='ip -c'
alias diff='diff --color=auto'
alias dmesg='dmesg --color=auto'
alias h="history 0"
alias pa='ps -eaf | grep'
alias pg="pgrep -fa"
alias pk="pkill -f"
alias reset="reset && printf '\e[3J'"
alias sudo='sudo '
alias g="grep -Ri"

# tools
alias b="bat"
alias calc="noglob _calc"
alias gpt="chatblade"
alias httpserver="python3 -m http.server"
alias lip='curl -w "\n" ifconfig.me'
alias sdiff="diff --color=always --side-by-side"

# systemd
alias ctl="sudo systemctl"
alias ctls="sudo systemctl status"
alias jrnl="sudo journalctl -b"
alias jrnle="sudo journalctl -p3 -xb"
alias jrnlu="sudo journalctl -b -u"
alias svc="systemctl --type=service"

# directory aliases
alias d='dirs -v'

# navigation
alias p='pwd'
alias l='ls -l --color'
alias ll='ls -la --color'
alias lt='ls -ltra --color'
alias lsd='ls -ld */'
alias lsl='readlink -f'
alias cdb="cd \$HOME/.local/bin"
alias cdc="cd \$XDG_CONFIG_HOME"
alias cdw="cd \${WORKSPACE_DIR:?not set}"
alias cdd="cd \${DATA_DIR:?not set}"
alias cdt="cd \${TEMP_DIR:?not set}"
alias cdn="cd \${NOTES_DIR:?not set}"
alias cdp="cd \${PROJECT_DIR:?not set}"
alias cdr="cd \${REPOS_DIR:?not set}"
alias cdh="cd \${HOMELAB_DIR:?not set}"
alias cdha="cd \${HOMELAB_DIR:?not set}/ansible"
alias cdht="cd \${HOMELAB_DIR:?not set}/terraform"
