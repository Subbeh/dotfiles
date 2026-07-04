#!/usr/bin/env bash
# Build a test Arch container, mount the repo, and run install.sh

set -euo pipefail

IMAGE_NAME="dotfiles-test:latest"
USERNAME="dev"

script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
repo_dir="$(dirname "$script_dir")"

docker build -t "$IMAGE_NAME" --build-arg USERNAME="$USERNAME" \
  --platform linux/amd64 \
  "$script_dir"

docker run --rm -it \
  -v "$repo_dir:/home/$USERNAME/dotfiles" \
  -v "${BITWARDENCLI_APPDATA_DIR:?not set}:/bw-data-host:ro" \
  -e SOURCE_DIR="/home/$USERNAME/dotfiles" \
  -e BITWARDENCLI_APPDATA_DIR="/home/$USERNAME/.config/bw" \
  ${BW_SESSION:+-e BW_SESSION="$BW_SESSION"} \
  -e NODE_NO_WARNINGS=1 \
  --dns 1.1.1.1 \
  "$IMAGE_NAME" \
  bash -c "mkdir -p /home/$USERNAME/.config/bw && cp -r /bw-data-host/. /home/$USERNAME/.config/bw && sh /home/$USERNAME/dotfiles/install.sh && bash"
