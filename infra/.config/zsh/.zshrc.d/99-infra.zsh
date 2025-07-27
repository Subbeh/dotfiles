#!/bin/zsh

# general aliases
alias cdh='cd ${HOMELAB_DIR:?not set}'
alias cdha='cd ${HOMELAB_DIR:?not set}/ansible'
alias cdht='cd ${HOMELAB_DIR:?not set}/terraform'
alias cdhk='cd ${HOMELAB_DIR:?not set}/k8s'
alias cdhs='cd ${HOMELAB_DIR:?not set}/.secret'

_chkcmd terraform && complete -o nospace -C $(which terraform) terraform
_chkcmd aws && complete -C $(which aws_completer) aws
_chkcmd aws-sso-util && eval "$(_AWS_SSO_UTIL_COMPLETE=zsh_source aws-sso-util)"
_chkcmd mise && eval "$(mise activate zsh)"
_chkcmd task && eval "$(task --completion zsh)"

# kubectl
_chkcmd kubectl && {
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

  alias k=kubectl
  alias kns="kubectl config set-context --current --namespace"
  alias kctx="kubectl config use-context"
  source <(kubectl completion zsh)
  _chkcmd kubectl-netshoot && {
    source <(kubectl netshoot completion zsh)
    alias kdbgrun="kubectl netshoot run debugger"
    alias kdbg="kubectl netshoot debug"
  }
  compdef k='kubectl'
}

# ansible
play() {
  local _popd
  [[ "$(pwd)" != "${HOMELAB_DIR:?not set}/ansible" ]] && _popd=1
  ((_popd)) && pushd "${HOMELAB_DIR:?not set}/ansible"
  ansible-playbook "playbooks/$@"
  ((_popd)) && popd
}

## completion function for ap command
_play() {
  local playbooks
  playbooks=("${HOMELAB_DIR}/ansible/playbooks/"*(N:t))
  _describe 'playbooks' playbooks
}

## Register the completion function
compdef _play play

# terraform
alias tinit="terraform init"
alias tplan="terraform plan"
alias tapply="terraform apply"

# direnv hook for Zsh history switching
# default history file
ZSH_DEFAULT_HISTFILE="$HOME/.zsh_history"

direnv_hook() {
  # get current HISTFILE value
  local new_histfile=${HISTFILE:-$ZSH_DEFAULT_HISTFILE}

  # only reload if HISTFILE has changed
  if [[ "$ZSH_ACTIVE_HISTFILE" != "$new_histfile" ]]; then
    fc -AI # save current history
    HISTFILE="$new_histfile"
    fc -R # reload new history
    ZSH_ACTIVE_HISTFILE="$HISTFILE"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd direnv_hook
add-zsh-hook precmd direnv_hook
