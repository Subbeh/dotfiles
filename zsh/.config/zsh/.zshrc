#!/usr/bin/zsh

# Enable debug mode:
# setopt xtrace

FPATH="$XDG_DATA_HOME"/zsh/site-functions:$FPATH
HISTDUP=erase
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=1

setopt appendhistory        # Append to history file rather than overwriting
setopt auto_pushd           # Automatically push directories to stack when cd-ing
setopt extended_history     # Save timestamp and duration for each command in history
setopt glob_dots            # Include hidden files in globbing/completion without explicit dot
setopt global_rcs           # Startup files /etc/zprofile, /etc/zshrc, /etc/zlogin and /etc/zlogout will not be run
setopt hist_find_no_dups    # When searching history, skip duplicates
setopt hist_ignore_dups     # Don't save duplicate commands in history
setopt hist_ignore_space    # Don't save commands starting with space in history
setopt hist_verify          # Show command from history before executing it
setopt inc_append_history   # Add commands to history as they are typed, not at shell exit
setopt interactive_comments # Allow comments in interactive shell
setopt menu_complete        # Insert first match immediately in completion
setopt no_beep              # Don't beep on errors
setopt nonomatch            # Pass failed filename patterns instead of error
setopt pushd_ignore_dups    # Don't push duplicate directories onto the stack
setopt pushd_silent         # Don't print directory stack after pushd/popd

hash -d ws=${XDG_WORKSPACE_HOME}

source "$XDG_CONFIG_HOME/zsh/keybinds"

# Adopt the behavior of the system wide configuration for application specific settings
#
# See: https://wiki.archlinux.org/title/Command-line_shell#/etc/profile

if [[ ! -o login ]]; then
  emulate sh -c 'test -r "$XDG_CONFIG_HOME/sh/profile.d.sh" && . "$_"'
fi

for script in "$XDG_CONFIG_HOME"/zsh/.zshrc.d/*.zsh; do
  if [ -r "$script" ]; then
    source "$script"
  fi
done

zstyle :completion:* use-cache true
zstyle :completion:* cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

autoload -U compinit
compinit -u -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"

# Rebuild the command hash and completion dump so newly installed programs are
# found and completable. Broadcast via SIGUSR1 by the dotfiles deploy hook.
_refresh_completions() {
  rehash
  compinit -u -d "${XDG_CACHE_HOME}/zsh/zcompdump"
}
TRAPUSR1() { _refresh_completions; }

# Reload shell configuration in place, then refresh completions. Broadcast via
# SIGUSR2 so `src all` can reload every running shell.
_reload() {
  source "$ZDOTDIR/.zshrc"
  # .zshrc only sources profile.d for non-login shells; reload it here so the
  # reload picks up profile.d changes regardless of login status.
  emulate sh -c 'test -r "$XDG_CONFIG_HOME/sh/profile.d.sh" && . "$_"'
  [[ -n $DIRENV_DIR ]] && direnv reload
  [[ -n $MISE_SHELL ]] && _mise_hook
  _refresh_completions
}
TRAPUSR2() { _reload; }

# Reload this shell, or every zsh with `src all`.
src() {
  if [[ "$1" == all ]]; then
    pkill -u "$USER" zsh --signal=USR2 || true
  else
    _reload
  fi
}
