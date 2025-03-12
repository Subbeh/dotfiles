#!/bin/sh

export LESS="-RF --mouse"
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"
export LESSOPEN="|lessfilter %s"
