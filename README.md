# Dotfiles

Managed with [statemate](https://github.com/subbeh/statemate).

## Setup on a new machine

1. Install statemate:
   ```sh
   # macOS
   brew install subbeh/tap/statemate

   # Arch Linux
   yay -S statemate
   ```

2. Clone this repository:
   ```sh
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

3. Register and apply:
   ```sh
   mate init    # Register this directory
   mate apply   # Deploy configuration
   ```
