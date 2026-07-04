#!/usr/bin/env bash
# Bootstrap statemate on a fresh machine

set -euo pipefail

REPO="Subbeh/dotfiles.git"
AGE_KEY_DIR="$HOME/.config/statemate"

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
  brew install --quiet age bitwarden-cli go
}

install_linux() {
  if ! command -v yay &>/dev/null; then
    echo "==> Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel age bitwarden-cli go
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  fi
  # yay -Syu --needed --noconfirm age bitwarden-cli go
}

install_statemate() {
  if command -v mate &>/dev/null; then
    echo "statemate already installed"
    return
  fi

  echo "==> Building statemate from source..."
  git clone https://github.com/subbeh/statemate.git /tmp/statemate
  (cd /tmp/statemate && make build)

  echo "==> Installing statemate..."
  case "$(uname -s)" in
    Darwin) sudo cp /tmp/statemate/mate /usr/local/bin/ ;;
    Linux) sudo cp /tmp/statemate/mate /usr/local/bin/ ;;
  esac
  rm -rf /tmp/statemate
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
    BW_SESSION="$(bw login --raw)" || {
      echo "Bitwarden login failed" >&2
      exit 1
    }
  else
    BW_SESSION="$(bw unlock --raw)" || {
      echo "Bitwarden unlock failed" >&2
      exit 1
    }
  fi
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

echo "==> Cloning dotfiles..."
if [[ -d "$SOURCE_DIR" ]]; then
  echo "Directory $SOURCE_DIR already exists, pulling latest..."
  git -C "$SOURCE_DIR" pull || true
else
  mkdir -p "$(dirname "$SOURCE_DIR")"
  git clone "git@github.com:$REPO" "$SOURCE_DIR"
fi

echo "==> Applying configuration..."
cd "$SOURCE_DIR"
mate init
mate apply
