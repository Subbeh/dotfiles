#!/bin/zsh

# set up zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

## syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)
typeset -A ZSH_HIGHLIGHT_STYLES
export ZSH_HIGHLIGHT_STYLES[comment]='fg=8'

## autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

## bgnotify
export bgnotify_threshold=10
export bgnotify_bell=false

function bgnotify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  if ! [[ "$2" =~ ^(nvim|vim|vi|less|man|lazygit)\ .* ]]; then
    bgnotify "$title -- after $3 s" "$2"
  fi
}

## alias-finder
export ZSH_ALIAS_FINDER_AUTOMATIC=true

## load plugins
zi light zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-completions
zi light zsh-users/zsh-autosuggestions
zi light zsh-users/zsh-history-substring-search
zi ice lucid wait'0'
zi light joshskidmore/zsh-fzf-history-search
zi light Aloxaf/fzf-tab
zi light hlissner/zsh-autopair
zi light jeffreytse/zsh-vi-mode
zi snippet OMZP::alias-finder
zi snippet OMZP::bgnotify
zi snippet OMZP::command-not-found
zi snippet OMZP::direnv
zi snippet OMZP::dirhistory
zi snippet OMZP::extract
zi snippet OMZP::fancy-ctrl-z
zi snippet OMZP::kubectl
zi snippet OMZP::safe-paste
zi snippet OMZP::sudo
