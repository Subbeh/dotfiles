#!/bin/sh

export BASE16_THEME_DEFAULT="${XDG_CONFIG_HOME}/vivid/theme.yml"

if [ -f "$BASE16_THEME_DEFAULT" ] && command -v vivid 1>/dev/null; then
	LS_COLORS="$(vivid generate "$BASE16_THEME_DEFAULT" 2>/dev/null)"
	export LS_COLORS
fi
