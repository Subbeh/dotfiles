#!/bin/sh

export FZF_PREVIEW_COMMAND='less {} 2>/dev/null'
export FZF_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
export FZF_DEFAULT_OPTS="--multi --bind 'tab:toggle+down' \
--bind ctrl-q:abort \
--bind ctrl-y:preview-up \
--bind ctrl-e:preview-down \
--bind ctrl-u:preview-half-page-up \
--bind ctrl-d:preview-half-page-down \
--bind ctrl-b:preview-page-up \
--bind ctrl-f:preview-page-down \
--bind alt-up:half-page-up \
--bind alt-down:half-page-down"

if [ -n "$BASE16_THEME" ]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
		--color=bg+:#$BASE16_COLOR_01_HEX,bg:#$BASE16_COLOR_00_HEX
		--color=fg:#$BASE16_COLOR_04_HEX,fg+:#$BASE16_COLOR_06_HEX
		--color=hl:#$BASE16_COLOR_0D_HEX,hl+:#$BASE16_COLOR_0D_HEX
		--color=info:#$BASE16_COLOR_0A_HEX,header:#$BASE16_COLOR_0D_HEX
		--color=prompt:#$BASE16_COLOR_0A_HEX,marker:#$BASE16_COLOR_0C_HEX
		--color=pointer:#$BASE16_COLOR_0C_HEX,spinner:#$BASE16_COLOR_0C_HEX"
fi
