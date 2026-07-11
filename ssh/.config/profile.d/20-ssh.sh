#!/bin/sh

alias sshp='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias scpp='scp -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias sshc='ssh -F /dev/null -o IdentitiesOnly=yes -o IdentityAgent=none'
