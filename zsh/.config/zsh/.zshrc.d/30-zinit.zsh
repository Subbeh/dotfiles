#!/bin/zsh

# zinit plugin manager -- https://github.com/zdharma-continuum/zinit
#
# This file is sourced by the .zshrc.d loop, which runs *before* compinit in
# .zshrc -- so completion plugins loaded here land on $fpath in time for it.

# Bootstrap: clone zinit on first run.
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
  command mkdir -p "$ZINIT_HOME"
  command git clone --depth=1 https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Extra completion definitions. Loaded synchronously so they are present when
# compinit runs; blockf lets zinit manage $fpath, atpull refreshes on update.
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# bgnotify (Oh My Zsh): desktop notification when a long command finishes in an
# unfocused terminal. The plugin reads these vars and defers to a pre-existing
# bgnotify_formatted at load time, so both are set here before the turbo load.
export bgnotify_threshold=10
export bgnotify_bell=false

function bgnotify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  local title
  (( $1 == 0 )) && title="Done" || title="Failed ($1)"
  # Skip interactive programs where a completion notice is just noise.
  if ! [[ "$2" =~ ^(nvim|vim|vi|less|man|lazygit)\ .* ]]; then
    bgnotify "$title -- after $3 s" "$2"
  fi
}

# ZLE plugins, loaded in turbo (just after the first prompt) so they attach once
# the line editor is fully set up -- which is also after compinit. Order matters:
# fzf-tab first (must be after compinit but before the widget-wrapping plugins),
# autosuggestions next (its start hook must be re-fired under turbo), and
# syntax-highlighting last. The atload hooks configure a plugin once it loads.
zinit wait lucid for \
  Aloxaf/fzf-tab \
  atload'ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd); _zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  OMZP::bgnotify \
  OMZP::safe-paste \
  atload'ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line); ZSH_HIGHLIGHT_STYLES[comment]="fg=8"' \
    zsh-users/zsh-syntax-highlighting
