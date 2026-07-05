# Dotfiles

Managed with [statemate](https://github.com/subbeh/statemate).

## Setup on a new machine

Run the bootstrap script. It installs prerequisites (statemate, yay/brew,
Bitwarden CLI), fetches the age key from Bitwarden, clones this repository, and
applies the configuration:

```sh
curl -fsSL https://raw.githubusercontent.com/Subbeh/dotfiles/main/install.sh | bash
```

You'll be prompted to log in to Bitwarden during the run to retrieve the
decryption key for secrets.
