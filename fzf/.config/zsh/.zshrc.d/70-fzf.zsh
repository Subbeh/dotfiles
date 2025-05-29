#!/bin/zsh

if [ -r "/usr/share/fzf/completion.zsh" ]; then
  source /usr/share/fzf/completion.zsh
fi

if [ -r "/usr/share/fzf/key-bindings.zsh" ]; then
  source /usr/share/fzf/key-bindings.zsh
  for keymap in emacs vicmd viins; do
    bindkey -rM $keymap '\ec'
    bindkey -rM $keymap '^T'
  done
fi

if [ -n "$BASE16_THEME" ] && [ -n "$BASE16_SHELL_ENABLE_VARS" ]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
--color=bg+:#$BASE16_COLOR_01_HEX,bg:#$BASE16_COLOR_00_HEX,spinner:#$BASE16_COLOR_0C_HEX,hl:#$BASE16_COLOR_0D_HEX
--color=fg:#$BASE16_COLOR_04_HEX,header:#$BASE16_COLOR_0D_HEX,info:#$BASE16_COLOR_0A_HEX,pointer:#$BASE16_COLOR_0C_HEX
--color=marker:#$BASE16_COLOR_0C_HEX,fg+:#$BASE16_COLOR_06_HEX,prompt:#$BASE16_COLOR_0A_HEX,hl+:#$BASE16_COLOR_0D_HEX"
fi

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1a --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags --multi
zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle+down'

eval "$(fzf --zsh)"

# fshow - git commit browser
fshow() {
  git rev-parse --git-dir >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    return
  fi

  local out sha q
  while out=$(
    git log --decorate=short --graph --oneline --color=always |
      fzf-tmux --ansi --multi --no-sort --reverse --query=$q --print-query
  ); do
    q=$(head -1 <<<"$out")
    while read sha; do
      [ -n "$sha" ] && git show --color=always $sha | less -R
    done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<<"$out" | awk '{print $1}')
  done
}

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" |
    fzf-tmux --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
}
