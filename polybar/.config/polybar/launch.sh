#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar top --config=$XDG_CONFIG_HOME/polybar/config.ini &
polybar bottom --config=$XDG_CONFIG_HOME/polybar/config.ini &
