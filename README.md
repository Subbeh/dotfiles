# Dotfiles

Managed with [statemate](https://github.com/subbeh/statemate).

## Setup on a new machine

Run the bootstrap script. It installs prerequisites (statemate, yay/brew,
Bitwarden CLI), fetches the age key from Bitwarden, clones this repository, and
applies the configuration:

```sh
curl -fsSL https://raw.githubusercontent.com/Subbeh/dotfiles/main/install.sh | bash
```

The script is interactive and prompts for each step, so you can skip any part
you don't need:

- Install prerequisites
- (Re)install statemate — choose the prebuilt binary (Homebrew on macOS) or
  build from source, selecting a branch when more than one exists
- Fetch secrets from Bitwarden (prompts to log in when needed)
- Clone the dotfiles repository — pick a branch and the clone location
- Initialize the configuration (`mate init`)
- Apply the configuration (`mate apply`)

You'll be prompted to log in to Bitwarden during the run to retrieve the
decryption key for secrets.
