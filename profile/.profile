# source files
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export DATA_DIR=/data
export TEMP_DIR=${DATA_DIR}/temp
export BIN_DIR=${HOME}/.local/bin
export PATH=${BIN_DIR}:/usr/bin:${PATH}

for file in environment bash_profile aliases functions ; do 
  test -f "${XDG_CONFIG_HOME}/env/$file" && . $_
done
