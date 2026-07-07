# Dotfiles

Managed with [statemate](https://github.com/subbeh/statemate).

## Setup on a new machine

Run the bootstrap script. It installs prerequisites (statemate, yay/brew,
Bitwarden CLI), fetches the age key from Bitwarden, clones this repository, and
applies the configuration:

```sh
curl -fsSL https://raw.githubusercontent.com/Subbeh/dotfiles/main/install.sh | bash
```

### Options

| Option | Description |
|--------|-------------|
| `--statemate [BRANCH]` | Build statemate from source instead of downloading the binary. Optionally specify a branch (default: `main`). |
| `--branch BRANCH` | Use specified branch for dotfiles repo (default: `main`). |
| `-h, --help` | Show help message. |

Examples:

```sh
# Default: download pre-built statemate binary, use main branch for dotfiles
curl -fsSL https://raw.githubusercontent.com/Subbeh/dotfiles/main/install.sh | bash

# Build statemate from source (main branch)
curl -fsSL https://raw.githubusercontent.com/Subbeh/dotfiles/main/install.sh | bash -s -- --statemate

# Build statemate from source (specific branch)
curl -fsSL https://raw.githubusercontent.com/Subbeh/dotfiles/main/install.sh | bash -s -- --statemate dev

# Use a different dotfiles branch
curl -fsSL https://raw.githubusercontent.com/Subbeh/dotfiles/main/install.sh | bash -s -- --branch feature-branch
```

You'll be prompted to log in to Bitwarden during the run to retrieve the
decryption key for secrets.
