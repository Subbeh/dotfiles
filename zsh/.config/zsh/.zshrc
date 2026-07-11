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

autoload -U select-word-style
zle -N select-word-style
select-word-style normal
zstyle :zle:transpose-words word-style shell

function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne '\e[2 q' ;;        # steady block
    viins | main) echo -ne '\e[6 q' ;; # steady line
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init() {
  zle -K viins
}
zle -N zle-line-init

function push-input-hold {
  buf="$BUFFER"
  cur="$CURSOR"
  zle push-input
  BUFFER="$buf"
  CURSOR="$cur"
}
zle -N push-input-hold

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

src() {
  source "$ZDOTDIR/.zshrc"
  [[ -n $DIRENV_DIR ]] && direnv reload
  [[ -n $MISE_SHELL ]] && _mise_hook
}

TRAPUSR1() {
  rehash
  compinit -u -d "${XDG_CACHE_HOME}/zsh/zcompdump"
}
