#!/bin/sh

export FZF_TMUX="${TMUX:+1}"
export FZF_TMUX_OPTS='-p80%,80%'
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
--bind alt-down:half-page-down \
--color fg:${BASE16_COLOR_07_HEX},hl:${BASE16_COLOR_09_HEX},fg+:${BASE16_COLOR_07_HEX}:bold,hl+:${BASE16_COLOR_09_HEX} \
--color info:${BASE16_COLOR_0B_HEX},prompt:${BASE16_COLOR_05_HEX},spinner:${BASE16_COLOR_0C_HEX},pointer:${BASE16_COLOR_0C_HEX},marker:${BASE16_COLOR_02_HEX},header:${BASE16_COLOR_02_HEX}"
