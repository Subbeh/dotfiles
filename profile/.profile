# set environment variables
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export DATA_DIR=/data
export TEMP_DIR=${DATA_DIR}/temp
export BIN_DIR=${HOME}/.local/bin
export PATH=${BIN_DIR}:/usr/bin:${PATH}
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# source files
for file in "${XDG_CONFIG_HOME:-$HOME/.config}"/env/* ; do
  test -f "$file" && . "$_"
done
