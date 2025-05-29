#!/bin/zsh

# Source profile in non-login shells (e.g. desktop terminal emulators)
if [[ ! -o login ]] && [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
fi

fpath+=("$HOME/.local/share/zsh/site-functions")

# Enable debug mode
# setopt xtrace

test -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" || mkdir -p "$_"
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase

setopt appendhistory          # Append to history file rather than overwriting
setopt auto_pushd             # Automatically push directories to stack when cd-ing
# setopt complete_aliases       # Complete aliases as their full commands NOTE: this messes up the kubectl autocompletion
setopt extended_history       # Save timestamp and duration for each command in history
setopt hist_find_no_dups      # When searching history, skip duplicates
setopt hist_ignore_dups       # Don't save duplicate commands in history
setopt hist_ignore_space      # Don't save commands starting with space in history
setopt hist_verify            # Show command from history before executing it
setopt inc_append_history     # Add commands to history as they are typed, not at shell exit
setopt interactive_comments   # Allow comments in interactive shell
setopt menu_complete          # Insert first match immediately in completion
setopt no_beep                # Don't beep on errors
setopt nonomatch              # Pass failed filename patterns instead of error
setopt pushd_ignore_dups      # Don't push duplicate directories onto the stack
setopt pushd_silent           # Don't print directory stack after pushd/popd
setopt glob_dots              # Include hidden files in globbing/completion without explicit dot
_comp_options+=(globdots)

autoload -Uz bashcompinit && bashcompinit
autoload -U colors && colors
autoload -U select-word-style
zle -N select-word-style
select-word-style normal
zstyle :zle:transpose-words word-style shell

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

zstyle :completion:* cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle :completion:* use-cache true
zstyle :completion:* rehash true
zstyle :completion::complete:* gain-privileges 1
zstyle :completion:* matcher-list 'm:{a-z}={A-Za-z}'
zstyle :completion:* list-colors "${(s.:.)LS_COLORS}"
zstyle :completion:* menu no


for script in "$ZDOTDIR"/.zshrc.d/*.zsh; do
	if [ -r "$script" ]; then
		source "$script"
	fi
done
