#!/bin/sh

export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgreprc"
_chkcmd rg && alias g="rg"
