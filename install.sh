#!/usr/bin/env bash
# Bootstrap statemate on a fresh machine

set -euo pipefail

REPO="Subbeh/dotfiles.git"
REPO_SSH="git@github.com:$REPO"
STATEMATE_REPO="https://github.com/subbeh/statemate.git"
AGE_KEY_DIR="$HOME/.config/statemate"
SSH_KEY="$HOME/.ssh/keys/id_github-ssh-key"

export BITWARDENCLI_APPDATA_DIR="$HOME/.local/share/bitwardencli"

case "$(uname -s)" in
  Darwin) OS=darwin; DEFAULT_SOURCE_DIR="$HOME/workspace/dotfiles" ;;
  Linux) OS=linux; DEFAULT_SOURCE_DIR="/data/workspace/dotfiles" ;;
  *)
    echo "Unsupported OS" >&2
    exit 1
    ;;
esac
SOURCE_DIR="${SOURCE_DIR:-$DEFAULT_SOURCE_DIR}"

# --- prompt helpers (read from /dev/tty so prompts work under `curl ... | bash`) ---

# confirm PROMPT DEFAULT(Y|N) -> exit 0 for yes, 1 for no
confirm() {
  local prompt="$1" default="${2:-Y}" reply hint
  if [[ "$default" == [Yy] ]]; then hint="[Y/n]"; else hint="[y/N]"; fi
  read -r -n 1 -p "$prompt $hint " reply </dev/tty || reply=""
  echo >/dev/tty
  reply="${reply:-$default}"
  [[ "$reply" == [Yy]* ]]
}

# prompt_default PROMPT DEFAULT -> echoes chosen value (default pre-filled and editable)
prompt_default() {
  local prompt="$1" default="$2" reply
  read -r -e -i "$default" -p "$prompt " reply </dev/tty || reply="$default"
  echo "${reply:-$default}"
}

# choose_branch REPO_URL -> echoes chosen branch; prompts only if >1 branch exists
choose_branch() {
  local repo="$1" branches choice i
  mapfile -t branches < <(git ls-remote --heads "$repo" 2>/dev/null | sed 's|.*refs/heads/||')
  if ((${#branches[@]} <= 1)); then
    printf '%s\n' "${branches[0]:-main}"
    return
  fi
  {
    echo "Available branches:"
    for i in "${!branches[@]}"; do
      printf '  %d) %s\n' "$((i + 1))" "${branches[$i]}"
    done
  } >/dev/tty
  while :; do
    read -r -p "Select branch [1]: " choice </dev/tty || choice=1
    choice="${choice:-1}"
    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#branches[@]})); then
      printf '%s\n' "${branches[$((choice - 1))]}"
      return
    fi
    echo "Invalid selection" >/dev/tty
  done
}

# --- detection ---

prereqs_installed() {
  local cmd
  for cmd in git age bw go jq; do
    command -v "$cmd" &>/dev/null || return 1
  done
  [[ "$OS" != linux ]] || command -v yay &>/dev/null
}

secrets_present() {
  [[ -s "$AGE_KEY_DIR/key.txt" && -s "$SSH_KEY" ]]
}

# --- install steps ---

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
  case "$OS" in
    darwin)
      brew install subbeh/tap/statemate
      ;;
    linux)
      local os arch
      os=$(uname -s | tr '[:upper:]' '[:lower:]')
      arch=$(uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/')
      curl -sL "https://github.com/subbeh/statemate/releases/download/latest/mate_${os}_${arch}.tar.gz" | sudo tar xz -C /usr/local/bin mate
      ;;
  esac
}

install_statemate_source() {
  local branch="$1"
  echo "==> Building statemate from source (branch: $branch)..."
  git clone --branch "$branch" "$STATEMATE_REPO" /tmp/statemate
  (cd /tmp/statemate && make build)

  echo "==> Installing statemate..."
  sudo cp /tmp/statemate/mate /usr/local/bin/
  rm -rf /tmp/statemate
}

install_statemate() {
  local method branch
  if [[ "$OS" == darwin ]]; then
    printf 'Install statemate from:\n  1) Homebrew (subbeh/tap/statemate)\n  2) source\n' >/dev/tty
  else
    printf 'Install statemate from:\n  1) prebuilt binary (GitHub release)\n  2) source\n' >/dev/tty
  fi
  read -r -p "Select [1]: " method </dev/tty || method=1
  method="${method:-1}"
  if [[ "$method" == 2 ]]; then
    branch=$(choose_branch "$STATEMATE_REPO")
    install_statemate_source "$branch"
  else
    install_statemate_binary
  fi
}

bw_ensure_session() {
  [[ -n "${BW_SESSION:-}" ]] && return
  if ! bw login --check &>/dev/null; then
    echo "==> Logging in to Bitwarden..."
    bw login </dev/tty || {
      echo "Bitwarden login failed" >&2
      exit 1
    }
  fi
  BW_SESSION="$(bw unlock --raw </dev/tty)" || {
    echo "Bitwarden unlock failed" >&2
    exit 1
  }
  [[ -n "$BW_SESSION" ]] || {
    echo "Failed to obtain Bitwarden session" >&2
    exit 1
  }
  export BW_SESSION
}

# --- prerequisites ---
prereqs_installed && prereq_default=N || prereq_default=Y
if confirm "Install prerequisites?" "$prereq_default"; then
  echo "==> Installing prerequisites..."
  case "$OS" in
    darwin) install_darwin ;;
    linux) install_linux ;;
  esac
