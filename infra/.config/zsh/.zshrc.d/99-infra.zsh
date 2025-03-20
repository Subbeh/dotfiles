#!/bin/zsh

_chkcmd terraform && complete -o nospace -C $(which terraform) terraform
_chkcmd aws && complete -C $(which aws_completer) aws
_chkcmd aws-sso-util && eval "$(_AWS_SSO_UTIL_COMPLETE=zsh_source aws-sso-util)"

# ansible
play() {
  pushd "${HOMELAB_DIR:?not set}/ansible"
  ansible-playbook "playbooks/$@"
  popd
}

# #Completion function for ap command
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
