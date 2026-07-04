#!/bin/sh

# system
alias d='dirs -v'
alias df='df -h'
alias du='du -h'
alias mv='mv -nv'
alias cp='cp -rnv'
alias free='free -h'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ip='ip -c'
alias diff='diff --color=auto'
alias dmesg='dmesg --color=auto'
alias dmesgg='dmesg --human --follow-new --decode --kernel'
alias h='history 0'
alias pa='ps -eaf | grep'
alias pg='pgrep -fa'
alias pk='pkill -f'
alias reset='reset && printf "\e[3J"'
alias sudo='sudo '
alias g='grep -Ri'

# navigation
alias p='pwd'
alias l='ls -l --color'
alias ll='ls -la --color'
alias lt='ls -ltra --color'
alias lsd='ls -ld */'
alias lsl='readlink -f'
alias cdb='cd $HOME/.local/bin'
alias cdc='cd $XDG_CONFIG_HOME'
alias cdw='cd ${WORKSPACE_DIR:?not set}'
alias cdd='cd ${DATA_DIR:?not set}'
alias cdt='cd ${TEMP_DIR:?not set}'
alias cdn='cd ${NOTES_DIR:?not set}'
alias cdp='cd ${PROJECT_DIR:?not set}'
alias cdr='cd ${REPOS_DIR:?not set}'
alias cds='cd ${STUDY_DIR:?not set}'

# tools
alias b='bat'
alias calc='noglob _calc'
alias httpserver='python3 -m http.server'
alias lip='curl -sw "\n" -4 ifconfig.me'
alias sdiff='diff --color=always --side-by-side'
alias ndiff='nvim -d'
alias ungron="gron --ungron"
alias icat="kitten icat"

# ssh
alias sshp='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias scpp='scp -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias sshc='ssh -F /dev/null -o IdentitiesOnly=yes -o IdentityAgent=none'

# git
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gau='git add -u'
alias gp='git push'
alias gpo='git push origin'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gr='git branch -r'
alias gplo='git pull origin'
alias gb='git branch '
alias gc='git commit -m'
alias gco='git checkout '
alias gl='git log --oneline --graph'
alias gr='git remote'
alias grs='git remote show'
alias glo='git log --pretty="oneline"'
alias glol='git log --graph --oneline --decorate'
alias lg='lazygit'
alias t='task'

# misc
alias dat='date +%Y-%m-%d'

if _chkcmd fd; then
  alias f="fd --list-details --ignore-case --hidden --follow --hyperlink=auto --one-file-system --exclude .git"
  alias fdir="fd --type dir --list-details --ignore-case --hidden --follow --hyperlink=auto --one-file-system --exclude .git"
fi

if _chkcmd eza; then
  alias l="eza --group-directories-first --group -1"
  alias ll="eza --long --all --group-directories-first --group --icons --git"
  alias lt="eza --long --all --sort=modified --group-directories-first --group --icons --git"
  alias ltree="eza --long --all --sort=modified --group-directories-first --group --icons --git --tree --level=2"
fi

_chkcmd rg && alias g="rg"

# OS specific
if [ "$PROFILE_OS" = "darwin" ]; then
  # clipboard
  alias cc="fc -ln -1 | pbcopy"
  alias xc="pbcopy"
  alias xp="pwd | tr -d '\n' | pbcopy"

  alias bu="brew update && brew upgrade --quiet --force"
  alias t="/opt/homebrew/Cellar/task/*/bin/task"

elif [ "$PROFILE_OS" = "linux" ]; then
  # clipdboard
  alias cc="fc -ln -1 | wl-copy -n"
  alias xc="wl-copy -n"
  alias xp="pwd | wl-copy -n"

  # systemd
  alias ctl='sudo systemctl'
  alias ctls='sudo systemctl status'
  alias jrnl='sudo journalctl -b'
  alias jrnle='sudo journalctl -p3 -xb'
  alias jrnlu='sudo journalctl -b -u'
  alias svc='systemctl --type=service'
  alias err='journalctl -b -p err'

  # pacman
  alias paczfl='pacman -Qq | fzf --preview "pacman -Qil {}" --layout=reverse --bind "enter:execute(pacman -Qil {} | less)"'
  alias paczfr='pacman -Slq | fzf --preview "pacman -Si {}" --layout=reverse'
fi