fi

# --- statemate ---
if command -v mate &>/dev/null; then
  if confirm "statemate is already installed. Reinstall?" N; then
    install_statemate
  fi
else
  if confirm "Install statemate?" Y; then
    install_statemate
  fi
fi

# --- secrets ---
secrets_present && secrets_default=N || secrets_default=Y
if confirm "Fetch secrets from Bitwarden?" "$secrets_default"; then
  bw_ensure_session
  bw sync

  echo "==> Fetching age key from Bitwarden..."
  mkdir -p "$AGE_KEY_DIR"
  bw get item statemate | jq -r '.fields[] | select(.name=="age-key").value' >"$AGE_KEY_DIR/key.txt"
  chmod 600 "$AGE_KEY_DIR/key.txt"

  echo "==> Fetching GitHub SSH key from Bitwarden..."
  mkdir -p "$(dirname "$SSH_KEY")"
  bw get item github-ssh-key | jq -r '.sshKey.privateKey' >"$SSH_KEY"
  chmod 600 "$SSH_KEY"
  export GIT_SSH_COMMAND="ssh -i $SSH_KEY -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"
fi

# --- clone ---
[[ -d "$SOURCE_DIR" ]] && clone_default=N || clone_default=Y
if confirm "Clone the dotfiles repository?" "$clone_default"; then
  DOTFILES_BRANCH="$(choose_branch "$REPO_SSH")"
  SOURCE_DIR="$(prompt_default "Clone to:" "$SOURCE_DIR")"

  echo "==> Cloning dotfiles..."
  if [[ -d "$SOURCE_DIR" ]]; then
    echo "Directory $SOURCE_DIR already exists, pulling latest..."
    git -C "$SOURCE_DIR" fetch
    git -C "$SOURCE_DIR" checkout "$DOTFILES_BRANCH"
    git -C "$SOURCE_DIR" pull || true
  else
    mkdir -p "$(dirname "$SOURCE_DIR")"
    git clone --branch "$DOTFILES_BRANCH" "$REPO_SSH" "$SOURCE_DIR"
  fi
fi

# --- init ---
if [[ -f "$AGE_KEY_DIR/mate.yaml" ]]; then
  init_default=N
else
  init_default=Y
fi
if confirm "Initialize statemate (mate init)?" "$init_default"; then
  if [[ -d "$SOURCE_DIR" ]]; then
    echo "==> Initializing configuration..."
    (cd "$SOURCE_DIR" && mate init)
  else
    echo "Source directory $SOURCE_DIR does not exist; skipping init" >&2
  fi
fi

# --- apply ---
if confirm "Apply configuration (mate apply)?" Y; then
  if [[ -d "$SOURCE_DIR" ]]; then
    echo "==> Applying configuration..."
    (cd "$SOURCE_DIR" && mate apply --force)
  else
    echo "Source directory $SOURCE_DIR does not exist; skipping apply" >&2
  fi
fi
