# source files

for file in bash_profile environment aliases functions ; do 
  test -f "${XDG_CONFIG_HOME:-$HOME/.config}/env/$file" && . $_
done
