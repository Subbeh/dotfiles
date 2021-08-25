# source files

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME}/zsh"

for file in environment aliases functions ; do 
  test -f "${XDG_CONFIG_HOME:-$HOME/.config}/env/$file" && . $_
done
