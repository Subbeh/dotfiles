# source files

for file in environment bash_profile aliases functions ; do 
  test -f "${XDG_CONFIG_HOME}/env/$file" && . $_
done
