#!/bin/zsh

# zsh-vi-mode plugin resets keybindings, so we need to initialize atuin after it
zvm_after_init() {
  eval "$(atuin init zsh --disable-up-arrow)"
}

# Also initialize directly so atuin works when re-sourcing with src()
eval "$(atuin init zsh --disable-up-arrow)"
