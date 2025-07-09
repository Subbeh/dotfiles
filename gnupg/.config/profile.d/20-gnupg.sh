#!/bin/sh

GNUPGHOME="${XDG_CONFIG_HOME:-${HOME}/.config}/gnupg"
if test -t 0; then
  GPG_TTY=$(tty)
  GPG_AGENT_SOCK="$(gpgconf --list-dirs agent-socket)"
  export GNUPGHOME GPG_TTY GPG_AGENT_SOCK

  unset SSH_AGENT_PID
  if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export SSH_AUTH_SOCK
  fi

  gpg-connect-agent -q updatestartuptty /bye >/dev/null
fi

alias gpgtest="echo test | gpg --clearsign"
alias gpgkill="gpgconf --kill gpg-agent"
alias gpgreload="gpg-connect-agent reloadagent /bye"
