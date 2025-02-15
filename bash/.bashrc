#!/usr/bin/bash
# shellcheck disable=1090

export HISTFILE=$XDG_STATE_HOME/bash/history

if [[ $- == *i* ]] && [ -d "$BASHCOMPDIR" ]; then
	for f in "$BASHCOMPDIR"/*; do
		source "$f"
	done
fi

command -v starship >/dev/null 2>&1 && source <(starship init bash)
