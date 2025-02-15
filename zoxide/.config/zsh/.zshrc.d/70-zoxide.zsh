#!/bin/zsh

if _chkcmd zoxide; then 
  export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
  eval "$(zoxide init --no-cmd zsh)"
  alias z=__zoxide_zi
fi

zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -l --color=always $realpath'
