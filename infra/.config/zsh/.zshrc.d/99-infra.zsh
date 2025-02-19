#!/bin/zsh

_chkcmd terraform && complete -o nospace -C $(which terraform) terraform
_chkcmd aws && complete -C $(which aws_completer) aws
_chkcmd aws-sso-util && eval "$(_AWS_SSO_UTIL_COMPLETE=zsh_source aws-sso-util)"
