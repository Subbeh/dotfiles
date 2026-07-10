#!/usr/bin/env bash
# Bootstrap statemate on a fresh machine

set -euo pipefail

REPO="Subbeh/dotfiles.git"
AGE_KEY_DIR="$HOME/.config/statemate"
BUILD_FROM_SOURCE=false
SOURCE_BRANCH="main"
DOTFILES_BRANCH="main"

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --statemate [BRANCH]  Build statemate from source instead of downloading binary
                        Optionally specify a branch (default: main)
  --branch BRANCH       Use specified branch for dotfiles repo (default: main)
  -h, --help            Show this help message
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --statemate)
      BUILD_FROM_SOURCE=true
      if [[ -n "${2:-}" && ! "$2" =~ ^- ]]; then
        SOURCE_BRANCH="$2"
        shift
      fi
      shift
      ;;
    --branch)
      if [[ -n "${2:-}" && ! "$2" =~ ^- ]]; then
        DOTFILES_BRANCH="$2"
        shift
      else
        echo "Error: --branch requires a branch name" >&2
        exit 1
      fi
      shift
      ;;
    -h | --help)
      usage
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      ;;
  esac
done

case "$(uname -s)" in
  Darwin) SOURCE_DIR="${SOURCE_DIR:-$HOME/workspace/dotfiles}" ;;
  Linux) SOURCE_DIR="${SOURCE_DIR:-/data/workspace/dotfiles}" ;;
  *)
    echo "Unsupported OS" >&2
    exit 1
    ;;
esac

install_darwin() {
  if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install --quiet age bitwarden-cli go jq
}

install_linux() {
  sudo pacman -S --needed --noconfirm git base-devel age bitwarden-cli go jq openssh
  if ! command -v yay &>/dev/null; then
    echo "==> Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  fi
}

install_statemate_binary() {
  echo "==> Installing statemate binary..."
  case "$(uname -s)" in
    Darwin)
      brew install subbeh/tap/statemate
      ;;
    Linux)
      local os arch
      os=$(uname -s | tr '[:upper:]' '[:lower:]')
      arch=$(uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/')
      curl -sL "https://github.com/subbeh/statemate/releases/download/latest/mate_${os}_${arch}.tar.gz" | sudo tar xz -C /usr/local/bin mate
      ;;
  esac
}

install_statemate_source() {
  echo "==> Building statemate from source (branch: $SOURCE_BRANCH)..."
  git clone --branch "$SOURCE_BRANCH" https://github.com/subbeh/statemate.git /tmp/statemate
  (cd /tmp/statemate && make build)

  echo "==> Installing statemate..."
  sudo cp /tmp/statemate/mate /usr/local/bin/
  rm -rf /tmp/statemate
}

install_statemate() {
  if command -v mate &>/dev/null; then
    echo "statemate already installed"
    return
  fi

  if [[ "$BUILD_FROM_SOURCE" == true ]]; then
    install_statemate_source
  else
    install_statemate_binary
  fi
}

echo "==> Installing prerequisites..."
case "$(uname -s)" in
  Darwin) install_darwin ;;
  Linux) install_linux ;;
esac

install_statemate

echo "==> Logging in to Bitwarden..."
if [[ -z "${BW_SESSION:-}" ]]; then
  if ! bw login --check &>/dev/null; then
    bw login </dev/tty || {
      echo "Bitwarden login failed" >&2
      exit 1
    }
  fi
  BW_SESSION="$(bw unlock --raw </dev/tty)" || {
    echo "Bitwarden unlock failed" >&2
    exit 1
  }
  if [[ -z "${BW_SESSION:-}" ]]; then
    echo "Failed to obtain Bitwarden session" >&2
    exit 1
  fi
fi
export BW_SESSION

bw sync

echo "==> Fetching age key from Bitwarden..."
mkdir -p "$AGE_KEY_DIR"
bw get item statemate | jq -r '.fields[] | select(.name=="age-key").value' >"$AGE_KEY_DIR/key.txt"
chmod 600 "$AGE_KEY_DIR/key.txt"

echo "==> Fetching GitHub SSH key from Bitwarden..."
SSH_KEY="$HOME/.ssh/keys/id_github-ssh-key"
mkdir -p "$(dirname "$SSH_KEY")"
bw get item github-ssh-key | jq -r '.sshKey.privateKey' >"$SSH_KEY"
chmod 600 "$SSH_KEY"
export GIT_SSH_COMMAND="ssh -i $SSH_KEY -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"

echo "==> Cloning dotfiles..."
if [[ -d "$SOURCE_DIR" ]]; then
  echo "Directory $SOURCE_DIR already exists, pulling latest..."
  git -C "$SOURCE_DIR" fetch
  git -C "$SOURCE_DIR" checkout "$DOTFILES_BRANCH"
  git -C "$SOURCE_DIR" pull || true
else
  mkdir -p "$(dirname "$SOURCE_DIR")"
  git clone --branch "$DOTFILES_BRANCH" "git@github.com:$REPO" "$SOURCE_DIR"
fi

echo "==> Applying configuration..."
cd "$SOURCE_DIR"
mate init
mate secrets fetch
mate apply
