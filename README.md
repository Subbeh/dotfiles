# dotfiles

1. install `stow`


2. clone repostitory

````
git clone git@github.com:Subbeh/dotfiles.git ~/.dotfiles
````

3. load submodules

```
cd ~/.dotfiles
git submodule init && git submodule update
```

4. load fonts
```
cd ~/.dotfiles/fonts/.local/share/fonts
git submodule init && git submodule update
```

5. run `dot` to synchronize files
```
$HOME/.dotfiles/dot load -g -p
```
