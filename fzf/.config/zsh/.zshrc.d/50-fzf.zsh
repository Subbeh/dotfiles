#!/bin/zsh

source <(fzf --zsh)

# fzf-tab (loaded via zinit in 30-zinit.zsh) replaces the completion menu with
# fzf. Disable zsh's own menu so it can capture the unambiguous prefix.
zstyle ':completion:*' menu no
