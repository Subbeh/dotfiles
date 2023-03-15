# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# env
export ZSHZ_DATA=${XDG_CACHE_HOME:?not set}/.z
export KEYTIMEOUT=1
export ZPLUG_HOME="${XDG_DATA_HOME:?not set}/zsh/plugins/zplug"
export HISTFILE=${XDG_CACHE_HOME:?not set}/zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY          # Write to the history file immediately, not when the shell exits.
setopt HIST_IGNORE_DUPS						 # Don't record an entry that was just recorded again.
setopt HIST_SAVE_NO_DUPS           # do not write a duplicate event to the history file.
setopt EXTENDED_HISTORY            # Write the history file in the ":start:elapsed;command" format.
setopt HIST_IGNORE_SPACE           # Don't record an entry starting with a space.
setopt GLOB_DOTS                   # enable glob expansion
_comp_options+=(globdots)          # with hidden files
autoload -U colors && colors

# plugins
test -f /usr/share/fzf/key-bindings.zsh && source $_
test -f /usr/share/fzf/completion.zsh && source $_
test -f ${XDG_CONFIG_HOME:?not set}/fzf/.fzf.zsh && source $_

# zplug plugins
source ${ZPLUG_HOME:?not set}/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-syntax-highlighting"         # syntax highlighting
zplug "zsh-users/zsh-autosuggestions"             # suggestions while typing
zplug "zsh-users/zsh-completions"                 # additional completion definitions
zplug "zsh-users/zsh-history-substring-search"    # browse history with keywords
zplug "agkozak/zsh-z"                             # navigate to directories using keywords
zplug "hlissner/zsh-autopair"                     # auto-add matching delimiters
zplug "Aloxaf/fzf-tab"                            # use fzf for suggestions
zplug 'wfxr/forgit'                               # efficient git
zplug "plugins/bgnotify",          from:oh-my-zsh # notify on finished command execution
zplug "plugins/dirhistory",        from:oh-my-zsh # navigate directories using key bindings
zplug "plugins/sudo",              from:oh-my-zsh # prefix last command with sudo [2x ESC]
zplug "plugins/command-not-found", from:oh-my-zsh # provide package suggestions [requires pkgfind]
zplug "plugins/alias-finder",      from:oh-my-zsh # alias suggestions
zplug "plugins/docker",            from:oh-my-zsh # add docker completions and aliases
zplug "plugins/kubtctl",           from:oh-my-zsh # add kubectl completions and aliases
zplug "romkatv/powerlevel10k",     as:theme, depth:1 # powerlevel10k prompt

zplug check --verbose || zplug install  # install missing plugins
zplug load                              # load plugins

# source env files
for file in environment aliases functions ; do
  test -f "${XDG_CONFIG_HOME:-$HOME/.config}/env/$file" && . $_
done

# key bindings
bindkey -e                          # use emacs keys
bindkey -s '\e[15~' 'src'         # run src with F5
bindkey '^]' kube-toggle            # ctrl-] to toggle kubecontext in powerlevel10k prompt
bindkey "[H" beginning-of-line    # enable HOME key
bindkey "[F" end-of-line          # enable END key
bindkey '[A' history-substring-search-up
bindkey '[B' history-substring-search-down
bindkey '^F' fzf-file-widget

# Z plugin
zstyle ':completion:*' menu select
(( ${+ZSHZ_EXCLUDE_DIRS} )) || typeset -ga ZSHZ_EXCLUDE_DIRS
ZSHZ_EXCLUDE_DIRS+="$HOME/.dotfiles"
ZSHZ_EXCLUDE_DIRS+="/mnt"
ZSHZ_NO_RESOLVE_SYMLINKS=1

# set bgnotify threshold in seconds
export bgnotify_threshold=3

# enable alias-finder
ZSH_ALIAS_FINDER_AUTOMATIC=true

# dynamic window titles
DISABLE_AUTO_TITLE="true"
case $TERM in
  alacritty)
    precmd () { print -Pn - '\e]0;%~\a' }
    ;;
esac

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=default
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='%B%F{005}+'
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|k9s'
# Show prompt segment "kubecontext" only when the command you are typing
# invokes kubectl, helm, kubens, kubectx, oc, istioctl, kogito, k9s, helmfile, flux, fluxctl, stern, kubeseal, or skaffold.
function kube-toggle() {
  if (( ${+POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND} )); then
    unset POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND
  else
    POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|k9s'
  fi
  p10k reload
  if zle; then
    zle push-input
    zle accept-line
  fi
}
zle -N kube-toggle
